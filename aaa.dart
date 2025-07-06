import 'dart:convert';

import 'package:http/http.dart' as http;

// Note: To use this code, you need to add the http package to your project.
// Add this line to your pubspec.yaml file under dependencies:
// http: ^1.2.1

// --- Data Model for the Quiz Question ---
// Using a class like this makes your code safer and easier to work with.
class Question {
  final String question;
  final Map<String, dynamic> choices;
  final String answer;

  Question({
    required this.question,
    required this.choices,
    required this.answer,
  });

  // A factory constructor to create a Question object from a JSON map.
  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      question: json['question'] as String,
      choices: json['choices'] as Map<String, dynamic>,
      answer: json['answer'] as String,
    );
  }

  // An override to make printing the Question object more informative.
  @override
  String toString() {
    return 'Question(question: $question, choices: $choices, answer: $answer)';
  }
}


// --- Main Function to Generate Questions ---
// This is the primary function you will call.
Future<List<Question>> generateQuiz(int numberOfQuestions, String subject) async {
  // 1. Construct the detailed prompt for the AI.
  String mainMessage = '''
Give me an array of $numberOfQuestions objects that has a questions, choices, and a true answer about $subject. Like this example:
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
    final List<Question> questions = decodedJson
        .map((item) => Question.fromJson(item as Map<String, dynamic>))
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
  const String apiKey = 'YOUR_DEEPSEEK_API_KEY';
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


// --- Example Usage ---
// // This is how you would call the function in your application.
// void main() async {
//   print("Generating a quiz...");
//   try {
//     // Generate 3 questions about 'World Capitals'
//     List<Question> myQuiz = await generateQuiz(3, 'World Capitals');
    
//     // Print the results
//     for (var i = 0; i < myQuiz.length; i++) {
//       print("\n--- Question ${i + 1} ---");
//       print(myQuiz[i]);
//     }

//   } catch (e) {
//     print("\nFailed to generate the quiz. Please check your API key and network connection.");
//   }
// }