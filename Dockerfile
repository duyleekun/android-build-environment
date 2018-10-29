# Android Dockerfile

FROM openjdk:8-jdk-alpine

MAINTAINER Le Duc Duy "duyleekun@gmail.com"

# Sets language to UTF8 : this works in pretty much all cases
ENV LANG en_US.UTF-8

ENV DOCKER_ANDROID_LANG en_US
ENV DOCKER_ANDROID_DISPLAY_NAME mobileci-docker

ENV ANDROID_SDK_TOOLS "4333796"
ENV FASTLANE_VERSION=2.107.0


# Never ask for confirmations
ENV DEBIAN_FRONTEND noninteractive

RUN apk update
RUN apk add wget tar unzip curl bash ruby ruby-irb ruby-dev libstdc++ zlib-dev openssh g++ make
RUN rm -rf /var/cache/apk/*

# Fastlane
RUN gem install fastlane -N -v $FASTLANE_VERSION

# Android tool
RUN wget --quiet --output-document=android-sdk.tgz https://dl.google.com/android/repository/sdk-tools-linux-$ANDROID_SDK_TOOLS.zip
RUN unzip android-sdk.tgz
RUN rm android-sdk.tgz


ENV ANDROID_HOME "$PWD/tools"
ENV PATH "$PATH:$PWD/tools/bin/"
