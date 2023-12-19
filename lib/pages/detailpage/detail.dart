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
  late Future _future;
  void initState() {
    _future = Supabase.instance.client
        .from('product')
        .select('*, productVariation(*)')
        .eq('product_id', widget.id);
  }

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
              } else {
                return buildProductDetails(snapshot.data);
              }
            },
          );
        }
      },
    );
  }

  Widget buildProductDetails(product) {
    final item = product[0];
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
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/star-solid.svg',
                    color: Colors.orange,
                    width: 14,
                    height: 14,
                  ),
                ],
              ),
            ),
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
                      Text(
                        'Colors',
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
                      SizedBox(height: 4),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: productVariations
                            .map<Widget>((variation) =>
                                _buildColorIndicator(variation['color']))
                            .toList(),
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
                      '\$0.00',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Product Added to Cart'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
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

  Widget _buildColorIndicator(color) {
    if (color == '') {
      return Text('');
    }
    Color getColorByName(String colorName) {
      switch (colorName.toLowerCase()) {
        case 'black':
          return Colors.black;
        case 'red':
          return Colors.red;
        case 'gray':
          return Colors.grey;
        case 'green':
          return Colors.green;
        case 'blue':
          return Colors.blue;
        case 'orange':
          return Colors.orange;
        default:
          return Colors
              .black; // Default to black if the color name is not recognized
      }
    }

    print('EACH COLOR $color');

    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: getColorByName(color),
      ),
    );
  }
}
