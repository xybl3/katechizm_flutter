enum KKKElementType { header, article, label, paragraph, comment, quote }

class KKKContent {
  final KKKElementType type;
  final int? number;
  final String? content;

  KKKContent({required this.type, this.number, this.content});

  factory KKKContent.fromJson(Map<String, dynamic> json) {
    return KKKContent(
      type: KKKElementType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
      ),
      number: json['number'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.toString().split('.').last,
      'number': number,
      'content': content,
    };
  }
}

class KKKChapter {
  final String name;
  final int index;
  final int startNum;
  final int endNum;
  final String sectionBelonged;
  final List<KKKContent> elements;

  KKKChapter({
    required this.name,
    required this.index,
    required this.startNum,
    required this.endNum,
    required this.sectionBelonged,
    required this.elements,
  });

  factory KKKChapter.fromJson(Map<String, dynamic> json) {
    return KKKChapter(
      name: json['name'],
      index: json['index'],
      startNum: json['startNum'],
      endNum: json['endNum'],
      sectionBelonged: json['sectionBelonged'],
      elements:
          (json['elements'] as List<dynamic>)
              .map((e) => KKKContent.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'index': index,
      'startNum': startNum,
      'endNum': endNum,
      'sectionBelonged': sectionBelonged,
      'elements': elements.map((e) => e.toJson()).toList(),
    };
  }
}

class KKKModel {
  final String title;
  final int startNum;
  final int endNum;
  final int sectionCount;
  final List<KKKChapter> chapters;

  KKKModel({
    required this.title,
    required this.startNum,
    required this.endNum,
    required this.sectionCount,
    required this.chapters,
  });

  factory KKKModel.fromJson(Map<String, dynamic> json) {
    return KKKModel(
      title: json['title'],
      startNum: json['startNum'],
      endNum: json['endNum'],
      sectionCount: json['sectionCount'],
      chapters:
          (json['chapters'] as List<dynamic>)
              .map((e) => KKKChapter.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'startNum': startNum,
      'endNum': endNum,
      'sectionCount': sectionCount,
      'chapters': chapters.map((e) => e.toJson()).toList(),
    };
  }
}

enum KKKPart { intro, first, second, third, fourth }

extension KKKPartExtension on KKKPart {
  static KKKPart fromNumber(int number) {
    if (number <= 25) {
      return KKKPart.intro;
    } else if (number <= 1065) {
      return KKKPart.first;
    } else if (number <= 1690) {
      return KKKPart.second;
    } else if (number <= 2557) {
      return KKKPart.third;
    } else {
      return KKKPart.fourth;
    }
  }
}
