# Findjob TT

Findjob TT là một cổng thông tin tuyển dụng được xây dựng trên nền tảng Spring Boot, dùng để kết nối Ứng viên, Nhà tuyển dụng và Quản trị viên. Ứng dụng sử dụng giao diện JSP, Spring Security, JPA, MySQL, chức năng tải tệp lên, đăng nhập Google OAuth2 và tính năng chấm điểm CV bằng AI.

## Tính năng

- Quy trình nghiệp vụ dành cho Ứng viên, Nhà tuyển dụng và Quản trị viên
- Đăng tin tuyển dụng và quản lý tin tuyển dụng
- Quản lý hồ sơ ứng viên, lưu việc làm, ứng tuyển và thông báo
- Quản lý thông tin công ty và bảng điều khiển dành cho Nhà tuyển dụng
- Bảng điều khiển Quản trị viên để quản lý người dùng, tin tuyển dụng, công ty và danh mục
- Đăng nhập bằng Google OAuth2
- Tải tệp lên cho CV, ảnh đại diện, logo công ty và giấy phép kinh doanh
- Tích hợp chức năng chấm điểm CV bằng AI

## Công nghệ sử dụng

- Java 17
- Spring Boot 4
- Spring MVC với giao diện JSP
- Spring Data JPA
- Spring Security
- Spring Boot OAuth2 Client
- MySQL
- Maven

## Cấu trúc dự án

- `src/main/java/com/findjob_tt/findjob_tt`: Mã nguồn chính của ứng dụng
- `src/main/resources/application.properties`: Tệp cấu hình chính của ứng dụng
- `src/main/webapp/WEB-INF/view`: Các trang JSP
- `database_seed_minimal.sql`: Dữ liệu khởi tạo tối thiểu cho cơ sở dữ liệu
- `uploads/`: Thư mục lưu trữ cục bộ cho các tệp được tải lên
- `run-windows.bat`: Build và chạy dự án từ mã nguồn trên Windows
- `run-windows-jar.bat`: Chạy tệp JAR đã được đóng gói trên Windows

## Yêu cầu

- Java 17
- MySQL đang chạy tại `localhost:3306`
- Tên cơ sở dữ liệu: `jobportal_intern`
- Tên người dùng và mật khẩu MySQL phải khớp với cấu hình trong `src/main/resources/application.properties`

## Cấu hình

Cấu hình chính nằm trong tệp `src/main/resources/application.properties`.

Các thiết lập quan trọng:

- Cổng máy chủ: `8080`
- Tiền tố đường dẫn giao diện JSP: `/WEB-INF/view/`
- Cơ sở dữ liệu: `jdbc:mysql://localhost:3306/jobportal_intern`
- Tự động cập nhật schema Hibernate: `spring.jpa.hibernate.ddl-auto=update`
- Giới hạn tải lên: 10 MB cho mỗi tệp, 20 MB cho mỗi yêu cầu
- Cấu hình AI chấm điểm CV có thể được ghi đè bằng các biến môi trường sau:
  - `CV_AI_BASE_URL`
  - `CV_AI_API_KEY`
  - `CV_AI_MODEL`
  - `CV_AI_TIMEOUT_SECONDS`
- Cấu hình Google OAuth2 có thể được ghi đè bằng:
  - `GOOGLE_CLIENT_ID`
  - `GOOGLE_CLIENT_SECRET`

## Chạy trên Windows

1. Giải nén tệp dự án.
2. Mở Command Prompt trong thư mục `findjob_tt`.
3. Chạy một trong các lệnh sau:

```bat
run-windows-jar.bat
```
