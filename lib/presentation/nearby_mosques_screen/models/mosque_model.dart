import 'package:equatable/equatable.dart';

/// Mosque data model
class MosqueModel extends Equatable {
  final String id;
  final String name;
  final String address;
  final double distance; // in kilometers
  final String? imageUrl;
  final double? latitude;
  final double? longitude;

  const MosqueModel({
    required this.id,
    required this.name,
    required this.address,
    required this.distance,
    this.imageUrl,
    this.latitude,
    this.longitude,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        address,
        distance,
        imageUrl,
        latitude,
        longitude,
      ];

  MosqueModel copyWith({
    String? id,
    String? name,
    String? address,
    double? distance,
    String? imageUrl,
    double? latitude,
    double? longitude,
  }) {
    return MosqueModel(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      distance: distance ?? this.distance,
      imageUrl: imageUrl ?? this.imageUrl,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  /// Format distance for display
  String get formattedDistance => '${distance.toStringAsFixed(1)} km';
}
