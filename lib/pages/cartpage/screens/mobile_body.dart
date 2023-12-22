import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../supabase/supabase.dart';
import '../../checkoutpage/checkout.dart';

class MobileScreen extends StatefulWidget {
  const MobileScreen({Key? key}) : super(key: key);

  @override
  State<MobileScreen> createState() => _MobileScreenState();
}

class _MobileScreenState extends State<MobileScreen> {
  late Future _cartData;
  late List<bool> isCheckedList;
  late List<int> quantityList;
  late List<CheckedCartItem> checkedItems;
  late List checkoutItems;

  @override
  void initState() {
    super.initState();
    _cartData = _initialCart();
    isCheckedList = [];
    quantityList = [];
    _cartData.then((data) {
      checkedItems = List.generate(
          data.length,
          (index) => CheckedCartItem(
              item: data[index], isChecked: false, quantity: 1));
    });
    checkoutItems = [];
  }

  List<CheckedCartItem> getCheckedItems() {
    List<CheckedCartItem> result = [];
    checkoutItems = [];

    for (int i = 0; i < checkedItems.length; i++) {
      if (checkedItems[i].isChecked) {
        CheckedCartItem checkedItem = CheckedCartItem(
          item: checkedItems[i].item,
          isChecked: true,
          quantity: quantityList[i],
        );

        result.add(checkedItem);
      }
    }

    for (CheckedCartItem item in result) {
      // print('isChecked: ${item.isChecked}, Quantity: ${item.quantity}');
      print(item.item);
      checkoutItems.add(item.item);
    }

    return result;
  }

  Future _initialCart() async {
    final data = await supabase.from('cart').select('*, product(*)').execute();

    final Map aggregatedData = {};

    for (var item in data.data as List) {
      final productId = item['product_id'] as int;

      if (aggregatedData.containsKey(productId)) {
        aggregatedData[productId]!['quantity'] += item['quantity'] as int;
      } else {
        aggregatedData[productId] = item;
      }
    }

    final aggregatedList = aggregatedData.values.toList();

    isCheckedList = List.generate(aggregatedList.length, (index) => false);
    quantityList = List.generate(
      aggregatedList.length,
      (index) => aggregatedList[index]['quantity'] as int,
    );

    return aggregatedList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: FutureBuilder(
          future: _cartData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No data available.'));
            } else {
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final item = snapshot.data![index];
                        final product = item['product'];

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.all(4),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Checkbox(
                                    value: checkedItems[index].isChecked,
                                    onChanged: (value) {
                                      setState(() {
                                        checkedItems[index].isChecked =
                                            value ?? false;
                                      });
                                      print(
                                          'Value Change : ${getCheckedItems()}');
                                    },
                                  ),
                                  Container(
                                    child: Image.network(
                                      'https://midlsoyjkxifqakotayb.supabase.co/storage/v1/object/public/data${product['thumbnail']}',
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Flexible(
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4),
                                            child: Text(product['product_name'],
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                )),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4),
                                            child: Text(product['description']),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4),
                                            child: Text(
                                                'Stock Available : ${product['stock']}'),
                                          ),
                                          Row(
                                            children: [
                                              IconButton(
                                                icon: Icon(Icons.remove),
                                                onPressed: () {
                                                  if (quantityList[index] > 1) {
                                                    setState(() {
                                                      quantityList[index]--;
                                                    });
                                                  }
                                                },
                                              ),
                                              Container(
                                                width: 20,
                                                child: Center(
                                                    child: Text(
                                                        '${quantityList[index]}')),
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.add),
                                                onPressed: () {
                                                  setState(() {
                                                    if (quantityList[index] <
                                                        product['stock']) {
                                                      quantityList[index]++;
                                                    } else {
                                                      // Optionally, you can show a message or handle the case
                                                      // where the maximum stock is reached.
                                                      // For now, I'm just printing a message to the console.
                                                      print(
                                                          'Maximum stock reached for ${product['product_name']}');
                                                    }
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .center, // Align children vertically centered
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          '\$${product['price']}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CheckoutButton(
                      onPressed: () {
                        Navigator.of(context).push(_createRoute(checkoutItems));
                      },
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

class CheckedCartItem {
  final Map item;
  bool isChecked;
  int quantity;

  CheckedCartItem(
      {required this.item, this.isChecked = false, this.quantity = 1});
}

class CheckoutButton extends StatelessWidget {
  final VoidCallback onPressed;

  CheckoutButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        primary: Colors.orange,
        minimumSize: Size(double.infinity, 0), // Set minimumSize for full width
      ),
      child: Container(
        padding: const EdgeInsets.all(4),
        child: Text(
          'Checkout',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

Route _createRoute(List cartItem) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        Checkout(checkoutItems: cartItem),
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
