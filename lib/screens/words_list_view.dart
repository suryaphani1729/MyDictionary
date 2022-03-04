import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:section_view/section_view.dart';
import '../models/word.model.dart';

class WordsListView extends StatefulWidget {
  Iterable<Word>? wordsList = [];
  Function getDataFromDB;
  WordsListView(this.wordsList, this.getDataFromDB, {Key? key})
      : super(key: key);

  @override
  State<WordsListView> createState() => _WordsListViewState();
}

class _WordsListViewState extends State<WordsListView> {
  List<AlphabetHeader<Word>> _filterWords = [];
  late TextEditingController _textController;
  final _refreshController = RefreshController(initialRefresh: false);
  _loadWords() async {
    //_words = convertListToAlphaHeader<Word>(
    //   widget.wordsList, (item) => (item.word).substring(0, 1).toUpperCase());
    _constructAlphabet(widget.wordsList);
  }

  void _constructAlphabet(Iterable<Word>? words) {
    var _wordsList = convertListToAlphaHeader<Word>(
        words!, (item) => (item.word).substring(0, 1).toUpperCase());
    setState(() {
      _filterWords = _wordsList;
    });
  }

  _didSearch() {
    var keywork = _textController.text.trim().toLowerCase();
    var filterwords = widget.wordsList!
        .where((item) => item.word.toLowerCase().contains(keywork));
    _constructAlphabet(filterwords);
  }

  @override
  void initState() {
    _loadWords();
    _textController = TextEditingController(text: '');
    _textController.addListener(_didSearch);
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future _onRefresh() async {
    await Future.delayed(const Duration(seconds: 2));
    widget.getDataFromDB();
    setState(() {});
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
          child: CupertinoSearchTextField(controller: _textController),
        ),
        Expanded(
          flex: 1,
          child: SectionView<AlphabetHeader<Word>, Word>(
            source: _filterWords,
            onFetchListData: (header) => header.items,
            enableSticky: true,
            alphabetAlign: Alignment.center,
            alphabetInset: const EdgeInsets.all(4.0),
            alphabetBuilder: getDefaultAlphabetBuilder((d) => d.alphabet),
            tipBuilder: getDefaultTipBuilder((d) => d.alphabet),
            refreshBuilder: (child) {
              return SmartRefresher(
                  enablePullDown: true,
                  enablePullUp: false,
                  header: const WaterDropHeader(),
                  controller: _refreshController,
                  onRefresh: _onRefresh,
                  child: child);
            },
            headerBuilder: (context, headerData, headerIndex) {
              return Container(
                color: const Color(0xFFF3F4F5),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 12.0),
                  child: Text(
                    headerData.alphabet,
                    style:
                        const TextStyle(fontSize: 18, color: Color(0xFF767676)),
                  ),
                ),
              );
            },
            itemBuilder:
                (context, itemData, itemIndex, headerData, headerIndex) {
              return Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: ListTile(
                    onLongPress: () {},
                    title: Text(itemData.word),
                    trailing: Text(itemData.meaning)),
              );
            },
          ),
        ),
      ],
    );
  }
}
