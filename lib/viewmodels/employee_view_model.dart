import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/employee.dart';

class EmployeeViewModel extends ChangeNotifier {
  List<Employee> _employees = [];
  List<Employee> get employees => _employees;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchEmployees() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await http.get(Uri.parse('https://669b3f09276e45187d34eb4e.mockapi.io/api/v1/employee'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _employees = data.map((e) => Employee.fromJson(e)).toList();
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

  Future<void> createEmployee(Employee employee) async {
    final response = await http.post(
      Uri.parse('https://669b3f09276e45187d34eb4e.mockapi.io/api/v1/employee'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(employee.toJson()),
    );
    if (response.statusCode == 201) {
      _employees.add(Employee.fromJson(json.decode(response.body)));
      notifyListeners();
    }
  }

  Future<void> deleteEmployee(String id) async {
    final response = await http.delete(Uri.parse('https://669b3f09276e45187d34eb4e.mockapi.io/api/v1/employee/$id'));
    if (response.statusCode == 200) {
      _employees.removeWhere((employee) => employee.id == id);
      notifyListeners();
    }
  }

  Future<void> updateEmployee(Employee employee) async {
    final response = await http.put(
      Uri.parse('https://669b3f09276e45187d34eb4e.mockapi.io/api/v1/employee/${employee.id}'),
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
}
