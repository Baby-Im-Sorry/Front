방구석 브리핑_Frontend
========================
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

4. Run
```
pub get
```
or 
```
flutter doctor
```
and try the follow instructions

### UI/UX
#### 1. Login
- if ID is exists, Login else, Sign up.

<img src="https://github.com/Baby-Im-Sorry/Front/assets/47784464/58cf8e33-14e3-461f-866c-7aea26e9bc58" width="300" height="480"/>|
|-|

#### 2. Home
- You can put time interval and set the end time to start the briefing.
- Or you can see ongoing briefing by tapping briefing button upside.
- You can go to History page and Custom GPT page in Home screen.

<img src="https://github.com/Baby-Im-Sorry/Front/assets/47784464/1971256f-35b9-430b-a83b-b90a7b11f9da" width="300" height="480"/>|
|-|

#### 3. Briefing
- You can see that captions are sent periodically at the interval you set.
- You can stop the briefing whenever you want.

<img src="https://github.com/Baby-Im-Sorry/Front/assets/47784464/44536b92-cef1-467d-9efd-d11da3f2adf4" width="300" height="480"/>|
|-|

#### 4. Request History
- You can select any past briefing you would like to see.


#### 5. Briefing History
- You can see every captions of each briefing.
- You can also receive the AI summary by pressing the 'AI summary' button.

<img src="https://github.com/Baby-Im-Sorry/Front/assets/47784464/ff7c43ba-a535-4488-80f2-772db1cefc9e" width="300" height="480"/>|
|-|

#### 6. AI Summary
- This is the summary of every captions in the briefing that you selected
- And this summary sentences are made by GPT-4 API
- Not only giving you a summary, But also giving you an advice for your constructive management. 

<img src="https://github.com/Baby-Im-Sorry/Front/assets/47784464/79cbf20b-466a-4187-b5a0-352d769733c2" width="300" height="480"/>|
|-|

#### 7. GPT Custom
- You can give instructions to customize GPT-4.
- You can adjust the length or style of a single caption by giving instructions.

<img src="https://github.com/Baby-Im-Sorry/Front/assets/47784464/83dcf6f0-0776-4a62-99fc-9158b048b443" width="300" height="480"/>|
|-|
