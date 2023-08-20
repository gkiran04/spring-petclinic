FROM openjdk:22-jdk-slim
WORKDIR /app
COPY ./target/spring-petclinic-3.1.0-SNAPSHOT.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
