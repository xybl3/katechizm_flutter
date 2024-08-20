import 'package:flutter/material.dart';
import 'package:katechizm_flutter/core/loader/kkk_loader.dart';
import 'package:katechizm_flutter/views/reader/chapter_select_screen.dart';
import 'package:katechizm_flutter/views/topics/topics_Screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> pushLoaded(BuildContext conext) async {
    final model = await KKKLoader.loadPart(1);
    Navigator.of(conext).push(
        MaterialPageRoute(builder: (c) => ChapterSelectScreen(model: model)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Katechizm"),
        ),
        body: ListView(
          children: [
            Image.asset("assets/images/pallotinum.png"),
            ListTile(
              onTap: () async {
                final topics = await KKKLoader.loadTopics();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (c) => TopicsScreen(
                          topics: topics,
                        )));
              },
              title: Text("Tematy"),
            ),
            ListTile(
              title: Text("Wstęp"),
            ),
            ListTile(
              onTap: () {
                pushLoaded(context);
              },
              leading: Image.asset(
                "assets/images/I.jpeg",
                width: 30,
                height: 30,
              ),
              title: Text("Część pierwsza"),
              trailing: Icon(Icons.chevron_right),
            ),
            ListTile(
              leading: Image.asset(
                "assets/images/II.jpeg",
                width: 30,
                height: 30,
              ),
              title: Text("Część druga"),
            ),
            ListTile(
              leading: Image.asset(
                "assets/images/III.jpeg",
                width: 30,
                height: 30,
              ),
              title: Text("Część trzecia"),
            ),
            ListTile(
              leading: Image.asset(
                "assets/images/IV.jpeg",
                width: 30,
                height: 30,
              ),
              title: Text("Część czwarta"),
            ),
          ],
        ));
  }
}
