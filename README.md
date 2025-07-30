# Clisence

Clisence is a Flutter mobile application that leverages Firebase for backend services and uses Provider for state management. The app is structured with authentication, home, settings, and profile pages, and is ready for further expansion with preferences, privacy, and help sections.

## Features

- User Authentication (Login, Signup)
- Home Screen
- Settings Screen
- Profile Screen
- Farm Location, Manage Crops (Coming Soon)
- Communication Preferences, Language Settings (Coming Soon)
- Privacy Settings (Coming Soon)
- Contact Support (Coming Soon)
- State management with Provider
- Theming support
- Environment variable management with `flutter_dotenv`
- Firebase integration (Auth, Firestore)
- Chat UI and Text-to-Speech (TTS)

## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [Dart SDK](https://dart.dev/get-dart)
- A Firebase project (for backend services)
- An `.env` file with your environment variables

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/DUSHIME1212/clisence.git
   cd clisence
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Set up Firebase:**
   - Follow the [FlutterFire documentation](https://firebase.flutter.dev/docs/overview/) to generate your `firebase_options.dart` file.
   - Place the generated file in `lib/firebase_options.dart`.

4. **Create a `.env` file:**
   - Place your environment variables in a `.env` file at the root of the project.

5. **Run the app:**
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
  core/
    configs/
      theme/
        app_theme.dart
        app_colors.dart
      text_to_speech.dart
  presentation/
    pages/
      app/
        home.dart
        settings.dart
        profile_screen.dart
        profile.dart
      auth/
        login.dart
        signup.dart
        login_or_signup.dart
    providers/
      auth_provider.dart
    widgets/
      auth_wrapper.dart
      (various weather and UI widgets)
  firebase_options.dart
  main.dart
```

## Dependencies

Key dependencies from `pubspec.yaml`:

- flutter
- provider
- firebase_core
- cloud_firestore
- firebase_auth
- flutter_dotenv
- flutter_chat_ui, flutter_chat_types, flutter_firebase_chat_core
- google_generative_ai
- uuid
- http
- flutter_bloc
- flutter_tts
- flutter_advanced_drawer
- crystal_navigation_bar
- cupertino_icons

See `pubspec.yaml` for the full list.

## Assets

Assets are located in the `assets/` directory and subdirectories, including images, icons, fonts, lottie animations, videos, audios, and vectors. The `.env` file is also included as an asset.

## Contributing

Pull requests are welcome! For major changes, please open an issue first to discuss what you would like to change.

## License

[MIT](LICENSE)
