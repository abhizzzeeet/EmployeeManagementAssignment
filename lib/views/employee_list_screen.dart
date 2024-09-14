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
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF603FEF), // Background color
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(30), // Curved bottom corners
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 8.0), // Added upper padding
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Employee List',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0), // Increased padding
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8.0), // Bottom margin
                    decoration: BoxDecoration(
                      color: Colors.white, // TextField background color
                      borderRadius: BorderRadius.circular(20), // Curved border
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        border: InputBorder.none, // Remove default border
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        hintText: 'Search by employee ID',
                        hintStyle: TextStyle(color: Colors.black45),
                      ),
                      style: TextStyle(color: Colors.black), // Text color
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<EmployeeViewModel>(
              builder: (context, viewModel, child) {
                return viewModel.isLoading
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8.0), // Reduce distance between containers
                  itemCount: viewModel.filteredEmployees.length,
                  itemBuilder: (context, index) {
                    final filteredEmployee = viewModel.filteredEmployees[index];
                    return EmployeeListTile(
                      employee: filteredEmployee,
                    );
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
        backgroundColor: Color(0xFF603FEF), // FloatingActionButton background color
        shape: CircleBorder(), // Circular shape
        child: Icon(Icons.add, color: Colors.white), // White icon color
      ),
    );
  }
}
