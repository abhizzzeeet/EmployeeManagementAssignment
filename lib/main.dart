import 'package:employee_management/views/add_edit_employee_screen.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/employee_view_model.dart';
import 'views/employee_details_screen.dart';
import 'views/employee_list_screen.dart';
// import 'views/add_edit_employee_screen.dart';
// import 'views/employee_details_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EmployeeViewModel()),
      ],
      child: MaterialApp(
        title: 'Employee Management',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/',
        routes: {
          '/': (context) => EmployeeListScreen(),
          '/add': (context) => AddEditEmployeeScreen(),
          '/edit': (context) => AddEditEmployeeScreen(),
          '/details': (context) => EmployeeDetailsScreen(),
        },
      ),
    );
  }
}
