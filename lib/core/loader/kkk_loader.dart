import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:katechizm_flutter/core/models/kkk_part_model.dart';
import 'package:katechizm_flutter/core/models/kkk_topic_model.dart';

class KKKLoader {
  static List<KKKContent>? _catechismElements;

  static Future<KKKModel> loadPart(KKKPart part) async {
    String path;
    switch (part) {
      case KKKPart.intro:
        path = "assets/data/wstep.json";
        break;
      case KKKPart.first:
        path = "assets/data/pierwsza.json";
        break;
      case KKKPart.second:
        path = "assets/data/druga.json";
        break;
      case KKKPart.third:
        path = "assets/data/trzecia.json";
        break;
      case KKKPart.fourth:
        path = "assets/data/czwarta.json";
        break;
    }
    final jsonContent = await rootBundle.loadString(path);
    return KKKModel.fromJson(jsonDecode(jsonContent));
  }

  static Future<KKKChapter> loadIntro() async {
    final jsonContent = await rootBundle.loadString("assets/data/wstep.json");
    return KKKModel.fromJson(jsonDecode(jsonContent)).chapters[0];
  }

  static Future<List<KKKTopicModel>> loadTopics() async {
    final jsonContent = await rootBundle.loadString("assets/data/tematy.json");

    return (jsonDecode(jsonContent) as List<dynamic>)
        .map(
          (element) => KKKTopicModel.fromJSON(element as Map<String, dynamic>),
        )
        .toList();
  }

  // --- Added: Load all catechism elements (paragraphs) for search ---
  static Future<List<KKKContent>> _loadCatechism() async {
    List<KKKContent> arr = [];
    for (final part in KKKPart.values) {
      final model = await loadPart(part);
      for (final chapter in model.chapters) {
        arr.addAll(
          chapter.elements.where((e) => e.type == KKKElementType.paragraph),
        );
      }
    }
    return arr;
  }

  // --- Added: Load search data into memory ---
  static Future<void> loadSearchData() async {
    _catechismElements = await _loadCatechism();
  }

  // --- Added: Search results by query (number or content) ---
  static List<KKKContent>? searchResults(String? query) {
    if (query == null || query.isEmpty) return null;
    if (_catechismElements == null) return null;

    final isNumber = int.tryParse(query) != null;
    if (isNumber) {
      return _catechismElements!
          .where(
            (e) => (e.number?.toString().toLowerCase() ?? '').contains(
              query.toLowerCase(),
            ),
          )
          .toList();
    } else {
      final queryWords =
          query.toLowerCase().split(' ').where((w) => w.isNotEmpty).toList();
      return _catechismElements!
          .where(
            (e) => queryWords.every(
              (word) => (e.content ?? '').toLowerCase().contains(word),
            ),
          )
          .toList();
    }
  }

  // --- Added: Unload search data from memory ---
  static void unloadSearchData() {
    _catechismElements = null;
  }

  // --- Added: Load and group subjects by first letter ---
  static Future<Map<String, List<KKKTopicModel>>> loadGroupedSubjects() async {
    final topics = await loadTopics();
    topics.sort((a, b) => a.subject.compareTo(b.subject));
    final Map<String, List<KKKTopicModel>> grouped = {};
    for (final topic in topics) {
      final letter = topic.letter.isNotEmpty ? topic.letter[0] : '';
      grouped.putIfAbsent(letter, () => []).add(topic);
    }
    return grouped;
  }

  // static List<KKKTopicModel> searchTopics(
  //   String query,
  //   List<KKKTopicModel> topics,
  // ) {
  //   if (query.isEmpty) return topics;

  //   final lowerQuery = query.toLowerCase();
  //   return topics.where((topic) {
  //     return topic.subject.toLowerCase().contains(lowerQuery) ||
  //         topic.content.toLowerCase().contains(lowerQuery);
  //   }).toList();
  // }

  // static KKKTopicModel
}
