import 'dart:async';
import 'package:flutter/material.dart';
import 'package:login/contractorlogin.dart';
import 'customer_login.dart';
import 'production_login.dart';
//import 'productionhome.dart';

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Color.fromARGB(255, 26, 83, 111)),
      home: SplashScreen(), // Changed to SplashScreen instead of Homescreen
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                Homescreen()), // Navigate to Homescreen after 2 seconds
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/productionunit.gif'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 32, 103, 138),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: ((context) => ContractorLogin())),
              );
              // Handle button press here
            },
            child: Text(
              'Contractor',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/qqq.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 50,
                  width: 250,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Customer()),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 255, 255, 255).withOpacity(
                            0.7), // Adjust opacity here (0.5 for 50% transparency)
                      ),
                    ),
                    child: Text(
                      'You are customer',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,

                        color: const Color.fromARGB(
                            255, 0, 0, 0), // Change text color here
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Container(
                  height: 50,
                  width: 250,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Production()),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 255, 255, 255).withOpacity(
                            0.7), // Adjust opacity here (0.5 for 50% transparency)
                      ),
                    ),
                    child: Text(
                      'You are Production Unit',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,

                        color: const Color.fromARGB(
                            255, 0, 0, 0), // Change text color here
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
