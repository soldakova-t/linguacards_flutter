class Strings {
  static String welcomeMessage = "Welcome To Flutter";

  static String getWordTopics(int numberOfTopics) {
    String wordTopics = "тема";
    if (numberOfTopics > 1 && numberOfTopics < 5) wordTopics = "темы";
    if (numberOfTopics >= 5) wordTopics = "тем";
    return wordTopics;
  }

  static String getWordWords(int numberOfWords) {
    int lastNumber;
    if (numberOfWords < 10) {
      lastNumber = numberOfWords;
    } else {
      lastNumber = int.parse(numberOfWords.toString()[1]);
    }

    String wordWords = "слово";
    if (lastNumber > 1 && lastNumber < 5) wordWords = "слова";
    if (lastNumber == 0 ||
        lastNumber >= 5 ||
        (numberOfWords >= 11 && numberOfWords <= 14)) wordWords = "слов";
    return wordWords;
  }

  static String getPartOfSpeech(String partOfSpeechDB) {
    String wordPartOfSpeech = "";
    if (partOfSpeechDB == "noun") wordPartOfSpeech = "существительное";
    if (partOfSpeechDB == "verb") wordPartOfSpeech = "глагол";
    if (partOfSpeechDB == "phrasal verb") wordPartOfSpeech = "фразовый глагол";
    if (partOfSpeechDB == "adjective") wordPartOfSpeech = "прилагательное";
    if (partOfSpeechDB == "adverb") wordPartOfSpeech = "наречие";
    if (partOfSpeechDB == "idiom") wordPartOfSpeech = "идиома";
    return wordPartOfSpeech;
  }
}
