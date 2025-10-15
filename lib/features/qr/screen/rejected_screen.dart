import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:modn/core/design_system/app_colors/app_colors.dart';
import 'package:modn/core/utils/app_assets.dart';
import 'package:modn/core/widgets/adaptive_button.dart';
import 'package:modn/core/widgets/app_spacing.dart';
import 'package:modn/shared/widgets/app_scaffold.dart';
import 'package:modn/shared/widgets/body_widget.dart';
import 'package:modn/shared/widgets/header_widget.dart';

import '../../../core/routes/app_navigators.dart';

class RejectedScreen extends StatelessWidget {
  const RejectedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      header: RejectedHeader(),
      body: RejectedBody(),
    );
  }
}

class RejectedBody implements Body {
  const RejectedBody({Key? key});
  @override
  Widget build(BuildContext context) {
    return BodyWidget(
      child: Column(
        children: [
          AppSpacing.height(context.height * 0.1),
          SvgPicture.asset(AppSvgAssets.failedIcon),
          AppSpacing.height(20),
          Text(
            'Access Denied',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryDark,
            ),
          ),
          AppSpacing.height(20),
          Text(
            'Invalid or already used ticket',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryDark,
            ),
          ),
          AppSpacing.height(50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Column(
              children: [
                AdaptiveButton(
                  onPressed: () {
                    context.go(AppNavigations.qr);
                  },
                  label: 'Scan next ticket',
                  borderRadius: 24,
                ),
                AppSpacing.height(20),
                AdaptiveButton(
                  onPressed: () {
                    context.go(AppNavigations.event);
                  },
                  label: 'Return to My Events',
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
      title: 'Rejected',
    );
  }
}
