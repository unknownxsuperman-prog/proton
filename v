name: Build APK

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
      
      - name: Set up JDK 17
        uses: actions/setup-java@v4
        with:
          java-version: '17'
          distribution: 'temurin'
          cache: gradle
      
      - name: Make gradlew executable
        run: chmod +x gradlew
      
      - name: Build debug APK
        run: ./gradlew assembleDebug
      
      - name: Build release APK (unsigned)
        run: ./gradlew assembleRelease
      
      - name: Upload debug APK
        uses: actions/upload-artifact@v3
        with:
          name: debug-apk
          path: xbit-build/app/build/outputs/apk/debug/*.apk
      
      - name: Upload release APK
        uses: actions/upload-artifact@v3
        with:
          name: release-apk
          path: xbit-build/app/build/outputs/apk/release/*.apk
      
      - name: Upload build reports
        if: always()
        uses: actions/upload-artifact@v3
        with:
          name: build-reports
          path: xbit-build/app/build/reports/
