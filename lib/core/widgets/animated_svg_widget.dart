import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:xml/xml.dart';

enum AnimatedSvgFillDirection {
  bottomToTop,
  topToBottom,
  leftToRight,
  rightToLeft,
}

/// Renders any path-based SVG asset as an animated stroke-to-fill sequence.
class AnimatedSvgWidget extends StatefulWidget {
  const AnimatedSvgWidget({
    super.key,
    required this.assetName,
    this.width,
    this.height,
    this.duration = const Duration(milliseconds: 2000),
    this.strokeWidth = 3,
    this.style = PaintingStyle.stroke,
    this.repeat = true,
    this.animateStrokeToFill = true,
    this.fillStartFraction = 0.65,
    this.strokeCurve = Curves.easeInOutCubic,
    this.fillCurve = Curves.easeOutCubic,
    this.fillDirection = AnimatedSvgFillDirection.bottomToTop,
    this.useSvgColors = true,
    this.strokeColor,
    this.fillColor,
    this.placeholder,
    this.errorBuilder,
  }) : assert(
          fillStartFraction > 0 && fillStartFraction < 1,
          'fillStartFraction must be between 0 and 1 (exclusive).',
        );

  final String assetName;
  final double? width;
  final double? height;
  final Duration duration;
  final double strokeWidth;
  final PaintingStyle style;
  final bool repeat;
  final bool animateStrokeToFill;
  final double fillStartFraction;
  final Curve strokeCurve;
  final Curve fillCurve;
  final AnimatedSvgFillDirection fillDirection;
  final bool useSvgColors;
  final Color? strokeColor;
  final Color? fillColor;
  final Widget? placeholder;
  final Widget Function(BuildContext context, String error)? errorBuilder;

  @override
  State<AnimatedSvgWidget> createState() => _AnimatedSvgWidgetState();
}

class _AnimatedSvgWidgetState extends State<AnimatedSvgWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  SvgVector? _vector;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _loadSvg();
  }

  @override
  void didUpdateWidget(covariant AnimatedSvgWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.assetName != widget.assetName) {
      _loadSvg();
    }

    if (oldWidget.duration != widget.duration) {
      _controller
        ..duration = widget.duration
        ..reset();
      _startAnimation();
    }

    if (oldWidget.repeat != widget.repeat) {
      if (widget.repeat) {
        _controller
          ..reset()
          ..repeat();
      } else {
        _controller
          ..stop()
          ..forward(from: _controller.value);
      }
    }

    if (!widget.repeat && !_controller.isAnimating && _controller.value >= 1) {
      _controller.value = 1;
    }
  }

  Future<void> _loadSvg() async {
    setState(() {
      _isLoading = true;
      _error = null;
      _vector = null;
    });

    try {
      final raw = await rootBundle.loadString(widget.assetName);
      final vector = SvgVector.parse(raw);
      if (vector.paths.isEmpty) {
        throw FormatException(
          '''AnimatedSvgWidget requires at least one <path> element. "${widget.assetName}" has none.
          ## SVG Requirements
            To render the animation correctly, your SVG must satisfy the following constraints:
            1. **Paths only** – every drawable element should be a `<path>` with a valid `d` attribute. Flatten any `<rect>`, `<circle>`, `<polygon>`, `<image>`, or clip/mask elements into paths before exporting.
            2. **Defined dimensions** – include a `viewBox` (preferred) or explicit `width`/`height` so the widget can calculate aspect ratio and scaling.
            3. **Reasonable file size** – keep assets lightweight (≤30KB recommended) to reduce load time and keep animations smooth.
            4. **Color handling** – set `fill` values if you plan to reuse SVG colors (`useSvgColors: true`). For custom colors, provide `strokeColor`/`fillColor` overrides.
            5. **No embedded rasters** – embedded bitmaps (e.g. `xlink:href="data:image/..."`) are ignored; replace them with vector paths if needed.
            If the loader does not find at least one `<path>`, `AnimatedSvgWidget` throws a `FormatException` with the asset name to surface the issue early.
          ''',
        );
      }
      if (!mounted) return;
      setState(() {
        _vector = vector;
        _isLoading = false;
      });
      _controller
        ..duration = widget.duration
        ..reset();
      _startAnimation();
    } catch (error, stackTrace) {
      debugPrint('AnimatedSvgWidget error: $error\n$stackTrace');
      if (!mounted) return;
      setState(() {
        _error = error.toString();
        _isLoading = false;
      });
    }
  }

  void _startAnimation() {
    final vector = _vector;
    if (vector == null || vector.paths.isEmpty) {
      return;
    }

    if (widget.repeat) {
      _controller.repeat();
    } else {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vector = _vector;
    final width = widget.width ?? vector?.viewBoxWidth ?? 100;
    final height = widget.height ??
        (widget.width != null && vector != null
            ? widget.width! * (vector.viewBoxHeight / vector.viewBoxWidth)
            : vector?.viewBoxHeight ?? 100);

    if (_isLoading) {
      return widget.placeholder ?? SizedBox(width: width, height: height);
    }

    if (_error != null) {
      final builder = widget.errorBuilder;
      if (builder != null) {
        return builder(context, _error!);
      }
      return widget.placeholder ?? SizedBox(width: width, height: height);
    }

    if (vector == null || vector.paths.isEmpty) {
      return widget.placeholder ?? SizedBox(width: width, height: height);
    }

    return SizedBox(
      width: width,
      height: height,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final textDirection =
              Directionality.maybeOf(context) ?? TextDirection.ltr;
          final effectiveFillDirection = _resolveFillDirection(
            widget.fillDirection,
            textDirection,
          );
          return CustomPaint(
            painter: _AnimatedSvgPainter(
              progress: _controller.value,
              vector: vector,
              strokeWidth: widget.strokeWidth,
              style: widget.style,
              animateStrokeToFill: widget.animateStrokeToFill,
              fillStartFraction: widget.fillStartFraction,
              strokeCurve: widget.strokeCurve,
              fillCurve: widget.fillCurve,
              fillDirection: effectiveFillDirection,
              useSvgColors: widget.useSvgColors,
              strokeColorOverride: widget.strokeColor,
              fillColorOverride: widget.fillColor,
            ),
          );
        },
      ),
    );
  }

  AnimatedSvgFillDirection _resolveFillDirection(
    AnimatedSvgFillDirection direction,
    TextDirection textDirection,
  ) {
    if (textDirection != TextDirection.rtl) {
      return direction;
    }

    switch (direction) {
      case AnimatedSvgFillDirection.leftToRight:
        return AnimatedSvgFillDirection.rightToLeft;
      case AnimatedSvgFillDirection.rightToLeft:
        return AnimatedSvgFillDirection.leftToRight;
      case AnimatedSvgFillDirection.bottomToTop:
      case AnimatedSvgFillDirection.topToBottom:
        return direction;
    }
  }
}

