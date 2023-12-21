import 'package:flutter/material.dart';
import '../../../supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MobileScreen extends StatefulWidget {
  const MobileScreen({Key? key}) : super(key: key);

  @override
  State<MobileScreen> createState() => _MobileScreenState();
}

class _MobileScreenState extends State<MobileScreen> {
  late Future _future;
  void initState() {
    _future = Supabase.instance.client
        .from('product')
        .select('*, productVariation(*)')
        .eq('product_id', 2);
  }

  Future<void> increment(int productId, int quantityToAdd) async {
    print('ID: $productId QTY: $quantityToAdd');

    try {
      final insertResponse = await supabase.from('cart').insert({
        'product_id': productId,
        'quantity': quantityToAdd,
        'email': 'xxdjtonygo@gmail.com'
      });

      print('uh ? $insertResponse');
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return buildProductDetails(snapshot.data);
          }
        },
      ),
    );
  }

  Widget buildProductDetails(product) {
    final item = product[0];
    final int id = item["product_id"];
    final authSession = supabase.auth.currentSession;
    if (authSession != null && authSession.user != null) {
      final userId = authSession.user!.id;
      print('ID NYA : $userId');
    }
    List<Map<String, dynamic>> productVariations =
        List<Map<String, dynamic>>.from(item['productVariation']);

    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 6 / 4,
              child: Image.network(
                'https://midlsoyjkxifqakotayb.supabase.co/storage/v1/object/public/data${item["thumbnail"]}',
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 16),
            Text(
              item['product_name'].toString(),
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
            ),
            Text(
              '\$${item['price'].toString()}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            // Container(
            //   margin: const EdgeInsets.only(bottom: 6),
            //   child: Row(
            //     children: [
            //       SvgPicture.asset(
            //         'assets/star-solid.svg',
            //         color: Colors.orange,
            //         width: 14,
            //         height: 14,
            //       ),
            //     ],
            //   ),
            // ),
            Divider(
              color: Color(0xffe3e3e3),
              thickness: 2,
            ),
            Text(
              'Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Condition',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'Brand',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'Category',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'New',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        item['brand'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'dummy',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(
              color: Color(0xffe3e3e3),
              thickness: 2,
            ),
            SizedBox(height: 8),
            Text(
              item['description'],
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 25),
        width: MediaQuery.of(context).size.width,
        height: 90,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total Price",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      // "\$" + numFormat.format((product.price * 10).toInt()),
                      '\$${item["price"]}',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () async {
                    increment(id, 1);
                  },
                  highlightColor: Colors.white,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(50)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(right: 4),
                          child: Icon(
                            Icons.shopping_bag_outlined,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Add to cart",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
