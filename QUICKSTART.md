# Quick Start - Run on Your Phone

## 🚀 Fastest Way (Automated)

Open Terminal in this directory and run:

```bash
./setup.sh
```

This script will:
1. ✅ Check Flutter installation
2. ✅ Install dependencies
3. ✅ Generate required code
4. ✅ Check for connected devices
5. ✅ Run the app on your phone

---

## 📱 Manual Setup (If Script Doesn't Work)

### Step 1: Connect Your Phone

**Android:**
- Enable Developer Mode: Settings → About → Tap "Build Number" 7 times
- Enable USB Debugging: Settings → Developer Options → USB Debugging
- Connect via USB and allow debugging

**iPhone:**
- Connect via USB
- Trust computer when prompted

### Step 2: Run These Commands

```bash
# 1. Install dependencies
flutter pub get

# 2. Generate code
flutter pub run build_runner build --delete-conflicting-outputs

# 3. Check your phone is connected
flutter devices

# 4. Run the app
flutter run
```

---

## ⏱️ Expected Time

- **First time**: 5-10 minutes (downloads dependencies)
- **Next times**: 30-60 seconds

---

## 🔑 API Key (Optional for Testing)

The app will run without an API key, but you need one for live currency conversion:

1. Get free key from: https://www.exchangerate-api.com/
2. Edit: `lib/core/config/api_keys.dart`
3. Replace `'YOUR_API_KEY_HERE'` with your actual key

**You can skip this for now and just test the UI!**

---

## ✅ What Works Without API Key

- ✅ Camera capture
- ✅ OCR text extraction
- ✅ UI navigation
- ✅ Settings
- ✅ Language switching (EN/ES/HE)
- ✅ Dark mode

❌ Live currency conversion (needs API key)

---

## 🆘 Problems?

### "Command not found: flutter"
→ Install Flutter from https://flutter.dev/docs/get-started/install

### "No devices found"
→ Connect phone via USB and enable Developer Mode/USB Debugging

### "Permission denied"
→ Run: `chmod +x setup.sh`

### Build errors
→ Run: `flutter clean && flutter pub get`

---

## 📖 More Help

- Full guide: See **RUN_ON_PHONE.md**
- Troubleshooting: Run `flutter doctor`

---

**Ready?** Just run `./setup.sh` and you're good to go! 🎉
