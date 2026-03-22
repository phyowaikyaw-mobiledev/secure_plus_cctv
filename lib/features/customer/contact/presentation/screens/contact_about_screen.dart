import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/launchers.dart';
import '../../../../../core/widgets/language_button.dart';
import '../../../../../core/widgets/secure_scaffold.dart';
import '../../../../../l10n/app_localizations.dart';

class ContactAboutScreen extends StatelessWidget {
  const ContactAboutScreen({super.key});

  static const String _phone1 = '09940965554';
  static const String _phone2 = '09971437554';
  static const String wechatUrl = 'weixin://dl/chat?wxid=wxid_jaljpkxknmkd22';
  static const String viberUrl = 'viber://chat?number=+959971437554';
  static const String telegramUrl = 'https://t.me/kai552288';
  static const String whatsappUrl = 'https://wa.me/959940965554';
  static const String facebookUrl = 'https://www.facebook.com/j.crab.37';
  static const String gmailEmail = 'phyosithu5522@gmail.com';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SecureScaffold(
      appBar: AppBar(title: Text(l10n.contactAndAbout), actions: const [LanguageButton()]),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _HeroCard(),
          const SizedBox(height: 16),
          _StoryCard(),
          const SizedBox(height: 16),
          _WhyUsCard(),
          const SizedBox(height: 16),
          _SectionLabel(l10n.contactChannels),
          const SizedBox(height: 12),
          _CallButtons(phone1: _phone1, phone2: _phone2),
          const SizedBox(height: 12),
          _SocialGrid(
            wechatUrl: wechatUrl, viberUrl: viberUrl, telegramUrl: telegramUrl,
            whatsappUrl: whatsappUrl, facebookUrl: facebookUrl, gmail: gmailEmail,
          ),
          const SizedBox(height: 16),
          _PaymentBrands(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF0A1628), Color(0xFF0F2744)],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        border: Border.all(color: AppColors.cyan.withOpacity(0.3)),
      ),
      child: Row(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset('assets/images/logo.jpg', width: 80, height: 80, fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 80, height: 80, color: AppColors.navySurfaceAlt,
                child: const Icon(Icons.videocam_rounded, color: AppColors.cyan, size: 40),
              )),
        ),
        const SizedBox(width: 16),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(l10n.appTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
          const SizedBox(height: 4),
          Text(l10n.cctvInstallationService, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
          const SizedBox(height: 8),
          Row(children: [
            _Badge(l10n.since2016, AppColors.cyan),
            const SizedBox(width: 6),
            _Badge(l10n.installationsCount.split(' ').first + '+', AppColors.success),
          ]),
        ])),
      ]),
    );
  }
}

class _StoryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: AppColors.navySurface,
        border: Border.all(color: AppColors.cyan.withOpacity(0.15)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.history_edu_rounded, color: AppColors.cyan, size: 18),
          const SizedBox(width: 8),
          const Text('Company Story', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.cyan)),
        ]),
        const SizedBox(height: 14),
        const Text(
          '၂၀၁၆ ခုနှစ်တွင် ကိုဖြိုးစည်သူ မှ စတင်တည်ထောင်ခဲ့သော Secure Plus CCTV သည် လုံခြုံရေးနည်းပညာပိုင်းတွင် ယုံကြည်စိတ်ချရသော Professional Security Solution Provider အဖြစ် ၁၀ နှစ်ကျော် ရပ်တည်လျက်ရှိပါသည်။',
          style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.7),
        ),
        const SizedBox(height: 12),
        const Text(
          'Camera တပ်ဆင်ပေးခြင်းထက်ပိုပြီး သင့်လုပ်ငန်း၏ အနာဂတ်ကို ကာကွယ်ပေးနေခြင်းကို အဓိကထားဆောင်ရွက်ပါသည်။',
          style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.7),
        ),
        const SizedBox(height: 16),
        const Divider(color: Colors.white10),
        const SizedBox(height: 12),
        const Text(
          '"Security is not an Expense. It is an Investment."',
          style: TextStyle(fontSize: 14, color: AppColors.cyan, fontStyle: FontStyle.italic, fontWeight: FontWeight.w600),
        ),
      ]),
    );
  }
}

