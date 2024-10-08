import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/country.dart';
import '../models/employee.dart';

class EmployeeViewModel extends ChangeNotifier {
  List<Employee> _employees = [];

  List<Employee> get employees => _employees;
  List<Employee> _filteredEmployees = [];

  List<Employee> get filteredEmployees => _filteredEmployees;

  Employee? _currentEmployee;

  Employee? get currentEmployee {
    final tempEmployee = _currentEmployee;
    _currentEmployee = null;
    return tempEmployee;
  }

  List<Country> _countries = [];

  List<Country> get countries => _countries;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<int> _sortedEmployeeIds = []; // Sorted list of employee IDs
  List<int> get sortedEmployeeIds =>
      _sortedEmployeeIds; // Getter for sortedEmployeeIds

  void setCurrentEmployee(Employee? employee) {
    _currentEmployee = employee;
    print("New current Employee: ${_currentEmployee?.name}");
  }

  Future<void> fetchEmployees() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await http.get(Uri.parse(
          'https://669b3f09276e45187d34eb4e.mockapi.io/api/v1/employee'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _employees = data.map((e) => Employee.fromJson(e)).toList();
        _filteredEmployees = _employees;
        // Update the sorted list of IDs
        _sortedEmployeeIds = _employees
            .map((employee) => int.tryParse(employee.id) ?? 0)
            .toList()
          ..sort(); // Sort the list in ascending order
      } else {
        throw Exception('Failed to load employees');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Filter method to handle search logic
  void filterEmployeesById(String searchQuery) {
    try {
      if (searchQuery.isEmpty) {
        _filteredEmployees = _employees; // Reset to full list if query is empty
      } else {
        _filteredEmployees = _employees
            .where((employee) => employee.id.contains(searchQuery))
            .toList();
      }
      notifyListeners(); // Notify the UI to update with the new filtered list
    } catch (e) {
      print('Error filtering employees: $e');
      // Optionally, handle the error or show a message in the UI
      // For example, set a state variable with the error message
    }
  }

  Future<void> fetchCountries() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await http.get(Uri.parse(
          'https://669b3f09276e45187d34eb4e.mockapi.io/api/v1/country'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _countries = data.map((e) => Country.fromJson(e)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load countries');
      }
    } catch (e) {
      print('Error fetching countries: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createEmployee(Employee employee) async {
    final response = await http.post(
      Uri.parse('https://669b3f09276e45187d34eb4e.mockapi.io/api/v1/employee'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(employee.toJson()),
    );
    if (response.statusCode == 201) {
      final newEmployee = Employee.fromJson(json.decode(response.body));
      _employees.add(newEmployee);
      print("Employee added: ${_employees}");
      // Update the sorted list of IDs
      _sortedEmployeeIds.add(int.tryParse(newEmployee.id) ?? 0);
      _sortedEmployeeIds.sort(); // Sort after adding a new ID

      notifyListeners();
    }
  }

  Future<void> deleteEmployee(String id) async {
    final response = await http.delete(Uri.parse(
        'https://669b3f09276e45187d34eb4e.mockapi.io/api/v1/employee/$id'));
    if (response.statusCode == 200) {
      _employees.removeWhere((employee) => employee.id == id);

      // Update the sorted list of IDs
      _sortedEmployeeIds.remove(int.tryParse(id) ?? 0);

      notifyListeners();
    }
  }

  Future<void> updateEmployee(Employee employee) async {
    print("vieModel: ${employee.country}");
    final response = await http.put(
      Uri.parse(
          'https://669b3f09276e45187d34eb4e.mockapi.io/api/v1/employee/${employee.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(employee.toJson()),
    );
    if (response.statusCode == 200) {
      final index = _employees.indexWhere((e) => e.id == employee.id);
      if (index != -1) {
        _employees[index] = employee;
        notifyListeners();
      }
    }
  }

  // Helper method to get the next available ID
  int getNextAvailableId() {
    if (_sortedEmployeeIds.isEmpty) return 1;
    return _sortedEmployeeIds.last +
        1; // Return the next ID after the current max
  }

  // Fetch employee by ID from the list
  Employee fetchEmployeeById(String id) {
      return _employees.firstWhere((employee) => employee.id == id);
  }

}
