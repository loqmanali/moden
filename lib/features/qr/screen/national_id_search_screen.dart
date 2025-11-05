import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:modn/core/design_system/app_colors/app_colors.dart';
import 'package:modn/core/routes/app_navigators.dart';
import 'package:modn/core/services/device_info_service.dart';
import 'package:modn/core/services/di.dart';
import 'package:modn/core/utils/ui_helper.dart';
import 'package:modn/core/widgets/adaptive_button.dart';
import 'package:modn/core/widgets/adaptive_loading.dart';
import 'package:modn/core/widgets/app_scaffold.dart';
import 'package:modn/core/widgets/app_spacing.dart';
import 'package:modn/core/widgets/app_text_form_field.dart';
import 'package:modn/core/widgets/body_widget.dart';
import 'package:modn/core/widgets/header_widget.dart';
import 'package:modn/features/qr/cubit/national_id_qr_cubit.dart';
import 'package:modn/features/qr/cubit/qr_scan_cubit.dart';

import '../../../core/localization/localization.dart';

class NationalIdSearchScreen extends StatelessWidget {
  const NationalIdSearchScreen({
    super.key,
    this.type = 'event',
    this.workshopId,
    this.eventId,
  });

  final String type;
  final String? workshopId;
  final String? eventId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => di<NationalIdQrCubit>(),
        ),
        BlocProvider(
          create: (context) => di<QrScanCubit>(),
        ),
      ],
      child: _NationalIdSearchContent(
        type: type,
        workshopId: workshopId,
        eventId: eventId,
      ),
    );
  }
}

class _NationalIdSearchContent extends StatefulWidget {
  const _NationalIdSearchContent({
    this.type = 'event',
    this.workshopId,
    this.eventId,
  });

  final String type;
  final String? workshopId;
  final String? eventId;

  @override
  State<_NationalIdSearchContent> createState() =>
      _NationalIdSearchContentState();
}

class _NationalIdSearchContentState extends State<_NationalIdSearchContent> {
  final _nationalIdController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late final DeviceInfoService _deviceInfoService;
  String? _deviceId;

  @override
  void initState() {
    super.initState();
    _deviceInfoService = di<DeviceInfoService>();
    _initDeviceId();
  }

  Future<void> _initDeviceId() async {
    _deviceId = await _deviceInfoService.getDeviceId();
  }

  @override
  void dispose() {
    _nationalIdController.dispose();
    super.dispose();
  }

  void _searchByNationalId() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<NationalIdQrCubit>().getUserQrCode(
            nationalId: _nationalIdController.text.trim(),
            eventId: widget.eventId ?? '',
          );
    }
  }

  Future<void> _completeCheckin(String qrData) async {
    final qrScanCubit = context.read<QrScanCubit>();

    // Get device ID if not already fetched
    final deviceId = _deviceId ?? await _deviceInfoService.getDeviceId();

    // Call API to scan QR code
    await qrScanCubit.scanQrCode(
      qrData: qrData,
      type: widget.type,
      workshopId: widget.workshopId,
      deviceId: deviceId,
    );

    if (!mounted) return;

    // Navigate based on response
    final state = qrScanCubit.state;
    final baseParams = <String, String>{
      'type': widget.type,
      if (widget.workshopId != null) 'workshopId': widget.workshopId!,
    };

    if (state.status == QrScanStatus.success &&
        state.response?.success == true) {
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
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      header: const _NationalIdSearchHeader(),
      body: _NationalIdSearchBody(
        formKey: _formKey,
        nationalIdController: _nationalIdController,
        onSearch: _searchByNationalId,
        onCompleteCheckin: _completeCheckin,
        type: widget.type,
        workshopId: widget.workshopId,
      ),
    );
  }
}

class _NationalIdSearchHeader implements Header {
  const _NationalIdSearchHeader();

  @override
  Widget build(BuildContext context) {
    return HeaderWidget(
      title: context.l10n.searchByNationalId,
      leading: Padding(
        padding: EdgeInsets.only(right: L10n.isArabic ? 0 : 16),
        child: GestureDetector(
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onTap: () => context.go(AppNavigations.event),
        ),
      ),
    );
  }
}

