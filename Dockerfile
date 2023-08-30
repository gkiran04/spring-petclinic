FROM 001285825849.dkr.ecr.us-east-1.amazonaws.com/openjdk:22-jdk-slim
WORKDIR /app
COPY ./target/spring-petclinic-3.1.0-SNAPSHOT.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "-Dspring.profiles.active=mysql", "app.jar"]
