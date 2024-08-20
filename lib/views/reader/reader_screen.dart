import 'package:flutter/material.dart';
import 'package:katechizm_flutter/core/models/kkk_part.model.dart';

class ReaderScreen extends StatelessWidget {
  const ReaderScreen({super.key, required this.chapter});
  final KKKChapter chapter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(chapter.name),
      ),
      body: ListView.builder(
          itemCount: chapter.elements.length,
          itemBuilder: (c, i) {
            final el = chapter.elements[i];

            switch (el.type) {
              case KKKElementType.paragraph:
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${el.number}.",
                            style: const TextStyle(fontSize: 18)),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Text(
                            el.content ?? "",
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              case KKKElementType.article:
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    el.content ?? "",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );

              case KKKElementType.comment:
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Opacity(
                    opacity: 0.8,
                    child: Text(
                      "Kom: ${el.content}",
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                );
              case KKKElementType.label:
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    el.content ?? "",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                );
              case KKKElementType.quote:
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Opacity(
                    opacity: 0.8,
                    child: Text(
                      "Cyt: ${el.content}",
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                );

              case KKKElementType.header:
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    el.content ?? "",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
            }
          }),
    );
  }
}
