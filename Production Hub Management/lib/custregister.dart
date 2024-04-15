import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';
import 'package:login/customer_login.dart';

class Custreg extends StatefulWidget {
  const Custreg({Key? key}) : super(key: key);

  @override
  State<Custreg> createState() => _CustregState();
}

class _CustregState extends State<Custreg> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController phonenumController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  bool isObsecure = true;
  bool isPasswordMatched = true;

  // Function to send registration data to the backend
  Future<void> registerUser() async {
    if (_formKey.currentState!.validate()) {
      final Map<String, dynamic> userData = {
        'firstname': firstnameController.text, // Add your form values here
        'lastname': lastnameController.text,
        'username': usernameController.text,
        'email': emailController.text,
        'phonenumber': phonenumController.text,
        'address': addressController.text,
        'password': passwordController.text,
      };

      // Inside the registerUser() method

// Validate email format
      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
          .hasMatch(emailController.text)) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.warning,
          text: 'Please enter a valid email',
        );
        return;
      }

// Validate phone number length
      if (phonenumController.text.length != 10) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.warning,
          text: 'Please enter a valid 10-digit phone number',
        );
        return;
      }

// Validate all fields filled
      if (!_formKey.currentState!.validate()) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.warning,
          text: 'Please fill in all fields',
        );
        return;
      }

// Validate passwords match
      if (passwordController.text != confirmPasswordController.text) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.warning,
          text: 'Passwords do not match',
        );
        return;
      }

      // Replace 'your_backend_url' with your actual backend API endpoint
      final url = Uri.parse('http://192.168.193.197:3000/api/customerinsert');

      try {
        final response = await http.post(
          url,
          body: userData,
        );

        if (response.statusCode == 200) {
          // Registration successful
          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            text: 'Registration Successful',
            autoCloseDuration: Duration(seconds: 2),
          );

          await Future.delayed(Duration(seconds: 2)); // Wait for 1 second

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Customer(), // Replace with your next screen
            ),
          );

          print('Registration successful');

          _clearFormFields();
        } else {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.warning,
            text: 'Registration Failed',
          );
          // Registration failed
          print('Registration failed: ${response.body}');
        }
      } catch (error) {
        print('Error registering user: $error');
      }
    }
  }

  void _clearFormFields() {
    firstnameController.clear();
    lastnameController.clear();
    usernameController.clear();
    emailController.clear();
    phonenumController.clear();
    addressController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
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
              Color.fromARGB(255, 51, 87, 119),
              Color.fromARGB(255, 174, 212, 250)
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Let's Create Your Account",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 0, 0, 0)),
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            height: 55,
                            child: TextFormField(
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                labelText: 'First Name',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.person),
                              ),
                              controller: firstnameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your first name';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Container(
                            height: 55,
                            child: TextFormField(
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                labelText: 'Last Name',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.person),
                              ),
                              controller: lastnameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your last name';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    Container(
                      width: 360,
                      height: 55,
                      child: TextFormField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Username',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.people),
                        ),
                        controller: usernameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your username';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 30),
                    Container(
                      width: 360,
                      height: 55,
                      child: TextFormField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        controller: emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          // Add email validation if needed
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 30),
                    Container(
                      width: 360,
                      height: 55,
                      child: TextFormField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Phone Number',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.call),
                        ),
                        controller: phonenumController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          // Add phone number validation if needed
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 30),
                    Container(
                      width: 360,
                      height: 55,
                      child: TextFormField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Address',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.location_city),
                        ),
                        controller: addressController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your address';
                          }
                          return null;
                        },
                      ),
                    ),

                    SizedBox(height: 30),
                    Container(
                      width: 360,
                      height: 55,
                      child: TextFormField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.password_sharp),
                        ),
                        controller: passwordController,
                        obscureText: isObsecure,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          // Add password validation if needed
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 30),
                    Container(
                      width: 360,
                      height: 55,
                      child: TextFormField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Confirm Password',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.password_sharp),
                        ),
                        controller: confirmPasswordController,
                        obscureText: isObsecure,
                        onChanged: (value) {
                          setState(() {
                            // Check if the passwords match
                            isPasswordMatched =
                                passwordController.text == value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                    ),
                    // Show error message if passwords do not match
                    if (!isPasswordMatched)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Passwords do not match',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    SizedBox(height: 20),
                    Container(
                      width: 360,
                      height: 55,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromARGB(
                                255, 56, 58, 60), // Set your desired color here
                          ),
                        ),
                        onPressed: registerUser,
                        child: Text(
                          'Create Account',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
