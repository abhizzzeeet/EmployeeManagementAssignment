import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // Import for File class
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

    if (employeeViewModel.countries.isEmpty) {
      employeeViewModel.fetchCountries();
    }

    if (employee != null) {
      _nameController.text = employee.name;
      _emailController.text = employee.email;
      _mobileController.text = employee.mobile;
      _stateController.text = employee.state;
      _districtController.text = employee.district;
      _selectedCountry = employee.country;
      _imageUrl = employee.avatar; // Set image URL from employee data
      print('AddEditEmployeeScreen employee not null');
    } else {
      _imageUrl = null; // No image URL for new employee
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
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: _imageUrl != null
                      ? _imageUrl!.startsWith('http') // Check if URL is a network URL
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
                      : Image.file(
                    File(_imageUrl!),
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
                decoration: InputDecoration(labelText: 'Country'),
                items: employeeViewModel.countries.map((country) {
                  return DropdownMenuItem(
                    value: country.name,
                    child: Row(
                      children: [
                        SizedBox(width: 10),
                        Text(country.name),
                      ],
                    ),
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
                      String formattedDate = DateFormat("yyyy-MM-ddTHH:mm:ss.SSSSSS").format(DateTime.now());
                      if (employee == null) {
                        await employeeViewModel.createEmployee(
                          Employee(
                            id: employeeViewModel.getNextAvailableId().toString(),
                            name: _nameController.text,
                            avatar: _imageUrl ?? '', // Set avatar to local image path or empty
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
                            name: _nameController.text,
                            avatar: _imageUrl ?? '', // Update avatar URL or keep it unchanged
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
