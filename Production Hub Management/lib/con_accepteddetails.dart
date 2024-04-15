import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AcceptedDetailsPage extends StatefulWidget {
  final int enquiry_Id;

  AcceptedDetailsPage({required this.enquiry_Id});

  @override
  State<AcceptedDetailsPage> createState() => _AcceptedDetailsPageState();
}

class _AcceptedDetailsPageState extends State<AcceptedDetailsPage> {
  List<Map<String, dynamic>> enquiryDetails = [];
  String documenttype = '';
  String worktitle = '';
  String taxCode = '';
  double taxPercentage = 0.0;
  String termsandconditions = '';

  @override
  void initState() {
    super.initState();
    // Fetch details for the given enquiry ID
    fetchEnquiryDetails();
  }

  Future<void> fetchEnquiryDetails() async {
    final String apiUrl =
        'http://192.168.193.197:3000/api/fetchEnquiryDetails/${widget.enquiry_Id}';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      print('API Response: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        final List<Map<String, dynamic>> details = [];

        for (List<dynamic> data in responseData) {
          details.add({
            'productid': data[0],
            'productname': data[1],
            'unitprice': data[2],
            'quantity': data[3],
            'len': data[4],
            'width': data[5],
            'height': data[6],
            'discount_percentage': data[7],
            'discount_price': data[8],
            'netamount': data[9],
          });
        }

        setState(() {
          enquiryDetails = details;
        });
      } else {
        throw Exception('Failed to fetch enquiry details');
      }
    } catch (error) {
      print('Error fetching enquiry details: $error');
    }
  }

  double calculateTotalNetAmount() {
    double totalNetAmount = 0.0;
    for (var detail in enquiryDetails) {
      totalNetAmount += detail['netamount'];
    }
    return totalNetAmount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accepted Enquiry Details'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  onChanged: (value) {
                    // Update documentType value when the text changes
                    setState(() {
                      documenttype = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Document Type',
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  onChanged: (value) {
                    // Update documentType value when the text changes
                    setState(() {
                      worktitle = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Work Description',
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  onChanged: (value) {
                    // Update documentType value when the text changes
                    setState(() {
                      taxCode = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Tax Code',
                  ),
                ),
                SizedBox(height: 16), // Add spacing between fields
                TextField(
                  onChanged: (value) {
                    // Update workDescription value when the text changes
                    setState(() {
                      taxPercentage = double.tryParse(value) ?? 0.0;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Tax Percentage',
                  ),
                ),
                SizedBox(height: 16), // Add spacing between fields
                TextField(
                  onChanged: (value) {
                    // Update discountPercentage value when the text changes
                    setState(() {
                      termsandconditions = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Terms and Condition',
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text('Product ID')),
                      DataColumn(label: Text('Product Name')),
                      DataColumn(label: Text('Unit Price')),
                      DataColumn(label: Text('Quantity')),
                      DataColumn(label: Text('Length')),
                      DataColumn(label: Text('Width')),
                      DataColumn(label: Text('Height')),
                      // DataColumn(label: Text('Discount %')),
                      // DataColumn(label: Text('Discount Price')),
                      DataColumn(label: Text('Net Amount')),
                    ],
                    rows: List<DataRow>.generate(
                      enquiryDetails.length,
                      (index) {
                        final detail = enquiryDetails[index];
                        return DataRow(cells: [
                          DataCell(Text(detail['productid'].toString())),
                          DataCell(Text(detail['productname'])),
                          DataCell(Text(detail['unitprice'].toString())),
                          DataCell(Text(detail['quantity'].toString())),
                          DataCell(Text(detail['len'].toString())),
                          DataCell(Text(detail['width'].toString())),
                          DataCell(Text(detail['height'].toString())),
                          // DataCell(
                          //     Text(detail['discount_percentage'].toString())),
                          // DataCell(Text(detail['discount_price'].toString())),
                          DataCell(Text(detail['netamount'].toString())),
                        ]);
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          try {
            // Fetch data from enquiry_header
            print('Fetching data from estimate_header...');
            final estimateHeaderUrl = Uri.parse(
                "http://192.168.193.197:3000/api/fetchEstimate/${widget.enquiry_Id}");
            final enquiryHeaderResponse = await http.get(estimateHeaderUrl);
            print('response is $enquiryHeaderResponse');

            if (enquiryHeaderResponse.statusCode == 200) {
              print('Enquiry header data fetched successfully');
              final enquiryHeaderData = jsonDecode(enquiryHeaderResponse.body);
              print('Response body: $enquiryHeaderData');

              final companyId = 'ABC';
              final documentType = documenttype;
              final workTitle = worktitle;
              final taxcode = taxCode;
              final tax_percentage = taxPercentage;
              final termsandcondition = termsandconditions;
              final enquiryId = widget.enquiry_Id;
              final username = enquiryHeaderData['username'];
              final customerName = enquiryHeaderData['customername'];
              final estimate_amount = enquiryHeaderData['estimate_amount'];
              print('est is$estimate_amount');
              final tax_amount = estimate_amount * (tax_percentage / 100);
              print('tax_amount$tax_amount');

              final quotation_amount = estimate_amount + tax_amount;
              print('sdf$quotation_amount');

              if (username != null && customerName != null) {
                print('Username: $username');
                print('Customer Name: $customerName');

                // Insert data into estimate_header table
                print('Inserting data into quotation_header table...');
                final estimateHeaderUrl = Uri.parse(
                    'http://192.168.193.197:3000/api/insertQuotation');
                final estimateHeaderResponse = await http.post(
                  estimateHeaderUrl,
                  body: jsonEncode({
                    'quotation_amount': quotation_amount,
                    'companyId': companyId,
                    'documentType': documentType,
                    'worktitle': workTitle,
                    'customerName': customerName,
                    'username': username,
                    'enquiry_Id': enquiryId,
                    'taxcode': taxcode,
                    'tax_percentage': tax_percentage,
                    'tax_amount': tax_amount,
                    'termsandcondition': termsandcondition,
                  }),
                  headers: {'Content-Type': 'application/json'},
                );
                if (estimateHeaderResponse.statusCode == 200) {
                  print('Data processed successfully');
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.success,
                    title: 'Quotation Generated',
                  );
                  // Handle success response
                } else {
                  print(
                      'Failed to process data: ${estimateHeaderResponse.statusCode}');
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.success,
                    title: 'Quotation Generated',
                  );
                  ;
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
                "http://192.168.193.197:3000/api/fetchEstimateFooter/${widget.enquiry_Id}");

            // Fetch data from estimate_footer
            print('Fetching data from estimate_footer...');
            final enquiryFooterResponse = await http.get(enquiryFooterUrl);
            print('Response is $enquiryFooterResponse');
            if (enquiryFooterResponse.statusCode == 200) {
              print('Estimate footer data fetched successfully');
              final enquiryFooterData =
                  jsonDecode(enquiryFooterResponse.body)['enquiryFooterData'];
              print('Response body: $enquiryFooterData');

              for (var item in enquiryFooterData) {
                final companyid = item['companyId'];
                final username = item['username'];
                final productId = item['product_id'];
                final productName = item['productname'];
                final unitPrice = item['unit_price'];
                final quantity = item['quantity'];
                final len = item['len'];
                final width = item['width'];
                final height = item['height'];
                final discountPercentage = item['discountPercentage'];
                final discountPrice = item['discountPrice'];
                final netAmount = item['netAmount'];
                final enquiry_Id = item['enquiry_id'];

                print('Inserting data into quotation_footer table...');
                final estimateFooterUrl = Uri.parse(
                    'http://192.168.193.197:3000/api/insertQuotationFooter');
                final estimateFooterResponse = await http.post(
                  estimateFooterUrl,
                  body: jsonEncode({
                    'companyId': companyid,
                    'username': username,
                    'enquiry_Id': enquiry_Id,
                    'productId': productId,
                    'productName': productName,
                    'unitPrice': unitPrice,
                    'quantity': quantity,
                    'len': len,
                    'width': width,
                    'height': height,
                    'discountPercentage': discountPercentage,
                    'discountPrice': discountPrice,
                    'netAmount': netAmount,
                  }),
                  headers: {'Content-Type': 'application/json'},
                );

                if (estimateFooterResponse.statusCode == 200) {
                  print('Data inserted successfully');

                  // Handle success response
                } else {
                  print(
                      'Failed to process data: ${estimateFooterResponse.statusCode}');
                  // Handle failure response
                }
              }
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
        label: Text('Generate Quotation'),
        icon: Icon(Icons.generating_tokens),
      ),
    );
  }
}
