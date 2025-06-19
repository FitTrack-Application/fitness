import React from "react";
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import { AuthProvider } from "./context/AuthContext";
import LoginPage from "./pages/LoginPage";
import Callback from "./pages/Callback";
import Dashboard from "./pages/Dashboard"; // <- thêm vào
import Layout from "./components/layout/Layout";
import { Navigate } from "react-router-dom";
import FoodManagement from "./pages/FoodManagement";
import ExerciseManagement from "./pages/ExerciseManagement";
import { GlobalStyles } from "./styles/GlobalStyles";

function App() {
  return (
    <AuthProvider>
      <>
        <GlobalStyles />
        <Router>
          <Routes>
            <Route path="/" element={<LoginPage />} />
            <Route path="/callback" element={<Callback />} />
            <Route path="/admin" element={<Layout />}>
              <Route index element={<Navigate to="dashboard" replace />} />
              <Route path="dashboard" element={<Dashboard />} />
              <Route path="food" element={<FoodManagement />} />
              <Route path="exercise" element={<ExerciseManagement />} />
            </Route>
            <Route path="*" element={<Navigate to="/" replace />} />
          </Routes>
        </Router>
      </>
    </AuthProvider>
  );
}

export default App;
