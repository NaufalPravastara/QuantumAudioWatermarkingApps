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
    "Apa itu kuantum watermarking?",
    [
      Answer("kuantum watermarking adalah teknik yang digunakan untuk menyembunyikan atau menyisipkan informasi rahasia dalam data kuantum", true),
      Answer("kuantum watermarking adalah teknik yang digunakan untuk menyembunyikan atau menyisipkan informasi rahasia dalam data klasik", false),
      Answer("kuantum watermarking adalah teknik yang digunakan untuk memperlihatkan informasi dalam data kuantum", false),
      Answer("semua jawaban benar", false),
    ],
  ));

  list.add(Question(
    "Berapa hasil qubit informasi yang dihasilkan jika menggunakan phase encoding?",
    [
      Answer("4", false),
      Answer("3", false),
      Answer("2", false),
      Answer("1", true),
    ],
  ));

  list.add(Question(
    "Mengapa metode LSB sering digunakan dalam kuantum watermarking?",
    [
      Answer("Karena memiliki algoritma yang detail dan merinci", false),
      Answer("Karena memiliki fase encoding yang sederhana dan efektif", false),
      Answer("Karena memiliki algoritma yang sederhana dan efektif", true),
      Answer("semua jawaban benar", false),
    ],
  ));

  list.add(Question(
    "Dimana letak perubahan bit audio jika menggunakan metode watermarking LSB?",
    [
      Answer("bit awal", false),
      Answer("bit tengah", false),
      Answer("bit terakhir", true),
      Answer("hanya bit yang bernilai tinggi", false),
    ],
  ));

  list.add(Question(
    "Bagaimana cara kerja dari serangan Pauli-X?",
    [
      Answer("menambah nilai qubit pada watermark", false),
      Answer("membalikan nilai qubit pada watermark", true),
      Answer("mengurangi nilai qubit pada watermark", false),
      Answer("membuat nilai qubit pada watermark", false),
    ],
  ));

  return list;
}