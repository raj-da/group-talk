import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grouptalk/features/chat/domain/entity/message_entity.dart';

class MessageModel extends MessageEntity {
  const MessageModel({
    required super.id,
    required super.roomId,
    required super.senderId,
    required super.senderName,
    required super.content,
    required super.isAI,
    required super.createdAt,
  });

  factory MessageModel.fromFirestore({
    required Map<String, dynamic> json,
    required String id,
  }) {
    return MessageModel(
      id: id,
      roomId: json['roomId'],
      senderId: json['senderId'],
      senderName: json['senderName'],
      content: json['content'],
      isAI: json['isAI'],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'roomId': roomId,
      'senderId': senderId,
      'senderName': senderName,
      'content': content,
      'isAI': isAI,
      'createdAt': createdAt,
    };
  }
}