class _NationalIdSearchBody implements Body {
  const _NationalIdSearchBody({
    required this.formKey,
    required this.nationalIdController,
    required this.onSearch,
    required this.onCompleteCheckin,
    required this.type,
    this.workshopId,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nationalIdController;
  final VoidCallback onSearch;
  final Function(String) onCompleteCheckin;
  final String type;
  final String? workshopId;

  @override
  Widget build(BuildContext context) {
    return BodyWidget(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: BlocConsumer<NationalIdQrCubit, NationalIdQrState>(
            listener: (context, state) {
              if (state.status == NationalIdQrStatus.failure) {
                UIHelper.showSnackBar(
                  context,
                  message: state.message ?? 'حدث خطأ',
                  type: SnackBarType.error,
                );
              }
            },
            builder: (context, state) {
              if (state.status == NationalIdQrStatus.success &&
                  state.response != null) {
                return _QrCodeDisplay(
                  qrCodeData: state.response!.qrCode,
                  onCompleteCheckin: onCompleteCheckin,
                  onBack: () {
                    context.read<NationalIdQrCubit>().reset();
                    nationalIdController.clear();
                    // context.go(AppNavigations.event);
                  },
                );
              }

              return Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      L10n.enterNationalId,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryDark,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const AppSpacing.height(24),
                    AppTextFormField(
                      controller: nationalIdController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      hintText: '2000000000',
                      textColor: AppColors.primaryDark,
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      cursorColor: AppColors.primary,
                      maxLength: 10,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return L10n.pleaseEnterNationalId;
                        }
                        if (value.trim().length != 10) {
                          return L10n.nationalIdMustBe10Digits;
                        }
                        return null;
                      },
                    ),
                    const AppSpacing.height(24),
                    if (state.status == NationalIdQrStatus.loading)
                      const Center(
                        child: LoadingIndicator(
                          type: LoadingIndicatorType.circle,
                          size: 50,
                          strokeWidth: 3,
                          color: AppColors.primary,
                        ),
                      )
                    else
                      AdaptiveButton(
                        onPressed: onSearch,
                        label: L10n.search,
                        borderRadius: 8,
                      ),
                  ],
                ),
              );
            },
          )),
    );
  }
}

class _QrCodeDisplay extends StatelessWidget {
  const _QrCodeDisplay({
    required this.qrCodeData,
    required this.onCompleteCheckin,
    required this.onBack,
  });

  final dynamic qrCodeData;
  final Function(String) onCompleteCheckin;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    // Decode base64 QR code image
    final qrCodeBase64 = qrCodeData.qrCode as String;
    final qrCodeBytes = base64Decode(qrCodeBase64);

    // // Parse QR data to get the JSON string
    // final qrPayload = <String, String>{
    //   'applicationId': qrCodeData.applicationId,
    //   'eventId': qrCodeData.eventId,
    //   'userId': qrCodeData.userId ?? qrCodeData.applicationId,
    // };

    // final qrDataJson = jsonEncode(qrPayload);

    return BlocBuilder<QrScanCubit, QrScanState>(
      builder: (context, scanState) {
        final isProcessing = scanState.status == QrScanStatus.loading;

        return Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  L10n.qrCode,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryDark,
                  ),
                  textAlign: TextAlign.center,
                ),
                const AppSpacing.height(24),
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Image.memory(
                      Uint8List.fromList(qrCodeBytes),
                      width: 250,
                      height: 250,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const AppSpacing.height(32),
                // AdaptiveButton(
                //   onPressed:
                //       isProcessing ? null : () => onCompleteCheckin(qrDataJson),
                //   label: isProcessing ? 'جاري المعالجة...' : 'إتمام الدخول',
                //   borderRadius: 16,
                // ),
                // const AppSpacing.height(12),
                AdaptiveButton(
                  onPressed: isProcessing ? null : onBack,
                  label: L10n.back,
                  variant: AdaptiveButtonVariant.outlined,
                  borderRadius: 16,
                ),
              ],
            ),
            if (isProcessing)
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
        );
      },
    );
  }
}
