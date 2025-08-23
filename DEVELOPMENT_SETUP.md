# StudySuite Development Setup Guide

## 🚀 Getting Started

This guide will help you set up the StudySuite development environment on your machine. StudySuite is an Android application that combines Kotlin frontend with native C++ backend for optimal performance.

## 📋 Prerequisites

### Required Software
- **Android Studio** (Latest stable version)
- **Java Development Kit (JDK)** 8 or 11
- **Android SDK** (API 26-34)
- **Android NDK** (Version 25.2.9519653)
- **CMake** (Version 3.18.1 or higher)
- **Git** (For version control)

### System Requirements
- **Operating System**: Windows 10/11, macOS 10.15+, or Linux
- **RAM**: Minimum 8GB, Recommended 16GB+
- **Storage**: At least 10GB free space
- **Processor**: Multi-core processor (Intel i5/AMD Ryzen 5 or better)

## 🛠 Installation Steps

### 1. Install Android Studio
1. **Download Android Studio** from [developer.android.com](https://developer.android.com/studio)
2. **Run the installer** and follow the setup wizard
3. **Install Android SDK** during setup (API 26-34)
4. **Install Android Virtual Device (AVD)** for testing

### 2. Install Java Development Kit
```bash
# For Windows (using Chocolatey)
choco install openjdk11

# For macOS (using Homebrew)
brew install openjdk@11

# For Linux (Ubuntu/Debian)
sudo apt update
sudo apt install openjdk-11-jdk

# For Linux (CentOS/RHEL)
sudo yum install java-11-openjdk-devel
```

### 3. Install Android NDK
1. **Open Android Studio**
2. **Go to Tools → SDK Manager**
3. **Click on SDK Tools tab**
4. **Check "NDK (Side by side)"**
5. **Click Apply and install NDK version 25.2.9519653**

### 4. Install CMake
1. **In SDK Manager → SDK Tools tab**
2. **Check "CMake"**
3. **Click Apply and install CMake 3.18.1**

## 🔧 Environment Configuration

### 1. Set Environment Variables

#### Windows
```cmd
# Set JAVA_HOME
setx JAVA_HOME "C:\Program Files\Java\jdk-11"

# Set ANDROID_HOME
setx ANDROID_HOME "%USERPROFILE%\AppData\Local\Android\Sdk"

# Set ANDROID_NDK_HOME
setx ANDROID_NDK_HOME "%USERPROFILE%\AppData\Local\Android\Sdk\ndk\25.2.9519653"

# Add to PATH
setx PATH "%PATH%;%ANDROID_HOME%\tools;%ANDROID_HOME%\platform-tools"
```

#### macOS/Linux
```bash
# Add to ~/.bash_profile or ~/.zshrc
export JAVA_HOME=/Library/Java/JavaVirtualMachines/openjdk-11.jdk/Contents/Home
export ANDROID_HOME=$HOME/Library/Android/sdk
export ANDROID_NDK_HOME=$HOME/Library/Android/sdk/ndk/25.2.9519653
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
```

### 2. Verify Installation
```bash
# Check Java version
java -version

# Check Android SDK
sdkmanager --list

# Check NDK
ls $ANDROID_NDK_HOME

# Check CMake
cmake --version
```

## 📱 Project Setup

### 1. Clone the Repository
```bash
git clone https://github.com/yourusername/StudySuite.git
cd StudySuite
```

### 2. Open in Android Studio
1. **Launch Android Studio**
2. **Select "Open an existing Android Studio project"**
3. **Navigate to the StudySuite folder**
4. **Click "OK"**

### 3. Sync Project
1. **Wait for initial sync to complete**
2. **If sync fails, click "Sync Now"**
3. **Resolve any dependency issues**

### 4. Configure NDK Path
1. **Go to File → Project Structure**
2. **Select "SDK Location"**
3. **Set NDK location to your installed NDK path**
4. **Click "OK"**

## 🔨 Build Configuration

### 1. Gradle Configuration
The project uses Gradle with the following configuration:

```groovy
// Top-level build.gradle
plugins {
    id 'com.android.application' version '8.1.4' apply false
    id 'com.android.library' version '8.1.4' apply false
    id 'org.jetbrains.kotlin.android' version '1.9.10' apply false
}
```

### 2. App-level Configuration
```groovy
// app/build.gradle
android {
    namespace 'com.studysuite.app'
    compileSdk 34
    
    defaultConfig {
        applicationId "com.studysuite.app"
        minSdk 26
        targetSdk 34
        versionCode 1
        versionName "1.0"
        
        externalNativeBuild {
            cmake {
                cppFlags "-std=c++14"
                arguments "-DANDROID_STL=c++_shared"
            }
        }
    }
    
    externalNativeBuild {
        cmake {
            path file('CMakeLists.txt')
            version '3.18.1'
        }
    }
    
    ndkVersion "25.2.9519653"
}
```

### 3. CMake Configuration
```cmake
# app/CMakeLists.txt
cmake_minimum_required(VERSION 3.18.1)
project("studysuite")

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

add_library(studysuite SHARED src/main/cpp/studysuite.cpp)
find_library(log-lib log)
target_link_libraries(studysuite ${log-lib})

if(ANDROID)
    set_target_properties(studysuite PROPERTIES
        ANDROID_STL c++_shared
        ANDROID_ARM_NEON TRUE
    )
    
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fPIC")
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fPIC")
endif()
```

## 🚀 Building the Project

### 1. Clean Build
```bash
# Clean previous builds
./gradlew clean

# Clean build cache
./gradlew cleanBuildCache
```

### 2. Build Debug APK
```bash
# Build debug version
./gradlew assembleDebug

# Build for specific ABI
./gradlew assembleDebug -PabiFilters=arm64-v8a
```

### 3. Build Release APK
```bash
# Build release version
./gradlew assembleRelease

# Build with ProGuard
./gradlew assembleRelease -PminifyEnabled=true
```

### 4. Install on Device
```bash
# Install debug version
./gradlew installDebug

# Install release version
./gradlew installRelease
```

## 🧪 Testing

### 1. Unit Tests
```bash
# Run all unit tests
./gradlew test

# Run specific test class
./gradlew test --tests "com.studysuite.app.StudySuiteActivityTest"
```

### 2. Instrumented Tests
```bash
# Run instrumented tests
./gradlew connectedAndroidTest

# Run on specific device
./gradlew connectedAndroidTest -PdeviceId=emulator-5554
```

### 3. Lint Checks
```bash
# Run lint analysis
./gradlew lint

# Generate lint report
./gradlew lintDebug
```

## 🔍 Debugging

### 1. Native Code Debugging
1. **Enable native debugging in build.gradle**
```groovy
android {
    buildTypes {
        debug {
            debuggable true
            jniDebuggable true
        }
    }
}
```

2. **Set breakpoints in C++ code**
3. **Use Android Studio's native debugger**

### 2. WebView Debugging
1. **Enable WebView debugging**
```kotlin
if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
    WebView.setWebContentsDebuggingEnabled(true)
}
```

2. **Use Chrome DevTools for WebView debugging**

### 3. Logging
```kotlin
// Kotlin logging
Log.d("StudySuite", "Debug message")
Log.e("StudySuite", "Error message")

// C++ logging
__android_log_print(ANDROID_LOG_INFO, "StudySuite", "Native log message");
```

## 📊 Performance Analysis

### 1. Profiling
1. **Use Android Studio Profiler**
2. **Monitor CPU, Memory, and Network usage**
3. **Analyze native code performance**

### 2. Memory Analysis
```bash
# Generate memory dump
./gradlew dumpMemory

# Analyze memory usage
./gradlew analyzeMemory
```

### 3. Performance Testing
```bash
# Run performance tests
./gradlew performanceTest

# Generate performance report
./gradlew performanceReport
```

## 🚨 Troubleshooting

### Common Issues

#### Build Failures
```bash
# Clean and rebuild
./gradlew clean
./gradlew assembleDebug

# Check Gradle daemon
./gradlew --stop
./gradlew assembleDebug
```

#### NDK Issues
```bash
# Verify NDK installation
ls $ANDROID_NDK_HOME

# Check NDK version compatibility
./gradlew --version
```

#### CMake Issues
```bash
# Verify CMake installation
cmake --version

# Check CMake path in build.gradle
```

#### Memory Issues
```bash
# Increase Gradle memory
echo 'org.gradle.jvmargs=-Xmx4096m' >> gradle.properties

# Clean build cache
./gradlew cleanBuildCache
```

### Getting Help
1. **Check Android Studio logs**
2. **Review Gradle build output**
3. **Check CMake configuration**
4. **Verify environment variables**
5. **Consult Android NDK documentation**

## 🔄 Continuous Integration

### 1. GitHub Actions
```yaml
# .github/workflows/android.yml
name: Android CI

on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: actions/setup-java@v2
        with:
          java-version: '11'
      - uses: actions/setup-android@v2
        with:
          ndk-version: '25.2.9519653'
      - run: ./gradlew assembleDebug
```

### 2. Local CI
```bash
# Run all checks locally
./gradlew check
./gradlew test
./gradlew lint
./gradlew assembleDebug
```

## 📚 Additional Resources

### Documentation
- [Android NDK Guide](https://developer.android.com/ndk/guides)
- [CMake Documentation](https://cmake.org/documentation/)
- [Kotlin Documentation](https://kotlinlang.org/docs/)
- [Android Developer Guide](https://developer.android.com/guide)

### Tools
- [Android Studio](https://developer.android.com/studio)
- [Android NDK](https://developer.android.com/ndk)
- [CMake](https://cmake.org/)
- [Gradle](https://gradle.org/)

### Community
- [Stack Overflow](https://stackoverflow.com/questions/tagged/android-ndk)
- [Android Developers Community](https://developer.android.com/community)
- [Kotlin Community](https://kotlinlang.org/community/)

---

## 🎯 Next Steps

1. **Explore the codebase** - Understand the project structure
2. **Run the app** - Test on device or emulator
3. **Make changes** - Start developing new features
4. **Write tests** - Ensure code quality
5. **Submit PRs** - Contribute to the project

Happy coding! 🚀
