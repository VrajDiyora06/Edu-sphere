import fs from 'fs';

const content = fs.readFileSync('src/pages/CourseDetailPage.tsx', 'utf-8');
const lines = content.split('\n');
lines.forEach((line, idx) => {
  if (line.includes('activeContentTab') || line.includes('Assignments') || line.includes('Quizzes')) {
    console.log(`${idx + 1}: ${line.trim()}`);
  }
});
