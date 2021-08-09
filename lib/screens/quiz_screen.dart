import 'dart:async';
import 'package:flutter/material.dart';
import 'package:quiz/components/gradient_box.dart';
import 'package:quiz/models/question.dart';
import 'package:quiz/screens/result_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({Key? key,
   required this.totalTime, 
   required this.questions,
   })
      : super(key: key);
  final int totalTime;
  final List<Question> questions;

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late int _currentTime;
  late Timer _timer;
  int _currentIndex = 0;
  String _selectedAnswer = '';
  int _score=0;
  @override
  void initState() {
    super.initState();
    _currentTime = widget.totalTime;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime -= 1;
      });
      if (_currentTime == 0) {
        _timer.cancel();
        pushResultScreen(context);
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = widget.questions[_currentIndex];
    return Scaffold(
      body: GradientBox(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 40.0,
              ),
              SizedBox(
                height: 40.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      LinearProgressIndicator(
                        value: _currentTime / widget.totalTime,
                      ),
                      Center(
                        child: Text(
                          _currentTime.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 40.0,
              ),
              Text(
                "Question",
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                currentQuestion.question,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                ),
              ),
              Spacer(),

              Expanded(
                child: ListView.builder(
                  // shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final answer = currentQuestion.answer[index];
                    return AnswerTile(
                      isSelected: answer == _selectedAnswer,
                      answer: answer,
                      correctAnswer: currentQuestion.correctAnswer,
                      onTap: () {
                        setState(() {
                          _selectedAnswer = answer;
                          _currentTime=10;
                        });
                        
                        if(answer==currentQuestion.correctAnswer){
                          _score++;
                        }

                        Future.delayed(Duration(milliseconds: 200), () {
                          if (_currentIndex ==widget.questions.length - 1) {
                            pushResultScreen(context);
                            return;
                          }
                          setState(() {
                            _currentIndex++;
                            _selectedAnswer = '';
                          });
                        });
                      },
                    );
                  },
                  itemCount: currentQuestion.answer.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void pushResultScreen(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          questions: widget.questions,
          totalTime: widget.totalTime,
          score: _score,
        ),
      ),
    );
  }
}

class AnswerTile extends StatelessWidget {
  const AnswerTile({
    Key? key,
    required this.isSelected,
    required this.answer,
    required this.correctAnswer,
    required this.onTap,
  }) : super(key: key);
  final bool isSelected;
  final String answer;
  final String correctAnswer;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: cardColor,
      child: ListTile(
        onTap: () => onTap(),
        title: Text(
          answer,
          style: TextStyle(
            fontSize: 18,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  Color get cardColor {
    if (!isSelected) return Colors.white;
    if ( answer == correctAnswer) {
      return Colors.teal;
    }
    return Colors.redAccent;
  }
}
