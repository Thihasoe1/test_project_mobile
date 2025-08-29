import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:test_project_mobile/core/custom_widgets/custom_text.dart';
import '../../models/product_model.dart';
import '../../providers/product_provider.dart';

class AddProductForm extends StatefulWidget {
  const AddProductForm({super.key});

  @override
  State<AddProductForm> createState() => _AddProductFormState();
}

class _AddProductFormState extends State<AddProductForm> {
  final _formKey = GlobalKey<FormState>();

  // // Form values
  // late String machineName = '';
  // late double temperature = 0.0;
  // late double pressure = 0.0;
  // late int speed = 0;
  late String status = 'running';
  DateTime? createdAt;

  // Status options
  final List<String> statusOptions = [
    'running',
    'stopped',
    'maintenance',
    'idle',
  ];

  // Controllers for text fields
  final TextEditingController _machineNameController = TextEditingController();
  final TextEditingController _temperatureController = TextEditingController();
  final TextEditingController _pressureController = TextEditingController();
  final TextEditingController _speedController = TextEditingController();

  @override
  void dispose() {
    _temperatureController.dispose();
    _pressureController.dispose();
    _speedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Add Product')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                /// Machine Name
                CustomTextFormField(
                  machineNameController: _machineNameController,
                  labelText: 'Machine Name',
                ),
                const SizedBox(height: 16),
                /// Temperature
                CustomTextFormField(
                  machineNameController: _temperatureController,
                  labelText: 'Temperature (°C)',
                ),
                const SizedBox(height: 16),
                /// Pressure
                CustomTextFormField(machineNameController: _pressureController,
                  labelText: 'Pressure (bar)'),
                const SizedBox(height: 16),
                /// Speed
                CustomTextFormField(machineNameController: _speedController,
                  labelText: 'Speed (RPM)'),
                const SizedBox(height: 16),

                /// Status Dropdown
                DropdownButtonFormField<String>(
                  value: status,
                  decoration: const InputDecoration(
                    labelText: 'Status',
                    border: OutlineInputBorder(),
                  ),
                  items:
                      statusOptions.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a status';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      status = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Created At (Date & Time Picker)
                ListTile(
                  title: Text(
                    createdAt == null
                        ? 'Select Creation Date & Time'
                        : 'Created At: ${DateFormat('yyyy-MM-dd HH:mm').format(createdAt!)}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );

                    if (pickedDate != null) {
                      final TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );

                      if (pickedTime != null) {
                        setState(() {
                          createdAt = DateTime(
                            pickedDate.year,
                            pickedDate.month,
                            pickedDate.day,
                            pickedTime.hour,
                            pickedTime.minute,
                          );
                        });
                      }
                    }
                  },
                ),
                const SizedBox(height: 16),

                /// Submit Button
                ///
                InkWell(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      final product = Product(
                        machineName: _machineNameController.text.trim(),
                        temperature: double.parse(
                          _temperatureController.text.trim(),
                        ),
                        pressure: double.parse(_pressureController.text.trim()),
                        speed: int.parse(_speedController.text.trim()),
                        status: status,
                        createdAt: createdAt ?? DateTime.now(),
                      );

                      provider.addMachine(product);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Product added successfully!'),
                        ),
                      );
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    height: 50,
                    child: Center(
                      child: CustomText(
                        text: "Add Product",
                        textColor: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                // ElevatedButton(
                //   onPressed: () {
                //     if (_formKey.currentState!.validate()) {
                //       _formKey.currentState!.save();
                //
                //       final product = Product(
                //         machineName: _machineNameController.text.trim(),
                //         temperature: double.parse(
                //           _temperatureController.text.trim(),
                //         ),
                //         pressure: double.parse(_pressureController.text.trim()),
                //         speed: int.parse(_speedController.text.trim()),
                //         status: status,
                //         createdAt: createdAt ?? DateTime.now(),
                //       );
                //
                //       provider.addMachine(product);
                //
                //       ScaffoldMessenger.of(context).showSnackBar(
                //         const SnackBar(
                //           content: Text('Product added successfully!'),
                //         ),
                //       );
                //     }
                //   },
                //   style: ElevatedButton.styleFrom(
                //     padding: const EdgeInsets.symmetric(vertical: 16),
                //     textStyle: const TextStyle(fontSize: 18),
                //   ),
                //   child: const Text('Add Product'),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required TextEditingController machineNameController,
    this.labelText,
  }) : _machineNameController = machineNameController;

  final TextEditingController _machineNameController;
  final String? labelText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _machineNameController,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $labelText';
        }
        return null;
      },
    );
  }
}
