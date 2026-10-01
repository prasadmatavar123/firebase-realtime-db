# Firebase Realtime Database

###########################################################################

# How to Connect a Flutter App to Firebase

## Step 1: Create a Firebase Project

1. Go to the **Firebase Console**.
2. Click **Create a project**.
3. Enter your **Project Name**.
4. Click **Continue**.
5. If Gemini in Firebase is enabled, disable it for now.
6. Click **Continue**.
7. Disable **Google Analytics** for now.
8. Click **Continue** to create the project.

---

## Step 2: Add Your Flutter App to Firebase

After creating the Firebase project:

1. From the Firebase project dashboard, click **Add app**.
2. Select **Android**.
3. You can also add **iOS** and **Web** later if required.

For this setup, we are adding an **Android app**.

---

## Step 3: Register Your Android App

Firebase will ask for your Android package name.

1. Open your Flutter project in **Android Studio**.
2. Open:

```text
android/app/build.gradle
```

3. Find the `applicationId`.

For example:

```gradle
applicationId = "com.example.firebase_auth_login_signup"
```

4. Copy this package name.
5. Paste it into the **Android package name** field in Firebase.
6. Click **Register app**.

### Important: SHA-1

For basic Firebase Email/Password Authentication, **SHA-1 is generally not required**.

| Firebase Feature                | SHA-1 Usually Required? |
| ------------------------------- | ----------------------- |
| Email & Password Authentication | ❌ No                    |
| Anonymous Authentication        | ❌ No                    |
| Phone Authentication            | ❌ Generally no          |
| Google Sign-In                  | ✅ Yes                   |
| Cloud Firestore                 | ❌ No                    |
| Realtime Database               | ❌ No                    |
| Firebase Storage                | ❌ No                    |
| Firebase Cloud Messaging        | ❌ Not for basic setup   |
| Crashlytics                     | ❌ No                    |

> **Note:** Some authentication providers and Android features may require SHA-1/SHA-256 depending on the configuration.

---

## Step 4: Download `google-services.json`

Firebase will now show **Step 2 – Download config file**.

1. Click **Download google-services.json**.
2. Download the file.
3. Copy `google-services.json` into:

```text
android/app/
```

Your project should look similar to:

```text
your_flutter_project/
├── android/
│   └── app/
│       ├── google-services.json
│       ├── build.gradle
│       └── ...
├── lib/
├── pubspec.yaml
└── ...
```

4. Return to Firebase and click **Next**.

---

# Step 5: Add the Firebase Gradle Plugin

Firebase may show instructions for adding the Google Services Gradle plugin.

Select:

**Groovy**

The plugin is:

```text
Google Services Gradle Plugin
```

Maven coordinates:

```text
com.google.gms:google-services
```

### Important

The exact Gradle configuration can vary depending on your Flutter/Android Gradle Plugin version. For newer Flutter projects, the plugin is commonly configured through the Gradle `plugins` block rather than the older `buildscript { dependencies { classpath ... } }` approach.

If Firebase gives you a specific Gradle configuration for your project, follow that configuration.

---

## Step 6: Configure the App-Level Gradle File

Open:

```text
android/app/build.gradle
```

Make sure the Google Services plugin is applied.

For example:

```gradle
plugins {
    id 'com.android.application'
    id 'com.google.gms.google-services'
}
```

> **Note:** Do not add an extra space before `com.google.gms.google-services`.

---

## Step 7: Firebase BoM

For a Flutter application using FlutterFire packages such as:

```text
firebase_core
firebase_auth
```

you normally **do not need to manually add the Firebase Android BoM** to your app-level Gradle file just to use Firebase Authentication.

The FlutterFire packages manage the relevant Firebase Android dependencies.

---

# Step 8: Finish Firebase Android Setup

After completing the Firebase configuration:

1. Return to the Firebase Console.
2. Click **Continue to console**.

Your Flutter Android app is now connected to the Firebase project.

---

# Step 9: Add Firebase Packages to Flutter

Open the terminal in your Flutter project and run:

```bash
flutter pub add firebase_core
flutter pub add firebase_database
flutter pub add provider
```

Alternatively, you can add them to `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter

  firebase_core: ^4.15.0
  provider: ^6.1.5+1
  firebase_database: ^12.6.0
```

Then run:

```bash
flutter pub get
```

> Package versions change over time, so use the versions currently recommended by the FlutterFire documentation or `flutter pub add`.

---

# Step 10: Initialize Firebase in `main.dart`

Open:

```text
lib/main.dart
```

Before calling `Firebase.initializeApp()`, initialize the Flutter binding.

Your `main()` function should look like:

```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(const MyApp());
}
```

---

# Step 11: Firebase Setup Is Complete

At this point:

```text
Flutter App
     ↓
Firebase Project
     ↓
Android App Registered
     ↓
google-services.json
     ↓
Firebase Gradle Plugin
     ↓
firebase_core
     ↓
Firebase.initializeApp()
```

Your Flutter application is now connected to Firebase.

You can then start adding Firebase services such as:

* 🔐 Firebase Authentication
* 🗄️ Cloud Firestore
* ⚡ Realtime Database
* 📁 Firebase Storage
* 🔔 Firebase Cloud Messaging (FCM)
* 📊 Analytics
* 🐛 Crashlytics
* 🔗 Dynamic Links / App Links

###########################################################################

# Realtime Database Configuration

## Step 1: Create a Realtime Database

1. Open your project in the **Firebase Console**.
2. Go to **Build → Realtime Database**.
3. Click **Create Database**.
4. Select your preferred database location.
5. Select **Start in Test Mode**.
6. Click **Enable**.

### Step 2: Update Database Rules

1. Go to the **Rules** tab in Realtime Database.
2. Change the required rule value from `false` to `true`.
3. Click **Publish** to save the changes.

> **Note:** Test Mode allows read and write access for development. For a production application, configure secure Firebase Database Rules instead of keeping unrestricted access enabled.
