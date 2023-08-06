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
    "Apa perbedaan bit klasik dengan bit kuantum/qubit?",
    [
      Answer("Bit kuantum tidak dapat berada pada keadaan superposisi", false),
      Answer("Bit classic dapat berada pada keadaan superposisi", false),
      Answer("Bit kuantum dapat berada pada keadaan superposisi", true),
      Answer("Bit kuantum dan klasik berbeda hanya dalam bentuknya saja", false),
    ],
  ));

  list.add(Question(
    "Teknik yang mengubah sinyal amplitudo pada audio menjadi sinyal frekuensi adalah?",
    [
      Answer("SS", false),
      Answer("LSB", false),
      Answer("DCT", true),
      Answer("Wavelet", false),
    ],
  ));

  list.add(Question(
    "Apa yang dimaksud dengan Signal to Noise Ratio?",
    [
      Answer("Signal to Noise Ratio (SNR) adalah perbandingan nilai antara sinyal audio asli dengan error sinyal audio yang sudah ter-watermark", true),
      Answer("Signal to Noise Ratio (SNR) adalah hasil dari sinyal yang sudah ter-watermark", false),
      Answer("Signal to Noise Ratio (SNR) adalah hasil sinyal error dari audio yang sudah ter-watermark", false),
      Answer("semua jawaban benar", false),
    ],
  ));

  list.add(Question(
    "Bagaimana konsep watermarking menggunakan Spread Spectrum?",
    [
      Answer("watermarking berbasis Spread Spectrum (SS) adalah menyebarkan setiap bit watermark di atas spektrum sinyal host", true),
      Answer("watermarking berbasis Spread Spectrum (SS) adalah menyebarkan setiap bit watermark di bawah spektrum sinyal host", false),
      Answer("watermarking berbasis Spread Spectrum (SS) adalah menyebarkan hanya bit awal saja di spektrum sinyal host", false),
      Answer("tidak ada jawaban yang benar", false),
    ],
  ));

  list.add(Question(
    "Apa yang dimaksud dengan MOS?",
    [
      Answer("Mean Opinion Score (MOS) adalah parameter objektif hasil penilaian secara reseptual dari survei terhadap responden", false),
      Answer("Mean Opinion Score (MOS) adalah parameter keberhasilan dari proses penyatuan antara file host dan file watermark", false),
      Answer("Mean Opinion Score (MOS) adalah parameter keberhasilan dari proses pemisahan ter-watermark", false),
      Answer("Mean Opinion Score (MOS) adalah parameter subjektif hasil penilaian secara perseptual dari survei terhadap responden", true),
    ],
  ));

  return list;
}