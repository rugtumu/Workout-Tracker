import 'package:flutter/material.dart';
import 'package:fitness_tracker/models/medical_data.dart';
import 'package:intl/intl.dart';

class MedicalDataCard extends StatelessWidget {
  final MedicalData medicalData;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const MedicalDataCard({
    super.key,
    required this.medicalData,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    medicalData.type,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      onEdit();
                    } else if (value == 'delete') {
                      onDelete();
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 16),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 16, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Delete', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                  child: const Icon(Icons.more_vert),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildValueChip(
                  '${medicalData.value}${medicalData.unit != null ? ' ${medicalData.unit}' : ''}',
                  _getColorForType(medicalData.type),
                ),
              ],
            ),
            if (medicalData.notes != null && medicalData.notes!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                medicalData.notes!,
                style: const TextStyle(
                  color: Colors.white70,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
            const SizedBox(height: 8),
            Text(
              DateFormat('MMM dd, yyyy').format(DateTime.parse(medicalData.date)),
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildValueChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _getColorForType(String type) {
    switch (type.toLowerCase()) {
      case 'weight':
        return Colors.blue;
      case 'height':
        return Colors.green;
      case 'body fat':
      case 'bodyfat':
        return Colors.orange;
      case 'blood pressure':
      case 'bp':
        return Colors.red;
      case 'heart rate':
      case 'hr':
        return Colors.purple;
      case 'vitamin d':
      case 'vitamin d3':
        return Colors.yellow;
      case 'cholesterol':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }
} 