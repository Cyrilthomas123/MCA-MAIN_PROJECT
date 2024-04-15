import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'contractorhome.dart';

// void main(List<String> args) {
//   runApp(ContractorLogin());
// }

class ContractorLogin extends StatefulWidget {
  const ContractorLogin({Key? key}) : super(key: key);

  @override
  _ContractorLoginState createState() => _ContractorLoginState();
}

class _ContractorLoginState extends State<ContractorLogin> {
  bool isIconVisible = true;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (isIconVisible)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isIconVisible = false;
                      });
                    },
                    child: Container(
                      child: Icon(
                        Icons.lock,
                        size: 80,
                      ),
                    ),
                  ),
                if (!isIconVisible) ...[
                  Text(
                    'Hello Contractor!!',
                    style: TextStyle(
                      fontSize: 70,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    color: Colors.black,
                    width: 300,
                    height: 300,
                    child: Image.asset(
                      'assets/images/loginills.png', // Path to your image asset
                      width: 20, // Adjust width as needed
                      height: 20,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          height: 50,
                          width: 300,
                          child: TextFormField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              labelText: 'Username',
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
                          height: 50,
                          width: 300,
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
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
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // Form is valid, check login credentials
                              if (_usernameController.text == 'cyril' &&
                                  _passwordController.text == '123') {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) =>
                                            ContractorHomePage())));
                                // Login successful
                                print('Login successful');
                              } else {
                                // Login failed
                                print('Login failed');
                                // Show an alert dialog
                                QuickAlert.show(
                                  context: context,
                                  type: QuickAlertType.error,
                                  text:
                                      'Incorrect username or password. Please try again.',
                                );
                              }
                            }
                          },
                          child: Text(
                            'Login',
                            style: TextStyle(fontWeight: FontWeight.w800),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black, // Background color
                            foregroundColor: Colors.white, // Text color
                            padding: EdgeInsets.symmetric(
                              horizontal: 100,
                              vertical: 15,
                            ), // Button padding
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