class SvgVector {
  const SvgVector({
    required this.viewBoxWidth,
    required this.viewBoxHeight,
    required this.paths,
  });

  final double viewBoxWidth;
  final double viewBoxHeight;
  final List<SvgPath> paths;

  static SvgVector parse(String raw) {
    final document = XmlDocument.parse(raw);
    final svgElement =
        document.findElements('svg').firstOrNull ?? document.rootElement;

    final viewBox = _parseViewBox(svgElement);
    final width = viewBox?.width ??
        _parseDimension(svgElement.getAttribute('width')) ??
        100;
    final height = viewBox?.height ??
        _parseDimension(svgElement.getAttribute('height')) ??
        100;

    final paths = <SvgPath>[];
    _collectPaths(svgElement, null, paths);

    return SvgVector(
      viewBoxWidth: width,
      viewBoxHeight: height,
      paths: paths,
    );
  }

  static _ViewBox? _parseViewBox(XmlElement svgElement) {
    final viewBoxAttr = svgElement.getAttribute('viewBox');
    if (viewBoxAttr == null) {
      return null;
    }
    final values = viewBoxAttr
        .split(RegExp(r'[ ,]+'))
        .where((value) => value.isNotEmpty)
        .map(double.tryParse)
        .whereType<double>()
        .toList();
    if (values.length != 4) {
      return null;
    }
    return _ViewBox(width: values[2], height: values[3]);
  }

  static double? _parseDimension(String? raw) {
    if (raw == null) return null;
    final cleaned = raw.replaceAll(RegExp(r'[^0-9.]+'), '');
    return double.tryParse(cleaned);
  }

  static void _collectPaths(
    XmlElement element,
    Color? inheritedFill,
    List<SvgPath> collector,
  ) {
    if (element.name.local == 'path') {
      final data = element.getAttribute('d');
      if (data != null && data.trim().isNotEmpty) {
        final path = parseSvgPathData(data);
        final fill = _resolveFillColor(element, inheritedFill);
        collector.add(SvgPath(path: path, fillColor: fill));
      }
      return;
    }

    final nextInheritedFill = _resolveFillColor(element, inheritedFill);
    for (final node in element.children) {
      if (node is XmlElement) {
        _collectPaths(node, nextInheritedFill, collector);
      }
    }
  }

