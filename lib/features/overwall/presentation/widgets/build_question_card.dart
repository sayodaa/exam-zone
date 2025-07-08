import 'package:flutter/material.dart';

class BuildQuestionCard extends StatelessWidget {
  final BuildContext context;
  final int index;
  final String question;
  final List<Map<String, dynamic>> options;
  final bool submitted;
  final String? selectedAnswer;
  final Function(String)? onAnswerSelected;

  const BuildQuestionCard({
    super.key,
    required this.context,
    required this.index,
    required this.question,
    required this.options,
    required this.submitted,
    required this.selectedAnswer,
    required this.onAnswerSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$index. $question',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...options.map((option) {
              final isSelected = selectedAnswer == option['id'];
              final isCorrect = option['isCorrect'] == true;

              IconData icon = Icons.radio_button_unchecked;
              Color iconColor = Colors.grey;

              if (submitted) {
                if (isSelected && isCorrect) {
                  icon = Icons.check_circle;
                  iconColor = Colors.green;
                } else if (isSelected && !isCorrect) {
                  icon = Icons.cancel;
                  iconColor = Colors.red;
                } else if (!isSelected && isCorrect) {
                  icon = Icons.check_circle_outline;
                  iconColor = Colors.green;
                }
              } else {
                icon = isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked;
                iconColor = isSelected ? Colors.blue : Colors.grey;
              }

              return ListTile(
                leading: Icon(icon, color: iconColor),
                title: Text("${option['id']}) ${option['text']}"),
                onTap: onAnswerSelected != null
                    ? () => onAnswerSelected!(option['id'])
                    : null,
              );
            }),
          ],
        ),
      ),
    );
  }
}
