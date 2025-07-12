# Fitness Tracker

A private, offline-capable workout tracker app for personal use. Built with Flutter and designed with a dark theme inspired by modern mobile apps.

## Features

### 🏋️ Workout Logging System
- Daily entry of exercises with name, sets, reps, and weight
- Visual progress tracking with graphs based on logged weight data over time
- Date-based workout organization and filtering
- Exercise-specific progress charts

### 🏥 Medical Data Tracking
- Track height, weight, body fat percentage, blood test results, and vitamin levels
- Visual representation of trends and changes in medical values over time
- Color-coded data types for easy identification
- Comprehensive medical data management

### 📊 Data Visualization
- Interactive progress charts for workout data
- Medical data trend analysis
- Real-time statistics and change tracking
- Beautiful dark theme UI with green/red/blue color scheme

### 💾 Data Export Functionality
- Export workout and medical data to JSON format
- Support for CSV export
- Complete data backup capabilities
- Local data storage with SQLite

## System Requirements

- **Operating System**: Ubuntu 20.04 or later
- **Flutter**: 3.0.0 or later
- **Android SDK**: API level 21 or higher
- **Android Device**: Android 5.0 (API 21) or higher

## Installation Instructions

### 1. Install Flutter on Ubuntu

First, download Flutter SDK:
```bash
cd ~/development
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.16.5-stable.tar.xz
tar xf flutter_linux_3.16.5-stable.tar.xz
```

Add Flutter to your PATH:
```bash
export PATH="$PATH:`pwd`/flutter/bin"
```

Add this line to your `~/.bashrc` file:
```bash
export PATH="$PATH:$HOME/development/flutter/bin"
```

Reload your terminal:
```bash
source ~/.bashrc
```

### 2. Install Android SDK

Install Android Studio:
```bash
sudo snap install android-studio --classic
```

Or download from the official website and install manually.

### 3. Configure Android SDK

Open Android Studio and install:
- Android SDK Platform-Tools
- Android SDK Build-Tools
- At least one Android SDK Platform (API 21 or higher)

Set ANDROID_HOME environment variable:
```bash
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/platform-tools
```

Add to `~/.bashrc`:
```bash
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/platform-tools
```

### 4. Enable USB Debugging on Android Device

1. Go to **Settings** > **About phone**
2. Tap **Build number** 7 times to enable Developer options
3. Go to **Settings** > **Developer options**
4. Enable **USB debugging**
5. Connect your device via USB
6. Allow USB debugging when prompted

### 5. Verify Flutter Installation

Run Flutter doctor to check your setup:
```bash
flutter doctor
```

Fix any issues reported by Flutter doctor.

## Building and Running the App

### 1. Clone and Setup

```bash
git clone <repository-url>
cd fitness_tracker
flutter pub get
```

### 2. Run on Connected Device

Connect your Android device and run:
```bash
flutter run
```

### 3. Build APK for Distribution

Build a debug APK:
```bash
flutter build apk --debug
```

Build a release APK:
```bash
flutter build apk --release
```

The APK will be located at:
```
build/app/outputs/flutter-apk/app-debug.apk
```

### 4. Install APK on Device

Transfer the APK to your device and install it, or use ADB:
```bash
adb install build/app/outputs/flutter-apk/app-debug.apk
```

## Using the App

### Workout Tracking
1. Tap the **Workouts** tab
2. Use the calendar icon to select a date
3. Tap the **+** button to add a workout
4. Enter exercise name, sets, reps, and weight
5. View progress charts in the **Progress** tab

### Medical Data Tracking
1. Tap the **Medical** tab
2. Tap the **+** button to add medical data
3. Select data type and enter values
4. View trends in the **Trends** tab

### Data Export
1. Go to the **Profile** tab
2. Tap **Export All Data** or specific export options
3. Choose your preferred sharing method
4. Data will be exported as JSON files

## Data Privacy

- All data is stored locally on your device
- No data is sent to external servers
- Data is encrypted in the local SQLite database
- You have complete control over your data
- Use export features for data backup

## Technical Details

### Database
- **SQLite** with `sqflite` package
- Local storage only
- Automatic data encryption
- Backup and restore capabilities

### Dependencies
- `flutter`: Core framework
- `sqflite`: Local database
- `provider`: State management
- `fl_chart`: Data visualization
- `intl`: Internationalization
- `path_provider`: File system access
- `share_plus`: Data sharing

### Architecture
- **Provider Pattern** for state management
- **Repository Pattern** for data access
- **Widget-based** UI components
- **Dark theme** with modern design

## Troubleshooting

### Common Issues

**Flutter not found:**
```bash
export PATH="$PATH:$HOME/development/flutter/bin"
```

**Android device not detected:**
```bash
adb devices
flutter doctor
```

**Build errors:**
```bash
flutter clean
flutter pub get
flutter run
```

**Permission issues:**
- Enable USB debugging
- Allow installation from unknown sources
- Grant storage permissions in app settings

## License

This project is licensed under the **GNU General Public License v3.0** (GPLv3).

### Why GPLv3?

- **Copyleft protection**: Ensures derivatives remain open source
- **Strong protection**: Prevents closed-source cloning
- **Community friendly**: Encourages collaboration
- **Privacy focused**: Aligns with the app's privacy-first approach

## Contributing

This is a personal project, but contributions are welcome. Please ensure any modifications maintain the privacy-first approach and open-source nature of the project.

## Support

For issues or questions:
1. Check the troubleshooting section
2. Review Flutter documentation
3. Ensure your development environment is properly configured

## Disclaimer

This app is designed for personal use. Always consult healthcare professionals for medical advice. The app is not a substitute for professional medical guidance. 