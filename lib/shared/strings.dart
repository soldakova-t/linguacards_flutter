class Strings {
  static String welcomeMessage = "Welcome To Flutter";

  static String getWordTopics(int numberOfTopics) {
    String wordTopics = "тема";
    if (numberOfTopics > 1 && numberOfTopics < 5) wordTopics = "темы";
    if (numberOfTopics >= 5) wordTopics = "тем";
    return wordTopics;
  }

  static String getPartOfSpeech(String partOfSpeechDB) {
    String wordPartOfSpeech = "";
    if (partOfSpeechDB == "noun") wordPartOfSpeech = "существительное";
    if (partOfSpeechDB == "verb") wordPartOfSpeech = "глагол";
    if (partOfSpeechDB == "phrasal verb") wordPartOfSpeech = "фразовый глагол";
    if (partOfSpeechDB == "adjective") wordPartOfSpeech = "прилагательное";
    if (partOfSpeechDB == "idiom") wordPartOfSpeech = "идиома";
    return wordPartOfSpeech;

  }


}
