import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/providers/medical_provider.dart';
import 'package:workout_tracker/models/medical_data.dart';
import 'package:workout_tracker/models/measurement_types.dart';
import 'package:intl/intl.dart';

class AddMedicalDataDialog extends StatefulWidget {
  final MedicalData? medicalData;

  const AddMedicalDataDialog({
    super.key,
    this.medicalData,
  });

  @override
  State<AddMedicalDataDialog> createState() => _AddMedicalDataDialogState();
}

class _AddMedicalDataDialogState extends State<AddMedicalDataDialog> {
  final _formKey = GlobalKey<FormState>();
  final _typeController = TextEditingController();
  final _valueController = TextEditingController();
  final _unitController = TextEditingController();
  final _notesController = TextEditingController();
  String _selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    if (widget.medicalData != null) {
      _typeController.text = widget.medicalData!.type;
      _valueController.text = widget.medicalData!.value.toString();
      _unitController.text = widget.medicalData!.unit ?? '';
      _notesController.text = widget.medicalData!.notes ?? '';
      _selectedDate = widget.medicalData!.date;
    }
  }

  @override
  void dispose() {
    _typeController.dispose();
    _valueController.dispose();
    _unitController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.medicalData == null ? 'Add Medical Data' : 'Edit Medical Data'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Autocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text.isEmpty) {
                    return MeasurementTypes.predefinedTypes;
                  }
                  return MeasurementTypes.predefinedTypes.where((type) =>
                      type.toLowerCase().contains(textEditingValue.text.toLowerCase()));
                },
                fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                  return TextFormField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      labelText: 'Measurement Type',
                      hintText: 'Select or type measurement type',
                      filled: true,
                      fillColor: const Color(0xFF294034),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a measurement type';
                      }
                      return null;
                    },
                  );
                },
                onSelected: (String selection) {
                  _typeController.text = selection;
                  _setDefaultUnit(selection);
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _valueController,
                      decoration: InputDecoration(
                        labelText: 'Value',
                        hintText: '70.5',
                        filled: true,
                        fillColor: const Color(0xFF294034),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        final val = double.tryParse(value);
                        if (val == null) {
                          return 'Invalid';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _unitController,
                      decoration: InputDecoration(
                        labelText: 'Unit',
                        hintText: 'kg',
                        filled: true,
                        fillColor: const Color(0xFF294034),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: _selectDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Date',
                    border: OutlineInputBorder(),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('MMM dd, yyyy').format(DateTime.parse(_selectedDate)),
                        style: const TextStyle(color: Colors.white),
                      ),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                decoration: InputDecoration(
                  labelText: 'Notes (optional)',
                  hintText: 'Any additional information',
                  filled: true,
                  fillColor: const Color(0xFF294034),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveMedicalData,
          child: Text(widget.medicalData == null ? 'Add' : 'Update'),
        ),
      ],
    );
  }

  void _setDefaultUnit(String type) {
    final defaultUnit = MeasurementTypes.getDefaultUnit(type);
    if (defaultUnit.isNotEmpty) {
      _unitController.text = defaultUnit;
    }
  }

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.parse(_selectedDate),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.green,
              onPrimary: Colors.white,
              surface: Color(0xFF1E1E1E),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _saveMedicalData() async {
    if (_formKey.currentState!.validate()) {
      final medicalData = MedicalData(
        id: widget.medicalData?.id,
        date: _selectedDate,
        type: _typeController.text.trim(),
        value: double.parse(_valueController.text),
        unit: _unitController.text.trim().isEmpty ? null : _unitController.text.trim(),
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      );

      final medicalProvider = context.read<MedicalProvider>();
      
      if (widget.medicalData == null) {
        await medicalProvider.addMedicalData(medicalData);
      } else {
        await medicalProvider.updateMedicalData(medicalData);
      }

      Navigator.of(context).pop();
    }
  }
} 