class _WhyUsCard extends StatelessWidget {
  static const _items = [
    'Professional Site Survey (Free Consultation)',
    'High Resolution HD / 4K Camera Systems',
    'Mobile Remote Viewing (Anywhere, Anytime)',
    'Clean & Systematic Installation',
    'Warranty + Fast After-Sales Service',
    'Budget အလိုက် Customized Security Plan',
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: AppColors.navySurface,
        border: Border.all(color: AppColors.cyan.withOpacity(0.15)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.verified_rounded, color: AppColors.cyan, size: 18),
          const SizedBox(width: 8),
          Text(l10n.whyChooseUs, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.cyan)),
        ]),
        const SizedBox(height: 14),
        ..._items.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 16),
            const SizedBox(width: 10),
            Expanded(child: Text(item, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4))),
          ]),
        )).toList(),
      ]),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);
  @override
  Widget build(BuildContext context) => Text(text,
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textSecondary, letterSpacing: 0.5));
}

class _Badge extends StatelessWidget {
  final String text;
  final Color color;
  const _Badge(this.text, this.color);
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: color.withOpacity(0.15)),
    child: Text(text, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w700)),
  );
}

class _CallButtons extends StatelessWidget {
  final String phone1, phone2;
  const _CallButtons({required this.phone1, required this.phone2});
  @override
  Widget build(BuildContext context) => Column(children: [
    _PhoneBtn(phone: phone1),
    const SizedBox(height: 8),
    _PhoneBtn(phone: phone2),
  ]);
}

class _PhoneBtn extends StatelessWidget {
  final String phone;
  const _PhoneBtn({required this.phone});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => launchTel(context, phone),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: AppColors.success.withOpacity(0.1),
        border: Border.all(color: AppColors.success.withOpacity(0.3)),
      ),
      child: Row(children: [
        Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.success.withOpacity(0.15)),
            child: const Icon(Icons.call_rounded, color: AppColors.success, size: 18)),
        const SizedBox(width: 12),
        Text(phone, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
        const Spacer(),
        const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.success, size: 13),
      ]),
    ),
  );
}

class _SocialGrid extends StatelessWidget {
  final String wechatUrl, viberUrl, telegramUrl, whatsappUrl, facebookUrl, gmail;
  const _SocialGrid({required this.wechatUrl, required this.viberUrl, required this.telegramUrl,
      required this.whatsappUrl, required this.facebookUrl, required this.gmail});

  @override
  Widget build(BuildContext context) {
    final items = [
      ('WeChat', Icons.wechat, AppColors.success, () => launchUrlString(context, wechatUrl)),
      ('Viber', Icons.phone_in_talk_rounded, const Color(0xFF7360F2), () => launchUrlString(context, viberUrl)),
      ('Telegram', Icons.telegram, const Color(0xFF2CA5E0), () => launchUrlString(context, telegramUrl)),
      ('WhatsApp', Icons.chat_bubble_rounded, const Color(0xFF25D366), () => launchUrlString(context, whatsappUrl)),
      ('Facebook', Icons.facebook, const Color(0xFF1877F2), () => launchUrlString(context, facebookUrl)),
      ('Gmail', Icons.email_rounded, const Color(0xFFEA4335), () => launchEmail(context, gmail)),
    ];
    return GridView.builder(
      shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 1.0),
      itemCount: items.length,
      itemBuilder: (_, i) {
        final (label, icon, color, onTap) = items[i];
        return GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(14),
                color: AppColors.navySurface, border: Border.all(color: color.withOpacity(0.25))),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 6),
              Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
            ]),
          ),
        );
      },
    );
  }
}

class _PaymentBrands extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _SectionLabel(l10n.paymentMethods),
      const SizedBox(height: 10),
      Row(children: [
        _Chip('KBZ Pay', AppColors.cyan),
        const SizedBox(width: 8),
        _Chip('Wave Pay', AppColors.blueAccent),
      ]),
      const SizedBox(height: 16),
      _SectionLabel(l10n.supportedBrands),
      const SizedBox(height: 10),
      Wrap(spacing: 8, runSpacing: 8, children: ['Dahua', 'Imou', 'Hikvision', 'Ezviz', 'Tiandy', 'UNV']
          .map((b) => _Chip(b, AppColors.textMuted)).toList()),
    ]);
  }
}

class _Chip extends StatelessWidget {
  final String text;
  final Color color;
  const _Chip(this.text, this.color);
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),
        color: color.withOpacity(0.1), border: Border.all(color: color.withOpacity(0.3))),
    child: Text(text, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w600)),
  );
}
