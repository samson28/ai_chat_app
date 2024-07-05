part of 'chat_bot_bloc.dart';

abstract class ChatBotState {
  final List<Message> messages;

  ChatBotState({required this.messages});
}

final class ChatBotInitial extends ChatBotState {
  ChatBotInitial():super(messages:[
    Message(message: "Hello", type: "user"),
    Message(message: "How can i help you ?", type: "assistant")
  ]);
}

final class ChatBotPendingState extends ChatBotState {
  ChatBotPendingState({required super.messages});
}

final class ChatBotSuccessState extends ChatBotState {
  ChatBotSuccessState({required super.messages});
}

final class ChatBotErrorState extends ChatBotState {
  final String errorMessage;
  ChatBotErrorState({required super.messages, required this.errorMessage});
}

