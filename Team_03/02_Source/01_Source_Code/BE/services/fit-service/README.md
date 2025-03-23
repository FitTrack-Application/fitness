# Fit Service

## Introduction
This is a fitness management service, part of a fitness system.

## Setup and Run

### Requirements
- Java 17
- Maven
- Docker
- PostgreSQL

### Configuration
Edit the `.env` file to set up database connection parameters:
```
POSTGRESQL_DB_HOST=host.docker.internal (or postgres if using docker-compose)
POSTGRESQL_DB_PORT=5432
POSTGRESQL_DB_NAME=fit_service_db
POSTGRESQL_DB_USERNAME=postgres
POSTGRESQL_DB_PASSWORD=yourpassword
```

### Running with Docker

#### Using docker-compose (recommended)
```bash
# Build and run both PostgreSQL and the service
docker-compose up -d
```

#### Or using Docker individually
```bash
# Build the application
./mvnw clean package -DskipTests

# Build Docker image
docker build -t fit-service .

# Run container
docker run -p 8080:8080 --env-file .env fit-service
```

### Running in development environment

```bash
./mvnw spring-boot:run
```

## Features
- **Automatic database creation**: The service will automatically create the database based on JPA entities using Hibernate.
- **Automatic schema generation**: Hibernate will automatically create and update the database schema using entity mappings with `spring.jpa.hibernate.ddl-auto=update` configuration.

## Notes
- Make sure PostgreSQL is installed and running before starting the service (unless using docker-compose).
- The PostgreSQL user must have permission to create databases and tables.
- Schema generation happens automatically using JPA/Hibernate entity mappings. 