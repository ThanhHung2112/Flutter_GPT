# Flutter_GPT

This is a mobile application built with Flutter, integrating OpenAI's API. The app was developed during my internship at BRYCEN company, featuring two main functionalities: a chatbot and a document summarization tool.

This repository contains a Flutter mobile app that utilizes the OpenAI API to power a chatbot functionality. The app interface is designed with multiple screens, including the Home Page, OpenAI key input, Chatbot Screen, and Summarize Screens.

Please note that the displayed below are part of the app's interface and showcase the various functionalities available in the Flutter_GPT app.

Feel free to explore the code and use it as a reference for your own projects or [download the APK](https://github.com/ThanhHung2112/Flutter_GPT/raw/main/assets/app-release.apk) to experience and don't forget to star this 😁

## Features

- Chatbot: Utilizing the **LLM GPT-3.5** model with swift responsiveness and naturalness for conversational interactions.
- Summarize Tool: Addressing all questions related to your documents, aiding in swift retrieval and information extraction from various sources.
- Enable **Memory feature** and **Multi-Conversation** for both functionality.
- Support for `.pdf`,`.txt`, `.docx` and audio file such as `.mp3`, `.wav`, `.mpga`, `.mpeg`.

## User Interface

https://github.com/ThanhHung2112/Flutter_GPT/assets/73764342/994f9db1-920e-4dfe-8b79-84a17966f238

### Chat Memory
<p align="center">
  <img src="https://github.com/ThanhHung2112/Flutter_GPT/blob/main/IMG/Screenshot_1690989691.png" width="350" alt="Home Page 1">
  <img src="https://github.com/ThanhHung2112/Flutter_GPT/blob/main/IMG/Screenshot_1690990527.png" width="350" alt="Home Page 2">
</p>

## Installation

You can download the APK file from the releases section of this repository or build the app from source using the
instructions below:

1. Clone this repository to your computer
```
git clone https://github.com/ThanhHung2112/Flutter_GPT/
```
2. Move to the Folder
```
cd Flutter_GPT/flutter_gpt
```
3. Install denpendencie
```
flutter pub get
```
4. If you are new to FlutterFire and you want to use this reponsitory with your own firebase 👉 flow the [Setup flutterfire](#section2)
```
flutter run
```
It may take a while for the first time you build this app.

## Interesting discovery

If you set the API key within the code like this, you can continue to use it even if the key has expired.
```dart
OpenAI.instance.build(
      token: "<<your-api-keys>>",
      baseOption: HttpSetup(
        receiveTimeout: const Duration(seconds: 100),
        connectTimeout: const Duration(seconds: 100),
      ),
    )
```
This trick is quite handy while building code, as it allows you to save time and resources and it still works until 31.07.23.

## Setup flutterfire
<a name="section2"></a>
Flow the link https://firebase.google.com/docs/flutter/setup?platform=ios

### 1. Setup your firebase
https://github.com/ThanhHung2112/Flutter_GPT/assets/73764342/80c8ef03-a75d-4253-b39d-899951cf3734

### Storage
 Choose test mode in Storage and paste this code at rules partten
```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read, write;
    }
  }
}
```
### 2. Setup firebase in your computer
```
npm i -g firebase-tools
```
```
firebase login
```
```
dart pub global activate flutterfire_cli
```
```
flutterfire configure
```
You might encounter the error ```command not found: flutterfire``` . In this case, you need to add the path that has been indicated when running the ```flutterfire_cli``` mismatch activation to your computer's environment. You can flow [Fix command not found](#section1) to solve this issue

After this command a file call ```firebase_option.dart``` will be create in your folder
```
flutter pub add firebase_core
```
Run this again to make sure everything installed in your computer
```
flutterfire configure
```
<a name="section1"></a>
## Fix command not found: flutterfire

1. In your terminal and run this code to open **Advanced system settings**
```
SystemPropertiesAdvanced
```
2. Click Environment Variables. In the section System Variables find the PATH environment variable and select it. Click Edit. If the PATH environment variable does not exist, click New.
4. In the Edit System Variable (or New System Variable) window, specify the value of the PATH environment variable ( The path might look like this *"C:\Users\YourUsername\AppData\Local\Pub\Cache\bin"*). Click OK. Close all remaining windows by clicking OK.
5. You might have to restart your computer to active path
## Acknowledgements

This app was built using the following open-source libraries and tools:

* [Flutter](https://flutter.dev/)
* [Dart](https://dart.dev/)
* [OpenAI GPT](https://beta.openai.com/)
* [Firebase](https://firebase.google.com/docs/flutter/setup)

## Time Tracking

| Date                   | Task                | Notes                                               |
|------------------------|---------------------|-----------------------------------------------------|
|12.07.23                | Project setup       |                                                     |
|13➖14.07.23      | Chatbot UI     | Theme, chatbot interface.                            |
|17➖19.07.23      | Send & Respond  | Send & respond message functionality.               |
|21➖23.07.23       | AIHandler        | Integrated chat_gpt_sdk for AI capabilities        |
| 24.07.23       | HomePage UI        | Implemented isKeyValid check and set up Navigator.   |
| 25➖26.07.23       | Firebase Connection | Set up Firebase_CIL and implemented file upload to Firebase. |
| 28.07.23       | Sidebar SM chatbot| Test the summarize feature & chatbot memory function, Sidebar UI, update the getApiKey method.|
| 29.07.23       | Upload file from Sidebar | Upload file/PDF from Sidebar. |
| 30.07.23       | Summarize model | SummarizeModel and Summrizechat send & respond message functionality, also update the sidebar UI.|
| 31.07.23       | View PDF, AI Summarize | Get and display PDF file, Create method Summarize chat. |
| 01.08.23       | Update readfile feature & uploadfile Notify | Update file reading feature to support docx and txt formats and add file upload notification for better user experience. Streamline the code for improved efficiency.|
| 02.08.23       | Text to speech & Chat Memory | Allow users to listen to bot responses. Add chat memory feature. |
| 08.08.23       | Audio file & chunking document |Upload audio file to firebase, Chunking down the documents for processing and code optimization.|
| 10.08.23 | Chunking document | Optimal summarize document and fix minor bugs |

