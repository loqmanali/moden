// adaptive_qr_scanner.dart
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// شكل الفريم
enum QrFrameShape { roundedRect, square, circle }

/// إعدادات الـ Overlay (فريم الكاميرا)
class QrOverlayConfig {
  final QrFrameShape shape;
  final double cornerRadius;
  final double borderWidth;
  final Color borderColor;

  /// لون التعتيم خارج الفريم
  final Color maskColor;

  /// حجم الفريم كنسبة من أقصر ضلع للشاشة (0.2..0.95)
  final double frameSizeFraction;

  /// إزاحة الفريم داخل مساحة الويدجت
  final EdgeInsets framePadding;

  /// إعدادات خط المسح
  final bool showScanLine;
  final double scanLineWidth;
  final double scanLineSpeed;
  final Color scanLineColor;

  /// رسم حواف بدل حدود كاملة
  final bool drawCornerEdges;
  final double cornerEdgeLength;

  /// مستطيل داخلي اختياري
  final bool showInnerBox;
  final double innerBoxInset;
  final double innerBoxWidth;
  final Color innerBoxColor;

  const QrOverlayConfig({
    this.shape = QrFrameShape.roundedRect,
    this.cornerRadius = 24,
    this.borderWidth = 3,
    this.borderColor = const Color(0xFFFFFFFF),
    this.maskColor = const Color(0x88000000),
    this.frameSizeFraction = 0.7,
    this.framePadding =
        const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
    this.showScanLine = true,
    this.scanLineWidth = 2,
    this.scanLineSpeed = 1.0,
    this.scanLineColor = const Color(0xFF00E5FF),
    this.drawCornerEdges = true,
    this.cornerEdgeLength = 28,
    this.showInnerBox = false,
    this.innerBoxInset = 10,
    this.innerBoxWidth = 1.2,
    this.innerBoxColor = const Color(0x33000000),
  }) : assert(frameSizeFraction > 0.2 && frameSizeFraction <= 0.95,
            'frameSizeFraction should be between 0.2 and 0.95');
}

/// كولباك عند اكتشاف كود
typedef OnQrDetect = void Function(
  String rawValue,
  Barcode barcode,
  BarcodeCapture capture,
);

/// ويدجت الماسح
class AdaptiveQrScanner extends StatefulWidget {
  final OnQrDetect onDetect;
  final QrOverlayConfig overlay;
  final List<BarcodeFormat> formats;
  final bool startPaused;
  final bool showControls;
  final BoxFit cameraFit;
  final bool allowDuplicates;
  final Duration duplicateThrottle;
  final MobileScannerController? controller;

  const AdaptiveQrScanner({
    super.key,
    required this.onDetect,
    this.overlay = const QrOverlayConfig(),
    this.formats = const [BarcodeFormat.qrCode],
    this.startPaused = false,
    this.showControls = true,
    this.cameraFit = BoxFit.cover,
    this.allowDuplicates = false,
    this.duplicateThrottle = const Duration(seconds: 2),
    this.controller,
  });

  @override
  State<AdaptiveQrScanner> createState() => _AdaptiveQrScannerState();
}

class _AdaptiveQrScannerState extends State<AdaptiveQrScanner>
    with SingleTickerProviderStateMixin {
  late final MobileScannerController _controller;
  String? _lastValue;
  DateTime _lastEmit = DateTime.fromMillisecondsSinceEpoch(0);
  late final AnimationController _scanAnim;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ??
        MobileScannerController(
          detectionSpeed: DetectionSpeed.noDuplicates,
          facing: CameraFacing.back,
          torchEnabled: false,
          autoStart: !widget.startPaused,
          formats: widget.formats,
          returnImage: false,
        );

    final baseDurationMs =
        (1800 ~/ widget.overlay.scanLineSpeed).clamp(300, 5000);
    _scanAnim = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: baseDurationMs),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    _scanAnim.dispose();
    super.dispose();
  }

  Rect _computeScanWindow(Size size) {
    final shortest = math.min(size.width, size.height);
    final frameSize = shortest * widget.overlay.frameSizeFraction;

    final centeredLeft = (size.width - frameSize) / 2;
    final centeredTop = (size.height - frameSize) / 2;

    final left = (centeredLeft +
            widget.overlay.framePadding.left -
            widget.overlay.framePadding.right * 0.5)
        .clamp(0.0, size.width - frameSize);
    final top = (centeredTop +
            widget.overlay.framePadding.top -
            widget.overlay.framePadding.bottom * 0.5)
        .clamp(0.0, size.height - frameSize);

    return Rect.fromLTWH(left, top, frameSize, frameSize);
  }

  bool _shouldEmit(String? value) {
    if (value == null || value.isEmpty) return false;
    if (widget.allowDuplicates) return true;
    final now = DateTime.now();
    if (value == _lastValue &&
        now.difference(_lastEmit) < widget.duplicateThrottle) {
      return false;
    }
    _lastValue = value;
    _lastEmit = now;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final size = Size(constraints.maxWidth, constraints.maxHeight);
      final scanWindow = _computeScanWindow(size);

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // الكاميرا + الفريم
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                MobileScanner(
                  controller: _controller,
                  fit: widget.cameraFit,
                  scanWindow: scanWindow,
                  onDetect: (capture) {
                    final barcode = capture.barcodes.firstOrNull;
                    final raw = barcode?.rawValue;
                    if (_shouldEmit(raw)) {
                      widget.onDetect(raw!, barcode!, capture);
                    }
                  },
                ),
                IgnorePointer(
                  child: CustomPaint(
                    painter: _QrOverlayPainter(
                      config: widget.overlay,
                      animationValue: _scanAnim.value,
                      frameRect: scanWindow,
                    ),
                    size: Size.infinite,
                  ),
                ),
              ],
            ),
          ),

          // الكنترولز تحت الفريم
          if (widget.showControls)
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 24),
              child: _ControlsBar(controller: _controller),
            ),
        ],
      );
    });
  }
}

