import { supabase, isSupabaseConfigured } from './supabaseClient';
import type { DbAssignment, DbAssignmentSubmission, AssignmentWithSubmission, DbPublicProfile } from '../types';

export const INSTRUCTION_ALLOWED_EXTENSIONS = ['.pdf', '.doc', '.docx'];
export const INSTRUCTION_MAX_SIZE_BYTES = 10 * 1024 * 1024; // 10MB

export const SUBMISSION_ALLOWED_EXTENSIONS = ['.pdf', '.doc', '.docx', '.zip'];
export const SUBMISSION_MAX_SIZE_BYTES = 25 * 1024 * 1024; // 25MB

/**
 * Validate an uploaded instruction file.
 */
export function validateInstructionFile(file: File): { valid: boolean; error: string | null } {
  if (file.size > INSTRUCTION_MAX_SIZE_BYTES) {
    return { valid: false, error: 'Instruction file size exceeds maximum limit of 10 MB.' };
  }
  const ext = '.' + file.name.split('.').pop()?.toLowerCase();
  if (!INSTRUCTION_ALLOWED_EXTENSIONS.includes(ext)) {
    return {
      valid: false,
      error: `Invalid file format (${ext}). Only PDF, DOC, and DOCX files are permitted for instructions.`,
    };
  }
  return { valid: true, error: null };
}

/**
 * Validate a student submission file.
 */
export function validateSubmissionFile(file: File): { valid: boolean; error: string | null } {
  if (file.size > SUBMISSION_MAX_SIZE_BYTES) {
    return { valid: false, error: 'Submission file size exceeds maximum limit of 25 MB.' };
  }
  const ext = '.' + file.name.split('.').pop()?.toLowerCase();
  if (!SUBMISSION_ALLOWED_EXTENSIONS.includes(ext)) {
    return {
      valid: false,
      error: `Invalid file format (${ext}). Only ZIP, PDF, DOC, and DOCX files are permitted.`,
    };
  }
  return { valid: true, error: null };
}

/**
 * Upload an instruction file to the private Supabase storage bucket.
 */
export async function uploadInstructionFile(
  file: File,
  courseId: string
): Promise<{ path: string | null; error: Error | null }> {
  const validation = validateInstructionFile(file);
  if (!validation.valid) {
    return { path: null, error: new Error(validation.error || 'Invalid file') };
  }

  if (!isSupabaseConfigured) {
    return { path: null, error: new Error('Supabase client is not configured.') };
  }

  const cleanFileName = file.name.replace(/[^a-zA-Z0-9.-]/g, '_');
  const path = `${courseId}/${Date.now()}_${cleanFileName}`;

  try {
    const { error: uploadError } = await supabase.storage
      .from('assignment-instructions')
      .upload(path, file, {
        cacheControl: '3600',
        upsert: false,
      });

    if (uploadError) {
      return { path: null, error: uploadError };
    }

    return { path, error: null };
  } catch (err) {
    return { path: null, error: err instanceof Error ? err : new Error(String(err)) };
  }
}

/**
 * Generate a temporary signed download URL for an instruction file.
 */
export async function getInstructionDownloadUrl(
  filePath: string
): Promise<{ url: string | null; error: Error | null }> {
  if (!filePath) {
    return { url: null, error: new Error('Missing file path.') };
  }

  try {
    const { data, error } = await supabase.storage
      .from('assignment-instructions')
      .createSignedUrl(filePath, 3600);

    if (error || !data?.signedUrl) {
      return { url: null, error: error || new Error('Failed to create download URL.') };
    }

    return { url: data.signedUrl, error: null };
  } catch (err) {
    return { url: null, error: err instanceof Error ? err : new Error(String(err)) };
  }
}

/**
 * Generate a temporary signed download URL for a student submission file.
 */
export async function getSubmissionDownloadUrl(
  filePath: string
): Promise<{ url: string | null; error: Error | null }> {
  if (!filePath) {
    return { url: null, error: new Error('Missing file path.') };
  }

  try {
    const { data, error } = await supabase.storage
      .from('assignment-submissions')
      .createSignedUrl(filePath, 3600);

    if (error || !data?.signedUrl) {
      return { url: null, error: error || new Error('Failed to create download URL.') };
    }

    return { url: data.signedUrl, error: null };
  } catch (err) {
    return { url: null, error: err instanceof Error ? err : new Error(String(err)) };
  }
}

/**
 * Get assignments for a course directly from Supabase.
 */
export async function getCourseAssignments(
  courseId: string,
  studentId?: string,
  isInstructor: boolean = false
): Promise<{ data: AssignmentWithSubmission[]; error: Error | null }> {
  try {
    let query = supabase
      .from('assignments')
      .select('*')
      .eq('course_id', courseId)
      .order('due_date', { ascending: true });

    if (!isInstructor) {
      query = query.eq('is_published', true);
    }

    const { data: dbData, error } = await query;
    if (error) {
      return { data: [], error };
    }

    const list = (dbData || []) as DbAssignment[];
    let dbSubmissions: DbAssignmentSubmission[] = [];

    if (studentId && list.length > 0) {
      const { data: subData } = await supabase
        .from('assignment_submissions')
        .select('*')
        .eq('student_id', studentId)
        .in('assignment_id', list.map((a) => a.id));

      if (subData) {
        dbSubmissions = subData as DbAssignmentSubmission[];
      }
    }

    const subMap = new Map<string, DbAssignmentSubmission>();
    dbSubmissions.forEach((s) => {
      subMap.set(s.assignment_id, s);
    });

    const combined: AssignmentWithSubmission[] = list.map((a) => ({
      ...a,
      submission: subMap.get(a.id) || null,
    }));

    return { data: combined, error: null };
  } catch (err) {
    return { data: [], error: err instanceof Error ? err : new Error(String(err)) };
  }
}

