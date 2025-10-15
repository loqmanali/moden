import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

enum CustomDropdownAlignment {
  start,
  center,
  end,
}

// ============================================================================
// Dropdown Manager
// ============================================================================

class _DropdownManager {
  static final _DropdownManager _instance = _DropdownManager._internal();
  factory _DropdownManager() => _instance;
  _DropdownManager._internal();

  final List<VoidCallback> _openDropdowns = [];

  void registerDropdown(VoidCallback closeCallback) {
    // إغلاق جميع القوائم المفتوحة الأخرى
    closeAll();
    _openDropdowns.add(closeCallback);
  }

  void unregisterDropdown(VoidCallback closeCallback) {
    _openDropdowns.remove(closeCallback);
  }

  void closeAll() {
    // نسخ القائمة لتجنب مشاكل التعديل أثناء التكرار
    final dropdowns = List<VoidCallback>.from(_openDropdowns);
    _openDropdowns.clear();
    for (var close in dropdowns) {
      close();
    }
  }
}

/// A custom dropdown menu widget that shows a popup overlay when triggered
///
/// This widget provides a flexible dropdown menu with support for:
/// - Multiple item types (items, labels, separators, checkboxes, radios)
/// - Auto-width matching trigger width
/// - Alignment options (start, center, end)
/// - Smooth animations
/// - Automatic positioning (opens upward if no space below)
/// - Auto-close when clicking outside or opening another dropdown
class CustomDropdownMenu extends HookWidget {
  final Widget trigger;
  final List<CustomDropdownEntry> items;
  final double? width;
  final CustomDropdownAlignment? align;
  final bool autoWidth;
  final String? selectedValue;

  const CustomDropdownMenu({
    super.key,
    required this.trigger,
    required this.items,
    this.width,
    this.align = CustomDropdownAlignment.center,
    this.autoWidth = true,
    this.selectedValue,
  });

  @override
  Widget build(BuildContext context) {
    final isOpen = useState(false);
    final overlayEntry = useRef<OverlayEntry?>(null);
    final layerLink = useMemoized(() => LayerLink());
    final triggerKey = useMemoized(() => GlobalKey());

    void closeMenu() {
      overlayEntry.value?.remove();
      overlayEntry.value = null;
      if (isOpen.value) {
        _DropdownManager().unregisterDropdown(closeMenu);
        isOpen.value = false;
      }
    }

    void openMenu() {
      if (overlayEntry.value != null) return;

      // تسجيل هذه القائمة في المدير (سيغلق القوائم الأخرى تلقائياً)
      _DropdownManager().registerDropdown(closeMenu);

      // Calculate offset based on trigger size and alignment
      final renderBox =
          triggerKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox == null) return;

      final triggerSize = renderBox.size;
      final screenHeight = MediaQuery.of(context).size.height;
      final screenWidth = MediaQuery.of(context).size.width;
      final triggerPosition = renderBox.localToGlobal(Offset.zero);

      // Calculate estimated dropdown height (max 60% of screen)
      final maxDropdownHeight = screenHeight * 0.6;
      final spaceBelow =
          screenHeight - (triggerPosition.dy + triggerSize.height);
      final spaceAbove = triggerPosition.dy;

      // Calculate the actual height of dropdown content
      double estimatedDropdownHeight = items.length * 40.0; // تقدير تقريبي
      if (estimatedDropdownHeight > maxDropdownHeight) {
        estimatedDropdownHeight = maxDropdownHeight;
      }

      // Determine if dropdown should open upward or downward
      bool openUpward = false;
      // إذا كانت المساحة السفلية أقل من ارتفاع المنيو المقدر، افتح لأعلى
      if (spaceBelow < estimatedDropdownHeight) {
        // تحقق إذا كانت المساحة العلوية كافية أو أكبر من السفلية
        if (spaceAbove >= estimatedDropdownHeight || spaceAbove > spaceBelow) {
          openUpward = true;
        }
      }

      double x = 0;
      double y = openUpward ? -8 : triggerSize.height + 8;

      // Handle horizontal alignment
      switch (align!) {
        case CustomDropdownAlignment.start:
          // x remains 0 (left aligned to trigger)
          break;
        case CustomDropdownAlignment.end:
          x = triggerSize.width -
              (autoWidth ? triggerSize.width : (width ?? 224));
          break;
        case CustomDropdownAlignment.center:
          x = (triggerSize.width -
                  (autoWidth ? triggerSize.width : (width ?? 224))) /
              2;
          break;
      }

      // Ensure dropdown stays within screen bounds horizontally
      final dropdownRightEdge = triggerPosition.dx +
          x +
          (autoWidth ? triggerSize.width : (width ?? 224));
      if (dropdownRightEdge > screenWidth - 16) {
        x = screenWidth -
            16 -
            triggerPosition.dx -
            (autoWidth ? triggerSize.width : (width ?? 224));
      }
      if (triggerPosition.dx + x < 16) {
        x = 16 - triggerPosition.dx;
      }

      overlayEntry.value = OverlayEntry(
        builder: (context) => _DropdownOverlayContent(
          link: layerLink,
          offset: Offset(x, y),
          items: items,
          width: width,
          align: align!,
          onClose: closeMenu,
          autoWidth: autoWidth,
          triggerKey: triggerKey,
          selectedValue: selectedValue,
          openUpward: openUpward,
        ),
      );

      Overlay.of(context).insert(overlayEntry.value!);
      isOpen.value = true;
    }

