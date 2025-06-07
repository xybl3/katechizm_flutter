import 'package:flutter/material.dart';
import 'package:katechizm_flutter/core/loader/kkk_loader.dart';
import 'package:katechizm_flutter/core/models/kkk_part_model.dart';
import 'package:katechizm_flutter/views/reader/chapter_select_screen.dart';
import 'package:katechizm_flutter/views/reader/reader_screen.dart';
import 'package:katechizm_flutter/views/topics/topics_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> pushLoaded(BuildContext conext, KKKPart part) async {
    final model = await KKKLoader.loadPart(part);
    if (conext.mounted) {
      Navigator.of(conext).push(
        MaterialPageRoute(builder: (c) => ChapterSelectScreen(model: model)),
      );
    }
  }

  Future<void> pushIntro(BuildContext context) async {
    final chapt = await KKKLoader.loadIntro();
    if (context.mounted) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (c) => ReaderScreen(chapter: chapt)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Katechizm")),
      body: ListView(
        children: [
          Image.asset("assets/images/pallotinum.png"),
          ListTile(
            trailing: Icon(Icons.chevron_right),
            leading: Image.asset("assets/images/T.png", width: 30, height: 30),
            onTap: () async {
              final topics = await KKKLoader.loadTopics();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (c) => TopicsScreen(topics: topics)),
              );
            },
            title: Text("Tematy"),
          ),
          ListTile(
            onTap: () {
              pushIntro(context);
            },
            trailing: Icon(Icons.chevron_right),
            leading: Image.asset("assets/images/W.png", width: 30, height: 30),
            title: Text("Wstęp"),
          ),
          ListTile(
            onTap: () {
              pushLoaded(context, KKKPart.first);
            },
            leading: Image.asset("assets/images/I.jpeg", width: 30, height: 30),
            title: Text("Część pierwsza"),
            trailing: Icon(Icons.chevron_right),
          ),
          ListTile(
            onTap: () {
              pushLoaded(context, KKKPart.second);
            },
            leading: Image.asset(
              "assets/images/II.jpeg",
              width: 30,
              height: 30,
            ),
            title: Text("Część druga"),
            trailing: Icon(Icons.chevron_right),
          ),
          ListTile(
            onTap: () {
              pushLoaded(context, KKKPart.third);
            },
            leading: Image.asset(
              "assets/images/III.jpeg",
              width: 30,
              height: 30,
            ),
            title: Text("Część trzecia"),
            trailing: Icon(Icons.chevron_right),
          ),
          ListTile(
            onTap: () {
              pushLoaded(context, KKKPart.fourth);
            },
            leading: Image.asset(
              "assets/images/IV.jpeg",
              width: 30,
              height: 30,
            ),
            title: Text("Część czwarta"),
            trailing: Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}
