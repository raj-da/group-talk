import 'package:dartz/dartz.dart';
import 'package:grouptalk/core/error/failure.dart';
import 'package:grouptalk/features/chat/domain/entity/message_entity.dart';

abstract class ChatRepository {
  Future<Either<Failure, void>> sendMessage({required MessageEntity message});
  Future<Either<Failure,void>> sendAIMessage({required String roomId, required String prompt});
  Future<Either<Failure, List<MessageEntity>>> getMessages({required String roomId});
}
