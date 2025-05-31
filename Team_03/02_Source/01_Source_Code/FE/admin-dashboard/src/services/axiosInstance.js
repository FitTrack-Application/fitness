import axios from "axios";
import KeycloakService from "./keycloakService";

const axiosInstance = axios.create({
  baseURL: import.meta.env.VITE_API_URL,
  timeout: 60000,
  headers: {
    "Content-Type": "application/json",
  },
});

// Interceptor để thêm token vào mỗi request
axiosInstance.interceptors.request.use(
  async (config) => {
    const keycloakService = KeycloakService.getInstance();

    // Kiểm tra token hiện tại có hợp lệ không
    if (!keycloakService.isTokenValid()) {
      try {
        // Làm mới token nếu hết hạn
        await keycloakService.refreshToken();
      } catch (error) {
        console.error("Lỗi khi làm mới token:", error);
        // Có thể chuyển hướng tới trang đăng nhập nếu cần
        window.location.href = "/";
        return Promise.reject(error);
      }
    }

    // Thêm token vào header
    const token = keycloakService.getAccessToken();
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }

    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

// Interceptor để xử lý lỗi phản hồi
axiosInstance.interceptors.response.use(
  (response) => {
    return response;
  },
  async (error) => {
    const originalRequest = error.config;

    // Nếu lỗi 401 (Unauthorized) và chưa thử lại
    if (
      error.response &&
      error.response.status === 401 &&
      !originalRequest._retry
    ) {
      originalRequest._retry = true;

      try {
        // Làm mới token
        const keycloakService = KeycloakService.getInstance();
        const refreshed = await keycloakService.refreshToken();

        if (refreshed) {
          // Thử lại request với token mới
          const token = keycloakService.getAccessToken();
          originalRequest.headers.Authorization = `Bearer ${token}`;
          return axiosInstance(originalRequest);
        }
      } catch (refreshError) {
        console.error("Không thể làm mới token:", refreshError);
        // Chuyển hướng đến trang đăng nhập
        window.location.href = "/";
      }
    }

    return Promise.reject(error);
  }
);

export default axiosInstance;
