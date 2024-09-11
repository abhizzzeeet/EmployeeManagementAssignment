import 'package:flutter/material.dart';
import '../models/employee.dart';

class EmployeeDetailsScreen extends StatelessWidget {
  final Employee employee;

  EmployeeDetailsScreen({required this.employee});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${employee.name} Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/edit',
                arguments: employee,
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
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
