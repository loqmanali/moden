import 'package:flutter/material.dart';

class BodyWidget extends StatelessWidget {
  const BodyWidget({
    super.key,
    required this.child,
    this.backgroundColor,
  });

  final Widget child;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Transform.translate(
        offset: const Offset(0, -20),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child: Container(
            key: const ValueKey('12:352'),
            width: double.infinity,
            color: backgroundColor ?? Colors.white,
            child: SafeArea(
              top: false, // we already offset with Positioned
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
