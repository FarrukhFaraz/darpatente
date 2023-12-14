
import 'package:flutter/material.dart';

class Question {
  final String text;

  Question(this.text);
}

class QuestionWidget extends StatelessWidget {
  final Question question;

  const QuestionWidget(this.question, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          question.text,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

