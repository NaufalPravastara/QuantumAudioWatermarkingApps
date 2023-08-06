class Question {
  final String questionText;
  final List<Answer> answersList;

  Question(this.questionText, this.answersList);
}

class Answer {
  final String answerText;
  final bool isCorrect;

  Answer(this.answerText, this.isCorrect);
}

List<Question> getQuestions() {
  List<Question> list = [];
  //ADD questions and answer here

  list.add(Question(
    "Bagaimana representasi dari quantum bit?",
    [
      Answer("0 dan 1", false),
      Answer("|0< dan |1<", false),
      Answer("|0> dan |1>", true),
      Answer("1 dan 1", false),
    ],
  ));

  list.add(Question(
    "Bagaimana cara kerja proses dekomposisi pada DWT?",
    [
      Answer("DWT menghambat sinyal yang akan dianalisis pada filter dengan frekuensi dan skala yang berbeda", false),
      Answer("DWT meloloskan sinyal yang akan dianalisis pada filter dengan frekuensi dan skala yang berbeda", true),
      Answer("DWT meloloskan sinyal yang akan dianalisis pada filter dengan frekuensi dan skala yang sama", false),
      Answer("DWT menghambat sinyal yang akan dianalisis pada filter dengan frekuensi dan skala yang sama", false),
    ],
  ));

  list.add(Question(
    "Ada berapa subband yang dihasilkan dari dekomposisi wavelet level 1?",
    [
      Answer("2, high-pass filter dan low-pass filter", true),
      Answer("1, high-pass filter", false),
      Answer("1, low-pass filter", false),
      Answer("semua jawaban benar", false),
    ],
  ));

  list.add(Question(
    "Berapa nilai bit tunggal yang dapat disisipkan menggunakan teknik watermarking spread spectrum?",
    [
      Answer("ada 2, 1 dan 2", false),
      Answer("ada 2, 0 dan -1", false),
      Answer("ada 2, 1 dan -1", true),
      Answer("ada 2, 0 dan 1", false),
    ],
  ));

  list.add(Question(
    "Apa parameter yang digunakan untuk mengetahui kerusakan yang terjadi pada watermark setelah dilakukan penyerangan?",
    [
      Answer("Signal to Ratio (SNR)", false),
      Answer("Mean Square Error (MSE)", false),
      Answer("Peak Signal-to-Noise Ratio (PSNR)", false),
      Answer("Bit Error Rate (BER)", true),
    ],
  ));

  return list;
}