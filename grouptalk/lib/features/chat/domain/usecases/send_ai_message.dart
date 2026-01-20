import 'package:dartz/dartz.dart';
import 'package:grouptalk/core/error/failure.dart';
import 'package:grouptalk/features/chat/domain/repository/chat_repository.dart';

class SendAiMessage {
  final ChatRepository repository;

  SendAiMessage({required this.repository});

  Future<Either<Failure, void>> call({required String roomId, required String prompt}) =>
      repository.sendAIMessage(roomId: roomId, prompt: prompt);
}
