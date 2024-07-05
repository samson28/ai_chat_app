import 'dart:convert';

import 'package:ai_chat_app/bloc/chat_bot_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class ChatBotPage extends StatelessWidget {
  ChatBotPage({super.key});

  TextEditingController queryController = TextEditingController();
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          "Chat Bot",
          style: TextStyle(color: Theme.of(context).indicatorColor),
        ),
      ),
      body: Column(
        children: [
          BlocBuilder<ChatBotBloc, ChatBotState>(builder: (event, state) {
            if (state is ChatBotPendingState) {
              return const CircularProgressIndicator();
            } else if (state is ChatBotErrorState) {
              return Column(
                children: [
                  Text(
                    state.errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                  ElevatedButton(
                      onPressed: (){
                        ChatBotEvent evt = context.read<ChatBotBloc>().lastEvent;
                        context.read<ChatBotBloc>().add(evt);
                      },
                      child: const Text("Retry"))
                ],
              );
            } else if (state is ChatBotSuccessState || state is ChatBotInitial) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      bool isUser = state.messages[index].type == 'user';
                      return Column(
                        children: [
                          ListTile(
                            trailing: isUser ? const Icon(Icons.person) : null,
                            leading: !isUser
                                ? const Icon(Icons.support_agent)
                                : null,
                            title: Row(
                              children: [
                                SizedBox(
                                  width: isUser ? 100 : 0,
                                ),
                                Expanded(
                                  child: Container(
                                    color: isUser
                                        ? const Color.fromARGB(100, 0, 200, 0)
                                        : Colors.white,
                                    padding: const EdgeInsets.all(10),
                                    child: Text(
                                      state.messages[index].message,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: isUser ? 0 : 100,
                                )
                              ],
                            ),
                          ),
                          Divider(
                            height: 1,
                            color: Theme.of(context).primaryColor,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              );
            }else{
              return Container();
            }
          }),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: queryController,
                    decoration: InputDecoration(
                      //icon: Icon(Icons.lock),
                      suffixIcon: const Icon(Icons.visibility),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1, color: Theme.of(context).primaryColor),
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    String query = queryController.text;
                    context.read<ChatBotBloc>().add(AskLLMEvent(query: query));
                  },
                  icon: const Icon(
                    Icons.send,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
