import 'package:flutter/material.dart';
import '../../../supabase/supabase.dart';

class MobileScreen extends StatefulWidget {
  const MobileScreen({Key? key}) : super(key: key);

  @override
  State<MobileScreen> createState() => _MobileScreenState();
}

class _MobileScreenState extends State<MobileScreen> {
  late Future _cartData;
  late List<bool> isCheckedList;
  late List<int> quantityList;

  @override
  void initState() {
    super.initState();
    _cartData = _initialCart();
    isCheckedList = [];
    quantityList = [];
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
              return ListView.builder(
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
                              value: isCheckedList[index],
                              onChanged: (value) {
                                setState(() {
                                  isCheckedList[index] = value ?? false;
                                });
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                        Text('${quantityList[index]}'),
                                        IconButton(
                                          icon: Icon(Icons.add),
                                          onPressed: () {
                                            setState(() {
                                              quantityList[index]++;
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
                              child: Text('\$${product['price']}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
