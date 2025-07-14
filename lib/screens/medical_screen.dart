import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/providers/medical_provider.dart';
import 'package:workout_tracker/widgets/medical_data_card.dart';
import 'package:workout_tracker/widgets/add_medical_data_dialog.dart';
import 'package:workout_tracker/widgets/medical_chart.dart';
import 'package:intl/intl.dart';

class MedicalScreen extends StatefulWidget {
  const MedicalScreen({super.key});

  @override
  State<MedicalScreen> createState() => _MedicalScreenState();
}

class _MedicalScreenState extends State<MedicalScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedType = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MedicalProvider>().loadMedicalData();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical Data'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.green,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white54,
          tabs: const [
            Tab(text: 'Data'),
            Tab(text: 'Trends'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDataTab(),
          _buildTrendsTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddMedicalDataDialog,
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildDataTab() {
    return Consumer<MedicalProvider>(
      builder: (context, medicalProvider, child) {
        if (medicalProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (medicalProvider.error.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  medicalProvider.error,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => medicalProvider.loadMedicalData(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (medicalProvider.medicalData.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.health_and_safety,
                  size: 64,
                  color: Colors.white54,
                ),
                const SizedBox(height: 16),
                const Text(
                  'No medical data recorded',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white54,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Tap the + button to add your first medical data!',
                  style: TextStyle(
                    color: Colors.white38,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: medicalProvider.medicalData.length,
          itemBuilder: (context, index) {
            return MedicalDataCard(
              medicalData: medicalProvider.medicalData[index],
              onEdit: () => _showEditMedicalDataDialog(medicalProvider.medicalData[index]),
              onDelete: () => _deleteMedicalData(medicalProvider.medicalData[index].id!),
            );
          },
        );
      },
    );
  }

  Widget _buildTrendsTab() {
    return Consumer<MedicalProvider>(
      builder: (context, medicalProvider, child) {
        if (medicalProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final types = medicalProvider.getUniqueTypes();
        
        if (types.isEmpty) {
          return const Center(
            child: Text(
              'No medical data available for trend analysis',
              style: TextStyle(color: Colors.white54),
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Medical Trends',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...types.map((type) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          type,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        MedicalChart(
                          dataType: type,
                          medicalData: medicalProvider.getMedicalDataByTypeMap()[type] ?? [],
                        ),
                        const SizedBox(height: 24),
                      ],
                    )),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showAddMedicalDataDialog() {
    showDialog(
      context: context,
      builder: (context) => const AddMedicalDataDialog(),
    );
  }

  void _showEditMedicalDataDialog(dynamic medicalData) {
    showDialog(
      context: context,
      builder: (context) => AddMedicalDataDialog(
        medicalData: medicalData,
      ),
    );
  }

  void _deleteMedicalData(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Medical Data'),
        content: const Text('Are you sure you want to delete this medical data?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<MedicalProvider>().deleteMedicalData(id);
              Navigator.of(context).pop();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
} 