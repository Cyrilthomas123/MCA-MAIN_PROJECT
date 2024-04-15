import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PdfGenerationPage extends StatelessWidget {
  final String enquiryId;

  PdfGenerationPage({required this.enquiryId});

  Future<void> _generatePdf(BuildContext context) async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.193.197:3000/api/generate-pdf/$enquiryId'),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final pdfPath = responseData['pdfPath'];
        if (pdfPath != null) {
          print('PDF generated successfully. Path: $pdfPath');
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Quotation Generated'),
                icon: Icon(
                  Icons.verified,
                  color: Color.fromARGB(255, 48, 176, 16),
                  size: 50,
                ),
                content: Text(
                  'Saved Locally in the System',
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

          // Handle the PDF path
        } else {
          print('Error: PDF path is null');
        }
      } else {
        print('Error generating PDF: ${response.statusCode}');
      }
    } catch (e) {
      print('Error generating PDF: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Generation'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _generatePdf(context),
          child: Text('Generate PDF'),
        ),
      ),
    );
  }
}
