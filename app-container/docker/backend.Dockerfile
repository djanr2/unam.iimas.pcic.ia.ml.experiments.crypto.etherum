FROM eclipse-temurin:19-jdk-alpine

WORKDIR /app
COPY backend/backend-ml-multivariate.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
