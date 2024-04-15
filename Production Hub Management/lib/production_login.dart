import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login/prodregis.dart';
import 'productionhome.dart';

String? loggedInUnitname;

class Production extends StatefulWidget {
  const Production({Key? key}) : super(key: key);

  @override
  State<Production> createState() => _ProductionState();
}

class _ProductionState extends State<Production> {
  bool isobsecure = true;
  final _formKey = GlobalKey<FormState>();
  TextEditingController unitnameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    unitnameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> signIn() async {
    final unitname = unitnameController.text;
    final password = passwordController.text;

    try {
      final response = await http.post(
        Uri.parse('http://192.168.193.197:3000/api/prodlogin'),
        body: json.encode({
          'unitname': unitname,
          'password': password,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      print('Response Body: ${response.body}');
      print('Response Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String loggedInUnitname = responseData['unitname'];
        print('login success');

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoggedInPage(unitname: loggedInUnitname),
          ),
        );
      } else {
        // Failed sign-in, display error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign-in failed. Please try again.')),
        );
      }
    } catch (e) {
      // Error occurred during sign-in process
      print('Error signing in: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('An unexpected error occurred. Please try again later.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login Page',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 60, 60, 60),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Color.fromARGB(255, 48, 48, 48),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Welcome Back!!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Icon(
                      Icons.factory,
                      size: 200,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 60,
                      width: 300,
                      child: TextFormField(
                        controller: unitnameController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Enter Unitname',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
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
                      height: 60,
                      width: 300,
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: isobsecure,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Enter Password',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
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
                      width: 200,
                      child: ElevatedButton(
                        onPressed: signIn,
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromARGB(186, 210, 233, 5),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    Text(
                      '''Don't have an account''',
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 40,
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Prodreg(),
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
      ),
    );
  }
}
