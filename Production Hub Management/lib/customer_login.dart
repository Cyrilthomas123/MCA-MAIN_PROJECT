import 'dart:convert';
import 'package:flutter/material.dart';
import 'custregister.dart';
import 'package:http/http.dart' as http;
//import 'package:login/enquiry.dart';
import 'enquiry.dart';

String? loggedInUsername;
//int? enquiry_id;

class Customer extends StatefulWidget {
  const Customer({Key? key}) : super(key: key);

  @override
  State<Customer> createState() => _CustomerState();
}

class _CustomerState extends State<Customer> {
  bool isobsecure = true;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _signIn() async {
    final String username = usernameController.text;
    final String password = passwordController.text;

    try {
      final Uri url = Uri.parse('http://192.168.193.197:3000/api/login');
      final http.Response response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData.containsKey('message') &&
            responseData['message'] == 'Authentication successful!') {
          print('success');
          // Set the loggedInUsername after successful authentication
          loggedInUsername = responseData['username'];
          print(loggedInUsername); // Update loggedInUsername
          // Navigate to the next screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => InteriorDesignPage(
                loggedInUsername: loggedInUsername,
                //enquiry_id: enquiry_id,
              ),
            ),
          );

          return; // Exit the method after successful authentication
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid Username or password'),
          ),
        );
        // Authentication failed
        //Show an error message
        print('Authentication failed: ${response.body}');
      }
    } catch (error) {
      // Handle any exceptions that occur during the POST request
      print('Error during sign in: $error');
      // Show an error message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 62, 62, 62),
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Login Page'),
        titleTextStyle: TextStyle(
            color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
      ),
      body: Container(
        color: Color.fromARGB(255, 62, 62, 62),
        child: SafeArea(
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Welcome Back!',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 70),
                  Container(
                    height: 50,
                    width: 350,
                    child: TextFormField(
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 35,
                        ),
                        hintText: 'Enter Username',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
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
                  SizedBox(height: 20),
                  Container(
                    height: 50,
                    width: 350,
                    child: TextFormField(
                      obscureText: isobsecure,
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.lock,
                          color: Colors.white,
                          size: 35,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Password',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isobsecure = !isobsecure;
                            });
                          },
                          icon: Icon(isobsecure
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ),
                      ),
                      controller: passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 40,
                    width: 250,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _signIn();
                          // Form is valid, perform sign in action
                        }
                      },
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromARGB(185, 227, 244, 71),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  Text(
                    '''Don't have an account''',
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 40,
                    width: 250,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Custreg(),
                          ),
                        );
                      },
                      child: Text(
                        'Register Now',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.black,
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
    );
  }
}
