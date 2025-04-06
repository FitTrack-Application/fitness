-- Tạo database cho các service
CREATE DATABASE fit_service_db;
CREATE DATABASE statistic_service_db;
CREATE DATABASE user_service_db;

-- Cấp quyền
GRANT ALL PRIVILEGES ON DATABASE fit_service_db TO postgres;
GRANT ALL PRIVILEGES ON DATABASE statistic_service_db TO postgres;
GRANT ALL PRIVILEGES ON DATABASE user_service_db TO postgres;