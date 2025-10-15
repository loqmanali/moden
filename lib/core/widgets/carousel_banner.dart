import 'package:flutter/material.dart';

enum IndicatorPosition { overlay, below }

abstract class CarouselItem {
  Widget build(BuildContext context);
}

/// ======== NEW: Marketing slide to match the mock ========
class MarketingCarouselItem implements CarouselItem {
  final String imageUrl;
  final bool isAsset;
  final BorderRadius borderRadius;

  // Left text content
  final String headline; // "Big Sale"
  final String subhead; // "Up to 50%"
  final String ctaLabel; // "Discover more"
  final VoidCallback? onCta;

  // Styling
  final Color ctaBg;
  final Color ctaFg;

  const MarketingCarouselItem({
    required this.imageUrl,
    this.isAsset = false,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    required this.headline,
    required this.subhead,
    required this.ctaLabel,
    this.onCta,
    this.ctaBg = const Color(0xFFFFFFFF),
    this.ctaFg = const Color(0xFF1E1E1E),
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ClipRRect(
      borderRadius: borderRadius,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Image
          if (isAsset)
            Image.asset(imageUrl, fit: BoxFit.cover)
          else
            Image.network(imageUrl, fit: BoxFit.cover),

          // Subtle dark overlay to pop the text
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.black.withValues(alpha: 0.35),
                  Colors.black.withValues(alpha: 0.10),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.35, 0.75],
              ),
            ),
          ),

          // Decorative soft blobs on the right (approx. like mock)
          Positioned.fill(
            child: IgnorePointer(
              child: Stack(
                children: [
                  // big soft arc bottom-right
                  Positioned(
                    right: -40,
                    bottom: -20,
                    child: _Blob(
                      width: 260,
                      height: 130,
                      color: const Color(0xFF8BA6B5).withValues(alpha: 0.25),
                    ),
                  ),
                  // smaller blob above it
                  Positioned(
                    right: 24,
                    bottom: 48,
                    child: _Blob(
                      width: 140,
                      height: 80,
                      color: const Color(0xFF8BA6B5).withValues(alpha: 0.18),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Left content (headline, subhead, CTA)
          Positioned(
            left: 20,
            right: 20,
            top: 24,
            bottom: 24,
            child: Align(
              alignment: Alignment.centerLeft,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 280),
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        headline,
                        style: textTheme.displaySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          height: 1.05,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        subhead,
                        style: textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _CtaButton(
                        label: ctaLabel,
                        onPressed: onCta,
                        bg: ctaBg,
                        fg: ctaFg,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  const _Blob({required this.width, required this.height, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(height),
      ),
    );
  }
}

class _CtaButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color bg, fg;
  const _CtaButton({
    required this.label,
    this.onPressed,
    required this.bg,
    required this.fg,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: bg,
            fontWeight: FontWeight.w700,
          ),
    );
  }
}

/// ======== Carousel container with below-indicator (pill style) ========

class CarouselBanner extends StatelessWidget {
  final int currentIndex;
  final PageController pageController;
  final ValueChanged<int> onPageChanged;
  final List<CarouselItem> items;

  final double height;
  final double horizontalPadding;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry outerPadding;
  final Color? borderColor;
  final double borderWidth;

  // Indicator
  final IndicatorPosition indicatorPosition;
  final bool showIndicator;
  final double indicatorDotWidth;
  final double indicatorDotHeight;
  final double indicatorInactiveWidth;
  final double indicatorInactiveHeight;
  final double indicatorSpacing;
  final Color indicatorActiveColor;
  final Color indicatorInactiveColor;
  final EdgeInsetsGeometry indicatorPadding;
  final MainAxisAlignment indicatorAlignment;

  const CarouselBanner({
    super.key,
    required this.currentIndex,
    required this.pageController,
    required this.onPageChanged,
    required this.items,
    this.height = 170,
    this.horizontalPadding = 8,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.outerPadding = const EdgeInsets.all(0),
    this.borderColor,
    this.borderWidth = 1,
    this.indicatorPosition = IndicatorPosition.below,
    this.showIndicator = true,
    this.indicatorDotWidth = 8,
    this.indicatorDotHeight = 8,
    this.indicatorInactiveWidth = 8,
    this.indicatorInactiveHeight = 8,
    this.indicatorSpacing = 10,
    this.indicatorActiveColor = const Color(0xFFE8AEB6), // rosy pink
    this.indicatorInactiveColor = const Color(0xFFF2DDE1), // pale pink
    this.indicatorPadding = const EdgeInsets.only(top: 14),
    this.indicatorAlignment = MainAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    final banner = Container(
      padding: outerPadding,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        border: borderColor == null
            ? null
            : Border.all(color: borderColor!, width: borderWidth),
      ),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: PageView.builder(
          controller: pageController,
          itemCount: items.length,
          onPageChanged: onPageChanged,
          itemBuilder: (context, i) => Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: items[i].build(context),
          ),
        ),
      ),
    );

    if (!showIndicator) return banner;

    if (indicatorPosition == IndicatorPosition.below) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          banner,
          Padding(
            padding: indicatorPadding,
            child: DotsIndicator(
              currentPage: currentIndex,
              pageCount: items.length,
              activeDotWidth: indicatorDotWidth,
              activeDotHeight: indicatorDotHeight,
              inactiveDotWidth: indicatorInactiveWidth,
              inactiveDotHeight: indicatorInactiveHeight,
              spacing: indicatorSpacing,
              activeColor: indicatorActiveColor,
              inactiveColor: indicatorInactiveColor,
              alignment: indicatorAlignment,
            ),
          ),
        ],
      );
    }

    // overlay (not used for this mock, but available)
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        banner,
        Positioned(
          bottom: 12,
          left: 0,
          right: 0,
          child: DotsIndicator(
            currentPage: currentIndex,
            pageCount: items.length,
            activeDotWidth: indicatorDotWidth,
            activeDotHeight: indicatorDotHeight,
            inactiveDotWidth: indicatorInactiveWidth,
            inactiveDotHeight: indicatorInactiveHeight,
            spacing: indicatorSpacing,
            activeColor: indicatorActiveColor,
            inactiveColor: indicatorInactiveColor,
            alignment: indicatorAlignment,
          ),
        ),
      ],
    );
  }
}

