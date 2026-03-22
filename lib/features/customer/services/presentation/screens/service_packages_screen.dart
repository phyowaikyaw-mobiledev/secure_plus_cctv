import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/firebase/fcm_service.dart';
import '../../../../../core/router/app_router.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/widgets/language_button.dart';
import '../../../../../core/widgets/secure_scaffold.dart';
import '../../../../../l10n/app_localizations.dart';

class ServicePackagesScreen extends StatefulWidget {
  const ServicePackagesScreen({super.key});
  @override
  State<ServicePackagesScreen> createState() => _ServicePackagesScreenState();
}

class _ServicePackagesScreenState extends State<ServicePackagesScreen> {
  @override
  void initState() {
    super.initState();
    FcmService().requestPermission();
    FcmService().registerAsCustomer();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SecureScaffold(
      appBar: AppBar(
        title: Text(l10n.securePlusServices),
        actions: const [LanguageButton()],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Header banner
          _HeaderBanner(),
          const SizedBox(height: 24),
          // Packages
          _SectionLabel(l10n.securePlusServices),
          const SizedBox(height: 12),
          _PackageCard(
            icon: Icons.home_rounded, color: AppColors.blueAccent,
            title: l10n.homeCctvPackage, description: l10n.homeCctvDesc,
            features: const ['4–8 ကင်မရာ', 'Mobile Viewing', 'HD Resolution'],
          ),
          _PackageCard(
            icon: Icons.storefront_rounded, color: AppColors.cyan,
            title: l10n.smePackage, description: l10n.smePackageDesc,
            features: const ['DVR/NVR Setup', 'Network Optimized', 'Mobile Viewing'],
            isPopular: true,
          ),
          _PackageCard(
            icon: Icons.factory_rounded, color: AppColors.warning,
            title: l10n.enterprisePackage, description: l10n.enterprisePackageDesc,
            features: const ['IP Camera System', 'Centralized Monitor', 'Long Recording'],
          ),
          const SizedBox(height: 24),
          // Action buttons
          _SectionLabel('Actions'),
          const SizedBox(height: 12),
          _ActionButton(icon: Icons.add_circle_rounded, label: l10n.requestNewInstallation,
              color: AppColors.cyan, onTap: () => context.push(AppRoutes.customerServiceRequest)),
          const SizedBox(height: 10),
          _ActionButton(icon: Icons.build_rounded, label: l10n.createMaintenanceTicket,
              color: AppColors.blueAccent, onTap: () => context.push(AppRoutes.customerTicket)),
          const SizedBox(height: 10),
          _ActionButton(icon: Icons.photo_library_rounded, label: l10n.viewCompletedSites,
              color: AppColors.success, onTap: () => context.push(AppRoutes.customerProjects)),
          const SizedBox(height: 10),
          _ActionButton(icon: Icons.info_rounded, label: l10n.contactAbout,
              color: AppColors.warning, onTap: () => context.push(AppRoutes.customerContact)),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _HeaderBanner extends StatelessWidget {
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
        border: Border.all(color: AppColors.cyan.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(l10n.appTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
              const SizedBox(height: 4),
              Text(l10n.appTagline, style: const TextStyle(fontSize: 12, color: AppColors.cyan)),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.success.withOpacity(0.15),
                  border: Border.all(color: AppColors.success.withOpacity(0.4)),
                ),
                child: Text(l10n.installationsCount,
                    style: const TextStyle(fontSize: 11, color: AppColors.success, fontWeight: FontWeight.w600)),
              ),
            ]),
          ),
          const SizedBox(width: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.asset('assets/images/logo.jpg', width: 64, height: 64, fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 64, height: 64, color: AppColors.navySurfaceAlt,
                  child: const Icon(Icons.videocam_rounded, color: AppColors.cyan, size: 32),
                )),
          ),
        ],
      ),
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

class _PackageCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String description;
  final List<String> features;
  final bool isPopular;
  const _PackageCard({required this.icon, required this.color, required this.title,
      required this.description, required this.features, this.isPopular = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: AppColors.navySurface,
        border: Border.all(color: isPopular ? color.withOpacity(0.5) : color.withOpacity(0.2), width: isPopular ? 1.5 : 1),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: color.withOpacity(0.15)),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white))),
          if (isPopular)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: color.withOpacity(0.2)),
              child: Text('Popular', style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w700)),
            ),
        ]),
        const SizedBox(height: 10),
        Text(description, style: const TextStyle(fontSize: 12, color: AppColors.textMuted, height: 1.5)),
        const SizedBox(height: 12),
        Wrap(spacing: 6, runSpacing: 6, children: features.map((f) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: color.withOpacity(0.1),
            border: Border.all(color: color.withOpacity(0.25)),
          ),
          child: Text(f, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w600)),
        )).toList()),
      ]),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _ActionButton({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: color.withOpacity(0.08),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(shape: BoxShape.circle, color: color.withOpacity(0.15)),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white))),
          Icon(Icons.arrow_forward_ios_rounded, color: color.withOpacity(0.6), size: 14),
        ]),
      ),
    );
  }
}
