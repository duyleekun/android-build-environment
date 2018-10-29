# Android Dockerfile

FROM openjdk:8-jdk-alpine

MAINTAINER Le Duc Duy "duyleekun@gmail.com"

# Sets language to UTF8 : this works in pretty much all cases
ENV LANG en_US.UTF-8

ENV DOCKER_ANDROID_LANG en_US
ENV DOCKER_ANDROID_DISPLAY_NAME mobileci-docker

ENV ANDROID_SDK_TOOLS "4333796"


# Never ask for confirmations
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get --quiet update --yes
RUN apt-get --quiet install --yes wget tar unzip lib32stdc++6 lib32z1
RUN rm -rf /var/lib/apt/lists/*
RUN apt-get clean

RUN wget --quiet --output-document=android-sdk.tgz https://dl.google.com/android/repository/sdk-tools-linux-$ANDROID_SDK_TOOLS.zip
RUN unzip android-sdk.tgz
RUN rm android-sdk.tgz

ENV ANDROID_HOME "$PWD/tools"
ENV PATH "$PATH:$PWD/tools/bin/"

RUN \curl -sSL https://get.rvm.io | bash -s master --ruby
RUN source /usr/local/rvm/scripts/rvm; gem install fastlane -NV
