import { createContext } from 'react';
import type { UserRole, UserProfile } from '../types';

export interface AuthContextType {
  role: UserRole;
  user: UserProfile | null;
  loading: boolean;
  isRealAuth: boolean;
  signInWithEmail: (email: string, password: string) => Promise<{ error: Error | null }>;
  signUpWithEmail: (email: string, password: string, fullName: string) => Promise<{ error: Error | null }>;
  logout: () => Promise<void>;
}

export const AuthContext = createContext<AuthContextType | undefined>(undefined);
