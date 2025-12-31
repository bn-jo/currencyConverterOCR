You are a senior mobile architect and full-stack developer.

Your task is to design and implement a NEW cross-platform mobile application
for iOS and Android (single codebase).

### App Concept
A real-time currency converter app.
Core functionality should be similar in FEATURES (not design) to this app:
https://play.google.com/store/apps/details?id=uk.quantabyte.currency

⚠️ Important:
- Do NOT copy UI, colors, icons, or text from the reference app.
- Create a unique, modern, clean design with your own color palette, icons, and wording.

---

### Core Features
1. Real-time currency conversion
2. Support for all major world currencies
3. Ability to select base currency and multiple target currencies
4. Favorite currencies
5. Offline fallback using last cached rates
6. Fast, lightweight, and battery-friendly

---

### 🔥 New Advanced Feature (Very Important)
Camera-based price conversion:

- When the user taps on a currency or a special "Camera Convert" button:
  1. The device camera opens
  2. User takes a photo of:
     - a price tag
     - product label
     - receipt
     - or sticker with a price
  3. OCR is used to detect the numeric price and currency symbol/text
  4. The detected price is automatically converted
  5. Converted values are displayed in the user-selected currencies

Requirements:
- OCR must work offline if possible (fallback online OCR allowed)
- User can manually correct detected number if OCR is inaccurate
- Support common currency symbols ($, €, £, ¥, ₪ etc.)

---

### Exchange Rates
- Use REAL-TIME official exchange rates
- Prefer reliable APIs (e.g. ECB, Open Exchange Rates, Fixer, CurrencyAPI)
- Explain which API you choose and why
- Include rate caching & refresh strategy

---

### Technical Requirements
- Cross-platform (single codebase)
- Recommend best framework (Flutter / React Native / Expo / others)
- Clean architecture
- State management
- Modular code structure
- Production-ready

---

### Deliverables
1. Recommended tech stack with explanation
2. App architecture diagram (textual explanation)
3. Data models
4. API integration strategy
5. OCR integration approach
6. Camera flow UX
7. Example screens & navigation structure
8. Sample code snippets for:
   - Currency conversion
   - OCR processing
   - Camera integration
9. Edge cases & error handling
10. Security & privacy considerations
11. Performance optimizations
12. App store readiness notes (iOS + Android)

---

### Design Guidelines
- Minimal
- Modern
- High contrast
- Large readable numbers
- Travel-friendly UX
- Dark & Light mode

Think step-by-step.
Act like you are building a real production app, not a demo.
