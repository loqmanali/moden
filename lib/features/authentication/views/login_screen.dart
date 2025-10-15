import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:modn/core/design_system/theme/moden_theme.dart';
import 'package:modn/core/routes/app_navigators.dart';
import 'package:modn/core/utils/app_assets.dart';
import 'package:modn/core/widgets/app_spacing.dart';
import 'package:modn/shared/widgets/app_scaffold.dart';
import 'package:modn/shared/widgets/body_widget.dart';
import 'package:modn/shared/widgets/header_widget.dart';

import '../../../core/design_system/app_colors/app_colors.dart';
import '../../../core/widgets/adaptive_button.dart';
import '../../../core/widgets/app_text_form_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      header: const HeaderLogin(),
      body: const BodyLogin(),
    );
  }
}

class HeaderLogin implements Header {
  const HeaderLogin({Key? key});
  @override
  Widget build(BuildContext context) {
    return HeaderWidget(
      title: 'Login',
    );
  }
}

class BodyLogin implements Body {
  const BodyLogin({Key? key});
  @override
  Widget build(BuildContext context) {
    return BodyWidget(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSpacing.height(48),
              Center(child: SvgPicture.asset(AppSvgAssets.logoColor)),
              AppSpacing.height(48),
              Text(
                'E-mail *',
                style: context.foruiTheme.typography.xl.copyWith(
                  color: AppColors.textTertiary,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              AppTextFormField(
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                hintText: 'Enter your email',
              ),
              AppSpacing.height(24),
              Text(
                'Password *',
                style: context.foruiTheme.typography.xl.copyWith(
                  color: AppColors.textTertiary,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              AppTextFormField(
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.visiblePassword,
                hintText: '********',
              ),
              AppSpacing.height(48),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: AdaptiveButton(
                  onPressed: () {
                    context.go(AppNavigations.event);
                  },
                  label: 'Sign In',
                  labelFontSize: 18,
                  borderRadius: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
