# ─── Build stage ──────────────────────────────────────────────────────────
FROM maven:3.9.6-eclipse-temurin-17-alpine AS build
WORKDIR /app
# Since we are already in the 'backend' folder (Root Directory), 
# we copy directly from here.
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# ─── Run stage ────────────────────────────────────────────────────────────
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar

# Render usually uses PORT 8080 or 10000, but we can configure it
EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
