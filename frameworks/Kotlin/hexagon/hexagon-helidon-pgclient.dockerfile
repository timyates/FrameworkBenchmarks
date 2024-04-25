#
# BUILD
#
FROM docker.io/gradle:8.6-jdk21-alpine AS build
USER root
WORKDIR /hexagon

ADD . .
RUN gradle --quiet classes
RUN gradle --quiet -x test installDist

#
# RUNTIME
#
FROM docker.io/eclipse-temurin:21-jre-alpine
ARG PROJECT=hexagon_helidon_pgclient

ENV POSTGRESQL_DB_HOST tfb-database
ENV JDK_JAVA_OPTIONS --enable-preview -XX:+AlwaysPreTouch -XX:+UseParallelGC -XX:+UseNUMA

COPY --from=build /hexagon/$PROJECT/build/install/$PROJECT /opt/$PROJECT

ENTRYPOINT [ "/opt/hexagon_helidon_pgclient/bin/hexagon_helidon_pgclient" ]
