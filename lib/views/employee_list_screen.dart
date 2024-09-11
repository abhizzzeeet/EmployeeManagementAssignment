import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/employee_view_model.dart';
import '../widgets/employee_list_tile.dart';

class EmployeeListScreen extends StatefulWidget {
  @override
  _EmployeeListScreenState createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  @override
  void initState() {
    super.initState();
    // Call fetchEmployees when the screen is first built
    Future.microtask(() => Provider.of<EmployeeViewModel>(context, listen: false).fetchEmployees());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Employee List')),
      body: Consumer<EmployeeViewModel>(
        builder: (context, viewModel, child) {
          return viewModel.isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
            itemCount: viewModel.employees.length,
            itemBuilder: (context, index) {
              final employee = viewModel.employees[index];
              return EmployeeListTile(employee: employee);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
