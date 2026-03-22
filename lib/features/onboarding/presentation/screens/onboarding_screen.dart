import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/language_button.dart';
import '../../../../l10n/app_localizations.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with TickerProviderStateMixin {
  final PageController _pageCtrl = PageController();
  int _page = 0;
  late AnimationController _dotCtrl;

  @override
  void initState() {
    super.initState();
    _dotCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    _dotCtrl.dispose();
    super.dispose();
  }

  void _next() {
    if (_page < 2) {
      _pageCtrl.nextPage(duration: const Duration(milliseconds: 450), curve: Curves.easeInOut);
    } else {
      context.go(AppRoutes.roleSelection);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final pages = [
      _PageData(image: 'assets/images/banner_1.jpeg', icon: Icons.videocam_rounded,
          title: l10n.onboardingTitle1, subtitle: l10n.onboardingSubtitle1),
      _PageData(image: 'assets/images/banner_2.jpeg', icon: Icons.phone_android_rounded,
          title: l10n.onboardingTitle2, subtitle: l10n.onboardingSubtitle2),
      _PageData(image: 'assets/images/banner_3.jpeg', icon: Icons.verified_rounded,
          title: l10n.onboardingTitle3, subtitle: l10n.onboardingSubtitle3),
    ];

    return Scaffold(
      backgroundColor: AppColors.navy,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageCtrl,
            onPageChanged: (i) => setState(() => _page = i),
            itemCount: pages.length,
            itemBuilder: (context, i) => _OnboardingPage(data: pages[i]),
          ),
          // Top bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const LanguageButton(),
                  TextButton(
                    onPressed: () => context.go(AppRoutes.roleSelection),
                    child: Text(l10n.skip, style: const TextStyle(color: AppColors.textMuted, fontSize: 14)),
                  ),
                ],
              ),
            ),
          ),
          // Bottom controls
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(28, 32, 28, 48),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter, end: Alignment.bottomCenter,
                  colors: [Colors.transparent, AppColors.navy, AppColors.navy],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(pages[_page].title,
                      style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Colors.white, height: 1.2)),
                  const SizedBox(height: 10),
                  Text(pages[_page].subtitle,
                      style: const TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.6)),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      // Dots
                      Row(
                        children: List.generate(3, (i) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.only(right: 6),
                          width: _page == i ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _page == i ? AppColors.cyan : Colors.white24,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        )),
                      ),
                      const Spacer(),
                      // Next button
                      GestureDetector(
                        onTap: _next,
                        child: Container(
                          width: 56, height: 56,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [AppColors.cyan, AppColors.blueAccent],
                              begin: Alignment.topLeft, end: Alignment.bottomRight,
                            ),
                            boxShadow: [BoxShadow(color: AppColors.cyan.withOpacity(0.4), blurRadius: 16, offset: const Offset(0, 6))],
                          ),
                          child: Icon(_page == 2 ? Icons.check_rounded : Icons.arrow_forward_rounded,
                              color: Colors.black, size: 26),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PageData {
  final String image;
  final IconData icon;
  final String title;
  final String subtitle;
  const _PageData({required this.image, required this.icon, required this.title, required this.subtitle});
}

class _OnboardingPage extends StatelessWidget {
  final _PageData data;
  const _OnboardingPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(data.image, fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter, end: Alignment.center,
                  colors: [Color(0xFF0D1F3C), AppColors.navy],
                ),
              ),
              child: Center(child: Icon(data.icon, size: 100, color: AppColors.cyan.withOpacity(0.3))),
            )),
        // Gradient overlay
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter, end: Alignment.bottomCenter,
              stops: [0.0, 0.4, 1.0],
              colors: [Color(0x44020617), Color(0x88020617), AppColors.navy],
            ),
          ),
        ),
      ],
    );
  }
}
