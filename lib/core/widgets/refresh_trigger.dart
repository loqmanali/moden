import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:modn/core/widgets/adaptive_loading.dart';

typedef RefreshIndicatorBuilder = Widget Function(
  BuildContext context,
  RefreshTriggerStage stage,
);

typedef FutureVoidCallback = Future<void> Function();
typedef RefreshCallback = Future<void> Function();
typedef LoadMoreCallback = Future<void> Function();

/// ===============================
/// ENUMS & TYPES
/// ===============================

enum RefreshTriggerDisplayMode { overlay, inset }

enum TriggerStage { idle, pulling, refreshing, completed, failed }

enum IndicatorPosition { top, bottom, left, right, custom }

/// ===============================
/// CONTROLLER
/// ===============================

class RefreshTriggerController extends ChangeNotifier {
  bool _isRefreshing = false;
  bool _isLoadingMore = false;
  TriggerStage _refreshStage = TriggerStage.idle;
  TriggerStage _loadMoreStage = TriggerStage.idle;

  bool get isRefreshing => _isRefreshing;
  bool get isLoadingMore => _isLoadingMore;
  TriggerStage get refreshStage => _refreshStage;
  TriggerStage get loadMoreStage => _loadMoreStage;

  RefreshTriggerState? _state;

  void _attach(RefreshTriggerState state) {
    _state = state;
  }

  void _detach() {
    _state = null;
  }

  /// Trigger refresh programmatically
  Future<void> requestRefresh() async {
    if (_state != null && !_isRefreshing) {
      await _state!.refresh();
    }
  }

  /// Trigger load more programmatically
  Future<void> requestLoadMore() async {
    if (_state != null && !_isLoadingMore) {
      await _state!.loadMore();
    }
  }

  /// Complete refresh manually
  void finishRefresh({bool success = true}) {
    if (_state != null) {
      _state!._finishRefresh(success);
    }
  }

  /// Complete load more manually
  void finishLoadMore({bool success = true, bool noMoreData = false}) {
    if (_state != null) {
      _state!._finishLoadMore(success, noMoreData);
    }
  }

  void _updateRefreshStage(TriggerStage stage, bool isRefreshing) {
    _refreshStage = stage;
    _isRefreshing = isRefreshing;
    notifyListeners();
  }

  void _updateLoadMoreStage(TriggerStage stage, bool isLoading) {
    _loadMoreStage = stage;
    _isLoadingMore = isLoading;
    notifyListeners();
  }

  @override
  void dispose() {
    _state = null;
    super.dispose();
  }
}

/// ===============================
/// STAGE INFO
/// ===============================

class RefreshTriggerStage {
  final TriggerStage stage;
  final Animation<double> extent;
  final Axis direction;
  final bool reverse;
  final double pixels;
  final bool isHeader;

  const RefreshTriggerStage(
    this.stage,
    this.extent,
    this.direction,
    this.reverse,
    this.pixels, {
    this.isHeader = true,
  });

  double get extentValue => extent.value;
}

/// ===============================
/// THEME
/// ===============================

class RefreshTriggerTheme {
  final double? minExtent;
  final double? maxExtent;
  final RefreshIndicatorBuilder? headerBuilder;
  final RefreshIndicatorBuilder? footerBuilder;
  final Curve? curve;
  final Duration? completeDuration;
  final RefreshTriggerDisplayMode? displayMode;
  final bool? enableRefresh;
  final bool? enableLoadMore;
  final ScrollPhysics? physics;
  final bool? enableSafeArea;

  const RefreshTriggerTheme({
    this.minExtent,
    this.maxExtent,
    this.headerBuilder,
    this.footerBuilder,
    this.curve,
    this.completeDuration,
    this.displayMode,
    this.enableRefresh,
    this.enableLoadMore,
    this.physics,
    this.enableSafeArea,
  });

