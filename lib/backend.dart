// import 'whatever'

class QuizState {
  static const topicNames = [
    'Helyek',
    'Városok',
    'Népek',
    'Országok',
    'Nyelvek',
  ];
  static var questions = [
    for (int i = 0; i < 5; i++)
      [for (int j = 0; j < 6; j++) '${i + 1}. téma ${j + 1}. kérdése'],
  ];
}
