import 'package:flutter/material.dart';
import '../../dimensions.dart';
import './screens/mobile_body.dart';
import './screens/desktop_body.dart';
import '../../supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Detail extends StatefulWidget {
  final int id;
  Detail({Key? key, required this.id}) : super(key: key) {
    initializeSupabase();
  }

  final Widget mobileScreen = const MobileScreen();
  final Widget desktopScreen = const DesktopScreen();

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > mobileWidth) {
          return widget.mobileScreen;
        } else if (constraints.maxWidth > desktopWidth) {
          return widget.desktopScreen;
        } else {
          return Text('no screen exist');
        }
      },
    );
  }
}
