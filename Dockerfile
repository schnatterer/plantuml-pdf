# Keep in sync with the versions in pom.xml
ARG JDK_VERSION='17'

FROM eclipse-temurin:${JDK_VERSION}-jdk-alpine as jdk

FROM jdk as maven-cache
ENV MAVEN_OPTS=-Dmaven.repo.local=/mvn
WORKDIR /app
COPY .mvn/ /app/.mvn/
COPY mvnw /app/ 
COPY pom.xml /app/
RUN ./mvnw dependency:go-offline

FROM jdk as build
ENV MAVEN_OPTS=-Dmaven.repo.local=/mvn 
WORKDIR /app
COPY --from=maven-cache /mvn/ /mvn/
COPY --from=maven-cache /app/ /app
RUN ./mvnw package 

FROM eclipse-temurin:${JDK_VERSION}-jre-jammy
WORKDIR /data

ENV LANG en_US.UTF-8

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
    graphviz \
    fonts-dejavu \
    && apt-get autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN useradd --create-home --shell /bin/bash -u 1000 plantuml
COPY --from=build --chown=1000:0 /app/target/plantuml-pdf-*-jar-with-dependencies.jar /opt/plantuml.jar

ENTRYPOINT ["java", "-jar", "/opt/plantuml.jar"]
CMD ["-version"]