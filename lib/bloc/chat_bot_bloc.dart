import 'package:ai_chat_app/repository/ollama_repository.dart';
import 'package:bloc/bloc.dart';

import '../model/message.dart';

part 'chat_bot_event.dart';
part 'chat_bot_state.dart';

class ChatBotBloc extends Bloc<ChatBotEvent, ChatBotState> {
  late ChatBotEvent lastEvent;
  final OllamaRepository ollamaRepository = OllamaRepository();

  ChatBotBloc() : super(ChatBotInitial()) {

    on<AskLLMEvent>((event, emit) async {
      lastEvent = event;
      emit(ChatBotPendingState(messages: state.messages));
      List<Message> currentMessages = state.messages;
      currentMessages.add(Message(message: event.query, type: "user"));
      try{
        Message responseMessage = await ollamaRepository.askLLM(event.query);
        currentMessages.add(responseMessage);
        emit(ChatBotSuccessState(messages: currentMessages));
      }catch(err){
        emit(ChatBotErrorState(messages: state.messages, errorMessage: err.toString()));
      }
    });

  }
}