/**
 * Create a new assignment.
 */
export async function createAssignment(assignmentData: {
  course_id: string;
  title: string;
  description: string;
  instructions_file_path?: string | null;
  instructions_file_name?: string | null;
  due_date: string;
  max_marks: number;
  allow_resubmission: boolean;
  is_published: boolean;
}): Promise<{ data: DbAssignment | null; error: Error | null }> {
  try {
    const { data, error } = await supabase
      .from('assignments')
      .insert({
        ...assignmentData,
        updated_at: new Date().toISOString(),
      })
      .select('*')
      .single();

    if (error) {
      return { data: null, error };
    }

    return { data: data as DbAssignment, error: null };
  } catch (err) {
    return { data: null, error: err instanceof Error ? err : new Error(String(err)) };
  }
}

/**
 * Update an existing assignment.
 */
export async function updateAssignment(
  assignmentId: string,
  assignmentData: Partial<DbAssignment>
): Promise<{ data: DbAssignment | null; error: Error | null }> {
  try {
    const { data, error } = await supabase
      .from('assignments')
      .update({
        ...assignmentData,
        updated_at: new Date().toISOString(),
      })
      .eq('id', assignmentId)
      .select('*')
      .single();

    if (error) {
      return { data: null, error };
    }

    return { data: data as DbAssignment, error: null };
  } catch (err) {
    return { data: null, error: err instanceof Error ? err : new Error(String(err)) };
  }
}

/**
 * Delete an assignment.
 */
export async function deleteAssignment(assignmentId: string): Promise<{ success: boolean; error: Error | null }> {
  try {
    const { error } = await supabase.from('assignments').delete().eq('id', assignmentId);
    if (error) {
      return { success: false, error };
    }
    return { success: true, error: null };
  } catch (err) {
    return { success: false, error: err instanceof Error ? err : new Error(String(err)) };
  }
}

/**
 * Submit work for an assignment.
 */
export async function submitAssignment(
  assignmentId: string,
  courseId: string,
  studentId: string,
  file: File
): Promise<{ data: DbAssignmentSubmission | null; error: Error | null }> {
  const validation = validateSubmissionFile(file);
  if (!validation.valid) {
    return { data: null, error: new Error(validation.error || 'Invalid file format') };
  }

  const cleanFileName = file.name.replace(/[^a-zA-Z0-9.-]/g, '_');
  const storagePath = `${courseId}/${assignmentId}/${studentId}/${Date.now()}_${cleanFileName}`;

  try {
    // 1. Upload to storage bucket
    const { error: uploadError } = await supabase.storage
      .from('assignment-submissions')
      .upload(storagePath, file, {
        cacheControl: '3600',
        upsert: false,
      });

    if (uploadError) {
      return { data: null, error: uploadError };
    }

    // 2. Submit record via atomic RPC submit_student_assignment
    const { data: rpcData, error: rpcError } = await supabase.rpc('submit_student_assignment', {
      p_assignment_id: assignmentId,
      p_file_path: storagePath,
      p_file_name: file.name,
      p_file_size_bytes: file.size,
    });

    if (rpcError) {
      return { data: null, error: rpcError };
    }

    if (rpcData?.submission) {
      return { data: rpcData.submission as DbAssignmentSubmission, error: null };
    }

    return { data: null, error: new Error('Submission completed but no record returned.') };
  } catch (err) {
    return { data: null, error: err instanceof Error ? err : new Error(String(err)) };
  }
}

/**
 * Fetch all student submissions for an assignment (instructor only).
 */
export async function getSubmissionsForAssignment(
  assignmentId: string
): Promise<{ data: DbAssignmentSubmission[]; error: Error | null }> {
  try {
    const { data, error } = await supabase
      .from('assignment_submissions')
      .select('*')
      .eq('assignment_id', assignmentId)
      .order('submitted_at', { ascending: false });

    if (error) {
      return { data: [], error };
    }

    const submissions = (data || []) as DbAssignmentSubmission[];
    if (submissions.length === 0) {
      return { data: [], error: null };
    }

    // Fetch student profile names/avatars
    const studentIds = Array.from(new Set(submissions.map((s) => s.student_id)));
    const { data: profiles } = await supabase
      .from('public_profiles')
      .select('id, full_name, avatar_url')
      .in('id', studentIds);

    const profileMap = new Map<string, DbPublicProfile>();
    (profiles || []).forEach((p) => profileMap.set(p.id, p as DbPublicProfile));

    const enriched = submissions.map((sub) => {
      const p = profileMap.get(sub.student_id);
      return {
        ...sub,
        student: {
          full_name: p?.full_name || 'Enrolled Student',
          avatar_url: p?.avatar_url || null,
        },
      };
    });

    return { data: enriched, error: null };
  } catch (err) {
    return { data: [], error: err instanceof Error ? err : new Error(String(err)) };
  }
}

/**
 * Grade a student submission (instructor only).
 */
export async function gradeSubmission(
  submissionId: string,
  marks: number,
  feedback: string
): Promise<{ data: DbAssignmentSubmission | null; error: Error | null }> {
  try {
    const { data: rpcData, error: rpcError } = await supabase.rpc('grade_student_assignment', {
      p_submission_id: submissionId,
      p_marks: marks,
      p_feedback: feedback,
    });

    if (rpcError) {
      return { data: null, error: rpcError };
    }

    if (rpcData?.submission) {
      return { data: rpcData.submission as DbAssignmentSubmission, error: null };
    }

    return { data: null, error: new Error('Grading failed') };
  } catch (err) {
    return { data: null, error: err instanceof Error ? err : new Error(String(err)) };
  }
}
