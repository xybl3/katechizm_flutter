import 'package:flutter/material.dart';
import 'package:katechizm_flutter/core/loader/kkk_loader.dart';
import 'package:katechizm_flutter/core/models/kkk_part_model.dart';
import 'package:katechizm_flutter/views/reader/reader_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<KKKContent>? _results;
  bool _loading = false;
  bool _initialized = false;

  List<TextSpan> highlightOccurrences(
    BuildContext context,
    String text,
    String query,
  ) {
    final matches = <TextSpan>[];
    var remaining = text;
    final queryWords =
        query.toLowerCase().split(' ').where((s) => s.isNotEmpty).toList();

    while (remaining.isNotEmpty) {
      var lowestIndex = remaining.length;
      var shortestQuery = '';

      // Find the earliest occurrence of any query word
      for (final word in queryWords) {
        final index = remaining.toLowerCase().indexOf(word);
        if (index != -1 && index < lowestIndex) {
          lowestIndex = index;
          shortestQuery = word;
        }
      }

      if (lowestIndex == remaining.length) {
        matches.add(TextSpan(text: remaining));
        break;
      }

      if (lowestIndex > 0) {
        matches.add(TextSpan(text: remaining.substring(0, lowestIndex)));
      }

      matches.add(
        TextSpan(
          text: remaining.substring(
            lowestIndex,
            lowestIndex + shortestQuery.length,
          ),
          style: TextStyle(
            backgroundColor:
                Theme.of(context).brightness == Brightness.light
                    ? Colors.yellow
                    : Colors.red,
          ),
        ),
      );

      remaining = remaining.substring(lowestIndex + shortestQuery.length);
    }

    return matches;
  }

  @override
  void dispose() {
    KKKLoader.unloadSearchData();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _initSearchData() async {
    if (!_initialized) {
      setState(() => _loading = true);
      await KKKLoader.loadSearchData();
      setState(() {
        _initialized = true;
        _loading = false;
      });
    }
  }

  void _onSearchChanged(String query) async {
    await _initSearchData();
    setState(() {
      _results = KKKLoader.searchResults(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Szukaj")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: "Wyszukaj numer lub treść...",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          if (_loading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            )
          else if (_results == null)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("Wpisz zapytanie, aby rozpocząć wyszukiwanie."),
            )
          else if (_results!.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("Brak wyników."),
            )
          else
            Expanded(
              child: Scrollbar(
                controller: _scrollController,
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: _results!.length,
                  itemBuilder: (context, idx) {
                    final item = _results![idx];
                    final query = _controller.text.toLowerCase();
                    final content = item.content ?? '';
                    final matches =
                        content.toLowerCase().contains(query) &&
                        query.isNotEmpty;

                    return ListTile(
                      onTap: () async {
                        KKKPart? part = KKKPartExtension.fromNumber(
                          item.number!,
                        );

                        KKKChapter chapter = (await KKKLoader.loadPart(
                          part,
                        )).chapters.firstWhere(
                          (c) =>
                              c.startNum <= item.number! &&
                              c.endNum >= item.number!,
                        );
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder:
                                (c) => ReaderScreen(
                                  chapter: chapter,
                                  scrollTo: item.number,
                                ),
                          ),
                        );
                      },
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (item.number != null)
                            Text(
                              '${item.number}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          const SizedBox(width: 8),
                          Expanded(
                            child:
                                matches && query.isNotEmpty
                                    ? Text.rich(
                                      TextSpan(
                                        children: highlightOccurrences(
                                          context,
                                          content,
                                          query,
                                        ),
                                      ),
                                    )
                                    : Text(content),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
