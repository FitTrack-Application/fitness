FROM openjdk:17-jdk-slim

WORKDIR /app

COPY target/*.jar app.jar
COPY .env .env

RUN apt-get update && apt-get install -y postgresql-client && apt-get clean

EXPOSE 8082

ENTRYPOINT ["java", "-jar", "app.jar"]
