# Android Dockerfile

FROM adoptopenjdk/openjdk11:alpine

# Sets language to UTF8 : this works in pretty much all cases
ENV LANG en_US.UTF-8

ENV DOCKER_ANDROID_LANG en_US
ENV DOCKER_ANDROID_DISPLAY_NAME mobileci-docker


ENV ANDROID_HOME="/usr/local/android-sdk"
ENV ANDROID_SDK_TOOLS_VERSION "9123335_latest"

ENV GLIBC_VERSION=2.35-r0
ENV FASTLANE_VERSION=2.211.0

# Never ask for confirmations
ENV DEBIAN_FRONTEND noninteractive

RUN apk add --no-cache \
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
    ruby-etc \
    yarn

# Fastlane
RUN gem install bundler --no-document
RUN gem install fastlane -N -v $FASTLANE_VERSION
RUN yarn global add npx firebase-tools


# Android SDK
ENV SDK_URL="https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_SDK_TOOLS_VERSION}.zip"
ENV DOWNLOAD_FILE=/tmp/sdk.zip
RUN mkdir -p "$ANDROID_HOME" \
    && wget -q -O "$DOWNLOAD_FILE" $SDK_URL \
    && unzip "$DOWNLOAD_FILE" -d "$ANDROID_HOME" \
    && rm "$DOWNLOAD_FILE"

RUN mv $ANDROID_HOME/cmdline-tools $ANDROID_HOME/latest && mkdir $ANDROID_HOME/cmdline-tools/ && mv $ANDROID_HOME/latest $ANDROID_HOME/cmdline-tools/
RUN yes | $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager --install "build-tools;28.0.3" "build-tools;29.0.3" "build-tools;31.0.0" "platforms;android-29" "platforms;android-31"
RUN yes | $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager --licenses


# AIDL deps
# RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub
# RUN mkdir -p /tmp/glibc
# RUN for PACKAGE in glibc glibc-bin glibc-i18n glibc-dev; do \
#         export APK_FILE="${PACKAGE}-${GLIBC_VERSION}.apk" && \
#         export APK_PATH="/tmp/glibc/$APK_FILE" && \
#         wget -O $APK_PATH https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/${APK_FILE} && \
#         ls -alh $APK_PATH && \
#         echo https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/${APK_FILE} && \
#         apk add --force-overwrite $APK_PATH; \
#     done

RUN rm -rf /tmp/glibc

# Android tool
RUN mkdir /app
WORKDIR /app
