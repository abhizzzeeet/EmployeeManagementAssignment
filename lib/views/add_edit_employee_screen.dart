import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/country.dart';
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
  String _buttonText = '';
  String? _imageUrl; // Store image URL
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _mobileController = TextEditingController();
    _stateController = TextEditingController();
    _districtController = TextEditingController();

    // Ensure this runs after the initial build to access passed data via ModalRoute
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final employee = ModalRoute.of(context)!.settings.arguments as Employee?;

      if (employee != null) {
        // Initialize controllers with the passed employee data
        _nameController.text = employee.name;
        _emailController.text = employee.email;
        _mobileController.text = employee.mobile;
        _stateController.text = employee.state;
        _districtController.text = employee.district;
        setState(() {
          _imageUrl = employee.avatar;
          _selectedCountry = employee.country; // Call setState to reflect in dropdown
          _buttonText = 'Save Changes';
        });
        print('EditEmployeeScreen employee initialized');
      } else {
        setState(() {
          _imageUrl = null;
          _buttonText = 'Add Employee';
        });
      }
    });
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

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageUrl = pickedFile.path; // Set image URL to local file path
      });
    }
    print("ImageUrl set locally: $_imageUrl");
  }

  @override
  Widget build(BuildContext context) {
    final employee = ModalRoute.of(context)!.settings.arguments as Employee?;
    final employeeViewModel = Provider.of<EmployeeViewModel>(context);

    // Fetch countries if not already fetched
    if (employeeViewModel.countries.isEmpty) {
      employeeViewModel.fetchCountries();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Employee',
          style: TextStyle(color: Colors.white), // White text color
        ),
        backgroundColor: Color(0xFF603FEF), // AppBar background color
        iconTheme: IconThemeData(color: Colors.white), // White icon color
      ),
      body: Container(
        color: Color(0xFFEFEFEF), // Background color for the rest of the body
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white, // Background color of the form container
                borderRadius: BorderRadius.circular(20), // Curved border
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    shrinkWrap: true, // Ensure ListView wraps content
                    children: [
                      Center(
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: _imageUrl != null
                              ? CachedNetworkImage(
                            imageUrl: _imageUrl!,
                            placeholder: (context, url) => CircleAvatar(
                              backgroundColor: Colors.grey[200],
                              child: Icon(Icons.image, color: Colors.grey[600]),
                            ),
                            errorWidget: (context, url, error) => CircleAvatar(
                              backgroundColor: Colors.grey[200],
                              child: Icon(Icons.person, color: Colors.grey[600]),
                            ),
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          )
                              : CircleAvatar(
                            backgroundColor: Colors.grey[200],
                            child: Icon(Icons.add_a_photo, color: Colors.grey[600]),
                            radius: 50,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          prefixIcon: Icon(Icons.person, color: Colors.black54), // Icon for name
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a name';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email, color: Colors.black54), // Icon for email
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an email';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _mobileController,
                        decoration: InputDecoration(
                          labelText: 'Mobile',
                          prefixIcon: Icon(Icons.phone, color: Colors.black54), // Icon for mobile
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a mobile number';
                          }
                          return null;
                        },
                      ),
                      DropdownButtonFormField<String>(
                        value: _selectedCountry != null
                            ? employeeViewModel.countries
                            .firstWhere(
                              (country) => country.name.toLowerCase() == _selectedCountry!.toLowerCase(),
                          orElse: () {
                            final newCountry = Country(id: '', name: _selectedCountry!, flag: '');
                            employeeViewModel.countries.add(newCountry);
                            return newCountry;
                          },
                        )
                            ?.name
                            : null,
                        decoration: InputDecoration(
                          labelText: 'Country',
                          prefixIcon: Icon(Icons.location_on, color: Colors.black54), // Icon for country
                        ),
                        items: employeeViewModel.countries.map((country) {
                          return DropdownMenuItem(
                            value: country.name,
                            child: Text(country.name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCountry = value;
                          });
                        },
                        validator: (value) => value == null || value.isEmpty ? 'Please select a country' : null,
                      ),
                      TextFormField(
                        controller: _stateController,
                        decoration: InputDecoration(
                          labelText: 'State',
                          prefixIcon: Icon(Icons.location_city, color: Colors.black54), // Icon for state
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a state';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _districtController,
                        decoration: InputDecoration(
                          labelText: 'District',
                          prefixIcon: Icon(Icons.location_pin, color: Colors.black54), // Icon for district
                        ),
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
                                    avatar: _imageUrl ??'',
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
                                    id: employee.id,
                                    avatar: _imageUrl ??'',
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
                        child: Text(
                          _buttonText,
                          style: TextStyle(color: Color(0xFF603FEF)), // Button text color
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
