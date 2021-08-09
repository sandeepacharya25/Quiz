import 'package:flutter/cupertino.dart';
import 'package:quiz/models/question.dart';
import 'package:quiz/models/quiz_user.dart';
import 'package:quiz/service/quiz_services.dart';

class QuizProvider extends ChangeNotifier{
  int totalTime=0;
  List<Question> questions=[];
  List<QuizUser> users=[];

  QuizProvider(){
    QuizServices.getAllQuestions().then((value) {
      questions=value;
      notifyListeners();
    });

    QuizServices.getTotalTime().then((value) {
      totalTime=value;
      notifyListeners();
    });
  }
  Future <void> getAllUsers()async{
    users=await QuizServices.getAllUsers();
    notifyListeners();
  }
  Future<void>updateHighscore(int currentScore)async{
    await QuizServices.upgdateHighScore(currentScore);
  }

}