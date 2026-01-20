import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:grouptalk/core/error/failure.dart';
import 'package:grouptalk/features/chat/data/datasources/ai_remote_data_source.dart';
import 'package:grouptalk/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:grouptalk/features/chat/data/model/message_model.dart';
import 'package:grouptalk/features/chat/domain/entity/message_entity.dart';
import 'package:grouptalk/features/chat/domain/repository/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource chatDataSource;
  final AiRemoteDataSource aiDataSource;

  ChatRepositoryImpl({
    required this.chatDataSource,
    required this.aiDataSource,
  });

  @override
  Future<Either<Failure, List<MessageEntity>>> getMessages({
    required String roomId,
  }) async {
    try {
      return Right(await chatDataSource.getMessages(roomId: roomId));
    } catch (e) {
      return Left(ServerFailure(failureMassage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendAIMessage({
    required String roomId,
    required String prompt,
  }) async {
    try {
      debugPrint(
        'sendAiMessage repository impl -------------------------------------------------------------------->',
      );
      final aiText = await aiDataSource.generateResponse(prompt: prompt);

      final aiMessage = MessageModel(
        id: '',
        roomId: roomId,
        senderId: 'ai',
        senderName: 'Study AI',
        content: aiText,
        isAI: true,
        createdAt: DateTime.now(),
      );

      await chatDataSource.sendMessage(message: aiMessage);
      return Right(null);
    } catch (e) {
      debugPrint('Error: ----------------------------------> ${e.toString()}');
      return Left(ServerFailure(failureMassage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendMessage({
    required MessageEntity message,
  }) async {
    try {
      await chatDataSource.sendMessage(
        message: MessageModel(
          id: message.id,
          roomId: message.roomId,
          senderId: message.senderId,
          senderName: message.senderName,
          content: message.content,
          isAI: message.isAI,
          createdAt: message.createdAt,
        ),
      );

      return Right(null);
    } catch (e) {
      return Left(ServerFailure(failureMassage: e.toString()));
    }
  }
}
