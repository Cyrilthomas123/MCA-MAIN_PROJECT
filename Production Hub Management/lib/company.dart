//import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';
import 'retrieve.dart';
import 'modify.dart';

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Company Form',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: CompanyForm(),
    );
  }
}

class CompanyForm extends StatefulWidget {
  const CompanyForm({Key? key}) : super(key: key);

  @override
  State<CompanyForm> createState() => CompanyFormState();
}

class CompanyFormState extends State<CompanyForm> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController? idController;
  TextEditingController? nameController;
  TextEditingController? address1Controller;
  TextEditingController? address2Controller;
  TextEditingController? address3Controller;
  TextEditingController? websiteController;
  TextEditingController? emailController;
  TextEditingController? phoneNumController;
  TextEditingController? countryCodeController;

  @override
  void initState() {
    super.initState();
    idController = TextEditingController();
    nameController = TextEditingController();
    address1Controller = TextEditingController();
    address2Controller = TextEditingController();
    address3Controller = TextEditingController();
    websiteController = TextEditingController();
    emailController = TextEditingController();
    phoneNumController = TextEditingController();
    countryCodeController = TextEditingController();
  }

  Future<void> submit() async {
    if (_formKey.currentState!.validate()) {
      final String companyid = idController!.text;
      final String companyname = nameController!.text;
      final String address1 = address1Controller!.text;
      final String address2 = address2Controller!.text;
      final String address3 = address3Controller!.text;
      final String website = websiteController!.text;
      final String email = emailController!.text;
      final String phonenum = phoneNumController!.text;
      final String countrycode = countryCodeController!.text;
      final String serverUrl = 'http://192.168.193.197:3000/api/post1';

      try {
        final response = await http.post(
          Uri.parse(serverUrl),
          body: {
            'COMPANY_ID': companyid,
            'COMPANY_NAME': companyname,
            'ADDRESS1': address1,
            'ADDRESS2': address2,
            'ADDRESS3': address3,
            'WEBSITE': website,
            'MAILID': email,
            'PHNO': phonenum,
            'COUNTRY_CODE': countrycode,
          },
        );

        if (response.statusCode == 200) {
          print('Data inserted successfully!');
          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            title: 'Company Added Successfully',
          );

          _clearFormFields();
        } else if (response.statusCode == 409) {
          print('Company ID already exists in the database');
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: 'Company ID Already Exists',
          );
        } else {
          print('Data insertion failed. Status code: ${response.statusCode}');
        }
      } catch (error) {
        print('Error: $error');
      }
    }
  }

  void _clearFormFields() {
    idController!.clear();
    nameController!.clear();
    address1Controller!.clear();
    address2Controller!.clear();
    address3Controller!.clear();
    websiteController!.clear();
    emailController!.clear();
    phoneNumController!.clear();
    countryCodeController!.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Company Form',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(
            color: const Color.fromARGB(
                255, 255, 255, 255)), // Change the color here
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 200,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 27, 27, 28),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Company Informations',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                    SizedBox(
                        height:
                            20), // Adjust the spacing between the text and icon
                    Icon(
                      Icons.business,
                      color: Colors.white,
                      size: 32,
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.remove_red_eye_outlined),
              title: Text('View Details'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RetrieveDetailsScreen()));
              },
            ),
            Divider(
              color: Colors.grey,
              height: 3,
              thickness: 3,
            ),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Modify Details'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ModifyCompanyDetailsPage()));
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Title(
                    color: Colors.black,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Registration',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                        SizedBox(
                          width: 25,
                        ),
                      ],
                    ),
                  ),
                  Image.asset(
                    'assets/images/registration.jpg',
                    width: 150,
                    height: 200,
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Enter Company ID'),
                            TextFormField(
                              controller: idController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.factory),
                                hintText: 'Enter Company ID',
                                hintFadeDuration: Duration(seconds: 1),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a company ID';
                                }
                                if (value.length > 3) {
                                  return 'Maximum 3 characters';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Enter Company Name'),
                            TextFormField(
                              controller: nameController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.people),
                                hintText: 'Enter Company Name',
                                hintFadeDuration: Duration(seconds: 1),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a company name';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Enter Website'),
                            TextFormField(
                                controller: websiteController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.link),
                                  hintText: 'Enter Website',
                                  hintFadeDuration: Duration(seconds: 1),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter Website';
                                  }
                                  return null;
                                }),
                          ],
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Enter Email'),
                            TextFormField(
                                controller: emailController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.mail),
                                  hintText: 'Enter Mail ID',
                                  hintFadeDuration: Duration(seconds: 1),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter Mail';
                                  }
                                  return null;
                                }),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Address1'),
                      TextFormField(
                          controller: address1Controller,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.place),
                            hintText: 'Enter Address',
                            hintFadeDuration: Duration(seconds: 1),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter Address';
                            }
                            return null;
                          }),
                    ],
                  ),
                  SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Address 2'),
                      TextFormField(
                          controller: address2Controller,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.place_outlined),
                            hintText: 'Enter Address ',
                            hintFadeDuration: Duration(seconds: 1),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter Address';
                            }
                            return null;
                          }),
                    ],
                  ),
                  SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Address 3'),
                      TextFormField(
                          controller: address3Controller,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.place_rounded),
                            hintText: 'Address 3',
                            hintFadeDuration: Duration(seconds: 1),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter Address';
                            }
                            return null;
                          }),
                    ],
                  ),
                  SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Enter Phone Number'),
                      TextFormField(
                        controller: phoneNumController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.phone),
                          hintText: 'Enter Phone Number',
                          hintFadeDuration: Duration(seconds: 1),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a phone number';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Phone number must be a number';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Enter Country Code'),
                      TextFormField(
                        controller: countryCodeController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.code),
                          hintText: 'Enter Country Code',
                          hintFadeDuration: Duration(seconds: 1),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a country code';
                          }
                          if (value.length > 3) {
                            return 'Maximum 3 characters';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: submit,
                      child: Text('Submit'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
