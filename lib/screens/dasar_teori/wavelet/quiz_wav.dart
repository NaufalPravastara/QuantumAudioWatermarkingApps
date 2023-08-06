import 'package:flutter/material.dart';
import 'package:ta_capstone/entry_point.dart';
import 'package:ta_capstone/models/question_model_wave.dart';
import 'package:ta_capstone/screens/home_screen.dart';

class QuizWav extends StatefulWidget {
  @override
  State<QuizWav> createState() => _QuizWavState();
}

class _QuizWavState extends State<QuizWav> {
  //define the datas
  List<Question> questionList = getQuestions();
  int currentQuestionIndex = 0;
  int score = 0;
  Answer? selectedAnswer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Quiz qWavelet"),
        centerTitle: true,
      ),
      backgroundColor: const Color.fromARGB(255, 5, 50, 80),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          const Text(
            "",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
          _questionWidget(),
          _answerList(),
          _nextButton(),
        ]),
      ),
    );
  }

  _questionWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Question ${currentQuestionIndex + 1}/${questionList.length.toString()}",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.center,
          width: double.infinity,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.orangeAccent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            questionList[currentQuestionIndex].questionText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        )
      ],
    );
  }

  _answerList() {
    return Column(
      children: questionList[currentQuestionIndex]
          .answersList
          .map(
            (e) => _answerButton(e),
          )
          .toList(),
    );
  }

  Widget _answerButton(Answer answer) {
    bool isSelected = answer == selectedAnswer;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      height: 48,
      child: ElevatedButton(
        child: Text(answer.answerText),
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          primary: isSelected ? Colors.orangeAccent : Colors.white,
          onPrimary: isSelected ? Colors.white : Colors.black,
        ),
        onPressed: () {
          if (selectedAnswer != answer) {
            // Periksa apakah jawaban yang baru dipilih berbeda dengan jawaban sebelumnya
            if (selectedAnswer != null && selectedAnswer!.isCorrect) {
              score--; // Mengurangi skor jika jawaban sebelumnya benar
            }
            if (answer.isCorrect) {
              score++; // Menambah skor jika jawaban baru yang dipilih benar
            }
            setState(() {
              selectedAnswer = answer; // Memperbarui jawaban yang dipilih
            });
          }
        },
      ),
    );
  }

  _nextButton() {
    bool isLastQuestion = false;
    if (currentQuestionIndex == questionList.length - 1) {
      isLastQuestion = true;
    }

    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      height: 48,
      child: ElevatedButton(
        child: Text(isLastQuestion ? "Submit" : "Next"),
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          primary: Colors.blueAccent,
          onPrimary: Colors.white,
        ),
        onPressed: () {
          if (isLastQuestion) {
            //display score

            showDialog(context: context, builder: (_) => _showScoreDialog());
          } else {
            //next question
            setState(() {
              selectedAnswer = null;
              currentQuestionIndex++;
            });
          }
        },
      ),
    );
  }

  _showScoreDialog() {
  bool isPassed = false;

  if (score >= questionList.length * 0.6) {
    //pass if 60%
    isPassed = true;
  }
  String title = isPassed ? "Passed " : "Failed";

  return AlertDialog(
    content: Container(
      constraints: BoxConstraints(maxWidth: 280), // Memuat constraints untuk membatasi lebar dialog
      child: Column(
        mainAxisSize: MainAxisSize.min, // Mengatur ukuran dialog agar sesuai dengan kontennya
        children: [
          Text(
            title + " | Score is $score",
            style: TextStyle(color: isPassed ? Colors.green : Colors.redAccent),
          ),
          ElevatedButton(
            child: const Text("Restart"),
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                currentQuestionIndex = 0;
                score = 0;
                selectedAnswer = null;
              });
            },
          ),
          ElevatedButton(
            child: const Text("Keluar"),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EntryPoint()),
                );
            },
          ),
        ],
      ),
    ),
  );
}


}
