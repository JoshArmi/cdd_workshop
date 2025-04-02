FROM eclipse-temurin:17-jdk-ubi9-minimal AS build
WORKDIR /workspace/app

# Install Maven
RUN microdnf install -y maven

# Download Maven wrapper
RUN mkdir -p .mvn/wrapper
RUN curl -o .mvn/wrapper/maven-wrapper.jar https://repo.maven.apache.org/maven2/org/apache/maven/wrapper/maven-wrapper/3.2.0/maven-wrapper-3.2.0.jar

COPY mvnw .
COPY .mvn .mvn
RUN chmod +x mvnw
COPY pom.xml .
COPY src src

RUN ./mvnw -version
RUN ./mvnw dependency:go-offline
RUN ./mvnw install
RUN mkdir -p target/dependency && (cd target/dependency; jar -xf ../*.jar)

FROM eclipse-temurin:17-jdk-ubi9-minimal
VOLUME /tmp
ARG DEPENDENCY=/workspace/app/target/dependency
COPY --from=build ${DEPENDENCY}/BOOT-INF/lib /app/lib
COPY --from=build ${DEPENDENCY}/META-INF /app/META-INF
COPY --from=build ${DEPENDENCY}/BOOT-INF/classes /app
ENTRYPOINT ["java","-cp","app:app/lib/*","com.example.demo.DemoApplication"] 
