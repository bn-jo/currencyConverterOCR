# Run on Your Phone - Step-by-Step Guide

## Prerequisites Check

Before running, ensure you have:
- ✅ Flutter SDK installed (run `flutter --version` to check)
- ✅ Android Studio (for Android) or Xcode (for iOS/macOS)
- ✅ USB cable to connect your phone
- ✅ Developer mode enabled on your phone

---

## Step 1: Get API Key (Optional for Testing)

For now, the app will work without a real API key, but you'll get errors when trying to fetch live rates. To get a free API key:

1. Go to https://www.exchangerate-api.com/
2. Sign up for free account
3. Copy your API key
4. Open `lib/core/config/api_keys.dart`
5. Replace `'YOUR_API_KEY_HERE'` with your actual key

**For now, you can skip this step and test the UI.**

---

## Step 2: Install Dependencies

Open Terminal in the project directory and run:

```bash
cd /Users/liat/Documents/currencyConverterOCR
flutter pub get
```

This will download all required packages (~2-3 minutes).

---

## Step 3: Generate Hive Adapters

Run the build_runner to generate necessary code:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

This generates the Hive type adapters for local storage.

---

## Step 4: Enable Developer Mode on Your Phone

### For Android:
1. Go to **Settings** → **About Phone**
2. Tap **Build Number** 7 times
3. Go back to **Settings** → **Developer Options**
4. Enable **USB Debugging**
5. Connect phone via USB
6. Allow USB debugging when prompted

### For iPhone:
1. Connect iPhone via USB
2. Trust the computer when prompted
3. Open Xcode and add your Apple ID (free)

---

## Step 5: Check Connected Devices

Verify your phone is connected:

```bash
flutter devices
```

You should see your phone listed. Example output:
```
iPhone 14 Pro (mobile) • 00008110-001234567890001A • ios • iOS 16.5
```

or

```
SM-G991B (mobile) • RFCT1234567 • android-arm64 • Android 13 (API 33)
```

---

## Step 6: Run the App

### Option A: Run in Debug Mode (Recommended for Testing)

```bash
flutter run
```

If you have multiple devices connected:
```bash
flutter run -d <device-id>
```

### Option B: Build and Install Release APK (Android Only)

```bash
# Build APK
flutter build apk --release

# The APK will be at:
# build/app/outputs/flutter-apk/app-release.apk

# Install manually on phone or via ADB:
adb install build/app/outputs/flutter-apk/app-release.apk
```

### Option C: Build for iOS (Mac Only)

```bash
flutter build ios --release
# Then open ios/Runner.xcworkspace in Xcode and run
```

---

## Step 7: First Run

When the app launches for the first time:

1. **Grant Camera Permission** when prompted
2. **Grant Photo Library Permission** when prompted
3. You'll see the home screen with a "Capture Currency" button

---

## Testing Without API Key

Even without a real API key, you can test:

✅ Camera functionality
✅ UI navigation
✅ Settings (language switching)
✅ History screen
✅ OCR processing (will process but conversion will fail)

❌ Live currency conversion (requires API key)
❌ Exchange rate fetching

---

## Troubleshooting

### "Command not found: flutter"

Flutter is not installed or not in PATH.

**Solution:**
1. Download Flutter from https://flutter.dev/docs/get-started/install
2. Add to PATH:
   ```bash
   export PATH="$PATH:`pwd`/flutter/bin"
   ```

### "No devices found"

Your phone is not connected or not recognized.

**Solution:**
- Check USB cable connection
- Enable Developer Mode and USB Debugging
- Run `flutter doctor` to diagnose

### "Camera permission denied"

The app needs camera access.

**Solution:**
- Go to phone Settings → Apps → Currency Converter OCR → Permissions
- Enable Camera and Storage

### "Build failed: Hive adapters not found"

You need to generate the Hive adapters.

**Solution:**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### "API Key Error"

You haven't added a real API key yet.

**Solution:**
- For testing: Ignore this error, test other features
- For full functionality: Get free API key from https://www.exchangerate-api.com/

### "Gradle build failed" (Android)

Gradle dependencies issue.

**Solution:**
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

### "Pod install failed" (iOS)

CocoaPods dependencies issue.

**Solution:**
```bash
cd ios
pod deintegrate
pod install
cd ..
flutter run
```

---

## Quick Commands Reference

```bash
# Check Flutter installation
flutter doctor

# List connected devices
flutter devices

# Install dependencies
flutter pub get

# Generate code
flutter pub run build_runner build

# Run on default device
flutter run

# Run on specific device
flutter run -d <device-id>

# Build release APK (Android)
flutter build apk --release

# Build for iOS
flutter build ios --release

# Clean build
flutter clean
```

---

## Expected Build Time

- **First build**: 5-10 minutes (downloads dependencies, compiles)
- **Subsequent builds**: 30-60 seconds (incremental)
- **Hot reload** (during development): <1 second

---

## What to Expect

### On First Launch:

1. **Splash Screen** (if added)
2. **Permission Requests**:
   - Camera access
   - Photo library access
3. **Home Screen** with:
   - Large "Capture Currency" button
   - Currency selectors (From/To)
   - Amount input field
   - Convert button
   - Settings icon (top right)
   - History icon (top right)

### App Features You Can Test:

1. **Camera Capture**
   - Tap "Capture Currency"
   - Take photo or select from gallery
   - OCR will process the image

2. **Settings**
   - Change language (English/Spanish/Hebrew)
   - Toggle dark mode
   - Set default currencies

3. **History**
   - View past conversions (if any)
   - Delete items
   - Clear all history

---

## Next Steps After Running

Once the app is running on your phone:

1. **Test Camera**: Capture a currency image
2. **Test OCR**: See if text extraction works
3. **Add API Key**: For live conversion rates
4. **Test Offline**: Turn off WiFi and test cached data
5. **Test Languages**: Switch between EN/ES/HE

---

## Support

If you encounter issues:

1. Run `flutter doctor` and fix any issues marked with ❌
2. Check the troubleshooting section above
3. Ensure your phone OS version is supported:
   - Android: API level 21+ (Android 5.0+)
   - iOS: iOS 11.0+

---

## File Checklist

Before running, ensure these exist:

- ✅ `lib/core/config/api_keys.dart` (created)
- ✅ `pubspec.yaml` (exists)
- ✅ `lib/main.dart` (exists)
- ✅ All dependency files in `lib/` (created)

All files are ready! Just need to run the commands above.

---

**Ready to run?** Start with Step 2 (flutter pub get) and follow through to Step 6!
