class Strings {
  static String welcomeMessage = "Welcome To Flutter";

  static String getWordTopics(int numberOfTopics) {
    String wordTopics = "тема";
    if (numberOfTopics > 1 && numberOfTopics < 5) wordTopics = "темы";
    if (numberOfTopics >= 5) wordTopics = "тем";
    return wordTopics;
  }


}
