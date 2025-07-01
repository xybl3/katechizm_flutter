import 'package:flutter/material.dart';
import 'package:katechizm_flutter/core/models/kkk_part_model.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ReaderScreen extends StatefulWidget {
  const ReaderScreen({super.key, required this.chapter, this.scrollTo});
  final KKKChapter chapter;
  final int? scrollTo;

  @override
  _ReaderScreenState createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();
  bool _hasScrolled = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.scrollTo != null) {
        _tryScrollToItem(widget.scrollTo!);
      }
    });
  }

  void _tryScrollToItem(int targetNumber) {
    final targetIndex = widget.chapter.elements.indexWhere(
      (el) => el.number == targetNumber,
    );
    if (targetIndex == -1) return;

    if (!_hasScrolled) {
      _itemScrollController.scrollTo(
        index: targetIndex,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
      _hasScrolled = true;
    }
  }

  Widget _buildElementWidget(int i) {
    final el = widget.chapter.elements[i];

    Widget child;

    switch (el.type) {
      case KKKElementType.paragraph:
        child = SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${el.number}.", style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  el.content ?? "",
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        );
        break;
      case KKKElementType.article:
        child = Text(
          el.content ?? "",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          textAlign: TextAlign.center,
        );
        break;
      case KKKElementType.comment:
        child = Opacity(
          opacity: 0.8,
          child: Text(
            el.content ?? "",
            style: const TextStyle(fontSize: 14),
          ),
        );
        break;
      case KKKElementType.label:
        child = Text(
          el.content ?? "",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        );
        break;
      case KKKElementType.quote:
        child = Opacity(
          opacity: 0.8,
          child: Text(
            el.content ?? "",
            style: const TextStyle(fontSize: 14),
          ),
        );
        break;
      case KKKElementType.header:
        child = Text(
          el.content ?? "",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          textAlign: TextAlign.center,
        );
        break;
      default:
        child = const SizedBox.shrink();
    }

    return Padding(padding: const EdgeInsets.all(12.0), child: child);
    // return Padding(padding: const EdgeInsets.all(8.0), child: child);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.chapter.name)),
      body: SafeArea(
        child: Scrollbar(
          child: ScrollablePositionedList.builder(
            itemScrollController: _itemScrollController,
            itemPositionsListener: _itemPositionsListener,
            itemCount: widget.chapter.elements.length,
            itemBuilder: (c, i) => _buildElementWidget(i),
          ),
        ),
      ),
    );
  }
}
