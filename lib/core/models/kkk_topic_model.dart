/*
{
    "letter": "A",
    "subject": "Abba",
    "numbers": [683, 742, 1303, 2605, 2766, 2777]
  },
  */

class KKKTopicModel {
  String letter;
  String subject;
  List<int> numbers;

  KKKTopicModel({
    required this.letter,
    required this.subject,
    required this.numbers,
  });

  factory KKKTopicModel.fromJSON(Map<String, dynamic> json) {
    return KKKTopicModel(
      letter: json["letter"],
      subject: json['subject'],
      numbers:
          (json['numbers'] as List<dynamic>)
              .map((element) => int.parse(element.toString()))
              .toList(),
    );
  }
}
