import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Prodreg extends StatefulWidget {
  const Prodreg({Key? key});

  @override
  State<Prodreg> createState() => _ProdState();
}

class _ProdState extends State<Prodreg> {
  bool isPasswordMatched = true;
  TextEditingController unitNameController = TextEditingController();
  TextEditingController ownerNameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool isObsecure = true;

  @override
  void dispose() {
    unitNameController.dispose();
    ownerNameController.dispose();
    locationController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    addressController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            //end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 26, 26, 26),
              Color.fromARGB(255, 103, 104, 105)
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Let's Create Your Account",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: unitNameController,
                          decoration: InputDecoration(
                            labelText: 'Unit Name',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person),
                            fillColor: Colors.white,
                            filled: true,
                          ),
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: TextFormField(
                          controller: ownerNameController,
                          decoration: InputDecoration(
                            labelText: 'Owner Name',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person),
                            fillColor: Colors.white,
                            filled: true,
                          ),
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: locationController,
                    decoration: InputDecoration(
                      labelText: 'Location',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.location_on),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    style: TextStyle(color: Colors.black),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      // Use RegExp for email validation
                      bool isValidEmail =
                          RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(value);
                      if (!isValidEmail) {
                        return 'Please enter a valid email';
                      }
                      return null; // Return null if the input is valid
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: phoneNumberController,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: addressController,
                    decoration: InputDecoration(
                      labelText: 'Address',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.home),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    style: TextStyle(color: Colors.black),
                    obscureText: isObsecure,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    style: TextStyle(color: Colors.black),
                    obscureText: isObsecure,
                    onChanged: (value) {
                      setState(() {
                        isPasswordMatched = passwordController.text == value;
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  !isPasswordMatched
                      ? Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            'Passwords do not match',
                            style: TextStyle(color: Colors.red),
                          ),
                        )
                      : SizedBox(),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      createAccount();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 35, 35, 34),
                      padding:
                          EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Create Account',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
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

  Future<void> createAccount() async {
    final String apiUrl = 'http://192.168.193.197:3000/api/createAccountProd';
    final String email = emailController.text;
    final String phoneNumber = phoneNumberController.text;
    final String password = passwordController.text;
    final String confirmPassword = confirmPasswordController.text;

    // Validate email format
    // if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
    //   showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return AlertDialog(
    //         title: Text('Error'),
    //         content: Text('Please enter a valid email'),
    //         actions: [
    //           TextButton(
    //             onPressed: () => Navigator.of(context).pop(),
    //             child: Text('OK'),
    //           ),
    //         ],
    //       );
    //     },
    //   );
    //   return;
    // }

    // // Validate phone number format (10 digits)
    // if (phoneNumber.length != 10) {
    //   showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return AlertDialog(
    //         title: Text('Error'),
    //         content: Text('Please enter a valid 10-digit phone number'),
    //         actions: [
    //           TextButton(
    //             onPressed: () => Navigator.of(context).pop(),
    //             child: Text('OK'),
    //           ),
    //         ],
    //       );
    //     },
    //   );
    //   return;
    // }

    // Validate all fields are filled
    if (unitNameController.text.isEmpty ||
        ownerNameController.text.isEmpty ||
        locationController.text.isEmpty ||
        email.isEmpty ||
        phoneNumber.isEmpty ||
        addressController.text.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please fill in all fields'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please enter a valid email'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    // Validate phone number format (10 digits)
    if (phoneNumber.length != 10) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please enter a valid 10-digit phone number'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }
    // Validate passwords match
    if (password != confirmPassword) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Passwords do not match'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    // All validations passed, proceed with creating account
    final Map<String, dynamic> requestData = {
      'unitname': unitNameController.text,
      'owner_name': ownerNameController.text,
      'location': locationController.text,
      'email': email,
      'phonenumber': phoneNumber,
      'address': addressController.text,
      'password': password,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: json.encode(requestData),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        clearFields();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success!!!'),
              content: Text(
                'Your Registration is Successful',
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
        print('Account created successfully');
      } else {
        // Failed to create account
        throw Exception('Failed to create account');
      }
    } catch (error) {
      print('Error creating account: $error');
      // Show error message to the user
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(
              'Try Registering with a unit name',
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

  void clearFields() {
    unitNameController.clear();
    ownerNameController.clear();
    locationController.clear();
    emailController.clear();
    phoneNumberController.clear();
    addressController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }
}
