import React, { useState, useEffect } from "react";
import KeycloakService from "../services/keycloakService";
import { AuthContext } from "../hook/useAuth";

// Khởi tạo KeycloakService một lần duy nhất ở ngoài component
const keycloakService = KeycloakService.getInstance();
let initializationAttempted = false;

export const AuthProvider = ({ children }) => {
  const [isAuthenticated, setIsAuthenticated] = useState(false);
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);

  const initKeycloak = async () => {
    if (initializationAttempted) return;

    initializationAttempted = true;
    try {
      const authenticated = await keycloakService.init();
      setIsAuthenticated(authenticated);

      if (authenticated) {
        setUser(keycloakService.getUserInfo());
      }
    } catch (error) {
      console.error("Lỗi khởi tạo Keycloak ở AuthContext:", error);
      setIsAuthenticated(false);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    const timer = setTimeout(() => {
      initKeycloak();
    }, 300);

    return () => clearTimeout(timer);
  }, []);

  const login = () => {
    keycloakService.login();
  };

  const logout = () => {
    keycloakService.logout();
  };

  const value = {
    isAuthenticated,
    user,
    login,
    logout,
    loading,
  };

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
};
