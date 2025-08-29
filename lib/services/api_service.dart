import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:test_project_mobile/models/product_model.dart';

class ApiService {
  static const String baseUrl =
      'https://test-app-007-7359ad01c0c6.herokuapp.com/api';
  static const Duration timeoutDuration = Duration(seconds: 10);

  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// Get all machines
  static Future<List<Product>> getAllMachines() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/machines'), headers: headers)
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse['success'] == true) {
          final List<dynamic> data = jsonResponse['data'] ?? [];
          return data.map((json) => Product.fromJson(json)).toList();
        } else {
          throw ApiException(
            jsonResponse['message'] ?? 'Failed to load machines',
          );
        }
      } else {
        throw ApiException('Server error: ${response.statusCode}');
      }
    } on SocketException {
      throw ApiException('No internet connection');
    } on http.ClientException {
      throw ApiException('Failed to connect to server');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Unexpected error: ${e.toString()}');
    }
  }

  /// Get machine by ID
  static Future<Product> getMachineById(int id) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/machines/$id'), headers: headers)
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse['success'] == true) {
          return Product.fromJson(jsonResponse['data']);
        } else {
          throw ApiException(jsonResponse['message'] ?? 'Machine not found');
        }
      } else if (response.statusCode == 404) {
        throw ApiException('Machine not found');
      } else {
        throw ApiException('Server error: ${response.statusCode}');
      }
    } on SocketException {
      throw ApiException('No internet connection');
    } on http.ClientException {
      throw ApiException('Failed to connect to server');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Unexpected error: ${e.toString()}');
    }
  }

  /// Create new machine
  static Future<Product> createMachine(Product machine) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/machines'),
            headers: headers,
            body: json.encode(machine.toJson()),
          )
          .timeout(timeoutDuration);

      debugPrint("Create Machine Response: ${response.body}");

      if (response.statusCode == 201) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse['success'] == true) {
          return Product.fromJson(jsonResponse['data']);
        } else {
          throw ApiException(
            jsonResponse['message'] ?? 'Failed to create machine',
          );
        }
      } else if (response.statusCode == 400) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        throw ApiException(jsonResponse['error'] ?? 'Invalid data');
      } else {
        throw ApiException('Server error: ${response.statusCode}');
      }
    } on SocketException {
      throw ApiException('No internet connection');
    } on http.ClientException {
      throw ApiException('Failed to connect to server');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Unexpected error: ${e.toString()}');
    }
  }

  /// Update machine
  static Future<Product> updateMachine(int id, Product machine) async {
    try {
      final response = await http
          .put(
            Uri.parse('$baseUrl/machines/$id'),
            headers: headers,
            body: json.encode(machine.toJson()),
          )
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse['success'] == true) {
          return Product.fromJson(jsonResponse['data']);
        } else {
          throw ApiException(
            jsonResponse['message'] ?? 'Failed to update machine',
          );
        }
      } else if (response.statusCode == 400) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        throw ApiException(jsonResponse['error'] ?? 'Invalid data');
      } else if (response.statusCode == 404) {
        throw ApiException('Machine not found');
      } else {
        throw ApiException('Server error: ${response.statusCode}');
      }
    } on SocketException {
      throw ApiException('No internet connection');
    } on http.ClientException {
      throw ApiException('Failed to connect to server');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Unexpected error: ${e.toString()}');
    }
  }

  /// Delete machine
  static Future<void> deleteMachine(int id) async {
    try {
      final response = await http
          .delete(Uri.parse('$baseUrl/machines/$id'), headers: headers)
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse['success'] != true) {
          throw ApiException(
            jsonResponse['message'] ?? 'Failed to delete machine',
          );
        }
      } else if (response.statusCode == 404) {
        throw ApiException('Machine not found');
      } else {
        throw ApiException('Server error: ${response.statusCode}');
      }
    } on SocketException {
      throw ApiException('No internet connection');
    } on http.ClientException {
      throw ApiException('Failed to connect to server');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Unexpected error: ${e.toString()}');
    }
  }

  /// Health check
  static Future<bool> checkServerHealth() async {
    try {
      final response = await http
          .get(
            Uri.parse('${baseUrl.replaceAll('/api', '')}/health'),
            headers: headers,
          )
          .timeout(timeoutDuration);

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}

/// Custom exception for API errors
class ApiException implements Exception {
  final String message;

  ApiException(this.message);

  @override
  String toString() => 'ApiException: $message';
}
