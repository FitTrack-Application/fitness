import axios from "axios";
import KeycloakService from "./keycloakService";

const axiosInstance = axios.create({
  baseURL: import.meta.env.VITE_API_URL,
  timeout: 180000,
  headers: {
    "Content-Type": "application/json",
  },
});

// Hàm delay với thời gian tùy chỉnh
const delay = (ms) => new Promise(resolve => setTimeout(resolve, ms));

// Hàm tính thời gian delay cho retry với exponential backoff
const getRetryDelay = (retryCount) => {
  return Math.min(1000 * Math.pow(2, retryCount), 10000); // Max 10 seconds
};

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
    
    // Kiểm tra nếu request đã retry quá 3 lần
    if (originalRequest._retryCount >= 3) {
      return Promise.reject(error);
    }

    // Khởi tạo số lần retry
    originalRequest._retryCount = (originalRequest._retryCount || 0) + 1;

    // Xử lý lỗi timeout hoặc lỗi 500
    if (
      (error.code === 'ECONNABORTED' && error.message.includes('timeout')) ||
      (error.response && error.response.status === 500)
    ) {
      const delayTime = getRetryDelay(originalRequest._retryCount);
      console.log(`Retry attempt ${originalRequest._retryCount} after ${delayTime}ms`);
      
      try {
        await delay(delayTime);
        return axiosInstance(originalRequest);
      } catch (retryError) {
        return Promise.reject(retryError);
      }
    }

    // Xử lý lỗi 401 (Unauthorized)
    if (error.response && error.response.status === 401 && !originalRequest._retry) {
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
