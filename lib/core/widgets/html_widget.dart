import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../design_system/app_colors/app_colors.dart';

class HtmlWidget extends StatelessWidget {
  const HtmlWidget({
    super.key,
    required this.title,
    required this.description,
    required this.isHtmlDescription,
  });

  final String title;
  final String description;
  final bool isHtmlDescription;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty) ...[
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
        ],
        if (isHtmlDescription)
          Html(
            data: description,
            style: {
              'body': Style(
                fontSize: FontSize(12),
                color: AppColors.textTertiary,
                padding: HtmlPaddings.zero,
                margin: Margins.zero,
                lineHeight: const LineHeight(2.5),
              ),
              'p': Style(margin: Margins.only(bottom: 10)),
              'li': Style(margin: Margins.only(bottom: 5)),
            },
          )
        else
          Text(
            description,
            style: const TextStyle(
              color: AppColors.textTertiary,
              fontSize: 12,
              fontWeight: FontWeight.normal,
            ),
          ),
      ],
    );
  }
}
