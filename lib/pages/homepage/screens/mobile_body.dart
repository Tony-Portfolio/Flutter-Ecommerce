import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../supabase/supabase.dart';
import '../../../pages/detailpage/detail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MobileScreen extends StatefulWidget {
  MobileScreen({Key? key}) : super(key: key) {
    initializeSupabase();
  }

  @override
  State<MobileScreen> createState() => _MobileScreenState();
}

class _MobileScreenState extends State<MobileScreen> {
  final _future =
      Supabase.instance.client.from('product').select('*, productVariation(*)');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
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
      ),
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
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            // Text('Brand : ${item["brand"]}',
            //     style: TextStyle(fontWeight: FontWeight.w600)),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text(item['description'],
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment
                  .center, // Align children vertically centered
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '\$${item['price']}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
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