    // Cleanup on dispose
    useEffect(() {
      return () {
        overlayEntry.value?.remove();
        overlayEntry.value = null;
        if (isOpen.value) {
          _DropdownManager().unregisterDropdown(closeMenu);
        }
      };
    }, []);

    return CompositedTransformTarget(
      link: layerLink,
      child: GestureDetector(
        key: triggerKey,
        onTap: isOpen.value ? closeMenu : openMenu,
        child: trigger,
      ),
    );
  }
}

/// Wrapper widget for the overlay content
class _DropdownOverlayContent extends StatelessWidget {
  final LayerLink link;
  final Offset offset;
  final List<CustomDropdownEntry> items;
  final double? width;
  final CustomDropdownAlignment align;
  final VoidCallback onClose;
  final bool autoWidth;
  final GlobalKey triggerKey;
  final String? selectedValue;
  final bool openUpward;

  const _DropdownOverlayContent({
    required this.link,
    required this.offset,
    required this.items,
    this.width,
    required this.align,
    required this.onClose,
    this.autoWidth = false,
    required this.triggerKey,
    this.selectedValue,
    this.openUpward = false,
  });

  @override
  Widget build(BuildContext context) {
    return CompositedTransformFollower(
      link: link,
      showWhenUnlinked: false,
      offset: offset,
      child: _AnimatedDropdownPanel(
        items: items,
        width: width,
        align: align,
        onClose: onClose,
        autoWidth: autoWidth,
        triggerKey: triggerKey,
        selectedValue: selectedValue,
        openUpward: openUpward,
      ),
    );
  }
}

/// Overlay widget that handles the dropdown content with animations
class _AnimatedDropdownPanel extends StatefulWidget {
  final List<CustomDropdownEntry> items;
  final double? width;
  final CustomDropdownAlignment align;
  final VoidCallback onClose;
  final bool autoWidth;
  final GlobalKey triggerKey;
  final String? selectedValue;
  final bool openUpward;

  const _AnimatedDropdownPanel({
    required this.items,
    this.width,
    required this.align,
    required this.onClose,
    this.autoWidth = false,
    required this.triggerKey,
    this.selectedValue,
    this.openUpward = false,
  });

  @override
  State<_AnimatedDropdownPanel> createState() => _AnimatedDropdownPanelState();
}

