import { useState, useEffect, useCallback } from "react";
import { getUserProfile } from "../services/authService";

export const useAuth = () => {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  const fetchUser = useCallback(async () => {
    try {
      setLoading(true);
      const userData = await getUserProfile();
      setUser(userData);
      setError(null);
    } catch (err) {
      setUser(null);
      setError(err.message || "Authentication failed");
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    const token = localStorage.getItem("token");
    if (token) {
      fetchUser();
    } else {
      setLoading(false);
    }
  }, [fetchUser]);

  return { user, loading, error, refetch: fetchUser };
};
