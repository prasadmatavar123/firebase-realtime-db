# Firebase Realtime Database

### Step 1: Connect Your Flutter App to Firebase

First, connect your Flutter application to your Firebase project.

### Step 2: Add Required Dependencies

Open the terminal in your Flutter project and run the following commands:

```bash
flutter pub add firebase_core
flutter pub add firebase_database
flutter pub add provider
```

### Step 3: Create a Realtime Database

1. Open your project in the **Firebase Console**.
2. Go to **Build → Realtime Database**.
3. Click **Create Database**.
4. Select your preferred database location.
5. Select **Start in Test Mode**.
6. Click **Enable**.

### Step 4: Update Database Rules

1. Go to the **Rules** tab in Realtime Database.
2. Change the required rule value from `false` to `true`.
3. Click **Publish** to save the changes.

> **Note:** Test Mode allows read and write access for development. For a production application, configure secure Firebase Database Rules instead of keeping unrestricted access enabled.

