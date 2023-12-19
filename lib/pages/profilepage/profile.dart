import 'package:flutter/material.dart';
import '../../dimensions.dart';
import './screens/mobile_body.dart';
import './screens/desktop_body.dart';
import '../../supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../detailpage/detail.dart';

class Profile extends StatefulWidget {
  Profile({
    Key? key,
  }) : super(key: key) {
    initializeSupabase();
  }

  final Widget mobileScreen = const MobileScreen();
  final Widget desktopScreen = const DesktopScreen();

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _future =
      Supabase.instance.client.from('product').select('*, productVariation(*)');

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > mobileWidth) {
          return widget.mobileScreen;
        } else if (constraints.maxWidth > desktopWidth) {
          return widget.desktopScreen;
        } else {
          return Text('Over');
        }
      },
    );
  }
}

Route _createRoute(int id) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => Detail(id: id),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
