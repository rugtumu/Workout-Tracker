# Workout Tracker

<details>
<summary>🇹🇷 Türkçe / Turkish</summary>

## Workout Tracker

Kişisel kullanım için özel, offline çalışabilen antrenman takip uygulaması. Flutter ile geliştirilmiş ve modern mobil uygulamalardan ilham alınan koyu tema tasarımına sahip.

## Özellikler

### 🏋️ Antrenman Kayıt Sistemi
- Egzersiz adı, set, tekrar ve ağırlık ile günlük kayıt
- **Önceden tanımlanmış egzersiz listesi** ile yazım hatalarını önleme
- Kayıtlı ağırlık verilerine dayalı görsel ilerleme takibi
- Tarih bazlı antrenman organizasyonu ve filtreleme
- Egzersiz özelinde ilerleme grafikleri

### 🏥 Medikal Veri Takibi
- Vücut ağırlığı, bel, vücut yağı, pazı, önkol ve kalori alımı dahil **önceden tanımlanmış ölçüm türleri**
- Boy, kilo, vücut yağ yüzdesi, kan testi sonuçları ve vitamin seviyeleri takibi
- Medikal değerlerdeki trendlerin ve değişimlerin görsel temsili
- Kolay tanımlama için renk kodlu veri türleri
- Kapsamlı medikal veri yönetimi

### 📊 Veri Görselleştirme
- Antrenman verileri için interaktif ilerleme grafikleri
- Medikal veri trend analizi
- Gerçek zamanlı istatistikler ve değişim takibi
- Yeşil/kırmızı/mavi renk şeması ile güzel koyu tema arayüzü

### 💾 Veri Dışa/İçe Aktarma İşlevselliği
- Antrenman ve medikal verileri JSON formatında dışa aktarma
- Çökme veya telefon sıfırlamasından sonra veri kurtarmak için **yedek dosyalardan veri içe aktarma**
- CSV dışa aktarma desteği
- Tam veri yedekleme yetenekleri
- SQLite ile yerel veri depolama
- Sadece bu uygulamadan dışa aktarılan dosyaların içe aktarılabilmesi için **veri doğrulama**

## Sistem Gereksinimleri

- **İşletim Sistemi**: Windows 10+, macOS 10.14+ veya Ubuntu 18.04+
- **Flutter**: 3.0.0 veya üzeri
- **Android SDK**: API seviyesi 21 veya üzeri
- **Android Cihaz**: Android 5.0 (API 21) veya üzeri

## Çoklu Platform Kurulum Talimatları

### Windows Kurulumu

#### 1. Windows'ta Flutter Kurulumu
1. Flutter SDK'yı [flutter.dev](https://flutter.dev/docs/get-started/install/windows) adresinden indirin
2. `C:\flutter` klasörüne çıkarın (yolda boşluk olmamalı)
3. `C:\flutter\bin` klasörünü PATH ortam değişkenine ekleyin
4. Komut İstemi'ni açın ve şunu çalıştırın:
   ```cmd
   flutter doctor
   ```

#### 2. Windows'ta Android Studio Kurulumu
1. Android Studio'yu [developer.android.com](https://developer.android.com/studio) adresinden indirin
2. Kurulum programını çalıştırın ve kurulum sihirbazını takip edin
3. Android SDK'yı kurun (API 33+ önerilir)
4. Android Emülatör'ü kurun

#### 3. Android Cihazda USB Hata Ayıklamayı Etkinleştirme
1. **Ayarlar** > **Telefon hakkında** bölümüne gidin
2. **Yapı numarası**'na 7 kez dokunun (Geliştirici seçeneklerini etkinleştirmek için)
3. **Ayarlar** > **Geliştirici seçenekleri**'ne gidin
4. **USB hata ayıklama**'yı etkinleştirin
5. Cihazı USB ile bağlayın ve hata ayıklamaya izin verin

### macOS Kurulumu

#### 1. macOS'ta Flutter Kurulumu
1. Flutter SDK'yı [flutter.dev](https://flutter.dev/docs/get-started/install/macos) adresinden indirin
2. Ana dizininize çıkarın: `~/development/flutter`
3. `~/.zshrc` veya `~/.bash_profile` dosyasına PATH ekleyin:
   ```bash
   export PATH="$PATH:$HOME/development/flutter/bin"
   ```
4. Terminal'i yeniden yükleyin: `source ~/.zshrc`
5. Çalıştırın: `flutter doctor`

