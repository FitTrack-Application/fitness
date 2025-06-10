# 📦 03_Build_Scripts – Flutter Mobile (Windows)

Thư mục này chứa các tập tin script `.bat` hỗ trợ nhà phát triển trong quá trình thiết lập môi trường, phát triển, kiểm tra và build ứng dụng Flutter Mobile.

---

## 🗂 Danh sách các script

| File                  | Mục đích                                                                 |
|-----------------------|--------------------------------------------------------------------------|
| `setup_env.bat`       | Cài đặt môi trường ban đầu, tải dependencies Flutter.                    |
| `run_dev.bat`         | Chạy ứng dụng Flutter ở chế độ debug (phát triển).                      |
| `run_prod.bat`        | Chạy ứng dụng Flutter ở chế độ release (mô phỏng môi trường production).|
| `build_apk.bat`       | Build file APK ở chế độ release.                                         |
| `flutter_analyze.bat` | Phân tích mã nguồn Flutter, phát hiện lỗi/lint.                         |
| `clean.bat`           | Xoá các tệp tạm, build cũ và dọn dẹp cache Flutter.                     |

---

## ⚙️ Cách sử dụng

Chạy file `.bat` bằng cách **double click** hoặc dùng Command Prompt/PowerShell:

```bat
.\setup_env.bat
```
### Các bước để build project trên Windows:

1. Clone dự án

```
git clone <repository-url>
cd <project-folder>
```
2. Thiết lập môi trường (Chạy lần đầu)

```bat
.\setup_env.bat
```

3. Build APK release

```bat
.\build_apk.bat
```
- Sau khi hoàn tất, APK sẽ được tạo tại:

```
build\app\outputs\flutter-apk\app-release.apk
```

4. Kiểm tra trước khi build (Tùy chọn)

```bat
.\flutter_analyze.bat
```

## 📌 Yêu cầu môi trường
- Hệ điều hành: Windows 10 hoặc 11

- Đã cài đặt:

    - Flutter SDK

    - Git

    - fvm (tuỳ chọn nếu quản lý nhiều version Flutter)

- Đã chạy flutter doctor và xử lý các cảnh báo nếu có

## 📝 Ghi chú

- Các script này ưu tiên sử dụng FVM nếu thư mục .fvm tồn tại và đã được cài đặt.

- Được thiết kế để làm việc với cấu trúc thư mục chuẩn của Flutter.

- Có thể tùy biến thêm để phù hợp với các quy trình CI/CD.