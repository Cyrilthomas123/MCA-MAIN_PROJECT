import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main.dart';
import 'enquiry_list_page.dart';
import 'booklist.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InteriorDesignPage extends StatefulWidget {
  final String? loggedInUsername;

  const InteriorDesignPage({Key? key, required this.loggedInUsername})
      : super(key: key);

  @override
  createState() => _InteriorDesignPageState();
}

class _InteriorDesignPageState extends State<InteriorDesignPage> {
  int? enquiry_id;

  // Function to navigate to enquiry details page
  Future<void> _navigateToEnquiryDetails(
      BuildContext context, String username) async {
    final url =
        Uri.parse('http://192.168.193.197:3000/api/enquiry_details/$username');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        print(responseData);

        // Extracting enquiry IDs directly from the response data
        final List<int> enquiryIds = responseData
            .map((row) => row[0]
                as int) // Access the first (and only) element of each row
            .toList();

        // Proceed with using the extracted enquiry IDs
        if (enquiryIds.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EnquiryListPage(enquiryIds: enquiryIds),
            ),
          );
        } else {
          print('No enquiry IDs found for the user');
        }
      } else {
        print(
            'Failed to fetch enquiry details. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching enquiry details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Interior Designing Products'),
      ),
      body: ProductList(
        onEnquiryIdChanged: (id) {
          setState(() {
            enquiry_id = id;
          });
        },
        loggedInUsername: widget.loggedInUsername,
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Book List',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          onTap: (int index) {
            if (index == 2) {
              // Handle Profile tab tap
              showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.logout),
                          title: Text('Logout'),
                          onTap: () {
                            // Pass context to _logout method
                            _logout(context);
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.info),
                          title: Text('Enquiry Details'),
                          onTap: () async {
                            Navigator.pop(
                                context); // Close the bottom modal sheet
                            // Fetch enquiry details
                            await _navigateToEnquiryDetails(
                                context, widget.loggedInUsername!);
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            }
            if (index == 1) {
              print('enq is $enquiry_id');
              if (enquiry_id != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookListPage(
                      loggedInUsername: widget.loggedInUsername!,
                      enquiry_Id: enquiry_id!,
                    ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('No Products Booked Yet'),
                  ),
                );
                print('No products booked yet');
              }
            }
          }),
    );
  }

  void _logout(BuildContext? context) async {
    if (context == null) {
      print('Context is null. Unable to perform logout.');
      return;
    }

    try {
      // Call the logout endpoint to clear session data
      final response =
          await http.post(Uri.parse('http://192.168.193.197:3000/api/logout'));

      if (response.statusCode == 200) {
        // Clear the enquiry_id from local storage using shared_preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove('enquiry_id');
        print('logout successful');

        // Perform logout action
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Homescreen()),
        );
      } else {
        // Handle error response
        print('Failed to logout. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network or other errors
      print('Error during logout: $e');
    }
  }
}

class ProductList extends StatelessWidget {
  final String? loggedInUsername;
  final void Function(int?) onEnquiryIdChanged;

  ProductList({
    required this.loggedInUsername,
    required this.onEnquiryIdChanged,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ProductItem(
            product: product,
            onEnquiryIdChanged: onEnquiryIdChanged,
            loggedInUsername: loggedInUsername,
          );
        },
      ),
    );
  }
}

class ProductItem extends StatefulWidget {
  final Product product;
  final String? loggedInUsername;
  final void Function(int?) onEnquiryIdChanged;

