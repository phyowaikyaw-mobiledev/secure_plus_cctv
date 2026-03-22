# Secure Plus – Push Notifications Setup (FCM)

အက်ပ်မှာ push notifications လုပ်ဖို့ အောက်ပါအတိုင်း ပြင်ဆင်ရပါမယ်။

---

## Blaze က ပိုက်ဆံ ကုန်မကုန် (အခမဲ့ သုံးလို့ရမလား)

**Blaze = Pay as you go** ဆိုပေမယ့် **Free tier** ပါပါတယ်။

- **အခမဲ့ limit အတွင်းသာ သုံးရင် ပိုက်ဆံ မကုန်ပါ။**  
  ဥပမာ Cloud Functions: တစ်လ ခေါ်ချက် ၂ သန်းအထိ အခမဲ့။ အက်ပ်သေးသေးမှာ သုံးရင် ဒီ limit ကို မကျော်သေးပါဘူး။
- Blaze ရွေးထားရင် **ကဒ် ထည့်ထားရ**ပါတယ်။ Limit ကျော်မှ ငွေချတာပါ။ သေးသေးလေး သုံးရင် **$0** ပဲ ချတာများပါတယ်။
- **လုံးဝ ပိုက်ဆံ / ကဒ် မထည့်ချင်ဘူး** ဆိုရင် အောက်က **“လုံးဝအခမဲ့ (Spark only)”** ကဏ္ဍကို ရွေးပါ။ Push မတက်ပဲ အက်ပ်ဖွင့်မှ “အသစ်ရှိတယ်” ပြမယ့် နည်းပါ။

---

## ၁။ Contact/About လင့်များ

လင့်တွေ ကလစ်ရင် မသွားတာကို ပြင်ထားပြီးပါပြီ။  
ဖုန်းမှာ **Tel**, **WeChat**, **Viber**, **Telegram**, **WhatsApp**, **Facebook**, **Gmail** စတဲ့ app တွေ ထည့်ထားရင် ခလုတ်နှိပ်ရင် ဖွင့်သွားပါလိမ့်မယ်။

---

## ၂။ Push Notifications (FCM) အတွက် သင်လိုအပ်မည့်အရာများ

### A. Firebase Console မှာ

1. **Project** က **Blaze (Pay as you go)** plan ဖြစ်ရပါမယ်။  
   - Console → Project settings → Usage and billing → Modify plan → Blaze ရွေးပါ။  
   - Cloud Functions သုံးဖို့ လိုပါတယ်။

2. **Cloud Messaging (FCM)** ဖွင့်ပါ။  
   - Build → Cloud Messaging။  
   - Legacy API / New API မှာ **Server key** (Legacy) သို့မဟုတ် **Service account** က Cloud Functions က သူ့ဟာသူ သုံးပါတယ်။ ထပ်လုပ်စရာ မလိုပါ။

3. **Android** အတွက်  
   - `google-services.json` ကို Firebase Console → Project settings → Your apps → Android app မှာ ဒေါင်းပြီး ထည့်ထားပါ။  
   - ပရောဂျက်မှာ `android/app/google-services.json` ထည့်ပြီးသား ဖြစ်ရပါမယ်။

4. **iOS** သုံးမယ်ဆိုရင်  
   - Apple Developer မှာ APNs key / certificate ထည့်ပြီး Firebase Console → Project settings → Cloud Messaging → Apple app config မှာ upload လုပ်ရပါမယ်။

### B. Cloud Functions Deploy လုပ်ခြင်း

1. **Node.js 20** ထည့်ထားပါ။

2. **Firebase CLI** ထည့်ပါ။  
   ```bash
   npm install -g firebase-tools
   firebase login
   ```

3. **ပရောဂျက် root** (ဥပမာ `secure_plus`) မှာ Firebase init လုပ်ပြီးသား ဖြစ်ရပါမယ်။ မလုပ်ရသေးရင်:  
   ```bash
   cd d:\Secure_Plus\secure_plus
   firebase init
   ```  
   - **Functions** ရွေးပါ။  
   - Existing `functions` folder ကို သုံးမယ်လို့ ပြောပါ (already have `functions/` with `package.json` and `index.js`).  
   - Language **JavaScript** ရွေးပါ။  
   - ESLint ကို လိုချင်ရင် ဖွင့်နိုင်ပါတယ်။

4. **Functions** folder မှာ dependency install လုပ်ပါ။  
   ```bash
   cd functions
   npm install
   cd ..
   ```

5. **Deploy** လုပ်ပါ။  
   ```bash
   firebase deploy --only functions
   ```  
   ပြီးရင် `onServiceRequestCreated`, `onTicketCreated`, `onProjectCreated` ဆိုတဲ့ functions တွေ deploy ဖြစ်သွားပါမယ်။

### C. အက်ပ်ဘက်မှာ လုပ်စရာ

- **ပြင်ဆင်ပြီးသား:**  
  - Customer က Services စာမျက်နှာ ဖွင့်တိုင်း FCM token ကို “customer” အနေနဲ့ Firestore `fcm_tokens` မှာ သိမ်းပါတယ်။  
  - Owner က Dashboard ဖွင့်တိုင်း FCM token ကို “admin” အနေနဲ့ သိမ်းပါတယ်။  