  static Color _resolveFillColor(XmlElement element, Color? fallback) {
    final fillAttr = element.getAttribute('fill');
    final parsedFill = _parseColor(fillAttr);
    if (parsedFill != null) {
      return parsedFill;
    }

    final styleAttr = element.getAttribute('style');
    if (styleAttr != null) {
      final styleMap = styleAttr
          .split(';')
          .map((entry) => entry.trim())
          .where((entry) => entry.contains(':'))
          .fold<Map<String, String>>({}, (map, entry) {
        final parts = entry.split(':');
        if (parts.length == 2) {
          map[parts[0].trim()] = parts[1].trim();
        }
        return map;
      });
      final styleFill = styleMap['fill'];
      final parsedStyleFill = _parseColor(styleFill);
      if (parsedStyleFill != null) {
        return parsedStyleFill;
      }
    }

    return fallback ?? Colors.black;
  }

  static Color? _parseColor(String? value) {
    if (value == null) return null;
    final normalized = value.trim();
    if (normalized.isEmpty || normalized == 'none') {
      return Colors.transparent;
    }
    if (normalized.startsWith('#')) {
      final hex = normalized.substring(1);
      if (hex.length == 3) {
        final r = hex[0];
        final g = hex[1];
        final b = hex[2];
        final expanded = '$r$r$g$g$b$b';
        final intColor = int.tryParse(expanded, radix: 16);
        if (intColor != null) {
          return Color(0xFF000000 | intColor);
        }
      } else if (hex.length == 6) {
        final intColor = int.tryParse(hex, radix: 16);
        if (intColor != null) {
          return Color(0xFF000000 | intColor);
        }
      } else if (hex.length == 8) {
        final intColor = int.tryParse(hex, radix: 16);
        if (intColor != null) {
          return Color(intColor);
        }
      }
    }

    if (normalized.startsWith('rgb')) {
      final values = normalized
          .replaceAll(RegExp(r'[rgb()\s]'), '')
          .split(',')
          .where((entry) => entry.isNotEmpty)
          .map(int.tryParse)
          .whereType<int>()
          .toList();
      if (values.length == 3) {
        return Color.fromARGB(255, values[0], values[1], values[2]);
      }
    }

    return null;
  }
}

class SvgPath {
  const SvgPath({required this.path, required this.fillColor});

  final Path path;
  final Color fillColor;
}

class _ViewBox {
  const _ViewBox({required this.width, required this.height});

  final double width;
  final double height;
}

class _AnimatedSvgPainter extends CustomPainter {
  _AnimatedSvgPainter({
    required this.progress,
    required this.vector,
    required this.strokeWidth,
    required this.style,
    required this.animateStrokeToFill,
    required this.fillStartFraction,
    required this.strokeCurve,
    required this.fillCurve,
    required this.fillDirection,
    required this.useSvgColors,
    required this.strokeColorOverride,
    required this.fillColorOverride,
  }) : _t = progress % 1.0;

  final double progress;
  final double _t;
  final SvgVector vector;
  final double strokeWidth;
  final PaintingStyle style;
  final bool animateStrokeToFill;
  final double fillStartFraction;
  final Curve strokeCurve;
  final Curve fillCurve;
  final AnimatedSvgFillDirection fillDirection;
  final bool useSvgColors;
  final Color? strokeColorOverride;
  final Color? fillColorOverride;

  @override
  void paint(Canvas canvas, Size size) {
    final viewBoxWidth = vector.viewBoxWidth;
    final viewBoxHeight = vector.viewBoxHeight;
    final scale = math.min(
      size.width / viewBoxWidth,
      size.height / viewBoxHeight,
    );

    canvas
      ..save()
      ..translate(
        (size.width - viewBoxWidth * scale) / 2,
        (size.height - viewBoxHeight * scale) / 2,
      )
      ..scale(scale, scale);

    final strokeProgress = _computeStrokeProgress();
    final fillProgress = _computeFillProgress();

    final shouldDrawStroke = style != PaintingStyle.fill || animateStrokeToFill;
    final shouldDrawFill = style == PaintingStyle.fill || animateStrokeToFill;

    if (shouldDrawFill && fillProgress > 0) {
      for (final info in vector.paths) {
        final color = _effectiveFillColor(info);
        if (color.a == 0) continue;
        _drawFill(canvas, info.path, color, fillProgress, viewBoxWidth,
            viewBoxHeight);
      }
    }

    if (shouldDrawStroke && strokeProgress > 0) {
      for (final info in vector.paths) {
        final color = _effectiveStrokeColor(info);
        if (color.a == 0) continue;
        _drawStroke(canvas, info.path, color, strokeProgress);
      }
    }

    canvas.restore();
  }

