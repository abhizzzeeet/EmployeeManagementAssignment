import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../models/employee.dart';
import '../viewmodels/employee_view_model.dart';
import 'package:provider/provider.dart';

class EmployeeListTile extends StatelessWidget {
  final Employee employee;

  EmployeeListTile({required this.employee});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigates to EmployeeDetailsScreen on tap of the ListTile
        Navigator.pushNamed(context, '/details', arguments: employee);
      },
      onLongPress: () {
        // Show delete confirmation dialog on long press
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Delete'),
            content: Text('Are you sure you want to delete this employee?'),
            actions: [
              TextButton(
                onPressed: () async {
                  await Provider.of<EmployeeViewModel>(context, listen: false)
                      .deleteEmployee(employee.id);
                  Navigator.pop(context); // Close the dialog
                },
                child: Text('Delete'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context), // Cancel action
                child: Text('Cancel'),
              ),
            ],
          ),
        );
      },
      child: ListTile(
        leading: CachedNetworkImage(
          imageUrl: employee.avatar,
          placeholder: (context, url) => CircleAvatar(
            backgroundColor: Colors.grey[200],
            child: Icon(Icons.person, color: Colors.grey[600]),
          ),
          errorWidget: (context, url, error) => CircleAvatar(
            backgroundColor: Colors.grey[200],
            child: Icon(Icons.person, color: Colors.grey[600]),
          ),
          fit: BoxFit.cover, // Ensures the image covers the boundary
        ),
        title: Text(employee.name),
        subtitle: Text('ID: ${employee.id}'),
        trailing: IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            // Navigates to AddEditEmployeeScreen when edit button is pressed
            Navigator.pushNamed(context, '/edit', arguments: employee);
          },
        ),
      ),
    );
  }
}
