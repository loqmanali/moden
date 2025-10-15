import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:modn/core/design_system/app_colors/app_colors.dart';
import 'package:modn/core/widgets/adaptive_button.dart';
import 'package:modn/core/widgets/adaptive_loading.dart';
import 'package:modn/core/widgets/app_spacing.dart';
import 'package:modn/features/qr/widgets/adaptive_qr_scanner.dart';
import 'package:modn/shared/widgets/app_scaffold.dart';
import 'package:modn/shared/widgets/body_widget.dart';
import 'package:modn/shared/widgets/header_widget.dart';

import '../../../core/routes/app_navigators.dart';

class QrScreen extends StatefulWidget {
  const QrScreen({Key? key}) : super(key: key);

  @override
  State<QrScreen> createState() => _QrScreenState();
}

class _QrScreenState extends State<QrScreen> {
  late final MobileScannerController _controller;

  bool _isScanning = false;
  bool _isLoading = false;
  bool _lastResultSuccess = false;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
      torchEnabled: false,
      autoStart: !kIsWeb,
      formats: const [BarcodeFormat.qrCode],
      returnImage: false,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleQr(String code) async {
    setState(() => _isLoading = true);

    // 🕐 ننتظر كأنها عملية API
    await Future.delayed(const Duration(seconds: 2));

    // نبدّل النتيجة كل مرة
    _lastResultSuccess = !_lastResultSuccess;
    final bool success = _lastResultSuccess;

    // نوقف الكاميرا بعد القراءة
    await _controller.stop();
    setState(() {
      _isLoading = false;
      _isScanning = false;
    });

    // ✅ أو ❌
    if (success) {
      if (mounted) {
        context.push(AppNavigations.qrAccepted);
      }
    } else {
      if (mounted) {
        context.push(AppNavigations.qrRejected);
      }
    }
  }

  Future<void> _toggleScan() async {
    if (_isScanning) {
      await _controller.stop();
    } else {
      await _controller.start();
    }
    setState(() => _isScanning = !_isScanning);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      header: QrHeader(),
      body: QrBody(
        controller: _controller,
        onDetect: (value, barcode, args) async {
          if (_isLoading) return; // ⬅️ حماية من التكرار
          await _controller.stop(); // ⬅️ أوقف الكاميرا فورًا
          setState(() => _isScanning = false);
          _handleQr(value);
        },
        onScan: _toggleScan,
        isLoading: _isLoading,
      ),
    );
  }
}

class QrHeader implements Header {
  const QrHeader({Key? key});
  @override
  Widget build(BuildContext context) {
    return HeaderWidget(
      title: 'QR Validator',
      trailing: Icon(
        FIcons.logOut,
        color: Colors.transparent,
      ),
    );
  }
}

class QrBody implements Body {
  const QrBody({
    Key? key,
    required this.controller,
    required this.onDetect,
    required this.onScan,
    required this.isLoading,
  });
  final MobileScannerController controller;
  final void Function(String, Barcode, BarcodeCapture) onDetect;
  final VoidCallback onScan;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return BodyWidget(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Stack(
          alignment: Alignment.center,
          children: [
            /// كل المحتوى الأساسي
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: ClipRRect(
                    clipBehavior: Clip.antiAlias,
                    borderRadius: BorderRadius.circular(24),
                    child: SizedBox(
                      height: 300,
                      child: AdaptiveQrScanner(
                        controller: controller,
                        startPaused: false,
                        showControls: false,
                        onDetect: onDetect,
                        overlay: QrOverlayConfig(
                          shape: QrFrameShape.square,
                          cornerRadius: 0,
                          borderWidth: 3,
                          borderColor: AppColors.primary,
                          maskColor: Colors.white,
                          frameSizeFraction: 0.72,
                          framePadding: const EdgeInsets.only(),
                          drawCornerEdges: true,
                          cornerEdgeLength: 32,
                          showInnerBox: true,
                          innerBoxInset: 15,
                          innerBoxWidth: 1,
                          innerBoxColor: AppColors.primary,
                          showScanLine: false,
                        ),
                        allowDuplicates: false,
                        duplicateThrottle: const Duration(seconds: 2),
                      ),
                    ),
                  ),
                ),
                AppSpacing.height(20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: AdaptiveButton(
                    onPressed: onScan,
                    label: 'Scan QR Code',
                    borderRadius: 24,
                  ),
                ),
              ],
            ),

            /// اللودينج في المنتصف (Overlay)
            if (isLoading)
              Container(
                color: AppColors.white.withValues(alpha: 0.7),
                alignment: Alignment.center,
                child: LoadingIndicator(
                  type: LoadingIndicatorType.circle,
                  size: 80,
                  strokeWidth: 3,
                  color: AppColors.primary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
