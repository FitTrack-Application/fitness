# USER SERVICE (AUTHENTICATION SERVICE)

Dịch vụ này cung cấp các chức năng xác thực người dùng sử dụng JWT để bảo mật và phân quyền.

## Chức năng chính

1. **Đăng ký tài khoản** (`/api/auth/register`): Đăng ký tài khoản mới với các thông tin cá nhân.
2. **Đăng nhập** (`/api/auth/login`): Xác thực người dùng và cung cấp JWT token.
3. **Bảo mật API**: Sử dụng JWT để xác thực và phân quyền truy cập các API khác trong hệ thống.

## Công nghệ sử dụng

- Java 17
- Spring Boot 3.4.3
- Spring Security
- JSON Web Token (JWT)
- PostgreSQL
- JPA / Hibernate

## Cấu trúc dự án

- **model**: Chứa các entity như User và enum Role
- **dto**: Các DTO (Data Transfer Object) cho các request và response
- **repository**: Các repository để truy xuất dữ liệu
- **service**: Chứa business logic
- **controller**: Các API endpoint
- **security**: Cấu hình bảo mật và JWT
- **utility**: Các lớp tiện ích

## Cài đặt và chạy

### Sử dụng Maven

```bash
mvn clean install
mvn spring-boot:run
```

### Sử dụng Docker

```bash
docker build -t user-service .
docker run -p 8082:8082 user-service
```

## Môi trường

Dự án sử dụng các biến môi trường sau, có thể cấu hình trong file .env:

- `POSTGRESQL_DB_HOST`: Host của PostgreSQL (mặc định: localhost)
- `POSTGRESQL_DB_PORT`: Port của PostgreSQL (mặc định: 5432)
- `POSTGRESQL_DB_NAME`: Tên database (mặc định: user_service_db)
- `POSTGRESQL_DB_USERNAME`: Username PostgreSQL (mặc định: postgres)
- `POSTGRESQL_DB_PASSWORD`: Password PostgreSQL (mặc định: yourpassword)
- `JWT_SECRET`: Khóa bí mật cho JWT
- `JWT_EXPIRATION`: Thời gian hết hạn của JWT token (mặc định: 7 ngày)
- `PORT`: Port của service (mặc định: 8082)

## API Endpoints

### Đăng ký tài khoản
```
POST /api/auth/register
```
Body:
```json
{
  "name": "Người dùng",
  "email": "user@example.com",
  "password": "password123",
  "age": 30,
  "gender": "Nam",
  "height": 170.0,
  "weight": 65.0,
  "imageUrl": "https://example.com/avatar.jpg",
  "role": "USER"
}
```

### Đăng nhập
```
POST /api/auth/login
```
Body:
```json
{
  "email": "user@example.com",
  "password": "password123"
}
``` 