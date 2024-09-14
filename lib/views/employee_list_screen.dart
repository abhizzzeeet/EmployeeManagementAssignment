import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/employee_view_model.dart';
import '../widgets/employee_list_tile.dart';

class EmployeeListScreen extends StatefulWidget {
  @override
  _EmployeeListScreenState createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Call fetchEmployees when the screen is first built
    Future.microtask(() => Provider.of<EmployeeViewModel>(context, listen: false).fetchEmployees());
    _searchController.addListener(() {
      final query = _searchController.text;
      Provider.of<EmployeeViewModel>(context, listen: false)
          .filterEmployeesById(query);
    });
  }

  

  @override
  Widget build(BuildContext context) {
    _searchController.text = '';
    return Scaffold(
      appBar: AppBar(title: Text('Employee List')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by Employee ID',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: Consumer<EmployeeViewModel>(
              builder: (context, viewModel, child) {
                return viewModel.isLoading
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                  itemCount: viewModel.filteredEmployees.length,
                  itemBuilder: (context, index) {
                    final filteredEmployee = viewModel.filteredEmployees[index];
                    return EmployeeListTile(employee: filteredEmployee);
                  },
                );
              },
            ),
          ),
        ],
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