  RefreshTriggerTheme copyWith({
    double? minExtent,
    double? maxExtent,
    RefreshIndicatorBuilder? headerBuilder,
    RefreshIndicatorBuilder? footerBuilder,
    Curve? curve,
    Duration? completeDuration,
    RefreshTriggerDisplayMode? displayMode,
    bool? enableRefresh,
    bool? enableLoadMore,
    ScrollPhysics? physics,
    bool? enableSafeArea,
  }) {
    return RefreshTriggerTheme(
      minExtent: minExtent ?? this.minExtent,
      maxExtent: maxExtent ?? this.maxExtent,
      headerBuilder: headerBuilder ?? this.headerBuilder,
      footerBuilder: footerBuilder ?? this.footerBuilder,
      curve: curve ?? this.curve,
      completeDuration: completeDuration ?? this.completeDuration,
      displayMode: displayMode ?? this.displayMode,
      enableRefresh: enableRefresh ?? this.enableRefresh,
      enableLoadMore: enableLoadMore ?? this.enableLoadMore,
      physics: physics ?? this.physics,
      enableSafeArea: enableSafeArea ?? this.enableSafeArea,
    );
  }
}

class RefreshTriggerThemeProvider extends InheritedWidget {
  final RefreshTriggerTheme data;

  const RefreshTriggerThemeProvider({
    super.key,
    required this.data,
    required super.child,
  });

  static RefreshTriggerTheme? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<RefreshTriggerThemeProvider>()
        ?.data;
  }

  @override
  bool updateShouldNotify(RefreshTriggerThemeProvider oldWidget) =>
      oldWidget.data != data;
}

T styleValue<T>({required T defaultValue, T? widgetValue, T? themeValue}) {
  return widgetValue ?? themeValue ?? defaultValue;
}

/// ===============================
/// MAIN WIDGET
/// ===============================

class RefreshTrigger extends StatefulWidget {
  final double? minExtent;
  final double? maxExtent;
  final RefreshCallback? onRefresh;
  final LoadMoreCallback? onLoadMore;
  final Widget child;
  final Axis direction;
  final RefreshIndicatorBuilder? headerBuilder;
  final RefreshIndicatorBuilder? footerBuilder;
  final Curve? curve;
  final Duration? completeDuration;
  final RefreshTriggerDisplayMode displayMode;
  final RefreshTriggerController? controller;
  final bool enableRefresh;
  final bool enableLoadMore;
  final bool refreshOnStart;
  final ScrollPhysics? physics;
  final bool enableSafeArea;
  final IndicatorPosition? headerPosition;
  final IndicatorPosition? footerPosition;

  const RefreshTrigger({
    super.key,
    this.minExtent,
    this.maxExtent,
    this.onRefresh,
    this.onLoadMore,
    this.direction = Axis.vertical,
    this.headerBuilder,
    this.footerBuilder,
    this.curve,
    this.completeDuration,
    this.displayMode = RefreshTriggerDisplayMode.inset,
    this.controller,
    this.enableRefresh = true,
    this.enableLoadMore = false,
    this.refreshOnStart = false,
    this.physics,
    this.enableSafeArea = true,
    this.headerPosition,
    this.footerPosition,
    required this.child,
  });

  @override
  State<RefreshTrigger> createState() => RefreshTriggerState();

  static Widget defaultHeaderBuilder(
    BuildContext context,
    RefreshTriggerStage stage,
  ) {
    return DefaultRefreshIndicator(stage: stage, isHeader: true);
  }

  static Widget defaultFooterBuilder(
    BuildContext context,
    RefreshTriggerStage stage,
  ) {
    return DefaultRefreshIndicator(stage: stage, isHeader: false);
  }
}

/// ===============================
/// STATE
/// ===============================

