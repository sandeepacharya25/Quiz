import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz/components/action_button.dart';
import 'package:quiz/components/gradient_box.dart';
import 'package:quiz/components/rank_auth_button.dart';
import 'package:quiz/providers/quiz_provider.dart';
import 'package:quiz/screens/quiz_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QuizProvider>();
    return Scaffold(
      body: SizedBox.expand(
        child: GradientBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Quiz",
                style: TextStyle(color: Colors.white, fontSize: 40.0),
              ),
              SizedBox(
                height: 40.0,
              ),
              if (provider.questions.isEmpty || provider.totalTime == 0)
                Center(
                  child: CircularProgressIndicator(),
                )
             else
              ActionButton(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => QuizScreen(
                        totalTime: provider.totalTime,
                        questions: provider.questions,
                      ),
                    ),
                  );
                },
                title: 'Start',
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Total Questions: ${provider.questions.length}",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 70.0,
              ),
              RankAuthButton(),
            ],
          ),
        ),
      ),
    );
  }
}