- ဒါကြောင့် **အက်ပ်ကို တစ်ခါ run ပြီး Customer / Owner စာမျက်နှာ ဖွင့်ပေးထားရင်** token တွေ Firestore မှာ ရောက်သွားပြီး push လက်ခံနိုင်ပါမယ်။

---

## ၃။ အလုပ်လုပ်ပုံ

| ဖြစ်ရပ် | လုပ်ချက် |
|----------|------------|
| Customer က **အသစ်တပ်တာဖြစ်ဖြစ်** (Service Request) ပို့တယ် | Admin ဆီ **New installation request** noti တက်မယ်။ |
| Customer က **Maintenance** လုပ်ချင်တာပို့တယ် (Ticket) | Admin ဆီ **New maintenance ticket** noti တက်မယ်။ |
| Admin က **Project add** လုပ်တယ် | Customer ဆီ **New completed site** noti တက်မယ်။ |

Firestore မှာ `service_requests`, `tickets`, `projects` ကို ထည့်တာနဲ့ Cloud Functions က အလိုအလျောက် FCM ပို့ပေးပါတယ်။

---

## ၄။ သင်ပြီးသား ပေးထားရမည့်အရာများ (အကျဉ်း)

- Firebase project **Blaze** plan  
- Android: **google-services.json** ကို `android/app/` မှာ ထည့်ထားပြီးသား  
- **firebase deploy --only functions** လုပ်ပြီးသား (Node 20 + firebase-tools)  
- iOS သုံးမယ်ဆိုရင်: APNs config ကို Firebase Console မှာ ထည့်ပြီးသား  

ဒီအတိုင်း ပြီးရင် Customer / Admin နှစ်ဘက်လုံး noti တက်ပါလိမ့်မယ်။

---

## ၅။ လုံးဝအခမဲ့ သုံးချင် (Blaze / ကဒ် မလိုချင်)

- **Spark plan** ပဲ သုံးပါ။ ကဒ် မထည့်ရပါ။
- **Push notification (အက်ပ်ပိတ်ထားတုန်း noti တက်တာ)** က **Cloud Functions လိုတယ်**၊ Cloud Functions က **Blaze** မှာပဲ ရတယ်။  
  ဒါကြောင့် Spark ပဲ သုံးရင် **အပြင်က push noti မတက်ပါ**။
- ဒါပေမယ့် **အက်ပ်ဖွင့်တဲ့အခါ** မှာ “Customer က request/ticket ပို့ပြီး” / “Admin က project ထည့်ပြီး” ဆိုတာ **စာရင်းထဲမှာ အသစ်ပြအောင်** လုပ်လို့ ရပါတယ်။ (Firestore ကို အက်ပ်က listen ထားပြီး “New” badge / count ပြခြင်း။)  
  ဒါက **လုံးဝအခမဲ့**၊ Blaze / ပိုက်ဆံ မလိုပါ။

**အတိုချုပ်:**
- **ပိုက်ဆံ / ကဒ် မထည့်ချင်** → Spark ပဲ သုံးပါ။ Push noti မတက်ပါ၊ အက်ပ်ဖွင့်မှ “အသစ်ရှိတယ်” ပြမယ့် စနစ်နဲ့ သုံးပါ။
- **Push noti တက်စေချင်** → Blaze ရွေးပြီး Free tier အတွင်းသာ သုံးရင် သေးသေးလေး အက်ပ်အတွက် **ပိုက်ဆံ မကုန်တာများပါတယ်**။

---

## ၆။ Noti မပေါ်ဘူး / Popup မတက်ဘူး / အသံမကြားရဘူး (ပြင်ဆင်ပြီး)

အက်ပ်မှာ အောက်ပါအတိုင်း ပြင်ထားပြီးပါပြီ။

- **Android 8+**: "default" notification channel ကို **high importance** နဲ့ create လုပ်ထားပြီး၊ **popup (heads-up)** နဲ့ **အသံ** ပါအောင် လုပ်ထားပါတယ်။
- **Android 13+**: `POST_NOTIFICATIONS` permission ကို app စဖွင့်တဲ့အခါ **တောင်းထားပါတယ်**။ ပထမတစ်ခါ အက်ပ်ဖွင့်ရင် permission dialog ပေါ်ပါလိမ့်မယ် — **Allow** ရွေးပေးပါ။
- **အက်ပ်ဖွင့်နေတဲ့အချိန် (foreground)**: FCM က system notification မပြတော့တာကြောင့် **local notification** နဲ့ ပြပေးထားပါတယ် (popup + အသံ ပါပါတယ်)။
- **Cloud Functions**: Android အတွက် `defaultSound`, `defaultVibrateTimings` ထပ်ထည့်ထားပါတယ်။

**စစ်ကြည့်ရန်:**
1. ဖုန်းမှာ **Settings → Apps → Secure Plus → Notifications** ဖွင့်ပြီး notifications **On** ဖြစ်နေပါစေ။
2. **Do Not Disturb** ပိတ်ထားရင် noti အသံ မကြားရနိုင်ပါ။
3. Cloud Functions ကို ပြ deploy လုပ်ပါ: `cd functions && npm install && cd .. && firebase deploy --only functions`
4. အက်ပ်ကို **ပိတ်ပြီး** (background) သို့မဟုတ် **ပိတ်ထား** (killed) မှာ noti စမ်းပါ။ ဖွင့်နေတဲ့အချိန် (foreground) မှာလည်း noti ပြပေးပါလိမ့်မယ်။
