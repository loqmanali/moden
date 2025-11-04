import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:modn/core/design_system/app_colors/app_colors.dart';
import 'package:modn/core/localization/localization.dart';
import 'package:modn/core/services/device_info_service.dart';
import 'package:modn/core/services/di.dart';
import 'package:modn/core/widgets/adaptive_button.dart';
import 'package:modn/core/widgets/adaptive_loading.dart';
import 'package:modn/core/widgets/app_scaffold.dart';
import 'package:modn/core/widgets/app_spacing.dart';
import 'package:modn/core/widgets/body_widget.dart';
import 'package:modn/core/widgets/header_widget.dart';
import 'package:modn/features/qr/cubit/qr_scan_cubit.dart';
import 'package:modn/features/qr/widgets/adaptive_qr_scanner.dart';

import '../../../core/routes/app_navigators.dart';

class QrScreen extends StatelessWidget {
  const QrScreen({
    super.key,
    this.type = 'event',
    this.workshopId,
  });

  final String type;
  final String? workshopId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di<QrScanCubit>(),
      child: _QrScreenContent(
        type: type,
        workshopId: workshopId,
      ),
    );
  }
}

class _QrScreenContent extends StatefulWidget {
  const _QrScreenContent({
    this.type = 'event',
    this.workshopId,
  });

  final String type;
  final String? workshopId;

  @override
  State<_QrScreenContent> createState() => _QrScreenContentState();
}

class _QrScreenContentState extends State<_QrScreenContent> {
  late final MobileScannerController _controller;
  late final DeviceInfoService _deviceInfoService;
  String? _deviceId;

  bool _isScanning = false;
  bool _isLoading = false;
  bool _isStartingCam = false;

  @override
  void initState() {
    super.initState();
    _deviceInfoService = di<DeviceInfoService>();
    _initDeviceId();
    _controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
      torchEnabled: false,
      autoStart: !kIsWeb, // Don't auto-start on web for PWA compatibility
      formats: const [BarcodeFormat.qrCode],
      returnImage: false,
    );
  }

  Future<void> _initDeviceId() async {
    _deviceId = await _deviceInfoService.getDeviceId();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleQr(String code) async {
    if (!mounted) return;

    setState(() => _isLoading = true);

    try {
      // Parse QR code data
      final qrScanCubit = context.read<QrScanCubit>();
      
      // Get device ID if not already fetched
      final deviceId = _deviceId ?? await _deviceInfoService.getDeviceId();
      
      // Call API to scan QR code
      await qrScanCubit.scanQrCode(
        qrData: code,
        type: widget.type,
        workshopId: widget.workshopId,
        deviceId: deviceId,
      );

      // Stop camera after scanning
      await _controller.stop();
      
      if (!mounted) return;
      
      setState(() {
        _isLoading = false;
        _isScanning = false;
      });

      // Navigate based on response
      final state = qrScanCubit.state;
      final baseParams = <String, String>{
        'type': widget.type,
        if (widget.workshopId != null) 'workshopId': widget.workshopId!,
      };
      
      if (state.status == QrScanStatus.success && state.response?.success == true) {
        if (mounted) {
          final qp = Uri(queryParameters: baseParams).query;
          context.push('${AppNavigations.qrAccepted}?$qp');
        }
      } else {
        if (mounted) {
          // Collect error info from state/response
          final errorMessage = state.message ?? state.response?.message;
          final errorCode = state.response?.code;
          final qp = Uri(
            queryParameters: <String, String>{
              ...baseParams,
              if (errorMessage != null) 'errorMsg': errorMessage,
              if (errorCode != null) 'errorCode': errorCode.toString(),
            },
          ).query;
          context.push('${AppNavigations.qrRejected}?$qp');
        }
      }
    } catch (e) {
      // Handle error
      await _controller.stop();
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isScanning = false;
        });
        final qp = Uri(
          queryParameters: <String, String>{
            'type': widget.type,
            if (widget.workshopId != null) 'workshopId': widget.workshopId!,
            'errorMsg': e.toString(),
          },
        ).query;
        context.push('${AppNavigations.qrRejected}?$qp');
      }
    }
  }

  Future<void> _toggleScan() async {
    if (_isStartingCam) return; // prevent re-entry while initializing
    if (_isScanning) {
      try {
        setState(() => _isStartingCam = true);
        await _controller.stop();
        setState(() => _isScanning = false);
      } finally {
        setState(() => _isStartingCam = false);
      }
    } else {
      try {
        setState(() => _isStartingCam = true);
        await _controller.start();
        setState(() => _isScanning = true);
      } catch (e) {
        if (mounted) {
          String errorMessage = 'Failed to start camera';
          if (kIsWeb) {
            if (e.toString().contains('Permission')) {
              errorMessage =
                  'Camera permission denied. Please allow camera access and try again.';
            } else if (e.toString().contains('NotFound') ||
                e.toString().contains('not found')) {
              errorMessage =
                  'No camera found. Please check your device has a camera.';
            } else {
              errorMessage =
                  'Camera not available. Make sure you\'re using HTTPS.';
            }
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      } finally {
        setState(() => _isStartingCam = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      header: const QrHeader(),
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
        isScanning: _isScanning,
        isStartingCam: _isStartingCam,
      ),
    );
  }
}

class QrHeader implements Header {
  const QrHeader({Key? key});
  @override
  Widget build(BuildContext context) {
    return HeaderWidget(
      title: context.l10n.qrScreenTitle,
      trailing: const Icon(
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
    required this.isScanning,
    required this.isStartingCam,
  });
  final MobileScannerController controller;
  final void Function(String, Barcode, BarcodeCapture) onDetect;
  final VoidCallback onScan;
  final bool isLoading;
  final bool isScanning;
  final bool isStartingCam;

  String _getButtonText(BuildContext context) {
    if (isLoading) return context.l10n.processing;
    if (isStartingCam) return context.l10n.startingCamera;
    if (isScanning) return context.l10n.stopScanning;
    return kIsWeb ? context.l10n.startCameraScan : context.l10n.scanQrCode;
  }

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
                        overlay: const QrOverlayConfig(
                          shape: QrFrameShape.square,
                          cornerRadius: 0,
                          borderWidth: 3,
                          borderColor: AppColors.primary,
                          maskColor: !kIsWeb ? Colors.white : Color(0x88000000),
                          frameSizeFraction: 0.72,
                          framePadding: EdgeInsets.only(),
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
                const AppSpacing.height(20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: AdaptiveButton(
                    onPressed: isLoading || isStartingCam ? null : onScan,
                    label: _getButtonText(context),
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
                child: const LoadingIndicator(
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
