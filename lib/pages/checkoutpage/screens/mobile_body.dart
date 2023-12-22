import 'package:flutter/material.dart';
import '../../../supabase/supabase.dart';
import '../../index.dart';

class MobileScreen extends StatefulWidget {
  final List checkoutItems;

  const MobileScreen({Key? key, required this.checkoutItems}) : super(key: key);

  @override
  State<MobileScreen> createState() => _MobileScreenState();
}

class _MobileScreenState extends State<MobileScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  late String email;
  late String phoneNumber;
  late String firstName;
  late String lastName;
  late String address;
  late List checkoutData;

  List extractIds(List checkoutItems) {
    List<int> ids = [];

    for (var item in checkoutItems) {
      if (item.containsKey('id')) {
        int id = item['id'] as int;

        ids.add(id);
      }
    }

    print('ID : $ids');

    return ids;
  }

  void checkout() async {
    email = emailController.text;
    phoneNumber = phoneNumberController.text;
    firstName = firstNameController.text;
    lastName = lastNameController.text;
    address = addressController.text;
    checkoutData = widget.checkoutItems;

    List extractedIds = extractIds(widget.checkoutItems);

    final rpc = await supabase.rpc('delete_cart_items', params: {
      'cart_ids': extractedIds,
      'email_value': 'xxdjtonygo@gmail.com',
    });

    String fullName = firstName + " " + lastName;

    final response = await supabase.from('checkout').insert({
      'product': checkoutData,
      'email': email,
      'name': fullName,
      'address': address,
      'phonenumber': phoneNumber
    });

    print('RESPONSE : $response');
    Navigator.of(context).pop(MobileScreen(checkoutItems: checkoutData));
    Navigator.of(context).push(_createRoute());
    if (response.error != null) {
      // If there is an error, handle it
      print('Error during checkout: ${response.error!.message}');
    } else {
      // If the upsert was successful, print the result
      print('Checkout successful. Result: ${response.data}');
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Checkout Items: ${widget.checkoutItems}');
    String initialEmail =
        widget.checkoutItems.isNotEmpty ? widget.checkoutItems[0]['email'] : '';
    emailController.text = initialEmail;
    return Scaffold(
      body: Column(
        children: [
          // Display checkoutItems list
          Expanded(
            child: ListView.builder(
              itemCount: widget.checkoutItems.length,
              itemBuilder: (context, index) {
                final item = widget.checkoutItems[index];
                // Customize how you want to display each checkout item
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(4),
                      child: Row(
                        children: [
                          Container(
                            child: Image.network(
                              'https://midlsoyjkxifqakotayb.supabase.co/storage/v1/object/public/data${item['product']['thumbnail']}',
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Flexible(
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['product']['product_name'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(item['product']['description']),
                                  Text('Quantity : ${item['quantity']}'),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  '\$${item['product']['price']}',
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
          // User input form
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: emailController,
                  style: TextStyle(fontSize: 12),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 2.0,
                      ),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 2, horizontal: 12),
                  ),
                ),
                SizedBox(height: 4),
                TextField(
                  controller: phoneNumberController,
                  style: TextStyle(fontSize: 12),
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 2.0,
                      ),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 2, horizontal: 12),
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: TextField(
                          controller: firstNameController,
                          style: TextStyle(fontSize: 12),
                          decoration: InputDecoration(
                            labelText: 'First Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 2.0,
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 2, horizontal: 12),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: TextField(
                          controller: lastNameController,
                          style: TextStyle(fontSize: 12),
                          decoration: InputDecoration(
                            labelText: 'Last Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 2.0,
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 2, horizontal: 12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                TextField(
                  controller: addressController,
                  style: TextStyle(fontSize: 12),
                  decoration: InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 2.0,
                      ),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 2, horizontal: 12),
                  ),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    checkout();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Checkout', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const Index(),
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