class RefreshTriggerState extends State<RefreshTrigger>
    with SingleTickerProviderStateMixin {
  double _headerExtent = 0;
  double _footerExtent = 0;
  bool _scrolling = false;
  ScrollDirection _userScrollDirection = ScrollDirection.idle;
  TriggerStage _headerStage = TriggerStage.idle;
  TriggerStage _footerStage = TriggerStage.idle;
  Future<void>? _currentRefreshFuture;
  Future<void>? _currentLoadMoreFuture;
  int _refreshFutureCount = 0;
  int _loadMoreFutureCount = 0;
  bool _noMoreData = false;

  late double _minExtent;
  late double _maxExtent;
  late RefreshIndicatorBuilder _headerBuilder;
  late RefreshIndicatorBuilder _footerBuilder;
  late Curve _curve;
  late Duration _completeDuration;
  late RefreshTriggerDisplayMode _displayMode;
  late ScrollPhysics _physics;
  late bool _enableSafeArea;

  @override
  void initState() {
    super.initState();
    widget.controller?._attach(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.refreshOnStart && widget.onRefresh != null) {
        refresh();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateThemeValues();
  }

  @override
  void didUpdateWidget(covariant RefreshTrigger oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?._detach();
      widget.controller?._attach(this);
    }
    _updateThemeValues();
  }

  @override
  void dispose() {
    widget.controller?._detach();
    super.dispose();
  }

  void _updateThemeValues() {
    final themeData = RefreshTriggerThemeProvider.of(context);

    _minExtent = styleValue<double>(
      widgetValue: widget.minExtent,
      themeValue: themeData?.minExtent,
      defaultValue: 75.0,
    );

    _maxExtent = styleValue<double>(
      widgetValue: widget.maxExtent,
      themeValue: themeData?.maxExtent,
      defaultValue: 150.0,
    );

    _headerBuilder = widget.headerBuilder ??
        themeData?.headerBuilder ??
        RefreshTrigger.defaultHeaderBuilder;

    _footerBuilder = widget.footerBuilder ??
        themeData?.footerBuilder ??
        RefreshTrigger.defaultFooterBuilder;

    _curve = widget.curve ?? themeData?.curve ?? Curves.easeOutSine;

    _completeDuration = widget.completeDuration ??
        themeData?.completeDuration ??
        const Duration(milliseconds: 500);

    _displayMode = styleValue<RefreshTriggerDisplayMode>(
      widgetValue: widget.displayMode,
      themeValue: themeData?.displayMode,
      defaultValue: RefreshTriggerDisplayMode.inset,
    );

    _physics =
        widget.physics ?? themeData?.physics ?? const BouncingScrollPhysics();

    _enableSafeArea = styleValue<bool>(
      widgetValue: widget.enableSafeArea,
      themeValue: themeData?.enableSafeArea,
      defaultValue: true,
    );
  }

  double _calculateSafeExtent(double extent) {
    if (extent > _minExtent) {
      final relativeExtent = extent - _minExtent;
      final maxExtent = _maxExtent;
      final diff = (maxExtent - _minExtent) - relativeExtent;
      final diffNormalized = diff / (maxExtent - _minExtent);
      final decel = Curves.decelerate.transform(diffNormalized.clamp(0, 1));
      return maxExtent - decel * diff;
    }
    return extent;
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification.depth != 0) return false;

    if (notification is ScrollEndNotification && _scrolling) {
      final shouldTriggerRefresh =
          _headerExtent >= _minExtent && widget.enableRefresh;
      final shouldTriggerLoadMore = _footerExtent >= _minExtent &&
          widget.enableLoadMore &&
          !_noMoreData;

      setState(() {
        _scrolling = false;
        if (!shouldTriggerRefresh && !shouldTriggerLoadMore) {
          _headerStage = TriggerStage.idle;
          _footerStage = TriggerStage.idle;
          _headerExtent = 0;
          _footerExtent = 0;
        }
      });

      if (shouldTriggerRefresh) {
        _scheduleRefresh();
      } else if (shouldTriggerLoadMore) {
        _scheduleLoadMore();
      }
    } else if (notification is ScrollUpdateNotification) {
      final delta = notification.scrollDelta;
      if (delta != null) {
        final axisDirection = notification.metrics.axisDirection;
        final normalizedDelta = (axisDirection == AxisDirection.down ||
                axisDirection == AxisDirection.right)
            ? -delta
            : delta;

        // Handle header pulling
        if (_headerStage == TriggerStage.pulling) {
          final forward = normalizedDelta > 0;
          if ((forward && _userScrollDirection == ScrollDirection.forward) ||
              (!forward && _userScrollDirection == ScrollDirection.reverse)) {
            setState(() {
              _headerExtent += normalizedDelta;
            });
          } else {
            if (_headerExtent >= _minExtent) {
              setState(() {
                _scrolling = false;
              });
              _scheduleRefresh();
            } else {
              setState(() {
                _headerExtent += normalizedDelta;
              });
            }
          }
        }
        // Handle footer pulling
        else if (_footerStage == TriggerStage.pulling) {
          final forward = normalizedDelta < 0;
          if ((forward && _userScrollDirection == ScrollDirection.forward) ||
              (!forward && _userScrollDirection == ScrollDirection.reverse)) {
            setState(() {
              _footerExtent += -normalizedDelta;
            });
          } else {
            if (_footerExtent >= _minExtent) {
              setState(() {
                _scrolling = false;
              });
              _scheduleLoadMore();
            } else {
              setState(() {
                _footerExtent += -normalizedDelta;
              });
            }
          }
        }
        // Start header pulling
        else if (_headerStage == TriggerStage.idle &&
            widget.enableRefresh &&
            notification.metrics.extentBefore == 0 &&
            normalizedDelta > 0) {
          setState(() {
            _headerExtent = normalizedDelta;
            _scrolling = true;
            _headerStage = TriggerStage.pulling;
          });
        }
        // Start footer pulling
        else if (_footerStage == TriggerStage.idle &&
            widget.enableLoadMore &&
            !_noMoreData &&
            notification.metrics.extentAfter == 0 &&
            normalizedDelta < 0) {
          setState(() {
            _footerExtent = -normalizedDelta;
            _scrolling = true;
            _footerStage = TriggerStage.pulling;
          });
        }
      }
    } else if (notification is UserScrollNotification) {
      _userScrollDirection = notification.direction;
    } else if (notification is OverscrollNotification) {
      final axisDirection = notification.metrics.axisDirection;
      final overscroll = (axisDirection == AxisDirection.down ||
              axisDirection == AxisDirection.right)
          ? -notification.overscroll
          : notification.overscroll;

      // Header overscroll
      if (overscroll > 0 && widget.enableRefresh) {
        if (_headerStage == TriggerStage.idle) {
          setState(() {
            _headerExtent = overscroll;
            _scrolling = true;
            _headerStage = TriggerStage.pulling;
          });
        } else {
          setState(() {
            _headerExtent += overscroll;
          });
        }
      }
      // Footer overscroll
      else if (overscroll < 0 && widget.enableLoadMore && !_noMoreData) {
        if (_footerStage == TriggerStage.idle) {
          setState(() {
            _footerExtent = -overscroll;
            _scrolling = true;
            _footerStage = TriggerStage.pulling;
          });
        } else {
          setState(() {
            _footerExtent += -overscroll;
          });
        }
      }
    }
    return false;
  }

  void _scheduleRefresh([RefreshCallback? callback]) {
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      refresh(callback);
    });
  }

  void _scheduleLoadMore([LoadMoreCallback? callback]) {
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      loadMore(callback);
    });
  }

  Future<void> refresh([RefreshCallback? refreshCallback]) async {
    if (_headerStage == TriggerStage.refreshing) return;

    _scrolling = false;
    final count = ++_refreshFutureCount;
    if (_currentRefreshFuture != null) {
      await _currentRefreshFuture;
    }

    setState(() {
      _currentRefreshFuture = _executeRefresh(refreshCallback);
    });

    return _currentRefreshFuture!.whenComplete(() {
      if (!mounted || count != _refreshFutureCount) return;
    });
  }

  Future<void> _executeRefresh([RefreshCallback? callback]) async {
    if (_headerStage != TriggerStage.refreshing) {
      setState(() {
        _headerStage = TriggerStage.refreshing;
      });
      widget.controller?._updateRefreshStage(_headerStage, true);
    }

    callback ??= widget.onRefresh;
    try {
      await callback?.call();
      _finishRefresh(true);
    } catch (e) {
      _finishRefresh(false);
    }
  }

  void _finishRefresh(bool success) {
    if (!mounted) return;
    setState(() {
      _currentRefreshFuture = null;
      _headerStage = success ? TriggerStage.completed : TriggerStage.failed;
      widget.controller?._updateRefreshStage(_headerStage, false);

      Timer(_completeDuration, () {
        if (!mounted) return;
        setState(() {
          _headerStage = TriggerStage.idle;
          _headerExtent = 0;
          widget.controller?._updateRefreshStage(_headerStage, false);
        });
      });
    });
  }

  Future<void> loadMore([LoadMoreCallback? loadMoreCallback]) async {
    if (_footerStage == TriggerStage.refreshing || _noMoreData) return;

    _scrolling = false;
    final count = ++_loadMoreFutureCount;
    if (_currentLoadMoreFuture != null) {
      await _currentLoadMoreFuture;
    }

    setState(() {
      _currentLoadMoreFuture = _executeLoadMore(loadMoreCallback);
    });

    return _currentLoadMoreFuture!.whenComplete(() {
      if (!mounted || count != _loadMoreFutureCount) return;
    });
  }

  Future<void> _executeLoadMore([LoadMoreCallback? callback]) async {
    if (_footerStage != TriggerStage.refreshing) {
      setState(() {
        _footerStage = TriggerStage.refreshing;
      });
      widget.controller?._updateLoadMoreStage(_footerStage, true);
    }

    callback ??= widget.onLoadMore;
    try {
      await callback?.call();
      _finishLoadMore(true, false);
    } catch (e) {
      _finishLoadMore(false, false);
    }
  }

  void _finishLoadMore(bool success, bool noMoreData) {
    if (!mounted) return;
    setState(() {
      _currentLoadMoreFuture = null;
      _noMoreData = noMoreData;
      _footerStage = success ? TriggerStage.completed : TriggerStage.failed;
      widget.controller?._updateLoadMoreStage(_footerStage, false);

      Timer(_completeDuration, () {
        if (!mounted) return;
        setState(() {
          _footerStage = TriggerStage.idle;
          _footerExtent = 0;
          widget.controller?._updateLoadMoreStage(_footerStage, false);
        });
      });
    });
  }

  Widget _buildHeader(double safeExtent) {
    final animation = AlwaysStoppedAnimation<double>(_headerExtent);
    final tween = _RefreshTriggerTween(_minExtent);
    final stage = RefreshTriggerStage(
      _headerStage,
      tween.animate(animation),
      widget.direction,
      false,
      safeExtent,
      isHeader: true,
    );
    return _headerBuilder(context, stage);
  }

  Widget _buildFooter(double safeExtent) {
    final animation = AlwaysStoppedAnimation<double>(_footerExtent);
    final tween = _RefreshTriggerTween(_minExtent);
    final stage = RefreshTriggerStage(
      _footerStage,
      tween.animate(animation),
      widget.direction,
      true,
      safeExtent,
      isHeader: false,
    );
    return _footerBuilder(context, stage);
  }

  @override
  Widget build(BuildContext context) {
    final headerSafeExtent = _calculateSafeExtent(_headerExtent);
    final footerSafeExtent = _calculateSafeExtent(_footerExtent);

    final headerClampedExtent = (_headerStage == TriggerStage.refreshing ||
            _headerStage == TriggerStage.completed ||
            _headerStage == TriggerStage.failed)
        ? _minExtent
        : headerSafeExtent.clamp(0.0, _maxExtent);

    final footerClampedExtent = (_footerStage == TriggerStage.refreshing ||
            _footerStage == TriggerStage.completed ||
            _footerStage == TriggerStage.failed)
        ? _minExtent
        : footerSafeExtent.clamp(0.0, _maxExtent);

    final scrollBehavior =
        ScrollConfiguration.of(context).copyWith(physics: _physics);

    Widget content = ScrollConfiguration(
      behavior: scrollBehavior,
      child: widget.child,
    );

    // Apply safe area if enabled
    if (_enableSafeArea) {
      content = SafeArea(child: content);
    }

    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: _displayMode == RefreshTriggerDisplayMode.inset
          ? _buildInsetMode(headerClampedExtent, footerClampedExtent, content)
          : _buildOverlayMode(headerSafeExtent, footerSafeExtent, content),
    );
  }

  Widget _buildInsetMode(
    double headerExtent,
    double footerExtent,
    Widget content,
  ) {
    final duration =
        _scrolling ? Duration.zero : const Duration(milliseconds: 250);

    if (widget.direction == Axis.vertical) {
      return Column(
        children: [
          if (widget.enableRefresh)
            AnimatedContainer(
              duration: duration,
              curve: _curve,
              height: headerExtent,
              child: _buildHeader(headerExtent),
            ),
          Expanded(child: content),
          if (widget.enableLoadMore && !_noMoreData)
            AnimatedContainer(
              duration: duration,
              curve: _curve,
              height: footerExtent,
              child: _buildFooter(footerExtent),
            ),
        ],
      );
    } else {
      return Row(
        children: [
          if (widget.enableRefresh)
            AnimatedContainer(
              duration: duration,
              curve: _curve,
              width: headerExtent,
              child: _buildHeader(headerExtent),
            ),
          Expanded(child: content),
          if (widget.enableLoadMore && !_noMoreData)
            AnimatedContainer(
              duration: duration,
              curve: _curve,
              width: footerExtent,
              child: _buildFooter(footerExtent),
            ),
        ],
      );
    }
  }

  Widget _buildOverlayMode(
    double headerExtent,
    double footerExtent,
    Widget content,
  ) {
    return Stack(
      fit: StackFit.passthrough,
      children: [
        content,
        if (widget.enableRefresh)
          _buildOverlayIndicator(
            headerExtent,
            _buildHeader(headerExtent),
            true,
          ),
        if (widget.enableLoadMore && !_noMoreData)
          _buildOverlayIndicator(
            footerExtent,
            _buildFooter(footerExtent),
            false,
          ),
      ],
    );
  }

  Widget _buildOverlayIndicator(
      double extent, Widget indicator, bool isHeader) {
    if (widget.direction == Axis.vertical) {
      return Positioned(
        top: isHeader ? 0 : null,
        bottom: isHeader ? null : 0,
        left: 0,
        right: 0,
        child: ClipRect(
          child: FractionalTranslation(
            translation: Offset(0, isHeader ? -1 : 1),
            child: Transform.translate(
              offset: Offset(0, isHeader ? extent : -extent),
              child: indicator,
            ),
          ),
        ),
      );
    } else {
      return Positioned(
        top: 0,
        bottom: 0,
        left: isHeader ? 0 : null,
        right: isHeader ? null : 0,
        child: ClipRect(
          child: FractionalTranslation(
            translation: Offset(isHeader ? -1 : 1, 0),
            child: Transform.translate(
              offset: Offset(isHeader ? extent : -extent, 0),
              child: indicator,
            ),
          ),
        ),
      );
    }
  }
}

