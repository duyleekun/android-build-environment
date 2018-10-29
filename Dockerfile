# Android Dockerfile

FROM openjdk:8-jdk-alpine

MAINTAINER Le Duc Duy "duyleekun@gmail.com"

# Sets language to UTF8 : this works in pretty much all cases
ENV LANG en_US.UTF-8

ENV DOCKER_ANDROID_LANG en_US
ENV DOCKER_ANDROID_DISPLAY_NAME mobileci-docker


ENV ANDROID_HOME="/usr/local/android-sdk"
ENV ANDROID_SDK_TOOLS_VERSION "4333796"

ENV FASTLANE_VERSION=2.107.0

# Never ask for confirmations
ENV DEBIAN_FRONTEND noninteractive

RUN apk add --update \
    ca-certificates \
    bash \
    wget \
    unzip \
    libstdc++ \
    g++ \
    make \
    ruby \
    ruby-irb \
    ruby-dev \
    yarn \
    && rm -rf /var/cache/apk/*

# Fastlane
RUN gem install fastlane -N -v $FASTLANE_VERSION


# Android SDK

ENV SDK_URL="https://dl.google.com/android/repository/sdk-tools-linux-${ANDROID_SDK_TOOLS_VERSION}.zip"
ENV DOWNLOAD_FILE=/tmp/sdk.zip
RUN mkdir -p "$ANDROID_HOME" \
    && wget -q -O "$DOWNLOAD_FILE" $SDK_URL \
    && unzip "$DOWNLOAD_FILE" -d "$ANDROID_HOME" \
    && rm "$DOWNLOAD_FILE" \
    && yes | $ANDROID_HOME/tools/bin/sdkmanager --licenses

# Android tool
RUN mkdir /app
WORKDIR /app
