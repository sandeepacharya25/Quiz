import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz/models/question.dart';
import 'package:quiz/models/quiz_user.dart';

class QuizServices {
  static Future<List<Question>> getAllQuestions() async {
    final questionsRef = FirebaseFirestore.instance.collection('questions');
    final questionDoc = await questionsRef.get();

    return questionDoc.docs
        .map((e) => Question.fromQueryDocumentSnapShot(e))
        .toList();
  }

  static Future<int> getTotalTime() async {
    final configRef = FirebaseFirestore.instance.collection('config');
    final conficDoc = await configRef.get();

    final config = conficDoc.docs.first.data();
    return config['key'];
  }

  static Future<List<QuizUser>> getAllUsers() async {
    final userRef = FirebaseFirestore.instance.collection('user').orderBy('score',descending: true);
    final userDoc =await userRef.get();

    return userDoc.docs
        .map((e) => QuizUser.fromQueryDocumentSnapShot(e))
        .toList();
  }
  static Future<void> upgdateHighScore(int currentScore)async{
   
    final authUser= FirebaseAuth.instance.currentUser;

    if(authUser==null) return ;

    final userRef=FirebaseFirestore.instance.collection('user').doc(authUser.uid);

    final userDoc=await userRef.get();

    if(userDoc.exists){
      final user=userDoc.data();

      if(user==null) return;

      final lastHighScore=user['score'];

      if(lastHighScore>=currentScore){
        return;
      }
      userRef.update({'score':currentScore});
      return;
    }
userRef.set({
  'email':authUser.email,
  'photoUrl':authUser.photoURL,
  'score':currentScore,
  'name':authUser.displayName
});

  }
  }
