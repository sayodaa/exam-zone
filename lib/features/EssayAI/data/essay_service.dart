import 'dart:convert';
import 'package:graduation/features/essayAI/data/essay_model.dart';
import 'package:http/http.dart' as http;

class EssayService {
  static const String _apiKey = 'sk-02e178544f904b9696c835285265f303'; // 🔒 استخدم .env أو secure storage
  static const String _model = "deepseek-chat";
  static final Uri _apiUrl = Uri.parse("https://api.deepseek.com/v1/chat/completions");

  static final Map<String, String> _headers = {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": "Bearer $_apiKey",
  };

  // ✅ توليد مقال
  static Future<String> generateEssay(String topic) async {
    final prompt = '''
Write a well-structured essay (150-200 words) about the following topic:
"$topic".

Use formal language, and include an introduction, body, and conclusion.

Do not return any explanation. Just the essay.
''';

    return await _callAI(prompt);
  }

  // ✅ تصحيح مقال
  static Future<EssayCorrectionModel> correctEssay({
    required String studentEssay,
    required String topic,
  }) async {
    final prompt = '''
You are a professional English essay grader.

Topic: "$topic"

Student's Essay:
"""
$studentEssay
"""

Please provide:
1. Score out of 10.
2. List of grammar or spelling mistakes.
3. One paragraph of constructive feedback.

Return your answer clearly formatted, no extra messages or notes.
''';

    final rawResult = await _callAI(prompt);
    return EssayCorrectionModel.fromRawText(rawResult);
  }

  // 🔒 الاتصال بـ API
  static Future<String> _callAI(String prompt) async {
    final body = jsonEncode({
      "model": _model,
      "messages": [
        {"role": "system", "content": prompt.trim()},
      ],
    });

    final response = await http.post(_apiUrl, headers: _headers, body: body);

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return data['choices'][0]['message']['content'].toString().trim();
    } else {
      throw Exception("API Error: ${response.statusCode} - ${response.reasonPhrase}");
    }
  }
}