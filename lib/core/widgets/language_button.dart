import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../locale/locale_cubit.dart';
import '../theme/app_theme.dart';
import '../../l10n/app_localizations.dart';

/// App bar action: tap to switch between English and Myanmar.
class LanguageButton extends StatelessWidget {
  const LanguageButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<LocaleCubit, Locale>(
      builder: (context, locale) {
        return PopupMenuButton<Locale>(
          icon: const Icon(Icons.language, color: Colors.white),
          color: AppColors.navySurface,
          onSelected: (Locale value) {
            context.read<LocaleCubit>().setLocale(value);
          },
          itemBuilder: (context) => [
            PopupMenuItem<Locale>(
              value: const Locale('en'),
              child: Row(
                children: [
                  if (locale.languageCode == 'en')
                    const Icon(Icons.check, color: AppColors.cyan, size: 20),
                  if (locale.languageCode == 'en') const SizedBox(width: 8),
                  Text(l10n.english),
                ],
              ),
            ),
            PopupMenuItem<Locale>(
              value: const Locale('my'),
              child: Row(
                children: [
                  if (locale.languageCode == 'my')
                    const Icon(Icons.check, color: AppColors.cyan, size: 20),
                  if (locale.languageCode == 'my') const SizedBox(width: 8),
                  Text(l10n.myanmar),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