class _ControlsBar extends StatefulWidget {
  final MobileScannerController controller;
  const _ControlsBar({required this.controller});

  @override
  State<_ControlsBar> createState() => _ControlsBarState();
}

class _ControlsBarState extends State<_ControlsBar> {
  bool _torch = false;
  CameraFacing _facing = CameraFacing.back;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _ControlButton(
          icon: _torch ? Icons.flash_on : Icons.flash_off,
          onTap: () async {
            await widget.controller.toggleTorch();
            setState(() => _torch = !_torch);
          },
        ),
        const SizedBox(width: 16),
        _ControlButton(
          icon: Icons.cameraswitch,
          onTap: () async {
            await widget.controller.switchCamera();
            setState(() => _facing = _facing == CameraFacing.back
                ? CameraFacing.front
                : CameraFacing.back);
          },
        ),
        const SizedBox(width: 16),
        _ControlButton(
          icon: Icons.pause,
          onTap: () async => widget.controller.stop(),
        ),
        const SizedBox(width: 16),
        _ControlButton(
          icon: Icons.play_arrow,
          onTap: () async => widget.controller.start(),
        ),
      ],
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _ControlButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(40),
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(40),
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}

class _QrOverlayPainter extends CustomPainter {
  final QrOverlayConfig config;
  final double animationValue;
  final Rect frameRect;

  _QrOverlayPainter({
    required this.config,
    required this.animationValue,
    required this.frameRect,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final maskPaint = Paint()..color = config.maskColor;
    final full = Path()..addRect(Offset.zero & size);

    Path framePath;
    switch (config.shape) {
      case QrFrameShape.circle:
        framePath = Path()
          ..addOval(Rect.fromCircle(
            center: frameRect.center,
            radius: frameRect.width / 2,
          ));
        break;
      case QrFrameShape.square:
        framePath = Path()..addRect(frameRect);
        break;
      case QrFrameShape.roundedRect:
        framePath = Path()
          ..addRRect(RRect.fromRectAndRadius(
            frameRect,
            Radius.circular(config.cornerRadius),
          ));
        break;
    }

    final mask = Path.combine(PathOperation.difference, full, framePath);
    canvas.drawPath(mask, maskPaint);

    final borderPaint = Paint()
      ..color = config.borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = config.borderWidth;

    if (config.drawCornerEdges) {
      _drawCornerEdges(canvas, frameRect, borderPaint, config.cornerEdgeLength);
    } else {
      canvas.drawPath(framePath, borderPaint);
    }

    if (config.showInnerBox) {
      final inset = config.innerBoxInset;
      final innerRect = Rect.fromLTWH(
        frameRect.left + inset,
        frameRect.top + inset,
        frameRect.width - inset * 2,
        frameRect.height - inset * 2,
      );
      final innerPaint = Paint()
        ..color = config.innerBoxColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = config.innerBoxWidth;

      if (config.shape == QrFrameShape.roundedRect) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            innerRect,
            Radius.circular(
                math.min(config.cornerRadius, innerRect.width / 10)),
          ),
          innerPaint,
        );
      } else if (config.shape == QrFrameShape.circle) {
        canvas.drawOval(innerRect, innerPaint);
      } else {
        canvas.drawRect(innerRect, innerPaint);
      }
    }

    if (config.showScanLine) {
      final y = frameRect.top + animationValue * frameRect.height;
      final scanPaint = Paint()
        ..color = config.scanLineColor
        ..strokeWidth = config.scanLineWidth
        ..style = PaintingStyle.stroke;
      final start = Offset(frameRect.left + 6, y);
      final end = Offset(frameRect.right - 6, y);
      canvas.drawLine(start, end, scanPaint);
    }
  }

  void _drawCornerEdges(Canvas canvas, Rect r, Paint p, double len) {
    // أعلى يسار
    canvas.drawLine(Offset(r.left, r.top), Offset(r.left + len, r.top), p);
    canvas.drawLine(Offset(r.left, r.top), Offset(r.left, r.top + len), p);
    // أعلى يمين
    canvas.drawLine(Offset(r.right, r.top), Offset(r.right - len, r.top), p);
    canvas.drawLine(Offset(r.right, r.top), Offset(r.right, r.top + len), p);
    // أسفل يسار
    canvas.drawLine(
        Offset(r.left, r.bottom), Offset(r.left + len, r.bottom), p);
    canvas.drawLine(
        Offset(r.left, r.bottom), Offset(r.left, r.bottom - len), p);
    // أسفل يمين
    canvas.drawLine(
        Offset(r.right, r.bottom), Offset(r.right - len, r.bottom), p);
    canvas.drawLine(
        Offset(r.right, r.bottom), Offset(r.right, r.bottom - len), p);
  }

  @override
  bool shouldRepaint(covariant _QrOverlayPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.config != config ||
        oldDelegate.frameRect != frameRect;
  }
}

extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull => isEmpty ? null : first;
}
