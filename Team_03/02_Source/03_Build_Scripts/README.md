# FitTrack Build Scripts (Batch Files)

Simple and clean build scripts for the FitTrack fitness tracking application.

## Available Scripts

### Core Build Scripts

- **`build-backend.bat`** - Builds all backend services using Docker

### Management Scripts

- **`manage-services.bat`** - Start, stop, restart, or check status of Docker services
- **`health-check.bat`** - Performs health checks on all running services

### Utility Scripts

- **`utils/check-requirements.bat`** - Checks if required tools are installed

## Prerequisites

- **Java 17+** (for Spring Boot services)
- **Docker Desktop** (for containerization)
- **Node.js** (for admin dashboard)
- **Flutter** (for mobile app)
- **Python 3.8+** (for embedding service)

Run `utils\check-requirements.bat` to verify installations.

## Quick Start

1. **Check Requirements**:
   ```cmd
   utils\check-requirements.bat
   ```

2. **Build Backend Services**:
   ```cmd
   build-backend.bat
   ```

3. **Start Services**:
   ```cmd
   manage-services.bat start
   ```

4. **Check Health**:
   ```cmd
   health-check.bat   ```

## Script Usage

### build-backend.bat
```cmd
build-backend.bat [--environment dev|prod] [--skip-tests] [--service service-name]
```

**Options:**
- `--environment`: Target environment (dev/prod, default: dev)
- `--skip-tests`: Skip running tests during build
- `--service`: Build specific service only (default: all)

**Examples:**
```cmd
build-backend.bat
build-backend.bat --service gateway-service
### manage-services.bat
Manages Docker services for the application.

```cmd
manage-services.bat <start|stop|restart|status> [--build]
```

Examples:
- `manage-services.bat start` - Start all services
- `manage-services.bat start --build` - Build and start services
- `manage-services.bat stop` - Stop all services
- `manage-services.bat status` - Show service status

### health-check.bat
Checks the health of all running services.

```cmd
health-check.bat
```

## Service Endpoints

When services are running:

- **Gateway**: http://localhost:8080
- **Food Service**: http://localhost:8081
- **Exercise Service**: http://localhost:8082
- **Media Service**: http://localhost:8083
- **Statistic Service**: http://localhost:8084
- **Embedding Service**: http://localhost:8085

## Health Check Endpoints

- **Gateway**: http://localhost:8080/actuator/health
- **Food Service**: http://localhost:8081/actuator/health
- **Exercise Service**: http://localhost:8082/actuator/health
- **Media Service**: http://localhost:8083/actuator/health
- **Statistic Service**: http://localhost:8084/actuator/health
- **Embedding Service**: http://localhost:8085/health


