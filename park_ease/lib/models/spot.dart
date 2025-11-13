import 'package:flutter/foundation.dart';

@immutable
class Spot {
  final String id;
  final String name;
  final bool occupied;

  const Spot({
    required this.id,
    required this.name,
    required this.occupied,
  });

  // Factory for creating a Spot instance from a JSON map
  factory Spot.fromJson(Map<String, dynamic> json) {
    return Spot(
      id: json['id'] as String,
      name: json['name'] as String,
      occupied: json['occupied'] as bool,
    );
  }

  // Convert a Spot instance to a JSON map (for future POSTs)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'occupied': occupied,
    };
  }

  // Allow simple copyWith for immutability
  Spot copyWith({String? id, String? name, bool? occupied}) {
    return Spot(
      id: id ?? this.id,
      name: name ?? this.name,
      occupied: occupied ?? this.occupied,
    );
  }
}
