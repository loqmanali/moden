import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:modn/core/design_system/app_colors/app_colors.dart';
import 'package:modn/core/localization/localization.dart';
import 'package:modn/core/utils/app_assets.dart';
import 'package:modn/core/widgets/adaptive_button.dart';
import 'package:modn/core/widgets/app_scaffold.dart';
import 'package:modn/core/widgets/app_spacing.dart';
import 'package:modn/core/widgets/body_widget.dart';
import 'package:modn/core/widgets/header_widget.dart';

import '../../../core/routes/app_navigators.dart';

class RejectedScreen extends StatelessWidget {
  const RejectedScreen({
    super.key,
    this.type = 'event',
    this.workshopId,
  });

  final String type;
  final String? workshopId;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      header: const RejectedHeader(),
      body: RejectedBody(
        type: type,
        workshopId: workshopId,
      ),
    );
  }
}

class RejectedBody implements Body {
  const RejectedBody({
    Key? key,
    this.type = 'event',
    this.workshopId,
  });

  final String type;
  final String? workshopId;
  @override
  Widget build(BuildContext context) {
    return BodyWidget(
      child: Column(
        children: [
          AppSpacing.height(context.height * 0.1),
          SvgPicture.asset(AppSvgAssets.failedIcon),
          const AppSpacing.height(20),
          Text(
            context.l10n.accessDenied,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryDark,
            ),
          ),
          const AppSpacing.height(20),
          Text(
            context.l10n.invalidOrAlreadyUsedTicket,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryDark,
            ),
          ),
          const AppSpacing.height(50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Column(
              children: [
                AdaptiveButton(
                  onPressed: () {
                    final queryParams = workshopId != null
                        ? '?type=$type&workshopId=$workshopId'
                        : '?type=$type';
                    context.go('${AppNavigations.qr}$queryParams');
                  },
                  label: context.l10n.scanNextTicket,
                  borderRadius: 24,
                ),
                const AppSpacing.height(20),
                AdaptiveButton(
                  onPressed: () {
                    context.go(AppNavigations.event);
                  },
                  label: context.l10n.returnToMyEvents,
                  borderRadius: 24,
                  variant: AdaptiveButtonVariant.outlined,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RejectedHeader implements Header {
  const RejectedHeader({Key? key});
  @override
  Widget build(BuildContext context) {
    return HeaderWidget(
      title: context.l10n.rejected,
    );
  }
}
