import React, { createContext, useState, useEffect, useContext } from "react";
import KeycloakService from "../services/keycloakService";

// Tạo context
export const AuthContext = createContext(null);

export const AuthProvider = ({ children }) => {
  const [isAuthenticated, setIsAuthenticated] = useState(false);
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);
  const keycloakService = KeycloakService.getInstance();

  useEffect(() => {
    const initKeycloak = async () => {
      try {
        setLoading(true);
        const authenticated = await keycloakService.init();

        if (authenticated) {
          setIsAuthenticated(true);
          setUser(keycloakService.getUserInfo());
        }
      } catch (err) {
        console.error("Lỗi khởi tạo Keycloak:", err);
      } finally {
        setLoading(false);
      }
    };

    initKeycloak();
  }, []);

  const login = async () => {
    await keycloakService.login();
  };

  const logout = async () => {
    await keycloakService.logout();
    setIsAuthenticated(false);
    setUser(null);
  };

  const refreshToken = async () => {
    return await keycloakService.refreshToken();
  };

  const value = {
    isAuthenticated,
    user,
    loading,
    login,
    logout,
    refreshToken,
    getAccessToken: keycloakService.getAccessToken,
  };

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
};

// Hook tiện lợi để sử dụng AuthContext
export const useAuth = () => useContext(AuthContext);
