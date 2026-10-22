import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import { AuthProvider } from './context/AuthContext';
import { Navbar } from './components/Navbar';
import { Footer } from './components/Footer';
import { LandingPage } from './pages/LandingPage';
import { CatalogPage } from './pages/CatalogPage';
import { CourseDetailPage } from './pages/CourseDetailPage';
import { LoginPage } from './pages/LoginPage';
import { RegisterPage } from './pages/RegisterPage';
import { StudentDashboardPage } from './pages/StudentDashboardPage';
import { InstructorStudioPage } from './pages/InstructorStudioPage';
import { AdminPortalPage } from './pages/AdminPortalPage';
import { ProtectedRoute } from './components/common/ProtectedRoute';

export function App() {
  return (
    <AuthProvider>
      <Router>
        <div className="min-h-screen flex flex-col bg-[#FAF9F5] text-[#1F2421] selection:bg-[#1B3B2B] selection:text-white">
          <Navbar />
          <main className="flex-1">
            <Routes>
              <Route path="/" element={<LandingPage />} />
              <Route path="/courses" element={<CatalogPage />} />
              <Route path="/courses/:id" element={<CourseDetailPage />} />
              <Route path="/login" element={<LoginPage />} />
              <Route path="/register" element={<RegisterPage />} />
              
              <Route
                path="/dashboard"
                element={
                  <ProtectedRoute allowedRoles={['student']}>
                    <StudentDashboardPage />
                  </ProtectedRoute>
                }
              />
              <Route
                path="/instructor"
                element={
                  <ProtectedRoute allowedRoles={['instructor', 'admin', 'system_admin']}>
                    <InstructorStudioPage />
                  </ProtectedRoute>
                }
              />
              <Route
                path="/admin"
                element={
                  <ProtectedRoute allowedRoles={['admin', 'system_admin']}>
                    <AdminPortalPage />
                  </ProtectedRoute>
                }
              />

              <Route path="*" element={<Navigate to="/" replace />} />
            </Routes>
          </main>
          <Footer />
        </div>
      </Router>
    </AuthProvider>
  );
}

export default App;