class _RefreshTriggerTween extends Animatable<double> {
  final double minExtent;
  const _RefreshTriggerTween(this.minExtent);
  @override
  double transform(double t) => t / minExtent;
}

/// ===============================
/// DEFAULT INDICATOR
/// ===============================

class DefaultRefreshIndicator extends StatelessWidget {
  final RefreshTriggerStage stage;
  final bool isHeader;

  const DefaultRefreshIndicator({
    super.key,
    required this.stage,
    this.isHeader = true,
  });

  @override
  Widget build(BuildContext context) {
    switch (stage.stage) {
      case TriggerStage.refreshing:
        return const LoadingIndicator(
          type: LoadingIndicatorType.modnLoading,
          size: 50,
        );
      case TriggerStage.completed:
        final progress = stage.extentValue.clamp(0.0, 1.0).toDouble();
        return Opacity(
          opacity: progress,
          child: const LoadingIndicator(
            type: LoadingIndicatorType.modnLoading,
            size: 50,
          ),
        );
      case TriggerStage.pulling:
        final pixels = stage.pixels;
        final opacity = (pixels / 60).clamp(0.2, 1.0).toDouble();
        return Opacity(
          opacity: opacity,
          child: const LoadingIndicator(
            type: LoadingIndicatorType.modnLoading,
            size: 50,
          ),
        );
      case TriggerStage.idle:
        return const SizedBox.shrink();
      case TriggerStage.failed:
        return Text(isHeader ? 'Failed to refresh' : 'Failed to load');
    }
  }
}