#### 2. macOS'ta Android Studio Kurulumu
1. Android Studio'yu [developer.android.com](https://developer.android.com/studio) adresinden indirin
2. Kurun ve kurulum sihirbazını çalıştırın
3. Android SDK ve emülatör'ü kurun
4. Android Studio'da Flutter eklentisini yapılandırın

#### 3. Android Cihazda USB Hata Ayıklamayı Etkinleştirme
1. **Ayarlar** > **Telefon hakkında** bölümüne gidin
2. **Yapı numarası**'na 7 kez dokunun
3. **Ayarlar** > **Geliştirici seçenekleri**'ne gidin
4. **USB hata ayıklama**'yı etkinleştirin
5. Cihazı bağlayın ve hata ayıklamaya izin verin

### Linux (Ubuntu) Kurulumu

#### 1. Ubuntu'da Flutter Kurulumu
```bash
# Flutter'ı indirin
cd ~/development
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.16.5-stable.tar.xz
tar xf flutter_linux_3.16.5-stable.tar.xz

# PATH'e ekleyin
export PATH="$PATH:$HOME/development/flutter/bin"
echo 'export PATH="$PATH:$HOME/development/flutter/bin"' >> ~/.bashrc
source ~/.bashrc

# Kurulumu doğrulayın
flutter doctor
```

#### 2. Ubuntu'da Android Studio Kurulumu
```bash
# Snap kullanarak (önerilen)
sudo snap install android-studio --classic

# Veya developer.android.com'dan manuel indirin
```

#### 3. Android SDK Yapılandırması
1. Android Studio'yu açın
2. **Dosya** > **Ayarlar** > **Görünüm ve Davranış** > **Sistem Ayarları** > **Android SDK**'ya gidin
3. Android SDK Platform'u kurun (API 33+)
4. Android SDK Build-Tools'u kurun
5. Android Emülatör'ü kurun

#### 4. Android Cihazda USB Hata Ayıklamayı Etkinleştirme
1. **Ayarlar** > **Telefon hakkında** bölümüne gidin
2. **Yapı numarası**'na 7 kez dokunun
3. **Ayarlar** > **Geliştirici seçenekleri**'ne gidin
4. **USB hata ayıklama**'yı etkinleştirin
5. Cihazı bağlayın ve hata ayıklamaya izin verin

## Uygulamayı Oluşturma ve Çalıştırma

### 1. Klonlama ve Kurulum (Tüm Platformlar)
```bash
git clone <repository-url>
cd fitness_tracker
flutter pub get
```

### 2. Bağlı Cihazda Çalıştırma (Tüm Platformlar)
Android cihazınızı bağlayın ve çalıştırın:
```bash
flutter run
```

### 3. Dağıtım için APK Oluşturma (Tüm Platformlar)
Debug APK oluşturun:
```bash
flutter build apk --debug
```

Release APK oluşturun:
```bash
flutter build apk --release
```

APK şu konumda bulunacak:
```
build/app/outputs/flutter-apk/app-debug.apk
```

### 4. Cihaza APK Kurma (Tüm Platformlar)
APK'yı cihazınıza aktarın ve kurun, veya ADB kullanın:
```bash
adb install build/app/outputs/flutter-apk/app-debug.apk
```

## Uygulamayı Kullanma

### Antrenman Takibi
1. **Antrenmanlar** sekmesine dokunun
2. Tarih seçmek için takvim simgesini kullanın
3. Antrenman eklemek için **+** düğmesine dokunun
4. **Önceden tanımlanmış egzersiz listesinden seçin** veya özel egzersiz yazın
5. Set, tekrar ve ağırlık girin
6. **İlerleme** sekmesinde ilerleme grafiklerini görüntüleyin

### Medikal Veri Takibi
1. **Medikal** sekmesine dokunun
2. Medikal veri eklemek için **+** düğmesine dokunun
3. **Önceden tanımlanmış ölçüm türlerinden seçin** veya özel türler ekleyin
4. Otomatik birim önerileri ile değerler girin
5. **Trendler** sekmesinde trendleri görüntüleyin

### Veri Dışa/İçe Aktarma
1. **Profil** sekmesine gidin
2. **Tüm Verileri Dışa Aktar** veya belirli dışa aktarma seçeneklerine dokunun
3. Tercih ettiğiniz paylaşım yöntemini seçin
4. Veriler JSON dosyaları olarak dışa aktarılacak
5. Yedek dosyalardan geri yüklemek için **Veri İçe Aktar** kullanın

