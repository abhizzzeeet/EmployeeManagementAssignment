import 'package:employee_management/viewmodels/employee_view_model.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../models/employee.dart';

class EmployeeDetailsScreen extends StatelessWidget {


  late Employee employee;

  @override
  Widget build(BuildContext context) {
    final employeeViewModel = Provider.of<EmployeeViewModel>(context, listen: false);
    final id = ModalRoute.of(context)!.settings.arguments as String;
    employeeViewModel.filterEmployeesById(id);

    // After filtering, assign the found employee to the local variable
    if (employeeViewModel.filteredEmployees.isNotEmpty) {
      employee = employeeViewModel.filteredEmployees.first;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${employee.name} Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // employeeViewModel.setCurrentEmployee(employee);
              Navigator.pushNamed(context, '/edit', arguments: employee);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Add CachedNetworkImage widget to display employee avatar
            Center(
              child: CachedNetworkImage(
                imageUrl: employee.avatar, // Replace with the actual image URL
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
              title: Text('Name'),
              subtitle: Text(employee.name),
            ),
            ListTile(
              title: Text('Email'),
              subtitle: Text(employee.email ?? 'N/A'),
            ),
            ListTile(
              title: Text('Mobile'),
              subtitle: Text(employee.mobile),
            ),
            ListTile(
              title: Text('Country'),
              subtitle: Text(employee.country),
            ),
            ListTile(
              title: Text('State'),
              subtitle: Text(employee.state),
            ),
            ListTile(
              title: Text('District'),
              subtitle: Text(employee.district),
            ),
          ],
        ),
      ),
    );
  }
}
