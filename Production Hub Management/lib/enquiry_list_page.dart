import 'package:flutter/material.dart';
import 'enquirydetails.dart';

class EnquiryListPage extends StatelessWidget {
  final List<int> enquiryIds;

  const EnquiryListPage({required this.enquiryIds});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enquiry IDs'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: ListView.builder(
          itemCount: enquiryIds.length,
          itemBuilder: (context, index) {
            final enquiryId = enquiryIds[index];
            return Card(
              elevation: 20,
              margin: EdgeInsets.only(bottom: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                title: Text(
                  'Enquiry ID: $enquiryId',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EnquiryDetailsPage(enquiryId: enquiryId),
                    ),
                  );
                },
                leading: Icon(Icons.list),
                trailing: Icon(Icons.arrow_forward),
                tileColor: Colors.blueGrey[50],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
