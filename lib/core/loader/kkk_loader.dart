import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:katechizm_flutter/core/models/kkk_part.model.dart';
import 'package:katechizm_flutter/core/models/kkk_topic_model.dart';

class KKKLoader {
  static Future<KKKModel> loadPart(int part) async {
    final jsonContent =
        await rootBundle.loadString("assets/contents/pierwsza.json");
    return KKKModel.fromJson(jsonDecode(jsonContent));
  }

  static Future<List<KKKTopicModel>> loadTopics() async {
    final jsonContent =
        await rootBundle.loadString("assets/contents/tematy.json");

    return (jsonDecode(jsonContent) as List<dynamic>)
        .map((element) =>
            KKKTopicModel.fromJSON(element as Map<String, dynamic>))
        .toList();
  }
}
