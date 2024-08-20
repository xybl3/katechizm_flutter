import 'package:flutter/material.dart';
import 'package:katechizm_flutter/core/models/kkk_topic_model.dart';

class TopicsScreen extends StatelessWidget {
  const TopicsScreen({super.key, required this.topics});
  final List<KKKTopicModel> topics;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tematy"),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: TopicsSearchDelegate(topics),
              );
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: ListView.separated(
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(topics[index].subject),
          );
        },
        separatorBuilder: (context, int) {
          return const Divider();
        },
        itemCount: topics.length,
      ),
    );
  }
}

class TopicsSearchDelegate extends SearchDelegate<String> {
  final List<KKKTopicModel> topics;

  TopicsSearchDelegate(this.topics);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = topics
        .where((topic) =>
            topic.subject.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final topic = results[index];
        return ListTile(
          title: _buildHighlightedText(context, topic.subject, query),
          onTap: () {
            close(context, topic.subject);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = topics
        .where((topic) =>
            topic.subject.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final topic = suggestions[index];
        return ListTile(
          title: _buildHighlightedText(context, topic.subject, query),
          onTap: () {
            query = topic.subject;
            showResults(context);
          },
        );
      },
    );
  }

  Widget _buildHighlightedText(
      BuildContext context, String text, String query) {
    if (query.isEmpty) {
      return Text(text);
    }

    final textLower = text.toLowerCase();
    final queryLower = query.toLowerCase();
    final startIndex = textLower.indexOf(queryLower);

    if (startIndex == -1) {
      return Text(text);
    }

    final endIndex = startIndex + query.length;

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: text.substring(0, startIndex),
            style: TextStyle(
                color:
                    MediaQuery.of(context).platformBrightness == Brightness.dark
                        ? Colors.white
                        : Colors.black),
          ),
          TextSpan(
            text: text.substring(startIndex, endIndex),
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: text.substring(endIndex),
            style: TextStyle(
                color:
                    MediaQuery.of(context).platformBrightness == Brightness.dark
                        ? Colors.white
                        : Colors.black),
          ),
        ],
      ),
    );
  }
}