/// ===============================
/// CUSTOM PHYSICS
/// ===============================

class RefreshTriggerPhysics extends ScrollPhysics {
  const RefreshTriggerPhysics({super.parent});

  @override
  RefreshTriggerPhysics applyTo(ScrollPhysics? ancestor) {
    return RefreshTriggerPhysics(parent: buildParent(ancestor));
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    // Allow overscroll for refresh trigger
    return offset;
  }
}

/// ===============================
/// COOL HEADER STYLES
/// ===============================

/// Classic Header - iOS style
class ClassicHeader extends StatelessWidget {
  final RefreshTriggerStage stage;
  final Color? color;

  const ClassicHeader({super.key, required this.stage, this.color});

  @override
  Widget build(BuildContext context) {
    final color = this.color ?? Theme.of(context).colorScheme.primary;

    return Center(
      child: AnimatedBuilder(
        animation: stage.extent,
        builder: (context, _) {
          final v = stage.extentValue.clamp(0.0, 1.0);

          if (stage.stage == TriggerStage.refreshing) {
            return SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: color,
              ),
            );
          }

          if (stage.stage == TriggerStage.completed) {
            return Icon(Icons.check_circle, color: color, size: 24);
          }

          return Transform.rotate(
            angle: math.pi * 2 * v,
            child: Icon(Icons.refresh, color: color, size: 24),
          );
        },
      ),
    );
  }
}