class _AnimatedDropdownPanelState extends State<_AnimatedDropdownPanel>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late double _cachedEffectiveWidth;

  @override
  void initState() {
    super.initState();

    // Cache the effective width to avoid recalculating during animation
    _cachedEffectiveWidth = _calculateEffectiveWidth();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  double _calculateEffectiveWidth() {
    if (widget.autoWidth) {
      final renderBox =
          widget.triggerKey.currentContext?.findRenderObject() as RenderBox?;
      return renderBox?.size.width ?? widget.width ?? 200;
    }
    return widget.width ?? 224;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Modal barrier that closes dropdown on tap outside
        Positioned.fill(
          child: Listener(
            behavior: HitTestBehavior.opaque,
            onPointerDown: (_) => widget.onClose(),
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
        // Dropdown content
        Positioned(
          left: 0,
          top: 0,
          child: Listener(
            behavior: HitTestBehavior.deferToChild,
            onPointerDown: (_) {}, // امنع الإغلاق عند الضغط على المنيو نفسها
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  alignment: widget.openUpward
                      ? Alignment.bottomCenter
                      : Alignment.topCenter,
                  child: Opacity(
                    opacity: _opacityAnimation.value,
                    child: child,
                  ),
                );
              },
              child: Builder(
                builder: (context) {
                  final isDark =
                      Theme.of(context).brightness == Brightness.dark;
                  return Material(
                    color: isDark ? const Color(0xFF1A2332) : Colors.white,
                    elevation: 0,
                    shadowColor: const Color(0x0D000000),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: isDark
                            ? const Color(0xFF808080).withValues(alpha: 0.3)
                            : const Color(0xFFE2E8F0),
                        width: 1,
                      ),
                    ),
                    child: Container(
                      width: widget.autoWidth ? _cachedEffectiveWidth : null,
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width - 32,
                        maxHeight: MediaQuery.of(context).size.height * 0.6,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: _DropdownItemsList(
                            items: widget.items,
                            autoWidth: widget.autoWidth,
                            openUpward: widget.openUpward,
                            onClose: widget.onClose,
                            selectedValue: widget.selectedValue,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Widget that renders the list of dropdown items
class _DropdownItemsList extends StatelessWidget {
  final List<CustomDropdownEntry> items;
  final bool autoWidth;
  final bool openUpward;
  final VoidCallback onClose;
  final String? selectedValue;

  const _DropdownItemsList({
    required this.items,
    required this.autoWidth,
    required this.openUpward,
    required this.onClose,
    this.selectedValue,
  });

  @override
  Widget build(BuildContext context) {
    final itemWidgets = items
        .map((item) => _DropdownItemRenderer(
              item: item,
              onClose: onClose,
              selectedValue: selectedValue,
            ))
        .toList();

    final content = autoWidth
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: itemWidgets,
          )
        : IntrinsicWidth(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: itemWidgets,
            ),
          );

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        // امنع انتشار إشعارات التمرير للخارج
        return true;
      },
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        reverse: openUpward,
        child: content,
      ),
    );
  }
}

/// Widget that renders individual dropdown items based on their type
class _DropdownItemRenderer extends StatelessWidget {
  final CustomDropdownEntry item;
  final VoidCallback onClose;
  final String? selectedValue;

  const _DropdownItemRenderer({
    required this.item,
    required this.onClose,
    this.selectedValue,
  });

  @override
  Widget build(BuildContext context) {
    if (item is CustomDropdownLabel) {
      return _buildLabel(item as CustomDropdownLabel);
    }

    if (item is CustomDropdownSeparator) {
      return _buildSeparator();
    }

    if (item is CustomDropdownItem) {
      return _buildItem(item as CustomDropdownItem);
    }

    if (item is CustomDropdownCheckbox) {
      return _buildCheckbox(item as CustomDropdownCheckbox);
    }

    if (item is CustomDropdownRadio) {
      return _buildRadio(item as CustomDropdownRadio);
    }

    return const SizedBox.shrink();
  }

  Widget _buildLabel(CustomDropdownLabel label) {
    return Builder(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
          child: Text(
            label.text,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? const Color(0xFFFFFFFF) : const Color(0xFF0F172A),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSeparator() {
    return Builder(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          height: 1,
          margin: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF808080).withValues(alpha: 0.3)
                : const Color(0xFFE2E8F0),
          ),
        );
      },
    );
  }

  Widget _buildItem(CustomDropdownItem item) {
    final isSelected = item.value != null && item.value == selectedValue;

    return Builder(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return InkWell(
          onTap: item.disabled
              ? null
              : () {
                  onClose();
                  item.onTap?.call();
                },
          borderRadius: BorderRadius.circular(4),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: isSelected
                  ? (isDark
                      ? const Color(0xFF1E90FF).withValues(alpha: 0.2)
                      : const Color(0xFFF1F5F9))
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                if (item.icon != null) ...[
                  Icon(
                    item.icon,
                    size: 16,
                    color: item.disabled
                        ? (isDark
                            ? const Color(0xFF808080)
                            : const Color(0xFF94A3B8))
                        : (isDark
                            ? const Color(0xFFB0B0B0)
                            : const Color(0xFF64748B)),
                  ),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Text(
                    item.text,
                    style: TextStyle(
                      fontSize: 14,
                      color: item.disabled
                          ? (isDark
                              ? const Color(0xFF808080)
                              : const Color(0xFF94A3B8))
                          : (isDark
                              ? const Color(0xFFFFFFFF)
                              : const Color(0xFF0F172A)),
                      fontWeight:
                          isSelected ? FontWeight.w500 : FontWeight.w400,
                    ),
                  ),
                ),
                if (isSelected) ...[
                  const SizedBox(width: 8),
                  Icon(
                    Icons.check,
                    size: 16,
                    color: isDark
                        ? const Color(0xFF1E90FF)
                        : const Color(0xFF3B82F6),
                  ),
                ],
                if (item.shortcut != null && !isSelected) ...[
                  const SizedBox(width: 12),
                  Text(
                    item.shortcut!,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? const Color(0xFF808080)
                          : const Color(0xFF64748B),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCheckbox(CustomDropdownCheckbox item) {
    return InkWell(
      onTap: item.disabled
          ? null
          : () {
              item.onChanged?.call(!item.checked);
            },
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Row(
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: Checkbox(
                value: item.checked,
                onChanged: item.disabled ? null : item.onChanged,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                item.text,
                style: TextStyle(
                  fontSize: 14,
                  color: item.disabled
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF0F172A),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadio(CustomDropdownRadio item) {
    return InkWell(
      onTap: item.disabled
          ? null
          : () {
              item.onChanged?.call(item.value);
            },
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Row(
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: Radio<String>(
                value: item.value,
                groupValue: item.groupValue,
                onChanged: item.disabled
                    ? null
                    : (value) => item.onChanged?.call(value!),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                item.text,
                style: TextStyle(
                  fontSize: 14,
                  color: item.disabled
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF0F172A),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// Data Classes for Dropdown Items
// ============================================================================

/// Base class for all dropdown menu entries
abstract class CustomDropdownEntry {}

/// A clickable menu item with text, optional icon, and callback
class CustomDropdownItem extends CustomDropdownEntry {
  final String text;
  final String? value;
  final IconData? icon;
  final String? shortcut;
  final VoidCallback? onTap;
  final bool disabled;

  CustomDropdownItem({
    required this.text,
    this.value,
    this.icon,
    this.shortcut,
    this.onTap,
    this.disabled = false,
  });
}

/// A section header label for grouping menu items
class CustomDropdownLabel extends CustomDropdownEntry {
  final String text;

  CustomDropdownLabel({required this.text});
}

/// A visual separator (horizontal line) between menu items
class CustomDropdownSeparator extends CustomDropdownEntry {}

/// A menu item with a checkbox for toggleable options
class CustomDropdownCheckbox extends CustomDropdownEntry {
  final String text;
  final bool checked;
  final ValueChanged<bool?>? onChanged;
  final bool disabled;

  CustomDropdownCheckbox({
    required this.text,
    required this.checked,
    this.onChanged,
    this.disabled = false,
  });
}

/// A menu item with a radio button for single-select options
class CustomDropdownRadio extends CustomDropdownEntry {
  final String text;
  final String value;
  final String? groupValue;
  final ValueChanged<String>? onChanged;
  final bool disabled;

  CustomDropdownRadio({
    required this.text,
    required this.value,
    this.groupValue,
    this.onChanged,
    this.disabled = false,
  });
}
