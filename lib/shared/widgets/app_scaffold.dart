import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.header,
    required this.body,
    this.backgroundColor,
  });

  final Header header;
  final Body body;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          header.build(context),
          body.build(context),
        ],
      ),
    );
  }
}

abstract class Header {
  const Header({Key? key});
  Widget build(BuildContext context);
}

abstract class Body {
  const Body({Key? key});
  Widget build(BuildContext context);
}
