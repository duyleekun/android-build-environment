# Android Dockerfile

FROM openjdk:8-jdk-alpine

MAINTAINER Le Duc Duy "duyleekun@gmail.com"

# Sets language to UTF8 : this works in pretty much all cases
ENV LANG en_US.UTF-8

ENV DOCKER_ANDROID_LANG en_US
ENV DOCKER_ANDROID_DISPLAY_NAME mobileci-docker


ENV ANDROID_HOME="/usr/local/android-sdk"
ENV ANDROID_SDK_TOOLS_VERSION "4333796"

ENV GLIBC_VERSION=2.28-r0
ENV FASTLANE_VERSION=2.134.0

# Never ask for confirmations
ENV DEBIAN_FRONTEND noninteractive

RUN apk add --update \
    ca-certificates \
    bash \
    wget \
    unzip \
    git \
    libstdc++ \
    g++ \
    make \
    ruby \
    ruby-irb \
    ruby-dev \
    yarn \
    ruby-bundler \
    && rm -rf /var/cache/apk/*

# Fastlane
RUN gem install fastlane -N -v $FASTLANE_VERSION
RUN yarn global add npx


# Android SDK

ENV SDK_URL="https://dl.google.com/android/repository/sdk-tools-linux-${ANDROID_SDK_TOOLS_VERSION}.zip"
ENV DOWNLOAD_FILE=/tmp/sdk.zip
RUN mkdir -p "$ANDROID_HOME" \
    && wget -q -O "$DOWNLOAD_FILE" $SDK_URL \
    && unzip "$DOWNLOAD_FILE" -d "$ANDROID_HOME" \
    && rm "$DOWNLOAD_FILE"

RUN yes | $ANDROID_HOME/tools/bin/sdkmanager --install "build-tools;28.0.3" "platforms;android-28"
RUN yes | $ANDROID_HOME/tools/bin/sdkmanager --licenses


# AIDL deps
RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub
RUN mkdir -p /tmp/glibc
RUN for PACKAGE in glibc glibc-bin glibc-i18n glibc-dev; do \
        export APK_FILE="${PACKAGE}-${GLIBC_VERSION}.apk"; \
        export APK_PATH="/tmp/glibc/$APK_FILE"; \
        wget -q -O $APK_PATH https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/${APK_FILE}; \
        apk add $APK_PATH; \
    done

RUN rm -rf /tmp/glibc

# Android tool
RUN mkdir /app
WORKDIR /app
