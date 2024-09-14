import 'package:employee_management/viewmodels/employee_view_model.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../models/employee.dart';

class EmployeeDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final employeeViewModel = Provider.of<EmployeeViewModel>(context, listen: false);
    final id = ModalRoute.of(context)!.settings.arguments as String;
    employeeViewModel.filterEmployeesById(id);

    // After filtering, assign the found employee to the local variable
    Employee? employee;
    if (employeeViewModel.filteredEmployees.isNotEmpty) {
      employee = employeeViewModel.filteredEmployees.first;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${employee?.name ?? 'Employee'} Details',
          style: TextStyle(color: Colors.white), // White text color
        ),
        backgroundColor: Color(0xFF603FEF), // AppBar background color
        iconTheme: IconThemeData(color: Colors.white), // White icon color
        actions: [
          if (employee != null)
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.pushNamed(context, '/edit', arguments: employee);
              },
            ),
        ],
      ),
      body: Container(
        color: Color(0xFFEFEFEF), // Background color for the rest of the body
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              // Container with white background and curved borders
              Container(
                decoration: BoxDecoration(
                  color: Colors.white, // Background color of the ListView content
                  borderRadius: BorderRadius.circular(20), // Curved border
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Center(
                      child: CachedNetworkImage(
                        imageUrl: employee?.avatar ?? '', // Replace with the actual image URL
                        placeholder: (context, url) => CircleAvatar(
                          backgroundColor: Colors.grey[200],
                          child: Icon(Icons.person, color: Colors.grey[600]),
                        ),
                        errorWidget: (context, url, error) => CircleAvatar(
                          backgroundColor: Colors.grey[200],
                          child: Icon(Icons.person, color: Colors.grey[600]),
                        ),
                        width: 100, // Adjust width as needed
                        height: 100, // Adjust height as needed
                        fit: BoxFit.cover, // Ensures the image covers the boundary
                      ),
                    ),
                    SizedBox(height: 16),
                    ListTile(
                      leading: Icon(Icons.person, color: Colors.black54),
                      title: Text('Name'),
                      subtitle: Text(employee?.name ?? 'N/A'),
                    ),
                    ListTile(
                      leading: Icon(Icons.email, color: Colors.black54),
                      title: Text('Email'),
                      subtitle: Text(employee?.email ?? 'N/A'),
                    ),
                    ListTile(
                      leading: Icon(Icons.phone, color: Colors.black54),
                      title: Text('Mobile'),
                      subtitle: Text(employee?.mobile ?? 'N/A'),
                    ),
                    ListTile(
                      leading: Icon(Icons.location_on, color: Colors.black54),
                      title: Text('Country'),
                      subtitle: Text(employee?.country ?? 'N/A'),
                    ),
                    ListTile(
                      leading: Icon(Icons.location_city, color: Colors.black54),
                      title: Text('State'),
                      subtitle: Text(employee?.state ?? 'N/A'),
                    ),
                    ListTile(
                      leading: Icon(Icons.location_pin, color: Colors.black54),
                      title: Text('District'),
                      subtitle: Text(employee?.district ?? 'N/A'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
