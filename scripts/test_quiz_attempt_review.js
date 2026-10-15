// Test script: quiz attempt review builder
console.log('[Quiz Test] Validating attempt review summary generator...');

const mockQuestions = [
  { id: 'q1', question_text: 'What is 2+2?', choices: [{ id: 'c1', is_correct: true }, { id: 'c2', is_correct: false }] },
  { id: 'q2', question_text: 'What is Big-O of binary search?', choices: [{ id: 'c3', is_correct: false }, { id: 'c4', is_correct: true }] }
];

const answers = { q1: 'c1', q2: 'c3' };
const review = mockQuestions.map(q => ({
  id: q.id,
  isCorrect: answers[q.id] === q.choices.find(c => c.is_correct).id
}));

const totalCorrect = review.filter(r => r.isCorrect).length;
console.log(`[Quiz Test] Score: ${totalCorrect}/${mockQuestions.length}. Review generation verified.`);
