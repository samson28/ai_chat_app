part of 'chat_bot_bloc.dart';


abstract class ChatBotEvent {}

class AskLLMEvent extends ChatBotEvent{
  final String query;

  AskLLMEvent({required this.query});
}

