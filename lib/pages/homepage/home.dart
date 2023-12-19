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
  }) : super(key: key) {
    initializeSupabase();
  }

  final Widget mobileScreen = const MobileScreen();
  final Widget desktopScreen = const DesktopScreen();

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _future =
      Supabase.instance.client.from('product').select('*, productVariation(*)');

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth == mobileWidth) {
          return widget.mobileScreen;
        } else if (constraints.maxWidth > desktopWidth) {
          return widget.desktopScreen;
        } else {
          return FutureBuilder(
            future: _future,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final product = snapshot.data!;
              print('runn $product');

              return SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(4),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.0,
                      mainAxisExtent: 300,
                      mainAxisSpacing: 16.0,
                    ),
                    itemCount: product.length,
                    itemBuilder: (context, index) {
                      return buildProductItem(product[index]);
                    },
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  Widget buildProductItem(Map<String, dynamic> item) {
    final brand = item['brand'];
    final thumbnail = item['thumbnail'];
    final productVariations = item['productVariation'] as List<dynamic>;

    final colors =
        productVariations.map((variation) => variation['color']).toList();

    return Container(
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(_createRoute(item['product_id']));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              'https://midlsoyjkxifqakotayb.supabase.co/storage/v1/object/public/data$thumbnail',
              height: 160,
              width: 160,
              fit: BoxFit.contain,
            ),
            Text(item['product_name'],
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            // Text('Brand : ${item["brand"]}',
            //     style: TextStyle(fontWeight: FontWeight.w600)),
            Text(item['description'],
                style: TextStyle(fontWeight: FontWeight.w600))
          ],
        ),
      ),
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