/// Material Header - Material Design style
class MaterialHeader extends StatelessWidget {
  final RefreshTriggerStage stage;
  final Color? color;

  const MaterialHeader({super.key, required this.stage, this.color});

  @override
  Widget build(BuildContext context) {
    final color = this.color ?? Theme.of(context).colorScheme.primary;

    return Center(
      child: AnimatedBuilder(
        animation: stage.extent,
        builder: (context, _) {
          final v = stage.extentValue.clamp(0.0, 1.0);

          if (stage.stage == TriggerStage.refreshing) {
            return SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: color,
              ),
            );
          }

          if (stage.stage == TriggerStage.completed) {
            return Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 24),
            );
          }

          return Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Transform.rotate(
                angle: math.pi * 2 * v,
                child: Icon(Icons.arrow_downward, color: color, size: 20),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Bezier Header - Animated curve style
class BezierHeader extends StatelessWidget {
  final RefreshTriggerStage stage;
  final Color? color;

  const BezierHeader({super.key, required this.stage, this.color});

  @override
  Widget build(BuildContext context) {
    final color = this.color ?? Theme.of(context).colorScheme.primary;

    return AnimatedBuilder(
      animation: stage.extent,
      builder: (context, _) {
        final v = stage.extentValue.clamp(0.0, 1.0);

        return CustomPaint(
          painter: BezierPainter(
            progress: v,
            color: color,
            isRefreshing: stage.stage == TriggerStage.refreshing,
          ),
          child: Center(
            child: stage.stage == TriggerStage.refreshing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : stage.stage == TriggerStage.completed
                    ? const Icon(Icons.check, color: Colors.white, size: 24)
                    : null,
          ),
        );
      },
    );
  }
}

class BezierPainter extends CustomPainter {
  final double progress;
  final Color color;
  final bool isRefreshing;

  BezierPainter({
    required this.progress,
    required this.color,
    required this.isRefreshing,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final height = size.height * progress;
    final controlHeight = height * 1.5;

    path.moveTo(0, 0);
    path.lineTo(0, height);
    path.quadraticBezierTo(
      size.width / 2,
      controlHeight,
      size.width,
      height,
    );
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant BezierPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.isRefreshing != isRefreshing;
  }
}

/// Water Drop Header - Liquid style
class WaterDropHeader extends StatelessWidget {
  final RefreshTriggerStage stage;
  final Color? color;

  const WaterDropHeader({super.key, required this.stage, this.color});

  @override
  Widget build(BuildContext context) {
    final color = this.color ?? Theme.of(context).colorScheme.primary;

    return Center(
      child: AnimatedBuilder(
        animation: stage.extent,
        builder: (context, _) {
          final v = stage.extentValue.clamp(0.0, 1.0);
          final size = 20 + (v * 30);

          if (stage.stage == TriggerStage.refreshing) {
            return SizedBox(
              width: size,
              height: size,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: color,
              ),
            );
          }

          if (stage.stage == TriggerStage.completed) {
            return Icon(Icons.check_circle, color: color, size: size);
          }

          return Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1 + (v * 0.2)),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.water_drop,
              color: color,
              size: size * 0.6,
            ),
          );
        },
      ),
    );
  }
}

