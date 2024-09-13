import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/employee.dart';

class EmployeeDetailsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final Employee employee = ModalRoute.of(context)!.settings.arguments as Employee;
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
                  child: Icon(Icons.error, color: Colors.grey[600]),
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
