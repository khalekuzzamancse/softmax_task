
# Table of Contents
* [Project Overview](#project-overview)
* [Setup Instructions](#setup-instructions)
  * [Flutter and Dart Version](#flutter-and-dart-version)
  * [Run Configuration](#run-configuration)
  * [Cleaning](#cleaning)
* [Deep Link Testing Command](#deep-link-testing-command)
* [App Links](#-app-links)
* [Technical Details](#-technical-details)
  * [Directory Structure](#directory-structure)


---

# Project Overview

A cross-platform app assigned by **Softmax**, covering basic features including:

* **Authentication**

  * Login
  * Logout
  * Token refresh
  * Force logout on token expiry

* **User Info**

  * Read basic user info and display image and name

* **Post List**

  * List posts with a search option
  * Pagination supported

* **Post Details**

  * Read post details by ID
  * Deep link navigation to post details

* **Misc**

  * Simple splash screen
  * Confirmation dialog on app exit

**Note:** Right now, Post Details can be opened via deep link **only if the app is not already running**.

The APIs are used from `https://dummyjson.com/`.

Sample username and passoword for login:
- username: ```emilys```
- password: ```emilyspass```

# Setup Instructions

### Flutter and Dart Version
- Flutter 3.32.0
- Dart 3.8.0 

For cleaner code practices, the OS-targeted apps such as Android, iOS, etc. are moved to the `applications` directory, which is why additional customization is needed to use the `Flutter` plugin.

### Run Configuration

* Android Studio → Create a new configuration → Select the Dart entry point file: `applications/lib/main`
* Or run:

  ```bash
  cd applications && flutter run
  ```

### Cleaning

* Clean each package (root, apps, features) separately
* Or use the following command:

  ```bash
  flutter clean && cd applications && flutter clean && cd .. && cd feature && flutter clean
  ```




# Deep Link Testing Command

```bash
adb shell am start -W -a android.intent.action.VIEW -d "softmax://post/postId" kzcs.softmax_task.softmax_task
```
Example as:
```bash
adb shell am start -W -a android.intent.action.VIEW -d "softmax://post/1" kzcs.softmax_task.softmax_task
```

---

## App Links

| Description       | Link                            |
|:------------------|:--------------------------------|
| **Video Preview** | \[https://youtu.be/6E3WyiaPLPM] |
| **APK and Video Download**  | https://drive.google.com/drive/folders/1m4zqG4L-5rrH2X-ZIGuD8P4aj7rPkbdM                     |
| **Latest Code**   | \[ checkout to the `dev` branch]  |

---
# Technical Details

## Directory Structure

This Clean Architecture–based structure is followed. The directories and their purposes are as follows:

* **application**

  * Contains the app targets.

* **core**

  * Contains custom libraries or plugins. In this project, it includes a custom plugin for native method-channel calls.

* **feature**

  * Contains the actual app implementation.

* **feature::core**

  * Contains feature-independent code including networking I/O, data sources, API one-to-one mappings, logger, custom data structures, and common but feature-independent UI.
  * It does not depend on any outer or feature layer, but any feature layer can depend on it.

* **feature::features**

  * The directory containing the actual feature directories.

