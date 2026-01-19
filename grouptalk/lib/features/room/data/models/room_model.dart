import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grouptalk/features/room/domain/entities/room_entity.dart';

class RoomModel extends RoomEntity{
  const RoomModel({
    required super.id,
    required super.name,
    required super.description,
    required super.ownerId,
    required super.isPublic,
    required super.subject,
  });

  factory RoomModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RoomModel(
      id: doc.id,
      name: data['name'],
      description: data['description'],
      ownerId: data['ownerId'],
      isPublic: data['isPublic'],
      subject: data['subject'],
    );
  }
}