## Veri Gizliliği ve Güvenlik

- Tüm veriler cihazınızda **şifreli (encrypted)** olarak saklanır (SQLCipher ile).
- Veritabanı şifresi, uygulama ilk açılışta belirlediğiniz **PIN** ile korunur. **PIN unutulursa kurtarılamaz!** PIN'inizi güvenli bir yerde saklayın.
- Hiçbir veri harici sunuculara gönderilmez.
- Veritabanı dosyası şifreli olduğu için, cihazınız kaybolsa veya hacklense bile verileriniz koruma altındadır.
- Cihazınızın kaybolma veya hacklenme durumuna karşı verilerinizi düzenli olarak yedeklemeniz tavsiye edilir.
- Eski (şifresiz) veritabanı ile uyumsuzluk durumunda, uygulama yeni şifreli veritabanı oluşturur. Eski veriler korunmaz.
- Workout ve medikal veri ekleme/güncelleme işlemlerinde, veriler anında ekranda görünür (gelişmiş state yönetimi).

## Teknik Detaylar

### Veritabanı
- `sqflite` paketi ile **SQLite**
- Sadece yerel depolama
- Otomatik veri şifreleme
- Yedekleme ve geri yükleme yetenekleri

### Bağımlılıklar
- `flutter`: Ana framework
- `sqflite`: Yerel veritabanı
- `provider`: Durum yönetimi
- `fl_chart`: Veri görselleştirme
- `intl`: Uluslararasılaştırma
- `path_provider`: Dosya sistemi erişimi
- `share_plus`: Veri paylaşımı
- `file_picker`: Veri içe aktarma

### Mimari
- Durum yönetimi için **Provider Pattern**
- Veri erişimi için **Repository Pattern**
- **Widget tabanlı** UI bileşenleri
- Modern tasarım ile **koyu tema**

### Platform Desteği
Bu uygulama öncelikle **Android** cihazlar için tasarlanmıştır. Flutter projesi, çoklu platform desteği için Flutter tarafından otomatik olarak oluşturulan platform özel klasörleri (`android/`, `ios/`, `linux/`, `macos/`, `web/`, `windows/`) içerir. Ancak bu uygulama Android için optimize edilmiştir ve diğer platformlarda optimal çalışmayabilir.

**iOS Desteği**: Proje iOS yapılandırması içerse de, iOS'a dağıtım şunları gerektirir:
- macOS bilgisayar
- Xcode kurulumu
- Apple Developer hesabı
- iOS cihaz veya simülatör

Apple'ın kısıtlamaları ve karmaşıklığı nedeniyle, iOS kurulumu bu README'de ele alınmamıştır.

## Sorun Giderme

### Yaygın Sorunlar

**Flutter bulunamadı:**
```bash
# Windows
set PATH=%PATH%;C:\flutter\bin

# macOS/Linux
export PATH="$PATH:$HOME/development/flutter/bin"
```

**Android cihaz algılanmadı:**
```bash
adb devices
flutter doctor
```

**Oluşturma hataları:**
```bash
flutter clean
flutter pub get
flutter run
```

**İzin sorunları:**
- USB hata ayıklamayı etkinleştirin
- Bilinmeyen kaynaklardan kuruluma izin verin
- Uygulama ayarlarında depolama izinlerini verin

**İçe/Dışa aktarma sorunları:**
- Dosyaların JSON formatında olduğundan emin olun
- Sadece bu uygulamadan dışa aktarılan dosyaları içe aktarın
- Dosya izinlerini kontrol edin

## Lisans

Bu proje **GNU General Public License v3.0** (GPLv3) altında lisanslanmıştır.

### Neden GPLv3?

- **Copyleft koruması**: Türevlerin açık kaynak kalmasını sağlar
- **Güçlü koruma**: Kapalı kaynak klonlamayı önler
- **Topluluk dostu**: İşbirliğini teşvik eder
- **Gizlilik odaklı**: Uygulamanın gizlilik öncelikli yaklaşımıyla uyumlu

## Katkıda Bulunma

Bu kişisel bir projedir, ancak katkılar hoş karşılanır. Lütfen herhangi bir değişikliğin gizlilik öncelikli yaklaşımı ve projenin açık kaynak doğasını koruduğundan emin olun.

