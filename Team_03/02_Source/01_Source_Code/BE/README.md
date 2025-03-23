# Fitness Services

Dự án này bao gồm các microservice cho ứng dụng Fitness:

1. **fit-service**: Service quản lý thông tin về bài tập, thức ăn, và các yếu tố liên quan đến sức khỏe
2. **statistic-service**: Service quản lý thống kê và theo dõi tiến trình của người dùng

## Các thành phần

Kiến trúc dự án:
- Java Spring Boot microservices
- PostgreSQL database
- Containerization với Docker

## Yêu cầu

- Java 17+
- Maven
- Docker và Docker Compose
- PostgreSQL (hoặc có thể sử dụng thông qua Docker)

## Cài đặt và Khởi động

### Sử dụng Docker (Khuyến nghị)

1. Cấu hình biến môi trường (nếu cần):
   - `.env` trong thư mục fit-service
   - `.env` trong thư mục statistic-service

2. Khởi động các service:
   - Trên Windows:
     ```
     start-services.bat
     ```
   - Trên Linux/Mac:
     ```
     chmod +x start-services.sh
     ./start-services.sh
     ```

3. Truy cập các service:
   - fit-service: http://localhost:8080
   - statistic-service: http://localhost:8081

### Chạy thủ công (Phát triển)

1. Chạy fit-service:
   ```
   cd fit-service
   ./mvnw spring-boot:run
   ```

2. Chạy statistic-service:
   ```
   cd statistic-service
   ./mvnw spring-boot:run
   ```

## API Endpoints

### fit-service

- `GET /api/foods`: Lấy danh sách thực phẩm
- `GET /api/foods/{id}`: Lấy chi tiết thực phẩm theo ID
- `POST /api/foods`: Tạo thực phẩm mới
- `PUT /api/foods/{id}`: Cập nhật thực phẩm
- `DELETE /api/foods/{id}`: Xóa thực phẩm

### statistic-service

- `GET /api/foodlogs`: Lấy tất cả food logs
- `GET /api/foodlogs/{id}`: Lấy food log theo ID
- `GET /api/foodlogs/user/{userId}`: Lấy food logs theo user ID
- `GET /api/foodlogs/user/{userId}/date/{date}`: Lấy food logs theo user ID và ngày
- `GET /api/foodlogs/user/{userId}/range`: Lấy food logs theo user ID và khoảng thời gian
- `POST /api/foodlogs`: Tạo food log mới
- `PUT /api/foodlogs/{id}`: Cập nhật food log
- `DELETE /api/foodlogs/{id}`: Xóa food log 