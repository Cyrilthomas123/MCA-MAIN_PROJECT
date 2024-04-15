import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';
import 'dart:convert';
import 'package:flutter_slidable/flutter_slidable.dart';

class BookListPage extends StatefulWidget {
  final String loggedInUsername;
  final int enquiry_Id;

  const BookListPage(
      {Key? key, required this.loggedInUsername, required this.enquiry_Id})
      : super(key: key);

  @override
  _BookListPageState createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  List<BookedProduct> bookedProducts = [];

  void removeProduct(int index) {
    setState(() {
      bookedProducts.removeAt(index);
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchBookedProducts(widget.enquiry_Id);
  }

  Future<void> _fetchBookedProducts(int enquiryId) async {
    final url =
        Uri.parse('http://192.168.193.197:3000/api/booklist/$enquiryId');

    try {
      final response = await http.get(url);
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        print('Parsed data: $data');
        setState(() {
          bookedProducts =
              data.map((item) => BookedProduct.fromJson(item)).toList();
        });
      } else {
        print(
            'Failed to fetch booked products. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching booked products: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book List'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Additional text widget
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Your Enquiry ID: ${widget.enquiry_Id}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          // ListView.builder widget to display booked products
          Expanded(
              child: ListView.builder(
            itemCount: bookedProducts.length,
            itemBuilder: (context, index) {
              final bookedProduct = bookedProducts[index];
              return Slidable(
                actionPane: SlidableDrawerActionPane(),
                actionExtentRatio: 0.25,
                child: Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Product Name: ${bookedProduct.productName}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Price: ₹${bookedProduct.price}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.green,
                          ),
                        ),
                        if (bookedProduct.length != null)
                          Text(
                            'Length: ${bookedProduct.length}',
                            style: TextStyle(fontSize: 16),
                          ),
                        if (bookedProduct.width != null)
                          Text(
                            'Width: ${bookedProduct.width}',
                            style: TextStyle(fontSize: 16),
                          ),
                        if (bookedProduct.height != null)
                          Text(
                            'Height: ${bookedProduct.height}',
                            style: TextStyle(fontSize: 16),
                          ),
                        Text(
                          'Quantity: ${bookedProduct.quantity}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                secondaryActions: <Widget>[
                  IconSlideAction(
                    caption: 'Delete',
                    color: Colors.red,
                    icon: Icons.delete,
                    onTap: () async {
                      await _deleteProduct(
                          widget.enquiry_Id, bookedProduct.productId);
                      setState(() {
                        bookedProducts.removeAt(index);
                      });
                    },
                  ),
                ],
              );
            },
          )),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          try {
            // Fetch data from enquiry_header
            print('Fetching data from enquiry_header...');
            final enquiryHeaderUrl = Uri.parse(
                "http://192.168.193.197:3000/api/fetchEnquiry/${widget.enquiry_Id}");
            final enquiryHeaderResponse = await http.get(enquiryHeaderUrl);
            print('response is $enquiryHeaderResponse');

            if (enquiryHeaderResponse.statusCode == 200) {
              print('Enquiry header data fetched successfully');
              final enquiryHeaderData = jsonDecode(enquiryHeaderResponse.body);
              print('Response body: $enquiryHeaderData');

              // Extract necessary data from enquiry header
              final companyId = 'ABC';
              //final documentType = 'EST';
              //final workDescription = 'interior work';
              final enquiryId = widget.enquiry_Id;
              final username = enquiryHeaderData['username'];
              final customerName = enquiryHeaderData['customername'];

              if (username != null && customerName != null) {
                // Insert data into estimate_header table
                print('Inserting data into estimate_header table...');
                final estimateHeaderUrl =
                    Uri.parse('http://192.168.193.197:3000/api/insertEstimate');
                final estimateHeaderResponse = await http.post(
                  estimateHeaderUrl,
                  body: jsonEncode({
                    'companyId': companyId,
                    //'documentType': documentType,
                    //'workDescription': workDescription,
                    'customerName': customerName,
                    'username': username,
                    'enquiry_Id': enquiryId,
                  }),
                  headers: {'Content-Type': 'application/json'},
                );
                if (estimateHeaderResponse.statusCode == 200) {
                  print('Data processed successfully');
                  // Handle success response
                } else {
                  print(
                      'Failed to process data: ${estimateHeaderResponse.statusCode}');
                  // Handle failure response
                }
              } else {
                print('Username or customer name is null');
              }
            } else {
              print(
                  'Failed to fetch enquiry header data: ${enquiryHeaderResponse.statusCode}');
              // Handle failure to fetch enquiry header data
            }
          } catch (e) {
            print('Error occurred: $e');
            // Handle any errors that occur during the API calls
          }

          try {
            final enquiryFooterUrl = Uri.parse(
                "http://192.168.193.197:3000/api/fetchEnquiryFooter/${widget.enquiry_Id}");

            // Fetch data from enquiry_footer
            print('Fetching data from enquiry_footer...');
            final enquiryFooterResponse = await http.get(enquiryFooterUrl);
            print('Response is $enquiryFooterResponse');
            if (enquiryFooterResponse.statusCode == 200) {
              print('Enquiry footer data fetched successfully');
              final enquiryFooterData = jsonDecode(enquiryFooterResponse.body);
              print('Response body: $enquiryFooterData');

              // Extract necessary data from enquiry footer
              final companyId = 'ABC';
              final username = enquiryFooterData['username'];
              final footerData = enquiryFooterData['enquiryFooterData'];
              for (var item in footerData) {
                final productId = item['product_id'];
                final productName = item['productname'];
                final unitPrice = item['unit_price'];
                final quantity = item['quantity'];
                final len = item['len'];
                final width = item['width'];
                final height = item['height'];
                final enquiry_Id = item['enquiry_id'];
                final sale_amount = item['sale_amount'];

                print('Inserting data into estimate_footer table...');
                final estimateFooterUrl = Uri.parse(
                    'http://192.168.193.197:3000/api/insertEstimateFooter');
                final estimateFooterResponse = await http.post(
                  estimateFooterUrl,
                  body: jsonEncode({
                    'companyId': companyId,
                    'username': username,
                    'enquiry_Id': enquiry_Id,
                    'productId': productId,
                    'productName': productName,
                    'unitPrice': unitPrice,
                    'quantity': quantity,
                    'len': len,
                    'width': width,
                    'height': height,
                    'netamount': sale_amount,
                    //'discountPercentage': 5,
                    //'discountPrice': (unitPrice * 5) / 100,
                    //'netAmount': (unitPrice - (unitPrice * 5 / 100)) * quantity,
                  }),
                  headers: {'Content-Type': 'application/json'},
                );

                if (estimateFooterResponse.statusCode == 200) {
                  // Handle success response
                } else {
                  print(
                      'Failed to process data: ${estimateFooterResponse.statusCode}');

                  // Handle failure response
                }
                // Handle success response
              }
              QuickAlert.show(
                context: context,
                type: QuickAlertType.success,
                text: 'You will get the estimate SOON!!',
              );
            } else {
              print(
                  'Failed to fetch enquiry footer data: ${enquiryFooterResponse.statusCode}');
              // Handle failure to fetch enquiry footer data
            }
          } catch (e) {
            print('Error occurred: $e');
            // Handle any errors that occur during the API calls
          }
        },
        label: Text('Get Estimate'),
        icon: Icon(Icons.article_outlined),
      ),
    );
  }
}

Future<void> _deleteProduct(int enquiryId, int productId) async {
  final apiUrl =
      'http://192.168.193.197:3000/api/delete_product/$enquiryId/$productId';
  try {
    final response = await http.delete(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      print('Product deleted successfully');
    } else {
      throw Exception('Failed to delete product');
    }
  } catch (error) {
    print('Error deleting product: $error');
    // Show error message to the user
  }
}

class BookedProduct {
  final int productId;
  final String productName;
  final double price;
  final int? length;
  final int? width;
  final int? height;
  final int quantity;

  BookedProduct({
    required this.productId,
    required this.productName,
    required this.price,
    this.length,
    this.width,
    this.height,
    required this.quantity,
  });

  factory BookedProduct.fromJson(List<dynamic> json) {
    return BookedProduct(
      productId: json[1],
      productName: json[2],
      price: json[3].toDouble(),
      length: json[4],
      width: json[5],
      height: json[6],
      quantity: json[7],
    );
  }
}