class DotsIndicator extends StatelessWidget {
  final int currentPage;
  final int pageCount;

  final double activeDotWidth;
  final double activeDotHeight;

  final double inactiveDotWidth;
  final double inactiveDotHeight;

  final double spacing;
  final Color activeColor;
  final Color inactiveColor;
  final MainAxisAlignment alignment;
  final Duration animationDuration;

  const DotsIndicator({
    super.key,
    required this.currentPage,
    required this.pageCount,
    this.activeDotWidth = 20,
    this.activeDotHeight = 8,
    this.inactiveDotWidth = 8,
    this.inactiveDotHeight = 8,
    this.spacing = 8,
    this.activeColor = const Color(0xFFE8AEB6),
    this.inactiveColor = const Color(0xFFF2DDE1),
    this.alignment = MainAxisAlignment.center,
    this.animationDuration = const Duration(milliseconds: 220),
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: alignment,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(pageCount, (index) {
        final isActive = index == currentPage;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: spacing / 2),
          child: AnimatedContainer(
            duration: animationDuration,
            curve: Curves.easeOut,
            width: isActive ? activeDotWidth : inactiveDotWidth,
            height: isActive ? activeDotHeight : inactiveDotHeight,
            decoration: BoxDecoration(
              color: isActive ? activeColor : inactiveColor,
              borderRadius: BorderRadius.circular(50),
            ),
          ),
        );
      }),
    );
  }
}
