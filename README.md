## 방구석 브리핑 - Front-end

### General info
-----
Implemented front-end application pages of BIS-'방구석 브리핑' with Flutter(Dart) for Prometheus AI service Hackathon on 02 Feb, 2024 ~ 03 Feb, 2024

### Technologies
-----
- Flutter SDK version: 3.16.6
- Dart SDK version: 3.2.3
- Android Studio Giraffe version: 2022.3.1 Patch 1

### Setup
----
To run this project, first, manually copy & paste Dart scripts in the lib directory + pubspec.yaml, so that you can run the Android emulator witout error. Second, you have to run the FastAPI backend server in your local environment. Please check the Back repository to run server. Unluckily, This project support Android only. 

- If some errors occurred, you might try steps below. 
1. Check that AndroidManifest.xml is in
```
android/app/src/main/AndroidManifest.xml
```
2. Check the location of Flutter SDK or Dart SDK
3. Run
```
pub get
```
or 
```
flutter doctor
```
and try the follow instructions

### UI/UX
1. Login
- if ID is exists, Login else, Sign up
<img src="https://github.com/Baby-Im-Sorry/Front/assets/47784464/58cf8e33-14e3-461f-866c-7aea26e9bc58" width="300" height="480"/>
2. 
