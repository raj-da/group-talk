import 'package:equatable/equatable.dart';

class RoomEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final String ownerId;
  final bool isPublic;
  final String subject;

  const RoomEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.ownerId,
    required this.isPublic,
    required this.subject
  });

  @override
  List<Object?> get props => [id, name, description, ownerId, isPublic];
}
