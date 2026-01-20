import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:grouptalk/features/chat/domain/entity/message_entity.dart';
import 'package:grouptalk/features/chat/domain/usecases/get_messages.dart';
import 'package:grouptalk/features/chat/domain/usecases/send_ai_message.dart';
import 'package:grouptalk/features/chat/domain/usecases/send_message.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetMessages getMessages;
  final SendMessage sendMessage;
  final SendAiMessage sendAIMessage;

  ChatBloc({
    required this.getMessages,
    required this.sendMessage,
    required this.sendAIMessage,
  }) : super(ChatInitial()) {
    on<LoadMessagesEvent>(_onLoadMessages);
    on<SendUserMessageEvent>(_onSendUserMessage);
    on<SendAiMessageEvent>(_onSendAiMessage);
  }

  Future<void> _onLoadMessages(
    LoadMessagesEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    final result = await getMessages(roomId: event.roomId);

    emit(
      result.fold(
        (failure) => ChatError(message: failure.failureMassage),
        (messages) => ChatLoaded(messages: messages),
      ),
    );
  }

  Future<void> _onSendUserMessage(
    SendUserMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    if (state is! ChatLoaded) {
      emit(ChatError(message: "Error!, You can't send right now"));
      return;
    }

    final currentMessages = (state as ChatLoaded).messages;

    emit(ChatSending(messages: currentMessages, isAi: false));

    final result = await sendMessage(message: event.message);
    if (result.isLeft()) {
      result.fold(
        (failure) => emit(ChatError(message: failure.failureMassage)),
        (_) => null,
      );
      return;
    }

    // message sent successfully — fetch latest messages and emit
    final messagesResult = await getMessages(roomId: event.message.roomId);
    messagesResult.fold(
      (failure) => emit(ChatError(message: failure.failureMassage)),
      (messages) => emit(ChatLoaded(messages: messages)),
    );
  }

  Future<void> _onSendAiMessage(
    SendAiMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    // if (state is! ChatLoaded) {
    //   emit(ChatError(message: "Error! You can't send right now"));
    //   return;
    // }

    final currentMessages = (state as ChatLoaded).messages;

    emit(ChatSending(messages: currentMessages, isAi: true));

    final result = await sendAIMessage(
      roomId: event.roomId,
      prompt: event.prompt,
    );
    if (result.isLeft()) {
      result.fold(
        (failure) => emit(ChatError(message: failure.failureMassage)),
        (_) => null,
      );
      return;
    }

    final messageResult = await getMessages(roomId: event.roomId);
    messageResult.fold(
      (failure) => emit(ChatError(message: failure.failureMassage)),
      (messages) => emit(ChatLoaded(messages: messages)),
    );
  }
}
