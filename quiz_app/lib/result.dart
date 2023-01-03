import 'package:flutter/material.dart';

class Result extends StatelessWidget {
  final int resultScore;
  final VoidCallback resetHandler;

  String get resultPhrase {
    var resultText = 'you did it!';
    if (resultScore <= 8) {
      resultText = 'You are awosome and innocent!';
    } else if (resultScore <= 12) {
      resultText = 'Pretty likable!';
    } else if (resultScore <= 16) {
      resultText = 'You are ... strange?!';
    } else {
      resultText = 'You are so bad!';
    }
    return resultText;
  }

  const Result(
      {super.key, required this.resultScore, required this.resetHandler});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            resultPhrase,
            style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          TextButton(
            onPressed: resetHandler,
            child: const Text('Restart Quiz!', style: TextStyle(fontSize: 20)),
          ),
        ],
      ),
    );
  }
}
