import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/employee.dart';
import '../viewmodels/employee_view_model.dart';

class AddEditEmployeeScreen extends StatefulWidget {
  @override
  _AddEditEmployeeScreenState createState() => _AddEditEmployeeScreenState();
}

class _AddEditEmployeeScreenState extends State<AddEditEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _mobileController;
  late TextEditingController _stateController;
  late TextEditingController _districtController;
  String? _selectedCountry;


  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _stateController.dispose();
    _districtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final employee = ModalRoute.of(context)!.settings.arguments as Employee?;

    final employeeViewModel = Provider.of<EmployeeViewModel>(context);
    _nameController = TextEditingController(text: employee?.name ?? '');
    _emailController = TextEditingController(text: employee?.email ?? '');
    _mobileController = TextEditingController(text: employee?.mobile ?? '');
    _stateController = TextEditingController(text: employee?.state ?? '');
    _districtController = TextEditingController(text: employee?.district ?? '');
    _selectedCountry = employee?.country ?? null;
    if(employee!=null){
      print('AddEditEmployeeScreen employee not null');
    }else{
      print('AddEditEmployeeScreen employee null');
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(employee == null ? 'Add Employee' : 'Edit Employee'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _mobileController,
                decoration: InputDecoration(labelText: 'Mobile'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a mobile number';
                  }
                  return null;
                },
              ),
              // DropdownButtonFormField<String>(
              //   value: _selectedCountry,
              //   decoration: InputDecoration(labelText: 'Country'),
              //   items: employeeViewModel.countries.map((country) {
              //     return DropdownMenuItem(
              //       value: country,
              //       child: Text(country),
              //     );
              //   }).toList(),
              //   onChanged: (value) {
              //     setState(() {
              //       _selectedCountry = value;
              //     });
              //   },
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Please select a country';
              //     }
              //     return null;
              //   },
              // ),
              TextFormField(
                controller: _stateController,
                decoration: InputDecoration(labelText: 'State'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a state';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _districtController,
                decoration: InputDecoration(labelText: 'District'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a district';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (employee == null) {
                      // employeeViewModel.createEmployee(
                      //   Employee(
                      //     name: _nameController.text,
                      //     email: _emailController.text,
                      //     mobile: _mobileController.text,
                      //     country: _selectedCountry!,
                      //     state: _stateController.text,
                      //     district: _districtController.text,
                      //   ),
                      // );
                    } else {
                      employeeViewModel.updateEmployee(
                        Employee(
                          id: employee!.id,
                          avatar: '',
                          name: _nameController.text,
                          email: _emailController.text,
                          mobile: _mobileController.text,
                          country: _selectedCountry!,
                          state: _stateController.text,
                          district: _districtController.text,
                        ),
                      );
                    }
                    Navigator.pop(context);
                  }
                },
                child: Text(employee == null ? 'Add Employee' : 'Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
