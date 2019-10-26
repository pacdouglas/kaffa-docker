FROM openjdk:8

ARG MAVEN_VERSION=3.6.1
ARG USER_HOME_DIR="/root"
ARG SHA=b4880fb7a3d81edd190a029440cdf17f308621af68475a4fe976296e71ff4a4b546dd6d8a58aaafba334d309cc11e638c52808a4b0e818fc0fd544226d952544
ARG BASE_URL=https://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries
RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
    && echo "Downloading maven" \
    && curl -fsSL -o /tmp/apache-maven.tar.gz ${BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
    \
    && echo "Checking download hash" \
    && echo "${SHA}  /tmp/apache-maven.tar.gz" | sha512sum -c - \
    \
    && echo "Unziping maven" \
    && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
    \
    && echo "Cleaning and setting links" \
    && rm -f /tmp/apache-maven.tar.gz \
    && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn
ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"
COPY maven/settings.xml /root/.m2/settings.xml

ARG GRADLE_VERSION=4.2.1
ARG GRADLE_BASE_URL=https://services.gradle.org/distributions
# obtained from here https://gradle.org/release-checksums/
ARG GRADLE_SHA=b551cc04f2ca51c78dd14edb060621f0e5439bdfafa6fd167032a09ac708fbc0
RUN mkdir -p /usr/share/gradle /usr/share/gradle/ref \
    && echo "Downlaoding gradle hash" \
    && curl -fsSL -o /tmp/gradle.zip ${GRADLE_BASE_URL}/gradle-${GRADLE_VERSION}-bin.zip \
    \
    && echo "Checking download hash" \
    && echo "${GRADLE_SHA}  /tmp/gradle.zip" | sha256sum -c - \
    \
    && echo "Unziping gradle" \
    && unzip -d /usr/share/gradle /tmp/gradle.zip \
    \
    && echo "Cleaning and setting links" \
    && rm -f /tmp/gradle.zip \
    && ln -s /usr/share/gradle/gradle-${GRADLE_VERSION} /usr/bin/gradle
ENV GRADLE_VERSION 3.3
ENV GRADLE_HOME /usr/bin/gradle
ENV GRADLE_USER_HOME /cache
ENV PATH $PATH:$GRADLE_HOME/bin
VOLUME $GRADLE_USER_HOME

RUN echo "Install Android SDK"
ARG ANDROID_SDK_VERSION=4333796
ENV ANDROID_HOME /opt/android-sdk
ENV ANDROID_SDK /opt/android-sdk
RUN mkdir -p ${ANDROID_HOME} && cd ${ANDROID_HOME} \
    && wget -q https://dl.google.com/android/repository/sdk-tools-linux-${ANDROID_SDK_VERSION}.zip \
    && unzip *tools*linux*.zip \
    && rm *tools*linux*.zip
RUN echo "Install Android SDK Versions" \
        && mkdir -p /root/.android/ \
        && touch /root/.android/repositories.cfg \
        && yes | $ANDROID_HOME/tools/bin/sdkmanager "build-tools;19.1.0" \
        && yes | $ANDROID_HOME/tools/bin/sdkmanager "build-tools;20.0.0" \
        && yes | $ANDROID_HOME/tools/bin/sdkmanager "build-tools;21.1.2" \
        && yes | $ANDROID_HOME/tools/bin/sdkmanager "build-tools;22.0.1" \
        && yes | $ANDROID_HOME/tools/bin/sdkmanager "build-tools;23.0.1" \
        && yes | $ANDROID_HOME/tools/bin/sdkmanager "build-tools;23.0.2" \
        && yes | $ANDROID_HOME/tools/bin/sdkmanager "build-tools;23.0.3" \
        && yes | $ANDROID_HOME/tools/bin/sdkmanager "build-tools;24.0.0" \
        && yes | $ANDROID_HOME/tools/bin/sdkmanager "build-tools;24.0.1" \
        && yes | $ANDROID_HOME/tools/bin/sdkmanager "build-tools;24.0.2" \
        && yes | $ANDROID_HOME/tools/bin/sdkmanager "build-tools;24.0.3" \
        && yes | $ANDROID_HOME/tools/bin/sdkmanager "build-tools;25.0.0" \
        && yes | $ANDROID_HOME/tools/bin/sdkmanager "build-tools;25.0.1" \
        && yes | $ANDROID_HOME/tools/bin/sdkmanager "build-tools;25.0.2" \
        && yes | $ANDROID_HOME/tools/bin/sdkmanager "build-tools;25.0.3" \
        && yes | $ANDROID_HOME/tools/bin/sdkmanager "build-tools;26.0.0" \
        && yes | $ANDROID_HOME/tools/bin/sdkmanager "build-tools;26.0.1" \
        && yes | $ANDROID_HOME/tools/bin/sdkmanager "build-tools;26.0.2" \
        && yes | $ANDROID_HOME/tools/bin/sdkmanager "build-tools;26.0.3" \
        && yes | $ANDROID_HOME/tools/bin/sdkmanager "build-tools;27.0.0" \
        && yes | $ANDROID_HOME/tools/bin/sdkmanager "build-tools;27.0.1" \
        && yes | $ANDROID_HOME/tools/bin/sdkmanager "build-tools;27.0.2" \
        && yes | $ANDROID_HOME/tools/bin/sdkmanager "build-tools;27.0.3" \
        && yes | $ANDROID_HOME/tools/bin/sdkmanager "build-tools;28.0.0" \
        && yes | $ANDROID_HOME/tools/bin/sdkmanager "build-tools;28.0.1" \
        && yes | $ANDROID_HOME/tools/bin/sdkmanager "build-tools;28.0.2" \
        && yes | $ANDROID_HOME/tools/bin/sdkmanager "build-tools;28.0.3" \
        && yes | $ANDROID_HOME/tools/bin/sdkmanager "platform-tools" \
        && yes | $ANDROID_HOME/tools/bin/sdkmanager "platforms;android-19" \
        && yes | $ANDROID_HOME/tools/bin/sdkmanager "platforms;android-20" \
        && yes | $ANDROID_HOME/tools/bin/sdkmanager "platforms;android-21" \
        && yes | $ANDROID_HOME/tools/bin/sdkmanager "platforms;android-22" \
        && yes | $ANDROID_HOME/tools/bin/sdkmanager "platforms;android-23" \
        && yes | $ANDROID_HOME/tools/bin/sdkmanager "platforms;android-24" \
        && yes | $ANDROID_HOME/tools/bin/sdkmanager "platforms;android-25" \
        && yes | $ANDROID_HOME/tools/bin/sdkmanager "platforms;android-26" \
        && yes | $ANDROID_HOME/tools/bin/sdkmanager "platforms;android-27" \
        && yes | $ANDROID_HOME/tools/bin/sdkmanager "platforms;android-28" \
        && echo "Android SDK finishing"

ARG ANDROID_NDK_SHA=ba85dbe4d370e4de567222f73a3e034d85fc3011b3cbd90697f3e8dcace3ad94
RUN echo "Downloading Android NDK R11c" \
    && mkdir -p /usr/share/android-ndk \
    && curl -fsSL -o /tmp/android-ndk.zip https://dl.google.com/android/repository/android-ndk-r11c-linux-x86_64.zip?hl=pt_br \
    && echo "Checking download hash" \
    && echo "${ANDROID_NDK_SHA}  /tmp/android-ndk.zip" | sha256sum -c - \
    \
    && echo "Unziping android-ndk" \
    && unzip -d /usr/share/android-ndk /tmp/android-ndk.zip \
    \
    && echo "Cleaning android-ndk" \
    && rm -f /tmp/android-ndk.zip
ENV ANDROID_NDK_HOME /usr/share/android-ndk/android-ndk-r11c
ENV PATH $PATH:$ANDROID_NDK_HOME

RUN echo "Install native dependencies" \
    && apt-get -y update \
    && apt-get -y install cmake \
    && apt-get -y install git \
    && apt-get -y install build-essential \
    && apt-get -y install automake  \
    && apt-get -y install libsqlite3-dev \
    && apt-get -y install g++-multilib \
    && apt-get -y install gcc-multilib \
    && apt-get -y install mingw-w64 \
    && apt-get -y install libz-mingw-w64 \
    && apt-get -y install libz-mingw-w64-dev \
    && apt-get -y install libtool \
    && apt-get -y install zlib1g \
    && apt-get -y install zlib1g-dev \
    && dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get -y install zlib1g:i386 \
    && apt-get -y install zlib1g-dev:i386

RUN echo "Install Wine" \
    && apt-get -y install --install-recommends wine-development

COPY kcct.sh /bin/kcct
COPY kcct-spatialite-cow /root/.kcct/
RUN echo "Install KCCT - Kaffa Cross Compiler Tool" \
    && chmod +x /bin/kcct

RUN echo "Copying Java Windows Includes"
COPY java-win-includes /opt/java-win-includes/
ENV JAVA_WIN_INCLUDES /opt/java-win-includes/

RUN echo "Install node 8 / npm / yarn" \
    && curl -sL https://deb.nodesource.com/setup_8.x | bash - \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update -qq && apt-get install -qq --no-install-recommends nodejs yarn \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get -y autoremove \
    && apt-get -y autoclean \
    && apt-get -y clean all

CMD [""]