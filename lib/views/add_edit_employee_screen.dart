import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _mobileController = TextEditingController();
    _stateController = TextEditingController();
    _districtController = TextEditingController();
  }

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

    // Fetch countries if not already fetched
    if (employeeViewModel.countries.isEmpty) {
      employeeViewModel.fetchCountries();
    }

    if(employee!=null){
      _nameController.text = employee.name;
      _emailController.text = employee.email;
      _mobileController.text = employee.mobile;
      _stateController.text = employee.state;
      _districtController.text = employee.district;
      _selectedCountry = employee.country;
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
              DropdownButtonFormField<String>(
                value: _selectedCountry,
                decoration: InputDecoration(labelText: 'Country'),
                items: employeeViewModel.countries.map((country) {
                  return DropdownMenuItem(
                    value: country.name,
                    child: Row(
                      children: [
                        // Image.network(
                        //   country.flag,
                        //   width: 25,
                        //   height: 25,
                        //   fit: BoxFit.cover,
                        // ),
                        // SizedBox(width: 10),
                        Text(country.name),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCountry = value;
                    print("value passed in selectedCountry: ${_selectedCountry}");
                  });
                },
                validator: (value) => value == null || value.isEmpty ? 'Please select a country' : null,
              ),
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
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      // Get the current date and time in ISO 8601 format
                      String formattedDate = DateFormat("yyyy-MM-ddTHH:mm:ss.SSSSSS").format(DateTime.now());
                      if (employee == null) {
                        await employeeViewModel.createEmployee(
                          Employee(
                            id: employeeViewModel.getNextAvailableId().toString(),
                            name: _nameController.text,
                            avatar: '',
                            email: _emailController.text,
                            mobile: _mobileController.text,
                            country: _selectedCountry!,
                            state: _stateController.text,
                            district: _districtController.text,
                            createdAt: formattedDate,
                          ),
                        );
                        print('Employee successfully added');
                      } else {
                        await employeeViewModel.updateEmployee(
                          Employee(
                            id: employee!.id,
                            avatar: '',
                            name: _nameController.text,
                            email: _emailController.text,
                            mobile: _mobileController.text,
                            country: _selectedCountry!,
                            state: _stateController.text,
                            district: _districtController.text,
                            createdAt: employee.createdAt,
                          ),
                        );
                        print('Employee successfully updated');
                      }

                      // After successful operation, go back to the previous screen
                      Navigator.pop(context);
                    } catch (error) {
                      print('Error: $error');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to save employee data: $error')),
                      );
                    }
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
