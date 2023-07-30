# Flutter_GPT

This is a mobile application built with Flutter, integrating OpenAI's API. The app was developed during my internship at BRYCEN company, featuring two main functionalities: a chatbot and a document summarization tool.

This repository contains a Flutter mobile app that utilizes the OpenAI API to power a chatbot functionality. The app interface is designed with multiple screens, including the Home Page, OpenAI key input, Chatbot Screen, and Summarize Screens.

Please note that the images displayed below are part of the app's interface and showcase the various functionalities available in the Flutter_GPT app.

Feel free to explore the code and use it as a reference for your own projects!

## Time Tracking

| Date             | Task                | Notes                                               |
|------------------|---------------------|-----------------------------------------------------|
|12.07.23          | Project setup       |                                                     |
|13.07.23-14.07.23| Chatbot UI     | Theme, chatbot interface                             |
|17.07.23-19.07.23| Send & Respond  | Send & respond message functionality               |
|21.07.23-23.07.23 | AIHandler        | Integrated chat_gpt_sdk for AI capabilities         |
| 24.07.23          | HomePage UI        | Implemented isKeyValid check and set up Navigator   |
| 25.07.23-26.07.23 | Firebase Connection | Set up Firebase_CIL and implemented file upload to Firebase |
| 28.07.23 | Sidebar SM chatbot| Test the summarize feature & chatbot memory function, Sidebar UI, update the getApiKey method.|
| 29.07.23 | Upload file from Sidebar | Upload file/PDF from Sidebar |
| 30.07.23 | Summarize model | SummarizeModel and Summrizechat send & respond message functionality, also update the sidebar UI.
## USER INTERFACE

### Home Page
<p align="center">
  <img src="https://github.com/ThanhHung2112/Flutter_GPT/blob/main/IMG/Screenshot_1690421223.png" width="350" alt="Home Page 1">
  <img src="https://github.com/ThanhHung2112/Flutter_GPT/blob/main/IMG/Screenshot_1690421239.png" width="350" alt="Home Page 2">
</p>

### Give the OpenAI Keys
<p>You have to provide the correct OpenAI API keys to get started.</p>
<p align="center">
  <img src="https://github.com/ThanhHung2112/Flutter_GPT/blob/main/IMG/Screenshot_1690426068.png" width="350" alt="OpenAI Keys">
  <img src="https://github.com/ThanhHung2112/Flutter_GPT/blob/main/IMG/Screenshot_1690421550.png" width="350" alt="OpenAI Keys">
</p>

### Chatbot Screen
<p align="center">
  <img src="https://github.com/ThanhHung2112/Flutter_GPT/blob/main/IMG/Screenshot_1690421902.png" width="350" alt="Chatbot Screen 1">
  <img src="https://github.com/ThanhHung2112/Flutter_GPT/blob/main/IMG/Screenshot_1690422007.png" width="350" alt="Chatbot Screen 2">
</p>

### Summarize Screens
<p align="center">
  <img src="https://github.com/ThanhHung2112/Flutter_GPT/blob/main/IMG/Screenshot_1690421964.png" width="350" alt="Summarize Screen 1">
  <img src="https://github.com/ThanhHung2112/Flutter_GPT/blob/main/IMG/Screenshot_1690422201.png" width="350" alt="Summarize Screen 2">
</p>

### Sidebar
<p align="center">
  <img src="https://github.com/ThanhHung2112/Flutter_GPT/blob/main/IMG/Screenshot_1690736790.png" width="350" alt="Sidebar 1">
  <img src="https://github.com/ThanhHung2112/Flutter_GPT/blob/main/IMG/Screenshot_1690736844.png" width="350" alt="Sidebar 2">
</p>

## Installation

You can download the APK file from the releases section of this repository or build the app from source using the
instructions below:

```bash
git clone https://github.com/ThanhHung2112/Flutter_GPT.git
cd Flutter_GPT/flutter_gpt
flutter pub get
flutter run
````
It may take a while for the first build of this app.

## Interesting discovery

If you set the API key within the code like this, you can continue to use it even if the key has expired.
```bash
OpenAI.instance.build(
      token: "<<your-api-keys>>",
      baseOption: HttpSetup(
        receiveTimeout: const Duration(seconds: 100),
        connectTimeout: const Duration(seconds: 100),
      ),
    )
````
This trick is quite handy while building code, as it allows you to save time and resources.

## Acknowledgements

This app was built using the following open-source libraries and tools:

* [Flutter](https://flutter.dev/)
* [Dart](https://dart.dev/)
* [OpenAI GPT](https://beta.openai.com/)
* [Firebase](https://firebase.google.com/docs/flutter/setup)



