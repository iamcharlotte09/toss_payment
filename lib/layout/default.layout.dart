import 'package:commerce_app/const/colors.dart';
import 'package:flutter/material.dart';

class DefaultLayout extends StatelessWidget {
  final FloatingActionButton? fab;
  final Widget child;
  final AppBar? appBar;

  const DefaultLayout({this.fab, required this.child, this.appBar, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: appBar,
      body: child,
      floatingActionButton: fab,
    );
  }
}
