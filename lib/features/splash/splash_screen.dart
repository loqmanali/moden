import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:modn/core/routes/app_navigators.dart';
import 'package:modn/core/widgets/adaptive_button.dart';
import 'package:modn/core/widgets/app_spacing.dart';

import '../../core/utils/app_assets.dart';
import '../../core/utils/app_system_ui.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppSystemUi.setSystemUIWithoutContext(isDark: true);
    final size = MediaQuery.of(context).size.width;
    print(size);
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(AppAssets.bg, fit: BoxFit.fill),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppSpacing.height(context.height * 0.2),
              SvgPicture.asset(
                AppSvgAssets.logoWhite,
                fit: BoxFit.cover,
              ),
              const AppSpacing.height(24),
              const Text(
                'Modn',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const AppSpacing.height(24),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 48),
                child: Text(
                  'Fast, secure ticket validation for event staff',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const AppSpacing.height(32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: AdaptiveButton(
                  onPressed: () {
                    context.go(AppNavigations.login);
                  },
                  label: 'Get Started',
                  borderRadius: 24,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
