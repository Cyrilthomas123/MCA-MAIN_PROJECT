import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:quickalert/quickalert.dart';

class EnquiryDetailsPage extends StatefulWidget {
  final int enquiryId;

  const EnquiryDetailsPage({required this.enquiryId});

  @override
  _EnquiryDetailsPageState createState() => _EnquiryDetailsPageState();
}

class _EnquiryDetailsPageState extends State<EnquiryDetailsPage> {
  List<Product> products = [];
  double? estimateAmount;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      print('Fetching products for enquiry ID: ${widget.enquiryId}');
      final response = await http.get(Uri.parse(
          'http://192.168.193.197:3000/api/products/${widget.enquiryId}'));

      print('API response status code: ${response.statusCode}');
      print('API response body: ${response.body}');

      if (response.statusCode == 200) {
        print(response);
        print('API call successful. Processing response...');

        final dynamic decodedResponse = json.decode(response.body);
        print('Type of decoded data: ${decodedResponse.runtimeType}');

        if (decodedResponse is List) {
          final List<dynamic> responseData = decodedResponse;

          setState(() {
            products =
                responseData.map((data) => Product.fromJson(data)).toList();
          });

          print('Products fetched successfully: $products');
        } else {
          throw Exception('Invalid response format: $decodedResponse');
        }
      } else {
        print('API call failed: ${response.statusCode}');
        throw Exception('Failed to fetch products');
      }
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  void viewEstimate() async {
    final String apiUrl =
        'http://192.168.193.197:3000/api/getEstimateAmount/${widget.enquiryId}';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        setState(() {
          estimateAmount = responseData['estimate_amount']?.toDouble();
        });

        if (estimateAmount == null) {
          // Show alert if estimate amount is not available
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Not Available'),
                icon: Icon(
                  Icons.error,
                  color: Colors.red,
                  size: 50,
                ),
                content: Text(
                  'Comeback Later',
                  textAlign: TextAlign.center,
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      } else {
        throw Exception('Failed to fetch estimate amount');
      }
    } catch (error) {
      print('Error fetching estimate amount: $error');
      // Show error message to the user
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              children: [
                Icon(
                  Icons.error,
                  color: Colors.red,
                ),
                SizedBox(width: 8),
                Text(
                  'Error',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: Text(
              'Failed to fetch estimate amount. Please try again later.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'OK',
                  style: TextStyle(
                    color: Color(0xDE9CD2FF), // Change text color
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  void cancelAction(BuildContext) async {
    final String apiUrlFooter =
        'http://192.168.193.197:3000/api/deleteEstimateFooter/${widget.enquiryId}';
    final String apiUrlHeader =
        'http://192.168.193.197:3000/api/deleteEstimateHeader/${widget.enquiryId}';

    try {
      // Delete data from estimate_footer table
      final responseFooter = await http.delete(Uri.parse(apiUrlFooter));
      if (responseFooter.statusCode == 200) {
        print('Data deleted from estimate_footer table');
      } else {
        throw Exception('Failed to delete data from estimate_footer table');
      }

      // Delete data from estimate_header table
      final responseHeader = await http.delete(Uri.parse(apiUrlHeader));
      if (responseHeader.statusCode == 200) {
        print('Data deleted from estimate_header table');

        // Show success message to the user
        showDialog(
          context: context,
          builder: (BuildContext) {
            return AlertDialog(
              title: Text('Success'),
              content: Text(
                'Data deleted successfully.',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                    Navigator.of(context)
                        .pop(); // Navigate back to previous page
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        throw Exception('Failed to delete data from estimate_header table');
      }
    } catch (error) {
      print('Error deleting data: $error');
      // Show error message to the user
      showDialog(
        context: context,
        builder: (BuildContext) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(
              'Failed to delete data. Please try again later.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products for Enquiry ID: ${widget.enquiryId}'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete, size: 30),
            onPressed: () {
              // Show the delete confirmation dialog
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Confirm Delete'),
                    content: Text('Are you sure you want to delete?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          // Navigate back to the previous page
                          Navigator.pop(context);
                        },
                        child: Text('No'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Call your cancelAction function here
                          cancelAction(context);
                          // Navigate back to the previous page
                          Navigator.pop(context);
                        },
                        child: Text('Yes'),
                      ),
                    ],
                  );
                },
              );
            },
            color: Colors.red,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: [
              DataColumn(
                  label: Text('Product ID',
                      style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(
                  label: Text('Product Name',
                      style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(
                  label: Text('Unit Price',
                      style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(
                  label: Text('Quantity',
                      style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(
                  label: Text('Length',
                      style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(
                  label: Text('Width',
                      style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(
                  label: Text('Height',
                      style: TextStyle(fontWeight: FontWeight.bold))),
              // DataColumn(
              //     label: Text('Discount Percentage',
              //         style: TextStyle(fontWeight: FontWeight.bold))),
              // DataColumn(
              //     label: Text('Discount Price',
              //         style: TextStyle(fontWeight: FontWeight.bold))),
              // DataColumn(
              //     label: Text('Net Amount',
              //         style: TextStyle(fontWeight: FontWeight.bold))),
            ],
            rows: products.map((product) {
              return DataRow(
                cells: [
                  DataCell(Text(product.id.toString())),
                  DataCell(Text(product.name)),
                  DataCell(Text('\₹${product.price.toString()}')),
                  DataCell(Text(product.quantity.toString())),
                  DataCell(Text(product.length.toString())),
                  DataCell(Text(product.width.toString())),
                  DataCell(Text(product.height.toString())),
                  // DataCell(Text(product.discountPercentage.toString())),
                  // DataCell(Text('\₹${product.discountPrice.toString()}')),
                  // DataCell(Text('\₹${product.netAmount.toString()}')),
                ],
              );
            }).toList(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: viewEstimate,
        label: Text('View Estimate'),
        icon: Icon(Icons.money),
      ),
      bottomNavigationBar: estimateAmount != null
          ? Container(
              color: Colors.grey[200],
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                      'Estimate Amount: \₹${estimateAmount!.toStringAsFixed(2)}'), // Add this line to display the estimate amount
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        // Make API call to update estimate status
                        final String apiUrl =
                            'http://192.168.193.197:3000/api/updateEstimateStatus/${widget.enquiryId}';
                        final Map<String, dynamic> requestData = {
                          'estimate_status':
                              'accepted', // Set the estimate status to accepted
                        };

                        final response = await http.put(
                          Uri.parse(apiUrl),
                          body: json.encode(requestData),
                          headers: {'Content-Type': 'application/json'},
                        );

                        if (response.statusCode == 200) {
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.success,
                            text: 'Estimate Accepted',
                          );
                          // Estimate status updated successfully
                          // You can show a success message or perform any other actions
                          print(
                              'Estimate status updated successfully to accepted');
                        } else {
                          // Failed to update estimate status
                          throw Exception('Failed to update estimate status');
                        }
                      } catch (error) {
                        print('Error updating estimate status: $error');
                        // Show error message to the user
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Error'),
                              content: Text(
                                'Failed to update estimate status. Please try again later.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: Text('Accept'),
                  ),

                  ElevatedButton(
                    onPressed: () async {
                      try {
                        // Make API call to update estimate status
                        final String apiUrl =
                            'http://192.168.193.197:3000/api/updateEstimateStatus/${widget.enquiryId}';
                        final Map<String, dynamic> requestData = {
                          'estimate_status': 'rejected',
                        };

                        final response = await http.put(
                          Uri.parse(apiUrl),
                          body: json.encode(requestData),
                          headers: {'Content-Type': 'application/json'},
                        );

                        if (response.statusCode == 200) {
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.error,
                            text: 'Estimate Rejected',
                          );
                          // Estimate status updated successfully
                          // You can show a success message or perform any other actions
                          print(
                              'Estimate status updated successfully to rejected');
                        } else {
                          // Failed to update estimate status
                          throw Exception('Failed to update estimate status');
                        }
                      } catch (error) {
                        print('Error updating estimate status: $error');
                        // Show error message to the user
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Error'),
                              content: Text(
                                'Failed to update estimate status. Please try again later.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: Text('Reject'),
                  ),
                ],
              ),
            )
          : null,
    );
  }
}

class Product {
  final int id;
  final String name;
  final double price;
  final int? quantity; // Make nullable
  final int? length; // Make nullable
  final int? width; // Make nullable
  final int? height; // Make nullable
  // final int? discountPercentage; // Make nullable
  // final double? discountPrice; // Make nullable
  final double? netAmount; // Make nullable

  Product({
    required this.id,
    required this.name,
    required this.price,
    this.quantity,
    this.length,
    this.width,
    this.height,
    // this.discountPercentage,
    // this.discountPrice,
    this.netAmount,
  });

  factory Product.fromJson(List<dynamic> json) {
    if (json.length == 8) {
      return Product(
        id: json[0] ?? 0,
        name: json[1] ?? '',
        price: (json[2] as num).toDouble(),
        quantity: json[3],
        length: json[4],
        width: json[5],
        height: json[6],
        netAmount: (json[7] as num).toDouble(),
      );
    } else {
      throw Exception('Invalid product data: $json');
    }
  }
}
