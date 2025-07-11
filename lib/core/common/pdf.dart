import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';

Future<void> exportExamAsTextPdf({
  required BuildContext context,
  required List<Map<String, dynamic>> mcqQuestions,
  required List<Map<String, dynamic>> essayQuestions,
  required Map<int, String> userAnswers,
  required int score,
}) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.MultiPage(
      textDirection: pw.TextDirection.rtl,
      build: (context) => [
        pw.Text('نتيجة الامتحان', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 20),
        if (mcqQuestions.isNotEmpty) ...[
          pw.Text('أسئلة الاختيار من متعدد:', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
          ...mcqQuestions.asMap().entries.map((entry) {
            final index = entry.key;
            final question = entry.value;
            final userAnswer = userAnswers[index];
            final correctAnswer = question['correctAnswer'];
            final options = question['options'] as List;

            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('${index + 1}- ${question['question']}'),
                ...options.map((opt) {
                  final optId = opt['id'];
                  final optText = opt['text'];
                  bool selected = optId == userAnswer;
                  bool correct = optId == correctAnswer;

                  return pw.Bullet(
                    text: '$optId) $optText'
                        '${selected ? " ← إجابتك" : ""}'
                        '${correct ? " ✔" : ""}',
                    style: pw.TextStyle(
                      color: selected
                          ? (selected == correct ? PdfColors.green : PdfColors.red)
                          : PdfColors.black,
                    ),
                  );
                }),
                pw.SizedBox(height: 10),
              ],
            );
          }),
        ],
        if (essayQuestions.isNotEmpty) ...[
          pw.SizedBox(height: 20),
          pw.Text('أسئلة المقال:', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
          ...essayQuestions.asMap().entries.map((entry) {
            final index = entry.key;
            final question = entry.value;
            final answerIndex = mcqQuestions.length + index;
            final userAnswer = userAnswers[answerIndex] ?? "";

            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('${index + 1}- ${question['question']}'),
                pw.Text('إجابتك: $userAnswer'),
                pw.SizedBox(height: 10),
              ],
            );
          }),
        ],
        pw.Divider(),
        pw.Text('الدرجة النهائية: $score من ${mcqQuestions.length}'),
        pw.Text('النسبة المئوية: ${(score / mcqQuestions.length * 100).toStringAsFixed(1)}%'),
      ],
    ),
  );

  // طلب الصلاحية
  var status = await Permission.manageExternalStorage.request();
  if (!status.isGranted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('يجب منح صلاحية التخزين')),
    );
    return;
  }

  try {
    // حفظ في مجلد التنزيلات
    final downloadsDir = Directory('/storage/emulated/0/Download');
    final filePath = '${downloadsDir.path}/exam_result_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final file = File(filePath);

    await file.writeAsBytes(await pdf.save());

    // إظهار رسالة
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم حفظ الملف في مجلد التنزيلات')),
    );

    // فتح الملف
    await OpenFile.open(file.path);
  } catch (e) {
    print("حدث خطأ أثناء حفظ أو فتح الملف: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('فشل في حفظ أو فتح الملف')),
    );
  }
}
