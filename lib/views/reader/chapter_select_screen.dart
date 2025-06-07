import 'package:flutter/material.dart';
import 'package:katechizm_flutter/core/models/kkk_part_model.dart';
import 'package:katechizm_flutter/views/reader/reader_screen.dart';

class ChapterSelectScreen extends StatelessWidget {
  final KKKModel model;
  const ChapterSelectScreen({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(model.title)),
      body: ListView.builder(
        itemCount: model.chapters.length,
        itemBuilder: (context, index) {
          final chapter = model.chapters[index];
          return ListTile(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (c) => ReaderScreen(chapter: chapter),
                ),
              );
            },
            title: Text(
              "${chapter.name} (${chapter.startNum}-${chapter.endNum})",
            ),
            trailing: Icon(Icons.chevron_right),
          );
        },
      ),
    );
  }
}
