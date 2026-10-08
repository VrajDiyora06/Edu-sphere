import React, { useState, useEffect, useCallback } from 'react';
import type { UserRole, UserProfile } from '../types';
import { AuthContext } from './authContextInstance';
import { supabase, isSupabaseConfigured } from '../lib/supabaseClient';

/**
 * Fetch authoritative user profile and role from PostgreSQL public.profiles.
 * Protected by Row Level Security (auth.uid() = id OR is_admin()).
 */
async function fetchDbProfile(userId: string): Promise<{
  role: UserRole;
  fullName?: string;
  avatarUrl?: string;
  bio?: string;
  email?: string;
} | null> {
  try {
    const { data, error } = await supabase
      .from('profiles')
      .select('id, email, full_name, role, avatar_url, bio')
      .eq('id', userId)
      .maybeSingle();

    if (!error && data) {
      const validRoles: UserRole[] = ['student', 'instructor', 'admin', 'system_admin'];
      const dbRole = validRoles.includes(data.role as UserRole)
        ? (data.role as UserRole)
        : 'student';

      return {
        role: dbRole,
        fullName: data.full_name || undefined,
        avatarUrl: data.avatar_url || undefined,
        bio: data.bio || undefined,
        email: data.email || undefined,
      };
    }

    // Fallback: check public_profiles view
    const { data: viewData, error: viewError } = await supabase
      .from('public_profiles')
      .select('id, full_name, role, avatar_url, bio')
      .eq('id', userId)
      .maybeSingle();

    if (!viewError && viewData) {
      const validRoles: UserRole[] = ['student', 'instructor', 'admin', 'system_admin'];
      const dbRole = validRoles.includes(viewData.role as UserRole)
        ? (viewData.role as UserRole)
        : 'student';

      return {
        role: dbRole,
        fullName: viewData.full_name || undefined,
        avatarUrl: viewData.avatar_url || undefined,
        bio: viewData.bio || undefined,
      };
    }
  } catch (err) {
    console.error('Error fetching database profile:', err);
  }
  return null;
}

export const AuthProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [role, setRoleState] = useState<UserRole>('guest');
  const [user, setUser] = useState<UserProfile | null>(null);
  const [loading, setLoading] = useState<boolean>(isSupabaseConfigured);
  const [isRealAuth, setIsRealAuth] = useState<boolean>(false);

  const applyAuthUser = useCallback(async (sessionUser: {
    id: string;
    email?: string;
    user_metadata?: Record<string, unknown>;
  }) => {
    setIsRealAuth(true);

    const dbProfile = await fetchDbProfile(sessionUser.id);

    // If profile cannot be loaded from database, fail safely
    if (!dbProfile) {
      console.warn('Could not verify profile from database for user:', sessionUser.id);
      setRoleState('guest');
      setUser(null);
      setIsRealAuth(false);
      return;
    }

    const roleFromDb = dbProfile.role || 'student';
    const fullName =
      dbProfile.fullName ||
      (sessionUser.user_metadata?.full_name as string) ||
      sessionUser.email?.split('@')[0] ||
      'Learner';
    const avatarUrl =
      dbProfile.avatarUrl || (sessionUser.user_metadata?.avatar_url as string);
    const bio = dbProfile.bio;
    const email = dbProfile.email || sessionUser.email || '';

    setRoleState(roleFromDb);
    setUser({
      id: sessionUser.id,
      email,
      fullName,
      role: roleFromDb,
      avatarUrl,
      bio,
    });
  }, []);

  useEffect(() => {
    if (!isSupabaseConfigured) {
      return;
    }

    let isMounted = true;

    // Initialize initial Supabase Auth session
    supabase.auth.getSession().then(async ({ data: { session } }) => {
      if (!isMounted) return;
      if (session?.user) {
        await applyAuthUser(session.user);
      } else {
        setIsRealAuth(false);
        setRoleState('guest');
        setUser(null);
      }
      setLoading(false);
    });

    // Listen to real-time auth state changes
    const {
      data: { subscription },
    } = supabase.auth.onAuthStateChange(async (_event, session) => {
      if (!isMounted) return;
      if (session?.user) {
        await applyAuthUser(session.user);
      } else {
        setIsRealAuth(false);
        setRoleState('guest');
        setUser(null);
      }
      setLoading(false);
    });

    return () => {
      isMounted = false;
      subscription.unsubscribe();
    };
  }, [applyAuthUser]);

  const signInWithEmail = async (
    email: string,
    password: string
  ): Promise<{ error: Error | null }> => {
    setLoading(true);
    if (!isSupabaseConfigured) {
      setLoading(false);
      return { error: new Error('Supabase project configuration missing in environment.') };
    }

    const { data, error } = await supabase.auth.signInWithPassword({
      email,
      password,
    });

    if (error) {
      setLoading(false);
      return { error };
    }

    if (data.user) {
      await applyAuthUser(data.user);
    }

    setLoading(false);
    return { error: null };
  };

  const signUpWithEmail = async (
    email: string,
    password: string,
    fullName: string
  ): Promise<{ error: Error | null }> => {
    setLoading(true);
    if (!isSupabaseConfigured) {
      setLoading(false);
      return { error: new Error('Supabase project configuration missing in environment.') };
    }

    const { data, error } = await supabase.auth.signUp({
      email,
      password,
      options: {
        data: {
          full_name: fullName,
          role: 'student',
        },
      },
    });

    if (error) {
      setLoading(false);
      return { error };
    }

    if (data.user && data.session) {
      await applyAuthUser(data.user);
    }

    setLoading(false);
    return { error: null };
  };

  const logout = async () => {
    setLoading(true);
    if (isSupabaseConfigured) {
      await supabase.auth.signOut();
    }
    setIsRealAuth(false);
    setRoleState('guest');
    setUser(null);
    setLoading(false);
  };

  return (
    <AuthContext.Provider
      value={{
        role,
        user,
        loading,
        isRealAuth,
        signInWithEmail,
        signUpWithEmail,
        logout,
      }}
    >
      {children}
    </AuthContext.Provider>
  );
};
