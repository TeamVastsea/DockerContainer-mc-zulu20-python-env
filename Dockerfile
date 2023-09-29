FROM azul/zulu-openjdk-alpine:20-latest AS zulu-jdk20
LABEL LABEL org.opencontainers.image.authors="Snowball_233"

# required to use jlink
RUN apk add --no-cache binutils

# build slim jre
RUN $JAVA_HOME/bin/jlink \
         --verbose \
         --add-modules ALL-MODULE-PATH \
         --strip-debug \
         --no-man-pages \
         --no-header-files \
         --compress=2 \
         --output /zulu-jre20

FROM python:3.11-bookworm AS python

# setup jre
ENV JAVA_HOME=/jre
ENV PATH="${JAVA_HOME}/bin:${PATH}"
COPY --from=zulu-jdk20 /zulu-jre20 $JAVA_HOME

# install mcdr
RUN pip3 install mcdreforged -i

CMD ["bash"]
