import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../l10n/app_localizations.dart';

class OwnerShellScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const OwnerShellScreen({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final items = [
      (Icons.dashboard_rounded, Icons.dashboard_outlined, l10n.navDash),
      (Icons.folder_rounded, Icons.folder_outlined, l10n.navProjects),
      (Icons.inbox_rounded, Icons.inbox_outlined, l10n.navRequests),
      (Icons.confirmation_number_rounded, Icons.confirmation_number_outlined, l10n.navTickets),
      (Icons.request_quote_rounded, Icons.request_quote_outlined, l10n.navQuotes),
      (Icons.settings_rounded, Icons.settings_outlined, l10n.navMore),
    ];

    return Scaffold(
      backgroundColor: AppColors.navy,
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.navySurface,
          border: Border(top: BorderSide(color: AppColors.cyan.withOpacity(0.15))),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, -4))],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 60,
            child: Row(
              children: List.generate(items.length, (i) {
                final selected = navigationShell.currentIndex == i;
                final (activeIcon, inactiveIcon, label) = items[i];
                return Expanded(
                  child: GestureDetector(
                    onTap: () => navigationShell.goBranch(i, initialLocation: i == navigationShell.currentIndex),
                    child: Container(
                      color: Colors.transparent,
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: selected ? AppColors.cyan.withOpacity(0.15) : Colors.transparent,
                          ),
                          child: Icon(selected ? activeIcon : inactiveIcon,
                              color: selected ? AppColors.cyan : AppColors.textMuted, size: 22),
                        ),
                        const SizedBox(height: 2),
                        Text(label,
                            style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600,
                                color: selected ? AppColors.cyan : AppColors.textMuted)),
                      ]),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