  Color _effectiveFillColor(SvgPath info) {
    if (!useSvgColors && fillColorOverride != null) {
      return fillColorOverride!;
    }
    if (useSvgColors && info.fillColor.a != 0) {
      return info.fillColor;
    }
    return fillColorOverride ?? info.fillColor;
  }

  Color _effectiveStrokeColor(SvgPath info) {
    if (strokeColorOverride != null) {
      return strokeColorOverride!;
    }
    if (useSvgColors && info.fillColor.a != 0) {
      return info.fillColor;
    }
    return info.fillColor == Colors.transparent
        ? const Color(0xFF000000)
        : info.fillColor;
  }

  double _computeStrokeProgress() {
    if (!animateStrokeToFill) {
      return strokeCurve.transform(_t);
    }

    if (_t <= fillStartFraction) {
      final normalized = (_t / fillStartFraction).clamp(0.0, 1.0);
      return strokeCurve.transform(normalized);
    }

    return 1.0;
  }

  double _computeFillProgress() {
    if (style == PaintingStyle.fill && !animateStrokeToFill) {
      return 1.0;
    }

    if (!animateStrokeToFill) {
      return 0.0;
    }

    final normalized =
        ((_t - fillStartFraction) / (1 - fillStartFraction)).clamp(0.0, 1.0);
    return fillCurve.transform(normalized);
  }

  void _drawStroke(
    Canvas canvas,
    Path path,
    Color color,
    double progress,
  ) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = color;

    final metrics = path.computeMetrics().toList(growable: false);
    final totalLength =
        metrics.fold<double>(0, (sum, metric) => sum + metric.length);
    final drawLength = totalLength * progress.clamp(0, 1);

    double remaining = drawLength;
    final extractPath = Path();

    for (final metric in metrics) {
      if (remaining <= 0) break;
      final segmentLength = math.min(metric.length, remaining);
      extractPath.addPath(metric.extractPath(0, segmentLength), Offset.zero);
      remaining -= segmentLength;
    }

    canvas.drawPath(extractPath, paint);
  }

  void _drawFill(
    Canvas canvas,
    Path path,
    Color color,
    double progress,
    double viewBoxWidth,
    double viewBoxHeight,
  ) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color;

    canvas.save();
    canvas.clipRect(
      _clipRectForProgress(progress, viewBoxWidth, viewBoxHeight),
    );
    canvas.drawPath(path, paint);
    canvas.restore();
  }

  Rect _clipRectForProgress(
    double progress,
    double viewBoxWidth,
    double viewBoxHeight,
  ) {
    final clamped = progress.clamp(0.0, 1.0);
    switch (fillDirection) {
      case AnimatedSvgFillDirection.bottomToTop:
        final startY = viewBoxHeight * (1 - clamped);
        return Rect.fromLTWH(0, startY, viewBoxWidth, viewBoxHeight - startY);
      case AnimatedSvgFillDirection.topToBottom:
        final extentY = viewBoxHeight * clamped;
        return Rect.fromLTWH(0, 0, viewBoxWidth, extentY);
      case AnimatedSvgFillDirection.leftToRight:
        final extentX = viewBoxWidth * clamped;
        return Rect.fromLTWH(0, 0, extentX, viewBoxHeight);
      case AnimatedSvgFillDirection.rightToLeft:
        final startX = viewBoxWidth * (1 - clamped);
        return Rect.fromLTWH(startX, 0, viewBoxWidth - startX, viewBoxHeight);
    }
  }

  @override
  bool shouldRepaint(covariant _AnimatedSvgPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.vector != vector ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.style != style ||
        oldDelegate.animateStrokeToFill != animateStrokeToFill ||
        oldDelegate.fillStartFraction != fillStartFraction ||
        oldDelegate.strokeCurve != strokeCurve ||
        oldDelegate.fillCurve != fillCurve ||
        oldDelegate.fillDirection != fillDirection ||
        oldDelegate.useSvgColors != useSvgColors ||
        oldDelegate.strokeColorOverride != strokeColorOverride ||
        oldDelegate.fillColorOverride != fillColorOverride;
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
