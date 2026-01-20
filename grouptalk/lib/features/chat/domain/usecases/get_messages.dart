import 'package:dartz/dartz.dart';
import 'package:grouptalk/core/error/failure.dart';
import 'package:grouptalk/features/chat/domain/entity/message_entity.dart';
import 'package:grouptalk/features/chat/domain/repository/chat_repository.dart';

class GetMessages {
  final ChatRepository repository;

  GetMessages({required this.repository});

  Future<Either<Failure, List<MessageEntity>>> call({required String roomId}) =>
      repository.getMessages(roomId: roomId);
}
