import 'package:dartz/dartz.dart';
import 'package:grouptalk/core/error/failure.dart';
import 'package:grouptalk/features/chat/domain/entity/message_entity.dart';
import 'package:grouptalk/features/chat/domain/repository/chat_repository.dart';

class SendMessage {
  final ChatRepository repository;

  SendMessage({required this.repository});

  Future<Either<Failure, void>> call({required MessageEntity message}) =>
      repository.sendMessage(message: message);
}
