# Axes Controller

Axes Controller is a cross-platform robot controller written in Flutter.

Supported platforms:

- Android
- Linux

Platforms to be tested:

- macOS
- Windows

## Screenshots

![Configuration on Android](/docs/screenshot_android.png "Configuration on Android")

![Controlling device on Ubuntu Linux](/docs/screenshot_linux.png "Controlling device on Ubuntu Linux")

![Selecting device on macOS](/docs/screenshot_macos.png "Selecting device on macOS")

## Building

### Requirements

Flutter 3.27.4

### Open Source Licenses

Use the command bellow to update Open Source Licenses list file:

``` sh
flutter pub run flutter_oss_licenses:generate.dart --output lib/static/oss_licenses.dart
```

### Launcher icons

After changing settings (file: `pubspec.yaml`, session `flutter_icons`), run the following command in the terminal:

``` sh
flutter pub run flutter_launcher_icons:main
```

When the package finishes running, your icons are ready.

### Splash screen

After changing settings (file: `pubspec.yaml`, session `flutter_native_splash`), run the following command in the terminal:

``` sh
flutter pub run flutter_native_splash:create
```

When the package finishes running, your splash screen is ready.

### Build number (optional)

This step is just for project contributors.

The build number is automatically updated on each git commit.
To enable the build number auto increment, please follow the steps below on your development environment:

``` sh
cd .git/hooks/
ln -s ../../.pre-commit pre-commit
cd -
```
