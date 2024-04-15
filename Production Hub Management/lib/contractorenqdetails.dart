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
  List<Map<String, dynamic>> enquiryDetails = [];
  String documentType = '';
  String workDescription = '';
  double discountPercentage = 0.0;
  double marginamnt = 0.0;
  double enquirymarginpercentage = 0.0;

  @override
  void initState() {
    super.initState();
    // Fetch details for the given enquiry ID
    fetchEnquiryDetails();
  }

  Future<void> fetchEnquiryDetails() async {
    final String apiUrl =
        'http://192.168.193.197:3000/api/fetchEnquiryDetails/${widget.enquiryId}';

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
      if (detail.containsKey('netamount')) {
        totalNetAmount += (detail['netamount'] ?? 0.0);
      }
    }
    double discount = totalNetAmount * (discountPercentage / 100);
    totalNetAmount = totalNetAmount - discount;
    double marginamnt = totalNetAmount * (enquirymarginpercentage / 100);
    totalNetAmount = totalNetAmount + marginamnt;
    return totalNetAmount;
  }

  Future<void> storeTotalNetAmount(double totalNetAmount) async {
    final String apiUrl =
        'http://192.168.193.197:3000/api/updateEstimateHeader/${widget.enquiryId}';
    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        body: jsonEncode({
          'totalNetAmount': totalNetAmount,
          'documentType': documentType,
          'workDescription': workDescription,
          'discountPercentage': discountPercentage,
        }),
        headers: {'Content-Type': 'application/json'},
      );
      print('API Response: ${response.body}');
      if (response.statusCode == 200) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          title: 'Estimate Generated Successfully!!',
        );
        print('Total net amount stored successfully');
      } else {
        throw Exception('Failed to store total net amount');
      }
    } catch (error) {
      print('Error storing total net amount: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enquiry Details'),
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
                      documentType = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Document Type',
                  ),
                ),
                SizedBox(height: 16), // Add spacing between fields
                TextField(
                  onChanged: (value) {
                    // Update workDescription value when the text changes
                    setState(() {
                      workDescription = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Work Description',
                  ),
                ),
                SizedBox(height: 16), // Add spacing between fields
                TextField(
                  onChanged: (value) {
                    // Update discountPercentage value when the text changes
                    setState(() {
                      discountPercentage = double.tryParse(value) ?? 0.0;
                    });
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Discount Percentage',
                  ),
                ),
                SizedBox(height: 16), // Add spacing between fields
                TextField(
                  onChanged: (value) {
                    // Update discountPercentage value when the text changes
                    setState(() {
                      enquirymarginpercentage = double.tryParse(value) ?? 0.0;
                    });
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Enquiry Margin Percentage',
                  ),
                ),
                SizedBox(
                    height: 16), // Add spacing between fields and DataTable
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: DataTable(
                    headingRowColor: MaterialStateColor.resolveWith(
                        (states) => const Color.fromARGB(255, 95, 87, 87)),
                    dataRowColor: MaterialStateColor.resolveWith(
                        (states) => Color.fromARGB(255, 116, 115, 115)),
                    columnSpacing: 20.0,
                    dividerThickness: 2,
                    horizontalMargin: 20,
                    showBottomBorder: true,
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
                      //     label: Text('Discount %',
                      //         style: TextStyle(fontWeight: FontWeight.bold))),
                      // DataColumn(
                      //     label: Text('Discount Price',
                      //         style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Text('Net Amount',
                              style: TextStyle(fontWeight: FontWeight.bold))),
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
        onPressed: () {
          double totalNetAmount = calculateTotalNetAmount();
          storeTotalNetAmount(totalNetAmount);
          print('Total Net Amount: $totalNetAmount');
        },
        label: Text('Generate Estimate'),
        icon: Icon(Icons.calculate),
      ),
    );
  }
}
