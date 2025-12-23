FROM dart:stable

# Install Flutter dependencies
RUN apt-get update && \
    apt-get install -y git curl unzip xz-utils zip libglu1-mesa openjdk-17-jdk wget && \
    rm -rf /var/lib/apt/lists/*

# Install Flutter SDK
RUN git clone https://github.com/flutter/flutter.git /flutter
ENV PATH="/flutter/bin:/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Install Android SDK
ENV ANDROID_SDK_ROOT="/android-sdk"
RUN mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools && \
    cd ${ANDROID_SDK_ROOT}/cmdline-tools && \
    wget https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -O tools.zip && \
    unzip tools.zip -d tmp && \
    mv tmp/cmdline-tools ${ANDROID_SDK_ROOT}/cmdline-tools/latest && \
    rm -rf tmp tools.zip

ENV PATH="${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${ANDROID_SDK_ROOT}/platform-tools:${PATH}"


# Isolate Gradle cache
ENV GRADLE_USER_HOME="/home/gradle-cache"

# Accept licenses and install build tools
RUN yes | sdkmanager --licenses && \
    sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"

# Set up Flutter
RUN flutter doctor

# Set working directory
WORKDIR /app

# Copy project files
COPY . .

# Replace default gradle.properties with Docker-safe version
COPY android/gradle-docker.properties android/gradle.properties

# Get Flutter packages
RUN flutter pub get

# Build APK
CMD ["flutter", "build", "apk", "--release"]
