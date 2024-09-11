// import 'package:flutter/material.dart';
// import '../models/employee.dart';
//
// class EmployeeForm extends StatefulWidget {
//   final Employee? employee;
//   final Function(Employee) onSave;
//
//   EmployeeForm({required this.employee, required this.onSave});
//
//   @override
//   _EmployeeFormState createState() => _EmployeeFormState();
// }
//
// class _EmployeeFormState extends State<EmployeeForm> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _mobileController = TextEditingController();
//   final _countryController = TextEditingController();
//   final _stateController = TextEditingController();
//   final _districtController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     if (widget.employee != null) {
//       _nameController.text = widget.employee!.name;
//       _emailController.text = widget.employee!.email;
//       _mobileController.text = widget.employee!.mobile;
//       _countryController.text = widget.employee!.country;
//       _stateController.text = widget.employee!.state;
//       _districtController.text = widget.employee!.district;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: _formKey,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           TextFormField(
//             controller: _nameController,
//             decoration: InputDecoration(labelText: 'Name'),
//             validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
//           ),
//           TextFormField(
//             controller: _emailController,
//             decoration: InputDecoration(labelText: 'Email'),
//             validator: (value) => value!.isEmpty ? 'Please enter an email' : null,
//           ),
//           TextFormField(
//             controller: _mobileController,
//             decoration: InputDecoration(labelText: 'Mobile'),
//             validator: (value) => value!.isEmpty ? 'Please enter a mobile number' : null,
//           ),
//           TextFormField(
//             controller: _countryController,
//             decoration: InputDecoration(labelText: 'Country'),
//             validator: (value) => value!.isEmpty ? 'Please enter a country' : null,
//           ),
//           TextFormField(
//             controller: _stateController,
//             decoration: InputDecoration(labelText: 'State'),
//             validator: (value) => value!.isEmpty ? 'Please enter a state' : null,
//           ),
//           TextFormField(
//             controller: _districtController,
//             decoration: InputDecoration(labelText: 'District'),
//             validator: (value) => value!.isEmpty ? 'Please enter a district' : null,
//           ),
//           SizedBox(height: 16),
//           ElevatedButton(
//             onPressed: () {
//               if (_formKey.currentState!.validate()) {
//                 final employee = Employee(
//                   id: widget.employee?.id ?? DateTime.now().toString(), // Generate new ID if creating
//                   name: _nameController.text,
//                   email: _emailController.text,
//                   mobile: _mobileController.text,
//                   country: _countryController.text,
//                   state: _stateController.text,
//                   district: _districtController.text,
//                   avatar: widget.employee?.avatar ?? '', // Placeholder for avatar
//                 );
//                 widget.onSave(employee);
//               }
//             },
//             child: Text('Save'),
//           ),
//         ],
//       ),
//     );
//   }
// }
