import Keycloak from "keycloak-js";

class KeycloakService {
  static instance = null;

  // Cấu hình cập nhật
  static KEYCLOAK_CONFIG = {
    url: import.meta.env.VITE_KEYCLOAK_URL,
    realm: import.meta.env.VITE_KEYCLOAK_REALM,
    clientId: import.meta.env.VITE_KEYCLOAK_CLIENT_ID,
    redirectUri: window.location.origin + "/callback",
  };

  constructor() {
    this.keycloak = new Keycloak({
      url: KeycloakService.KEYCLOAK_CONFIG.url,
      realm: KeycloakService.KEYCLOAK_CONFIG.realm,
      clientId: KeycloakService.KEYCLOAK_CONFIG.clientId,
    });

    this.keycloak.onTokenExpired = () => {
      console.log("Token đã hết hạn. Đang làm mới...");
      this.refreshToken();
    };
  }

  // Singleton pattern
  static getInstance() {
    if (!KeycloakService.instance) {
      KeycloakService.instance = new KeycloakService();
    }
    return KeycloakService.instance;
  }

  // Khởi tạo kết nối với Keycloak
  async init() {
    try {
      const authenticated = await this.keycloak.init({
        onLoad: "check-sso",
        silentCheckSsoRedirectUri:
          window.location.origin + "/silent-check-sso.html",
        pkceMethod: "S256",
        checkLoginIframe: false,
      });

      if (authenticated) {
        const roles = this.keycloak.tokenParsed.realm_access?.roles || [];

        if (!roles.includes("ADMIN")) {
          console.warn("Người dùng không có role ADMIN. Đăng xuất...");
          await this.logout(); // Xoá token và chuyển hướng ra login
          return false; // Không cho phép đăng nhập tiếp
        }

        localStorage.setItem("access_token", this.keycloak.token);
        localStorage.setItem("refresh_token", this.keycloak.refreshToken);
        localStorage.setItem(
          "token_expiration",
          this.keycloak.tokenParsed.exp * 1000
        );
      }

      return authenticated;
    } catch (error) {
      console.error("Lỗi khởi tạo Keycloak ở KeycloakService:", error);
      return false;
    }
  }

  // Đăng nhập với Keycloak
  async login() {
    try {
      await this.keycloak.login({
        redirectUri: KeycloakService.KEYCLOAK_CONFIG.redirectUri,
      });
      return true;
    } catch (error) {
      console.error("Lỗi đăng nhập:", error);
      return false;
    }
  }

  // Lấy access token
  getAccessToken() {
    return localStorage.getItem("access_token");
  }

  // Làm mới token khi hết hạn
  async refreshToken() {
    try {
      const refreshed = await this.keycloak.updateToken(60); // Làm mới nếu token sẽ hết hạn trong 60 giây
      if (refreshed) {
        localStorage.setItem("access_token", this.keycloak.token);
        localStorage.setItem("refresh_token", this.keycloak.refreshToken);
        localStorage.setItem(
          "token_expiration",
          this.keycloak.tokenParsed.exp * 1000
        );
        console.log("Token đã được làm mới");
        return true;
      }
      return false;
    } catch (error) {
      console.error("Lỗi làm mới token:", error);
      return false;
    }
  }

  // Đăng xuất
  async logout() {
    try {
      await this.keycloak.logout({
        redirectUri: window.location.origin,
      });
      localStorage.removeItem("access_token");
      localStorage.removeItem("refresh_token");
      localStorage.removeItem("token_expiration");
      return true;
    } catch (error) {
      console.error("Lỗi đăng xuất:", error);
      return false;
    }
  }

  // Kiểm tra token có còn hiệu lực không
  isTokenValid() {
    const token = this.getAccessToken();
    if (!token) return false;

    const expiration = localStorage.getItem("token_expiration");
    if (!expiration) return false;

    return parseInt(expiration) > Date.now();
  }

  // Lấy thông tin người dùng từ token
  getUserInfo() {
    if (this.keycloak.tokenParsed) {
      return {
        username: this.keycloak.tokenParsed.preferred_username,
        email: this.keycloak.tokenParsed.email,
        firstName: this.keycloak.tokenParsed.given_name,
        lastName: this.keycloak.tokenParsed.family_name,
        roles: this.keycloak.tokenParsed.realm_access?.roles || [],
      };
    }
    return null;
  }
}

export default KeycloakService;
