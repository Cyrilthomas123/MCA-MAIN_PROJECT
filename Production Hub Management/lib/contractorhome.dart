import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'con_enquiriescreated.dart';
import 'con_acceptedenq.dart';
import 'quotationlist.dart';
import 'con_productionmanage.dart';
import 'con_conversion.dart';

class ContractorHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(
            255, 166, 194, 216), // Change the background color of the AppBar
        title: Text(
          'Contractor Home Page',
          style: TextStyle(
            color: Color.fromARGB(
                255, 29, 28, 28), // Change the text color of the title
            fontSize: 20, // Change the font size of the title
            fontWeight: FontWeight.bold, // Change the font weight of the title
          ),
        ),
      ),
      body: Container(
        color: Color.fromARGB(255, 33, 113, 179),
        child: GridView.count(
          crossAxisCount: 2,
          padding: EdgeInsets.all(10),
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          children: [
            Container(
              child: _buildMenuItem(
                  context, 'Enquiries Created', Icons.add_circle, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EnquiriesCreatedPage()),
                );
              }),
            ),
            _buildMenuItem(context, 'Calls', Icons.phone, () {
              _launchPhoneApp();
            }),
            _buildMenuItem(context, 'Accepted Enquiries', Icons.done, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AcceptedEnquiries()),
              );
            }),
            _buildMenuItem(context, 'Quotation', Icons.document_scanner, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QuotationListPage()),
              );
            }),
            _buildMenuItem(
                context, 'Manage Production Unit', Icons.manage_accounts, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProductionManagePage()),
              );
            }),
            _buildMenuItem(
                context, 'Conversion', Icons.confirmation_number_outlined, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ConversionPage()),
              );
            }),
          ],
        ),
      ),
    );
  }

  Future<void> _launchPhoneApp() async {
    const String phoneAppScheme = 'tel:';
    try {
      await launch(phoneAppScheme);
    } catch (e) {
      print('Error launching phone app: $e');
    }
  }

  Widget _buildMenuItem(
      BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap, // Call the onTap function provided
      child: Card(
        elevation: 20,
        color: Color.fromARGB(255, 255, 255, 255),
        shadowColor: const Color.fromARGB(255, 0, 0, 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 50,
              color: Color.fromARGB(255, 30, 140, 204),
            ),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
