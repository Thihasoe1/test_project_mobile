import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:test_project_mobile/core/constants/app_colors.dart';
import 'package:test_project_mobile/core/custom_widgets/custom_text.dart';
import 'package:test_project_mobile/core/extension/gap_extension.dart';
import 'package:test_project_mobile/models/product_model.dart';
import 'package:test_project_mobile/providers/product_provider.dart';
import 'package:test_project_mobile/routes/app_routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _deleteMachine(BuildContext context, Product machine) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppColor.background,
            title: const Text('Delete Machine'),
            content: Text(
              'Are you sure you want to delete ${machine.machineName}?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      final provider = Provider.of<ProductProvider>(context, listen: false);
      await provider.deleteMachine(machine);
      _showSnackBar(context, 'Machine deleted successfully', Colors.green);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);

    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: AppColor.background,
        //surfaceTintColor: AppColor.background,
        title: CustomText(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          text: 'Machine Monitor',
          textColor: AppColor.textColor,
        ),
        actions: [
          IconButton(
            icon: Icon(
              provider.isServerOnline ? Icons.cloud_done : Icons.cloud_off,
              color: provider.isServerOnline ? Colors.green : Colors.red,
            ),
            onPressed: () {
              _showSnackBar(
                context,
                provider.isServerOnline
                    ? 'Server is online'
                    : 'Server is offline',
                provider.isServerOnline ? Colors.green : Colors.red,
              );
              provider.checkServerStatus();
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: provider.loadMachines,
          ),
        ],
      ),
      body: RefreshIndicator(
        color: Colors.green,
        onRefresh: provider.loadMachines,
        child: _buildBody(context, provider),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(Routes.addProduct),
        tooltip: 'Add Machine',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(BuildContext context, ProductProvider provider) {
    if (provider.isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: AppColor.textColor,),
            SizedBox(height: 16),
            CustomText(
              text: 'Loading machines...',
              textColor: AppColor.textColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
      );
    }

    if (provider.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(
              'Error loading machines',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                provider.errorMessage!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: provider.loadMachines,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (provider.machines.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.precision_manufacturing, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No machines found',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Tap the + button to add a machine',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 8,left: 8,right: 8,top: 20),
      physics: const BouncingScrollPhysics(),
      itemCount: provider.machines.length,
      itemBuilder: (context, index) {
        final machine = provider.machines[index];
        return _MachineCard(
          machine: machine,
          onTap: () {},
          onEdit: () {
            context.push(Routes.updateProduct, extra: machine);
          },
          onDelete: () => _deleteMachine(context, machine),
        );
      },
    );
  }
}

class _MachineCard extends StatelessWidget {
  final Product machine;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _MachineCard({
    required this.machine,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      color: AppColor.background,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: machine.machineName,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          textColor: AppColor.textColor,
                        ),
                        CustomText(
                          text: 'Status: ${machine.status.toUpperCase()}',
                          fontSize: 14,
                          textColor:
                              machine.status.toLowerCase() == 'running'
                                  ? Colors.green
                                  : machine.status.toLowerCase() == 'stopped'
                                  ? Colors.red
                                  : Colors.orange,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      switch (value) {
                        case 'edit':
                          onEdit();
                          break;
                        case 'delete':
                          onDelete();
                          break;
                      }
                    },
                    itemBuilder:
                        (context) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit),
                                SizedBox(width: 8),
                                CustomText(
                                  text: 'Edit',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  textColor: AppColor.textColor,
                                ),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete, color: Colors.red),
                                SizedBox(width: 8),
                                CustomText(
                                  text: 'Delete',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  textColor: Colors.red,
                                ),
                              ],
                            ),
                          ),
                        ],
                  ),
                ],
              ),
              12.gh(),
              Row(
                children: [
                  Expanded(
                    child: _MetricChip(
                      icon: Icons.thermostat,
                      label: 'Temp',
                      value: '${machine.temperature}°C',
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _MetricChip(
                      icon: Icons.compress,
                      label: 'Press',
                      value: '${machine.pressure} PSI',
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _MetricChip(
                      icon: Icons.speed,
                      label: 'Speed',
                      value: '${machine.speed} RPM',
                      color: Colors.purple,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              CustomText(
                text:
                    "Created: ${machine.createdAt != null ? DateFormat('dd-MMM-yyyy').format(machine.createdAt!.toLocal()) : 'N/A'}",
                fontSize: 12,
                textColor: Colors.grey.shade500,
                fontWeight: FontWeight.w400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetricChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _MetricChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              CustomText(
                text: label,
                fontSize: 10,
                textColor: color,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
          const SizedBox(height: 2),
          CustomText(
            text: value,
            textColor: AppColor.textColor,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ],
      ),
    );
  }
}
