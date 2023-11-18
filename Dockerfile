FROM maven:3.6-jdk-11 as step1
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn package

FROM adoptopenjdk/openjdk11:alpine-slim
COPY --from=step1 /app/target/*.jar /app/application.jar
ENTRYPOINT ["java","-jar","/app/application.jar"]