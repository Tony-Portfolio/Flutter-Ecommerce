import 'package:flutter/material.dart';
import '../../dimensions.dart';
import './screens/mobile_body.dart';
import './screens/desktop_body.dart';
import '../../supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../detailpage/detail.dart';

class Home extends StatefulWidget {
  Home({
    Key? key,
  }) : super(key: key);

  final Widget mobileScreen = MobileScreen();
  final Widget desktopScreen = const DesktopScreen();

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > mobileWidth) {
          return widget.mobileScreen;
        } else if (constraints.maxWidth > desktopWidth) {
          return widget.desktopScreen;
        } else
          return Text('no screen available');
      },
    );
  }
}
