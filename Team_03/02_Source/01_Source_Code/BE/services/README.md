# Fitness App Services

Dự án quản lý các microservice của ứng dụng Fitness.

## Cấu trúc dự án

- `fit-service`: Quản lý thông tin liên quan đến fitness
- `statistic-service`: Quản lý thống kê dữ liệu
- `user-service`: Quản lý người dùng 

## Cài đặt và Chạy

### Yêu cầu

- Docker và Docker Compose
- Git

### Cấu hình biến môi trường

1. Sao chép file `.env.example` thành `.env` (nếu chưa tồn tại):
```
cp .env.example .env
```

2. Điều chỉnh các biến môi trường trong file `.env`:
```
# Thay đổi mật khẩu của PostgreSQL
POSTGRES_PASSWORD=your_secure_password

# Thay đổi các cấu hình khác nếu cần
```

### Cách chạy

1. Clone dự án:
```
git clone <repository-url>
cd <project-folder>
```

2. Chạy tất cả các service bằng Docker Compose:
```
Nếu chạy lần đầu
docker-compose up -d --build

```

```
docker-compose up -d
```

3. Kiểm tra trạng thái các container:
```
docker-compose ps
```

4. Xem logs của các service:
```
docker-compose logs -f
```

### Kết nối đến Database

Bạn có thể kết nối đến database từ các công cụ như DBeaver với các thông tin sau:

- **Host**: localhost
- **Port**: 5432 (hoặc giá trị của POSTGRES_PORT trong file .env)
- **Database**: fit_service_db hoặc statistic_service_db hoặc user_service_db
- **Username**: postgres (hoặc giá trị của POSTGRES_USER trong file .env)
- **Password**: mật khẩu được cấu hình trong file .env

### Truy cập các service

- Fit Service: http://localhost:8080 (hoặc giá trị port được cấu hình trong file .env)
- Statistic Service: http://localhost:8081 (hoặc giá trị port được cấu hình trong file .env)
- User Service: - User Service: URL_ADDRESS:8082 (hoặc giá trị port được cấu hình trong file.env)

### Dừng các service

```
docker-compose down
```

Để xóa tất cả volumes (cơ sở dữ liệu):
```
docker-compose down -v
```

## Bảo mật

- Không commit file `.env` chứa thông tin nhạy cảm lên hệ thống quản lý mã nguồn
- Thay đổi các mật khẩu mặc định trước khi triển khai vào môi trường production
- Hạn chế truy cập vào port của database từ bên ngoài hệ thống (chỉ mở khi cần thiết)

## Thông tin thêm

- Cả ba service đều sử dụng cùng một PostgreSQL database, nhưng với các schema khác nhau
- Mỗi service có file cấu hình riêng trong thư mục của nó 