part of 'chat_bloc.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class LoadMessagesEvent extends ChatEvent {
  final String roomId;
  const LoadMessagesEvent({required this.roomId});
}

class SendUserMessageEvent extends ChatEvent {
  final MessageEntity message;
  const SendUserMessageEvent({required this.message});
}

class SendAiMessageEvent extends ChatEvent {
  final String roomId;
  final String prompt;
  const SendAiMessageEvent({required this.roomId, required this.prompt});
}