/// ===============================
/// FOOTER STYLES
/// ===============================

/// Classic Footer
class ClassicFooter extends StatelessWidget {
  final RefreshTriggerStage stage;
  final Color? color;
  final bool noMoreData;

  const ClassicFooter({
    super.key,
    required this.stage,
    this.color,
    this.noMoreData = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = this.color ?? Theme.of(context).colorScheme.primary;

    if (noMoreData) {
      return Center(
        child: Text(
          'No more data',
          style: TextStyle(color: color.withValues(alpha: 0.6)),
        ),
      );
    }

    return Center(
      child: AnimatedBuilder(
        animation: stage.extent,
        builder: (context, _) {
          if (stage.stage == TriggerStage.refreshing) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: color,
                  ),
                ),
                const SizedBox(width: 8),
                Text('Loading...', style: TextStyle(color: color)),
              ],
            );
          }

          if (stage.stage == TriggerStage.completed) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: color, size: 16),
                const SizedBox(width: 8),
                Text('Loaded', style: TextStyle(color: color)),
              ],
            );
          }

          final v = stage.extentValue.clamp(0.0, 1.0);
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Transform.rotate(
                angle: math.pi * v,
                child: Icon(Icons.arrow_upward, color: color, size: 16),
              ),
              const SizedBox(width: 8),
              Text(
                v < 1 ? 'Pull to load more' : 'Release to load',
                style: TextStyle(color: color),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// ===============================
/// USAGE EXAMPLES
/// ===============================
///
/// // Basic Example
/// RefreshTrigger(
///   onRefresh: () async {
///     await Future.delayed(const Duration(seconds: 2));
///   },
///   child: ListView.builder(
///     itemCount: 30,
///     itemBuilder: (_, i) => ListTile(title: Text('Item $i')),
///   ),
/// )
///
/// // With Controller
/// final controller = RefreshTriggerController();
///
/// RefreshTrigger(
///   controller: controller,
///   onRefresh: () async {
///     await Future.delayed(const Duration(seconds: 2));
///   },
///   onLoadMore: () async {
///     await Future.delayed(const Duration(seconds: 2));
///     // controller.finishLoadMore(noMoreData: true);
///   },
///   enableLoadMore: true,
///   child: ListView.builder(
///     itemCount: 30,
///     itemBuilder: (_, i) => ListTile(title: Text('Item $i')),
///   ),
/// )
///
/// // With Custom Headers
/// RefreshTrigger(
///   headerBuilder: (context, stage) => ClassicHeader(stage: stage),
///   footerBuilder: (context, stage) => ClassicFooter(stage: stage),
///   onRefresh: () async {
///     await Future.delayed(const Duration(seconds: 2));
///   },
///   enableLoadMore: true,
///   onLoadMore: () async {
///     await Future.delayed(const Duration(seconds: 2));
///   },
///   child: ListView.builder(
///     itemCount: 30,
///     itemBuilder: (_, i) => ListTile(title: Text('Item $i')),
///   ),
/// )
///
/// // With Theme
/// RefreshTriggerThemeProvider(
///   data: RefreshTriggerTheme(
///     minExtent: 80,
///     maxExtent: 150,
///     curve: Curves.easeOutCubic,
///     headerBuilder: (context, stage) => MaterialHeader(stage: stage),
///     footerBuilder: (context, stage) => ClassicFooter(stage: stage),
///     displayMode: RefreshTriggerDisplayMode.inset,
///     enableSafeArea: true,
///   ),
///   child: RefreshTrigger(
///     onRefresh: () async {
///       await Future.delayed(const Duration(seconds: 2));
///     },
///     enableLoadMore: true,
///     onLoadMore: () async {
///       await Future.delayed(const Duration(seconds: 2));
///     },
///     refreshOnStart: true,
///     child: ListView.builder(
///       physics: const BouncingScrollPhysics(),
///       itemCount: 30,
///       itemBuilder: (_, i) => ListTile(title: Text('Item $i')),
///     ),
///   ),
/// )
///
/// // Programmatic Refresh
/// ElevatedButton(
///   onPressed: () => controller.requestRefresh(),
///   child: const Text('Refresh'),
/// )
///
/// // Listen to Controller
/// controller.addListener(() {
///   print('Refreshing: ${controller.isRefreshing}');
///   print('Loading: ${controller.isLoadingMore}');
/// });
///
