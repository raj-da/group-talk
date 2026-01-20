part of 'chat_bloc.dart';

sealed class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

final class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<MessageEntity> messages;
  const ChatLoaded({required this.messages});
}

class ChatError extends ChatState {
  final String message;
  const ChatError({required this.message});
}

class ChatSending extends ChatState {
  final List<MessageEntity> messages;
  final bool isAi;
  const ChatSending({required this.messages, required this.isAi});
}
