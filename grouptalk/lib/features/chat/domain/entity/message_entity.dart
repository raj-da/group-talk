import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  final String id;
  final String roomId;
  final String senderId;
  final String senderName;
  final String content;
  final bool isAI;
  final DateTime createdAt;

  const MessageEntity({
    required this.id,
    required this.roomId,
    required this.senderId,
    required this.senderName,
    required this.content,
    required this.isAI,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    roomId,
    senderId,
    senderName,
    content,
    isAI,
    createdAt,
  ];
}