  const ProductItem({
    Key? key,
    required this.product,
    required this.onEnquiryIdChanged,
    required this.loggedInUsername,
  }) : super(key: key);

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  String? selectedLength;
  String? selectedWidth;
  String? selectedHeight;
  String? selectedQuantity;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Image.asset(
              widget.product.imagePath,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '\₹${widget.product.price.toString()}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 8),
                if (widget.product.isCustomizable)
                  Column(
                    children: [
                      Row(
                        children: [
                          DropdownButton<String>(
                            hint: Text('Length in foot'),
                            value: selectedLength,
                            onChanged: (value) {
                              setState(() {
                                selectedLength = value;
                              });
                            },
                            items: ['10', '11', '12']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                          SizedBox(width: 8),
                          DropdownButton<String>(
                            hint: Text('Width in foot'),
                            value: selectedWidth,
                            onChanged: (value) {
                              setState(() {
                                selectedWidth = value;
                              });
                            },
                            items: ['10', '11', '12']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                          SizedBox(width: 8),
                          DropdownButton<String>(
                            hint: Text('Height in foot'),
                            value: selectedHeight,
                            onChanged: (value) {
                              setState(() {
                                selectedHeight = value;
                              });
                            },
                            items: ['10', '11', '12']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ],
                  ),
                SizedBox(height: 8),
                DropdownButton<String>(
                  hint: Text('Quantity'),
                  value: selectedQuantity,
                  onChanged: (value) {
                    setState(() {
                      selectedQuantity = value;
                    });
                  },
                  items: ['1', '2', '3', '4', '5']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () async {
                    if (widget.loggedInUsername != null) {
                      int? enquiryId = await _bookProduct(
                        widget.product,
                        widget.loggedInUsername!,
                        context,
                        selectedLength: selectedLength,
                        selectedWidth: selectedWidth,
                        selectedHeight: selectedHeight,
                        selectedQuantity: selectedQuantity,
                      );
                      if (enquiryId != null) {
                        // Update enquiryId in InteriorDesignPage
                        widget.onEnquiryIdChanged(enquiryId);
                        // Show a snackbar indicating successful booking
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Product booked successfully'),
                          ),
                        );
                      }
                    } else {
                      print('Handle case where required fields are null');
                    }
                  },
                  child: Text('Book'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Future<int?> _bookProduct(
    Product product, String loggedInUsername, BuildContext context,
    {String? selectedLength,
    String? selectedWidth,
    String? selectedHeight,
    String? selectedQuantity}) async {
  final url = Uri.parse('http://192.168.193.197:3000/api/enquiry');

  // Construct the request body JSON object
  final Map<String, dynamic> requestBody = {
    'productid': product.id,
    'username': loggedInUsername,
    'productname': product.name,
    'unit_price': product.price,
  };

  // Add length, width, and height only if the product is customizable
  if (product.isCustomizable) {
    requestBody['len'] = selectedLength ?? '10';
    requestBody['width'] = selectedWidth ?? '10';
    requestBody['height'] = selectedHeight ?? '10';
  }

  // Always include quantity
  requestBody['quantity'] = selectedQuantity ?? '1';

  try {
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(requestBody),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final int? enquiryId = responseData['enquiry_id'];
      print('Product booked successfully');
      print('Enquiry ID: $enquiryId');
      return enquiryId;
    } else {
      print('Failed to book product. Status code: ${response.statusCode}');
      if (response.statusCode == 500) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Product already added to booklist'),
          ),
        );
        print('Response body: ${response.body}');
      }
      return null;
    }
  } catch (e) {
    print('Error booking product: $e');
    return null;
  }
}

class Product {
  final int id;
  final String name;
  final double price;
  final String imagePath;
  final bool isCustomizable;

  Product(this.id, this.name, this.price, this.imagePath,
      {this.isCustomizable = false});
}

final List<Product> products = [
  Product(1, 'Sofa Set', 1200, 'assets/images/sofaset.jpg',
      isCustomizable: true),
  Product(2, 'Coffee Table', 600, 'assets/images/coffeetable.jpg',
      isCustomizable: true),
  Product(3, 'Wall Mirror', 700, 'assets/images/wallmirror.jpeg',
      isCustomizable: false),
  Product(4, 'Floor Lamp', 800, 'assets/images/floorlamp.jpg',
      isCustomizable: false),
];
