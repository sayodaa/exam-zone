import 'dart:convert';

import 'package:graduation/features/overwall/data/quation_model.dart';
import 'package:http/http.dart' as http;

// Note: To use this code, you need to add the http package to your project.
// Add this line to your pubspec.yaml file under dependencies:
// http: ^1.2.1

// --- Data Model for the Quiz Question ---
// Using a class like this makes your code safer and easier to work with.

// --- Main Function to Generate Questions ---
// This is the primary function you will call.
Future<List<QuestionModel>> generateQuiz({
  required int numQuestions,
  required String subject,
  required double difficulty,
}) async {
  // 1. Construct the detailed prompt for the AI.
  String mainMessage = '''
Give me an array of $numQuestions objects that has a questions, choices, and a true answer about $subject.
The difficulty of the question is $difficulty.
Like this example:
[
  {
    "question": "What is the value of 2 + 2?",
    "choices": {
      "a": 3,
      "b": 4,
      "c": 5,
      "d": 6
    },
    "answer": "b"
  },
  {
    "question": "What is the value of 3 + 3?",
    "choices": {
      "a": 3,
      "b": 4,
      "c": 5,
      "d": 6
    },
    "answer": "d"
  }
]
Provide only this object, with no extra text.
Make the answer random, not just 'a'; it should be random between 'a', 'b', 'c', or 'd'.
If the object has Arabic or any other language words, make the object choices 'a', 'b', 'c', 'd', not like 'ا', 'ب', 'ج', 'د'.
dont add backticks in respone
''';

  try {
    // 2. Call the API function to get the raw string response.
    final String rawResponse = await _generateWithAI(mainMessage);

    // 3. Clean up the response and parse the JSON string.
    // The AI might sometimes wrap the JSON in backticks, so we remove them.
    final String cleanedResponse = rawResponse.replaceAll('`', '').trim();
    
    // Decode the cleaned JSON string into a List of dynamic objects.
    final List<dynamic> decodedJson = jsonDecode(cleanedResponse);

    // 4. Convert the list of dynamic objects into a list of Question objects.
    final List<QuestionModel> questions = decodedJson
        .map((item) => QuestionModel.fromJson(item as Map<String, dynamic>, 'en'))
        .toList();

    return questions;

  } catch (e) {
    print("Error generating quiz: $e");
    // Depending on your app's needs, you might want to return an empty list
    // or re-throw the error to be handled by the caller.
    rethrow;
  }
}


// --- Private Helper Function for API Call ---
// This function handles the direct communication with the DeepSeek API.
Future<String> _generateWithAI(String predefinedRules) async {
  // IMPORTANT: Replace with your actual API key.
  // It is highly recommended to store your API key securely and not hardcode it.
  const String apiKey = 'sk-02e178544f904b9696c835285265f303';
  const String model = "deepseek-chat";
  final Uri apiUrl = Uri.parse("https://api.deepseek.com/v1/chat/completions");

  final Map<String, String> headers = {
    "Content-Type": "application/json",
    "Authorization": "Bearer $apiKey",
  };

  final Map<String, dynamic> body = {
    "model": model,
    "messages": [
      {"role": "system", "content": predefinedRules.trim()},
    ],
  };

  try {
    final response = await http.post(
      apiUrl,
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      if (data['choices'] != null && (data['choices'] as List).isNotEmpty) {
        print("Model: $model success");
        print("*");
        return data['choices'][0]['message']['content'];
      } else {
        throw Exception("API returned an empty or invalid response.");
      }
    } else {
      throw Exception('API error: ${response.statusCode} ${response.reasonPhrase}');
    }
  } catch (e) {
    print("Error in _generateWithAI: $e");
    rethrow;
  }
}