## Destek

Sorunlar veya sorular için:
1. Sorun giderme bölümünü kontrol edin
2. Flutter dokümantasyonunu inceleyin
3. Geliştirme ortamınızın düzgün yapılandırıldığından emin olun

## Sorumluluk Reddi

Bu uygulama kişisel kullanım için tasarlanmıştır. Tıbbi tavsiye için her zaman sağlık uzmanlarına danışın. Uygulama profesyonel tıbbi rehberliğin yerini tutmaz.

## Yenilikler (v1.0.2)

- Veritabanı artık **SQLCipher** ile şifreli ve PIN ile korunuyor. PIN unutulursa kurtarılamaz, uyarı ekranı eklendi.
- Eski şifresiz veritabanı ile uyumsuzluk durumunda yeni şifreli veritabanı otomatik oluşturuluyor.
- Workout ve medical data ekleme/güncelleme işlemlerinde anında güncellenen UI (await ile).
- Gelişmiş güvenlik ve veri gizliliği vurgusu.

</details>

<details>
<summary>🇺🇸 English</summary>

A private, offline-capable workout tracker app for personal use. Built with Flutter and designed with a dark theme inspired by modern mobile apps.

## Features

### 🏋️ Workout Logging System
- Daily entry of exercises with name, sets, reps, and weight
- **Predefined exercise list** with 30+ common exercises to avoid spelling errors
- Visual progress tracking with graphs based on logged weight data over time
- Date-based workout organization and filtering
- Exercise-specific progress charts

### 🏥 Medical Data Tracking
- **Predefined measurement types** including body weight, waist, body fat, biceps, forearms, and caloric intake
- Track height, weight, body fat percentage, blood test results, and vitamin levels
- Visual representation of trends and changes in medical values over time
- Color-coded data types for easy identification
- Comprehensive medical data management

### 📊 Data Visualization
- Interactive progress charts for workout data
- Medical data trend analysis
- Real-time statistics and change tracking
- Beautiful dark theme UI with green/red/blue color scheme

### 💾 Data Export/Import Functionality
- Export workout and medical data to JSON format
- **Import data from backup files** to recover data after crashes or phone resets
- Support for CSV export
- Complete data backup capabilities
- Local data storage with SQLite
- **Data validation** to ensure only files exported from this app can be imported

## System Requirements

- **Operating System**: Windows 10+, macOS 10.14+, or Ubuntu 18.04+
- **Flutter**: 3.0.0 or later
- **Android SDK**: API level 21 or higher
- **Android Device**: Android 5.0 (API 21) or higher

## Multi-Platform Installation Instructions

### Windows Setup

