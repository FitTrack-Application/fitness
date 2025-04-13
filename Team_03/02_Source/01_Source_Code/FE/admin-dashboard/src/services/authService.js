import axios from "axios";

// Replace with your actual API base URL
const API_URL = "https://your-api-url.com/api";

// Create axios instance with default config
const api = axios.create({
  baseURL: API_URL,
  headers: {
    "Content-Type": "application/json",
  },
});

// Add request interceptor to include auth token in requests
api.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem("token");
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => Promise.reject(error)
);

export const login = async (username, password) => {
  try {
    // For development/testing, you can use this mock response
    // Remove this in production and uncomment the actual API call below
    await new Promise((resolve) => setTimeout(resolve, 1000)); // Simulate network delay
    if (username === "admin" && password === "password") {
      return {
        token: "mock-jwt-token",
        user: {
          id: 1,
          username: "admin",
          role: "admin",
        },
      };
    } else {
      throw new Error("Invalid credentials");
    }

    // Uncomment for actual API integration
    // const response = await api.post('/auth/login', { username, password });
    // return response.data;
  } catch (error) {
    if (error.response) {
      throw new Error(error.response.data.message || "Login failed");
    }
    throw error;
  }
};

export const logout = () => {
  localStorage.removeItem("token");
  // You can also call an API endpoint to invalidate the token on the server
  // api.post('/auth/logout');
};

export const getUserProfile = async () => {
  try {
    const response = await api.get("/auth/me");
    return response.data;
  } catch {
    throw new Error("Authentication failed");
  }
};

export default api;
