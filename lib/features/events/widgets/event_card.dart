import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modn/core/design_system/app_colors/app_colors.dart';
import 'package:modn/core/localization/localization.dart';
import 'package:modn/core/utils/app_assets.dart';
import 'package:modn/core/widgets/adaptive_button.dart';

import '../../../core/widgets/app_spacing.dart';

class EventCard extends StatelessWidget {
  const EventCard({
    super.key,
    required this.title,
    required this.dateText,
    required this.location,
    required this.checkedIn,
    required this.capacity,
    this.onViewWorkshops,
    this.onStartScanning,
    this.onSearchByNationalId,
  });

  final String title;
  final String dateText;
  final String location;
  final int checkedIn;
  final int capacity;
  final VoidCallback? onViewWorkshops;
  final VoidCallback? onStartScanning;
  final VoidCallback? onSearchByNationalId;

  @override
  Widget build(BuildContext context) {
    final percent =
        capacity == 0 ? 0.0 : (checkedIn / capacity).clamp(0.0, 1.0);

    return Card(
      elevation: 4,
      shadowColor: Colors.black.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryDark,
                height: 1.1,
              ),
            ),
            const AppSpacing.height(14),

            // Date row
            _InfoRow(
              icon: AppSvgAssets.calendar,
              text: dateText,
            ),
            const AppSpacing.height(8),

            // Location row
            _InfoRow(
              icon: AppSvgAssets.location,
              text: location,
            ),
            const AppSpacing.height(14),

            // Check-in progress (muted track + right-aligned %)
            _CheckinProgress(
              checkedIn: checkedIn,
              capacity: capacity,
              percent: percent,
              barColor: Colors.transparent,
            ),

            const AppSpacing.height(14),

            // CTA buttons
            onViewWorkshops != null
                ? Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: AdaptiveButton(
                              variant: AdaptiveButtonVariant.outlined,
                              onPressed: onViewWorkshops,
                              label: L10n.viewWorkshops,
                              borderRadius: 24,
                              sizeSpec: const ButtonSizeSpec(
                                height: 34,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                              ),
                            ),
                          ),
                          const AppSpacing.width(8),
                          Expanded(
                            child: AdaptiveButton(
                              onPressed: onStartScanning,
                              label: L10n.startScanning,
                              borderRadius: 24,
                              sizeSpec: const ButtonSizeSpec(
                                height: 34,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (onSearchByNationalId != null) ...[
                        const AppSpacing.height(8),
                        AdaptiveButton(
                          variant: AdaptiveButtonVariant.outlined,
                          onPressed: onSearchByNationalId,
                          label: L10n.searchByNationalId,
                          borderRadius: 24,
                          sizeSpec: const ButtonSizeSpec(
                            height: 34,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                          ),
                        ),
                      ],
                    ],
                  )
                : Column(
                    children: [
                      AdaptiveButton(
                        onPressed: onStartScanning,
                        label: L10n.startScanning,
                        borderRadius: 24,
                        sizeSpec: const ButtonSizeSpec(
                          height: 34,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                        ),
                      ),
                      if (onSearchByNationalId != null) ...[
                        const AppSpacing.height(8),
                        AdaptiveButton(
                          variant: AdaptiveButtonVariant.outlined,
                          onPressed: onSearchByNationalId,
                          label: 'بحث بالهوية الوطنية',
                          borderRadius: 24,
                          sizeSpec: const ButtonSizeSpec(
                            height: 34,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                          ),
                        ),
                      ],
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final String icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          icon,
          width: 18,
          height: 18,
          colorFilter:
              const ColorFilter.mode(Color(0xFF3C7E85), BlendMode.srcIn),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.primaryLight,
          ),
        ),
      ],
    );
  }
}

class _CheckinProgress extends StatelessWidget {
  const _CheckinProgress({
    required this.checkedIn,
    required this.capacity,
    required this.percent,
    required this.barColor,
  });

  final int checkedIn;
  final int capacity;
  final double percent;
  final Color barColor;

  @override
  Widget build(BuildContext context) {
    final percentLabel = '${(percent * 100).round()}%';

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF0F3F5),
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.group_outlined,
              size: 18, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '$checkedIn / $capacity checked in',
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            percentLabel,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.primaryLight,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// Extension helper to draw a rounded progress bar behind the child
extension ProgressBar on Widget {
  Widget withProgressBar({
    required double percent,
    required Color color,
  }) {
    percent = percent.clamp(0.0, 1.0);
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final fill = width * percent;
        return Stack(
          children: [
            // Track (already provided by container background)
            this,
            // Fill overlay
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: fill,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          color.withValues(alpha: 0.25),
                          color.withValues(alpha: 0.12),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
