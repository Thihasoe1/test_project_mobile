
class Product {
  final int? id;
  final String machineName;
  final double temperature;
  final double pressure;
  final int speed;
  final String status;
  final DateTime? createdAt;

  Product({
    this.id,
    required this.machineName,
    required this.temperature,
    required this.pressure,
    required this.speed,
    required this.status,
    this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      machineName: json['machine_name'] ?? '',
      temperature: (json['temperature'] ?? 0.0).toDouble(),
      pressure: (json['pressure'] ?? 0.0).toDouble(),
      speed: json['speed'] ?? 0,
      status: json['status'] ?? 'stopped',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'machine_name': machineName,
      'temperature': temperature,
      'pressure': pressure,
      'speed': speed,
      'status': status,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
    };
  }

  Product copyWith({
    int? id,
    String? machineName,
    double? temperature,
    double? pressure,
    int? speed,
    String? status,
    DateTime? createdAt,
  }) {
    return Product(
      id: id ?? this.id,
      machineName: machineName ?? this.machineName,
      temperature: temperature ?? this.temperature,
      pressure: pressure ?? this.pressure,
      speed: speed ?? this.speed,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}