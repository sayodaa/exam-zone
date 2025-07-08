// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:path_provider/path_provider.dart';
// import 'package:open_file/open_file.dart';

// Future<void> exportExamAsTextPdf({
//   required BuildContext context,
//   required List<Map<String, dynamic>> mcqQuestions,
//   required List<Map<String, dynamic>> essayQuestions,
//   required Map<int, String> userAnswers,
//   required int score,
//   String fileName = 'exam_result',
// }) async {
//   final pdf = pw.Document();

//   pdf.addPage(
//     pw.MultiPage(
//       textDirection: pw.TextDirection.rtl,
//       build: (context) => [
//         pw.Text('نتيجة الامتحان', style: pw.TextStyle(fontSize: 24)),
//         pw.SizedBox(height: 10),
//         pw.Text('الدرجة النهائية: $score من ${mcqQuestions.length}'),
//         pw.Text('النسبة المئوية: ${(score / mcqQuestions.length * 100).toStringAsFixed(1)}%'),
//         pw.SizedBox(height: 20),
//         pw.Text('الأسئلة:', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
//         pw.SizedBox(height: 10),

//         ...mcqQuestions.asMap().entries.map((entry) {
//           final index = entry.key;
//           final q = entry.value;
//           final answer = userAnswers[index];
//           return pw.Column(
//             crossAxisAlignment: pw.CrossAxisAlignment.start,
//             children: [
//               pw.Text('${index + 1}- ${q['question']}'),
//               pw.Text('إجابتك: $answer'),
//               pw.SizedBox(height: 10),
//             ],
//           );
//         }),

//         ...essayQuestions.asMap().entries.map((entry) {
//           final index = entry.key;
//           final q = entry.value;
//           final answer = userAnswers[mcqQuestions.length + index] ?? '';
//           return pw.Column(
//             crossAxisAlignment: pw.CrossAxisAlignment.start,
//             children: [
//               pw.Text('${index + 1}- ${q['question']}'),
//               pw.Text('إجابتك: $answer'),
//               pw.SizedBox(height: 10),
//             ],
//           );
//         }),
//       ],
//     ),
//   );

//   try {
//     // الحصول على مسار مجلد Downloads
//     final directory = await getExternalStorageDirectory();
//     if (directory == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('❌ لا يمكن الوصول إلى مجلد التنزيلات')),
//       );
//       return;
//     }

//     final downloadsPath = '${directory.path}/Download';
//     // إنشاء المجلد إذا لم يكن موجوداً
//     await Directory(downloadsPath).create(recursive: true);
    
//     final path = '$downloadsPath/$fileName.pdf';
//     final file = File(path);

//     await file.writeAsBytes(await pdf.save());

//     // عرض رسالة نجاح مع مسار الملف
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('✅ تم حفظ الملف بنجاح'),
//             Text('المسار: $path', style: TextStyle(fontSize: 12)),
//           ],
//         ),
//         duration: Duration(seconds: 5),
//         action: SnackBarAction(
//           label: 'فتح',
//           onPressed: () async {
//             final result = await OpenFile.open(file.path);
//             if (result.type != ResultType.done) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text('❌ تعذر فتح الملف')),
//               );
//             }
//           },
//         ),
//       ),
//     );

//   } catch (e) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('❌ حصل خطأ أثناء الحفظ: $e')),
//     );
//   }
// }
