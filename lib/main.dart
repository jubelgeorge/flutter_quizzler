import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'quiz_brain.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

QuizBrain quizBrain = QuizBrain();

void main() => runApp(Quizzler());

class Quizzler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey.shade900,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "QUIZZLER",
            style: TextStyle(fontSize: 30.0),
          ),
        ),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: QuizPage(),
        )),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Icon> scoreKeeper = [];
  final audio = AssetsAudioPlayer();

  void checkedAnswer(bool userPickedAnswer) {
    bool correctAnswer = quizBrain.getQuestionAnswer();
    setState(() {
      if (quizBrain.isFinished() == true) {
        audio.open(
          Audio("assets/Getlow.mp3"),
        );
        Alert(
                context: context,
                title: "Finished!",
                desc: "You\'ve reached the end of the quiz.")
            .show();
        quizBrain.reset();
        scoreKeeper = [];
      } else {
        if (userPickedAnswer == correctAnswer) {
          audio.open(
            Audio("assets/correct sound effect.mp3"),
          );
          scoreKeeper.add(
            Icon(
              Icons.check,
              color: Colors.green,
            ),
          );
          quizBrain.nextQuestion();
        } else {
          audio.open(
            Audio("assets/incorrect sound effect.mp3"),
          );
          scoreKeeper.add(
            Icon(
              Icons.clear,
              color: Colors.red,
            ),
          );
          quizBrain.nextQuestion();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: Text(
                quizBrain.getQuestionText(),
                style: TextStyle(color: Colors.white, fontSize: 30.0),
              )),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FlatButton(
                onPressed: () {
                  checkedAnswer(true);
                },
                child: Text(
                  'True',
                  style: TextStyle(color: Colors.white, fontSize: 40.0),
                ),
                color: Colors.green,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FlatButton(
                onPressed: () {
                  checkedAnswer(false);
                },
                child: Text(
                  'False',
                  style: TextStyle(color: Colors.white, fontSize: 40.0),
                ),
                color: Colors.red,
              ),
            ),
          ),
          Row(
            children: scoreKeeper,
          )
        ],
      ),
    );
  }
}
