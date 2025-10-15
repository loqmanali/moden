import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:modn/core/design_system/app_colors/app_colors.dart';
import 'package:modn/core/routes/app_navigators.dart';
import 'package:modn/core/utils/app_assets.dart';
import 'package:modn/core/widgets/adaptive_button.dart';
import 'package:modn/shared/widgets/app_scaffold.dart';
import 'package:modn/shared/widgets/body_widget.dart';
import 'package:modn/shared/widgets/header_widget.dart';

import '../../../core/widgets/app_spacing.dart';

class AcceptedScreen extends StatelessWidget {
  const AcceptedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      header: AcceptedHeader(),
      body: AcceptedBody(),
    );
  }
}

class AcceptedHeader implements Header {
  const AcceptedHeader({Key? key});
  @override
  Widget build(BuildContext context) {
    return HeaderWidget(
      title: 'Accepted',
    );
  }
}

class AcceptedBody implements Body {
  const AcceptedBody({Key? key});
  @override
  Widget build(BuildContext context) {
    return BodyWidget(
      child: Column(
        children: [
          AppSpacing.height(context.height * 0.1),
          SvgPicture.asset(AppSvgAssets.successIcon),
          AppSpacing.height(20),
          Text(
            'Access Granted',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryDark,
            ),
          ),
          AppSpacing.height(20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            margin: const EdgeInsets.symmetric(horizontal: 24),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xFF28B3BA).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                Text(
                  'Guest Information',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2B717F),
                  ),
                ),
                AppSpacing.height(16),
                Text(
                  'Name: Mohamed Hassan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF2B717F),
                  ),
                ),
                AppSpacing.height(16),
                Text(
                  'Ticket: VIP Access',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF2B717F),
                  ),
                ),
                AppSpacing.height(16),
                Text(
                  'Section: A-12',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF2B717F),
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.height(20),
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