#### 1. Install Flutter on Windows
1. Download Flutter SDK from [flutter.dev](https://flutter.dev/docs/get-started/install/windows)
2. Extract to `C:\flutter` (avoid spaces in path)
3. Add `C:\flutter\bin` to your PATH environment variable
4. Open Command Prompt and run:
   ```cmd
   flutter doctor
   ```

#### 2. Install Android Studio on Windows
1. Download Android Studio from [developer.android.com](https://developer.android.com/studio)
2. Run the installer and follow the setup wizard
3. Install Android SDK (API 33+ recommended)
4. Install Android Emulator

#### 3. Enable USB Debugging on Android Device
1. Go to **Settings** > **About phone**
2. Tap **Build number** 7 times to enable Developer options
3. Go to **Settings** > **Developer options**
4. Enable **USB debugging**
5. Connect device via USB and allow debugging

### macOS Setup

#### 1. Install Flutter on macOS
1. Download Flutter SDK from [flutter.dev](https://flutter.dev/docs/get-started/install/macos)
2. Extract to your home directory: `~/development/flutter`
3. Add to PATH in `~/.zshrc` or `~/.bash_profile`:
   ```bash
   export PATH="$PATH:$HOME/development/flutter/bin"
   ```
4. Reload terminal: `source ~/.zshrc`
5. Run: `flutter doctor`

#### 2. Install Android Studio on macOS
1. Download Android Studio from [developer.android.com](https://developer.android.com/studio)
2. Install and run the setup wizard
3. Install Android SDK and emulator
4. Configure Flutter plugin in Android Studio

#### 3. Enable USB Debugging on Android Device
1. Go to **Settings** > **About phone**
2. Tap **Build number** 7 times
3. Go to **Settings** > **Developer options**
4. Enable **USB debugging**
5. Connect device and allow debugging

### Linux (Ubuntu) Setup

#### 1. Install Flutter on Ubuntu
```bash
# Download Flutter
cd ~/development
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.16.5-stable.tar.xz
tar xf flutter_linux_3.16.5-stable.tar.xz

# Add to PATH
export PATH="$PATH:$HOME/development/flutter/bin"
echo 'export PATH="$PATH:$HOME/development/flutter/bin"' >> ~/.bashrc
source ~/.bashrc

# Verify installation
flutter doctor
```

#### 2. Install Android Studio on Ubuntu
```bash
# Using snap (recommended)
sudo snap install android-studio --classic

# Or download manually from developer.android.com
```

#### 3. Configure Android SDK
1. Open Android Studio
2. Go to **File** > **Settings** > **Appearance & Behavior** > **System Settings** > **Android SDK**
3. Install Android SDK Platform (API 33+)
4. Install Android SDK Build-Tools
5. Install Android Emulator

#### 4. Enable USB Debugging on Android Device
1. Go to **Settings** > **About phone**
2. Tap **Build number** 7 times
3. Go to **Settings** > **Developer options**
4. Enable **USB debugging**
5. Connect device and allow debugging

## Building and Running the App

### 1. Clone and Setup (All Platforms)
```bash
git clone <repository-url>
cd fitness_tracker
flutter pub get
```

### 2. Run on Connected Device (All Platforms)
Connect your Android device and run:
```bash
flutter run
```

### 3. Build APK for Distribution (All Platforms)
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

### 4. Install APK on Device (All Platforms)
Transfer the APK to your device and install it, or use ADB:
```bash
adb install build/app/outputs/flutter-apk/app-debug.apk
```

## Using the App

### Workout Tracking
1. Tap the **Workouts** tab
2. Use the calendar icon to select a date
3. Tap the **+** button to add a workout
4. **Select from predefined exercise list** or type custom exercise
5. Enter sets, reps, and weight
6. View progress charts in the **Progress** tab

### Medical Data Tracking
1. Tap the **Medical** tab
2. Tap the **+** button to add medical data
3. **Select from predefined measurement types** or add custom types
4. Enter values with automatic unit suggestions
5. View trends in the **Trends** tab

### Data Export/Import
1. Go to the **Profile** tab
2. Tap **Export All Data** or specific export options
3. Choose your preferred sharing method
4. Data will be exported as JSON files
5. Use **Import Data** to restore from backup files

## Data Privacy

- All data is stored **encrypted** on your device (using SQLCipher).
- The database password is protected by a **PIN** you set on first launch. **If you forget your PIN, it cannot be recovered!** Store your PIN safely.
- No data is sent to external servers.
- The database file is encrypted, so even if your device is lost or hacked, your data is protected.
- It is recommended to back up your data regularly in case your device is lost or compromised.
- If an old (unencrypted) database is detected, the app will create a new encrypted database. Old data will not be preserved.
- Workout and medical data additions/updates now instantly update the UI (improved state management).

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
- `file_picker`: Data import

### Architecture
- **Provider Pattern** for state management
- **Repository Pattern** for data access
- **Widget-based** UI components
- **Dark theme** with modern design

### Platform Support
This app is primarily designed for **Android** devices. The Flutter project includes platform-specific folders (`android/`, `ios/`, `linux/`, `macos/`, `web/`, `windows/`) that are auto-generated by Flutter for multiplatform support. However, this app is optimized for Android and may not work optimally on other platforms.

**iOS Support**: While the project includes iOS configuration, deploying to iOS requires:
- macOS computer
- Xcode installation
- Apple Developer account
- iOS device or simulator

Due to Apple's restrictions and complexity, iOS setup is not covered in this README.

## Troubleshooting

### Common Issues

**Flutter not found:**
```bash
# Windows
set PATH=%PATH%;C:\flutter\bin

# macOS/Linux
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

**Import/Export issues:**
- Ensure files are in JSON format
- Only import files exported from this app
- Check file permissions

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

## What's New (v1.0.2)

- Database is now **encrypted with SQLCipher** and protected by a PIN. If you forget your PIN, it cannot be recovered; warning screen added.
- If an old unencrypted database is detected, a new encrypted database is automatically created.
- Workout and medical data additions/updates now instantly update the UI (using await).
- Enhanced security and data privacy emphasis.

</details> 