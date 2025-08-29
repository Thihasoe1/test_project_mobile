import 'package:flutter/foundation.dart';
import 'package:test_project_mobile/models/product_model.dart';
import '../services/api_service.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _machines = [];
  bool _isLoading = true;
  String? _errorMessage;
  bool _isServerOnline = false;

  List<Product> get machines => _machines;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isServerOnline => _isServerOnline;

  /// Fetch all machines
  Future<void> loadMachines() async {

    debugPrint("Loading machines...");
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final machines = await ApiService.getAllMachines();
      _machines = machines;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Delete a machine
  Future<void> deleteMachine(Product machine) async {
    if (machine.id == null) return;

    try {
      await ApiService.deleteMachine(machine.id!);
      _machines.remove(machine);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  /// Add a new machine
  Future<void> addMachine(Product machine) async {
    try {
      debugPrint("Adding machine: ${machine.toJson()}");
      final newMachine = await ApiService.createMachine(machine);
      debugPrint("Added new machine: $newMachine");
      _machines.add(newMachine);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  /// Update a machine
  Future<void> updateMachine(Product updateProduct) async {
    try {
      final machine = await ApiService.updateMachine(updateProduct.id ?? 0, updateProduct);
      final index = _machines.indexWhere((m) => m.id == machine.id);
      if (index != -1) {
        _machines[index] = machine;
      }
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  /// Check server status
  Future<void> checkServerStatus() async {
    final status = await ApiService.checkServerHealth();
    _isServerOnline = status;
    notifyListeners();
  }

  /// Call this once when app starts
  Future<void> initialize() async {
    await checkServerStatus();
    await loadMachines();
  }
}