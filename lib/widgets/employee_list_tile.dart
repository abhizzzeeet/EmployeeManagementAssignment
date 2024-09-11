import 'package:flutter/material.dart';
import '../models/employee.dart';
import '../viewmodels/employee_view_model.dart';
import 'package:provider/provider.dart';

class EmployeeListTile extends StatelessWidget {
  final Employee employee;

  EmployeeListTile({required this.employee});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(backgroundImage: NetworkImage(employee.avatar)),
      title: Text(employee.name),
      subtitle: Text(employee.email),
      trailing: IconButton(
        icon: Icon(Icons.edit),
        onPressed: () {
          Navigator.pushNamed(context, '/edit', arguments: employee);
        },
      ),
      onLongPress: () {
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
                  Navigator.pop(context);
                },
                child: Text('Delete'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
            ],
          ),
        );
      },
    );
  }
}
