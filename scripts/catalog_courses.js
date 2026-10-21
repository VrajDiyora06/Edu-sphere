// scripts/catalog_courses.js
// Aggregates all 15 course modules into a unified coursesData export

import { coursesPart1 } from './data_cs_software_part1.js';
import { coursesPart2 } from './data_cs_software_part2.js';
import { coursesPart3 } from './data_cs_software_part3.js';
import { coursesPart4 } from './data_cs_software_part4.js';
import { coursesAiEmerging } from './data_ai_emerging.js';
import { coursesEngineeringMath } from './data_engineering_math.js';
import { coursesProfessionalSkills } from './data_professional_skills.js';

export const coursesData = [
  ...coursesPart1,
  ...coursesPart2,
  ...coursesPart3,
  ...coursesPart4,
  ...coursesAiEmerging,
  ...coursesEngineeringMath,
  ...coursesProfessionalSkills
];
