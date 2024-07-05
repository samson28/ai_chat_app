import 'dart:convert';

import '../model/message.dart';
import 'package:http/http.dart' as http;

class OllamaRepository{

  Future<Message> askLLM(String query) async {

    var ollamaLLMUri = Uri.http("localhost:11434", "/api/generate");

    Map<String, String> headers = {
      "Content-Type": "application/json"
    };

    var prompt = {
      "model": "llama3-chatqa",
      "prompt": query,
      "stream": false
    };

    try{
      http.Response response =  await http.post(ollamaLLMUri, headers: headers, body: json.encode(prompt));
      if(response.statusCode == 200){
        Map<String, dynamic> result = jsonDecode(response.body);
        Message message = Message(message: result['response'], type: "assistant");
        return message;
      }else{
        return throw("Error ${response.statusCode}");
      }
    }catch(err){
        return throw("Error ${err.toString()}");
    }



  }
}