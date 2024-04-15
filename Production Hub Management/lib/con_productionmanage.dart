import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:quickalert/quickalert.dart';

class ProductionManagePage extends StatefulWidget {
  @override
  _ProductionManagePageState createState() => _ProductionManagePageState();
}

class _ProductionManagePageState extends State<ProductionManagePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<String> enquiryIds = []; // List to hold enquiry IDs
  Map<String, String> selectedEnquiryIds =
      {}; // Map to hold selected enquiry IDs for each production unit

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // Refresh the UI when tab changes
    });
    fetchEnquiryIds(); // Fetch enquiry IDs when the widget initializes
  }

  Future<List<String>> _fetchProductionUnits(String status) async {
    final apiUrl = 'http://192.168.193.197:3000/api/production_units';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final filteredUnits = data.where((unit) => unit['status'] == status);
        return List<String>.from(filteredUnits.map((unit) => unit['unitName']));
      } else {
        throw Exception('Failed to fetch production units');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> fetchEnquiryIds() async {
    final apiUrl = 'http://192.168.193.197:3000/api/enquiry_ids';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          enquiryIds = data.map((id) => id.toString()).toList();
        });
      } else {
        throw Exception('Failed to fetch enquiry IDs');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> _allocateWork(String unitName) async {
    final selectedEnquiryId = selectedEnquiryIds[unitName];
    if (selectedEnquiryId == null || selectedEnquiryId.isEmpty) {
      print('Please select an enquiry ID');
      return;
    }

    try {
      // Step 1: Insert data into workallocate table
      final workAllocateUrl = 'http://192.168.193.197:3000/api/work_allocate';
      final requestBody = jsonEncode({
        'enquiryId': selectedEnquiryId,
        'unitName': unitName,
      });
      final workAllocateResponse = await http.post(Uri.parse(workAllocateUrl),
          body: requestBody, headers: {'Content-Type': 'application/json'});

      // Check if the insertion was successful
      if (workAllocateResponse.statusCode != 200) {
        throw Exception('Failed to allocate work');
      }

      // Step 2: Update production unit status to "busy"
      final statusUpdateUrl =
          'http://192.168.193.197:3000/api/update_status_to_busy/$unitName';
      final statusUpdateResponse = await http.put(Uri.parse(statusUpdateUrl));

      // Check if the status update was successful
      if (statusUpdateResponse.statusCode == 200) {
        // Step 3: Update status of quotation_header to 'allocated'
        final updateStatusUrl =
            'http://192.168.193.197:3000/api/update_status_to_allocated/$selectedEnquiryId';
        final updateStatusResponse = await http.put(Uri.parse(updateStatusUrl));

        // Check if the status update was successful
        if (updateStatusResponse.statusCode == 200) {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            title: 'Work Successfully Allocated',
          );
          print(
              'Work allocated successfully for $unitName with enquiry ID $selectedEnquiryId');
        } else {
          throw Exception('Failed to update status to "allocated"');
        }
      } else {
        throw Exception('Failed to update production unit status to busy');
      }
    } catch (e) {
      if (e.toString().contains('primary key constraint')) {
        print('Error: Work already allocated for this unit and enquiry ID');
      } else {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.warning,
          title: 'This work is already allocated',
        );
        print('Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Production Units'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 8, 8, 8).withOpacity(0.9),
                  spreadRadius: 5,
                  blurRadius: 10,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: _tabController.index == 0
                    ? const Color.fromARGB(255, 19, 216, 25)
                    : const Color.fromARGB(255, 216, 28, 14),
                // Color changes based on selected tab
              ),
              tabs: [
                SizedBox(
                  width: 120,
                  child: Tab(
                    text: 'Active',
                    icon: Icon(Icons.check_circle),
                  ),
                ),
                SizedBox(
                  width: 120,
                  child: Tab(
                    text: 'Busy',
                    icon: Icon(Icons.cancel),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildProductionUnitList('free'),
          _buildProductionUnitList('busy'),
        ],
      ),
    );
  }

  Widget _buildProductionUnitList(String status) {
    return FutureBuilder<List<String>>(
      future: _fetchProductionUnits(status),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final productionUnits = snapshot.data!;
          return ListView.builder(
            itemCount: productionUnits.length,
            itemBuilder: (context, index) {
              final productionUnit = productionUnits[index];
              return Card(
                elevation: 4, // Add elevation for a raised effect
                margin: EdgeInsets.symmetric(
                    vertical: 15, horizontal: 20), // Adjust margins
                child: ListTile(
                  tileColor: status == 'free'
                      ? Colors.lightGreen[100]
                      : const Color.fromARGB(255, 233, 104, 94),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        productionUnit,
                        style: TextStyle(
                          fontWeight: FontWeight.bold, // Make text bold
                          fontSize: 16, // Adjust font size
                          color: status == 'free'
                              ? Colors.green[900]
                              : Color.fromARGB(255, 0, 0, 0),
                          // Set text color based on status
                        ),
                      ),
                      if (status == 'free')
                        Row(
                          children: [
                            Text('EnquiryID'),
                            DropdownButton<String>(
                              value:
                                  selectedEnquiryIds.containsKey(productionUnit)
                                      ? selectedEnquiryIds[productionUnit]
                                      : null,
                              onChanged: (String? newValue) {
                                setState(() {
                                  if (newValue != null &&
                                      enquiryIds.contains(newValue)) {
                                    selectedEnquiryIds[productionUnit] =
                                        newValue;
                                  }
                                });
                              },
                              items: enquiryIds.map<DropdownMenuItem<String>>(
                                (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                },
                              ).toList(),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _allocateWork(productionUnit);
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  Color.fromARGB(255, 40, 147, 40),
                                ),
                              ),
                              child: Text(
                                'Allocate Work',
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  onTap: () {
                    // Handle onTap event
                  },
                ),
              );
            },
          );
        }
      },
    );
  }
}
