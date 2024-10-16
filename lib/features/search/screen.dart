import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

import 'package:tradule/common/search_text_field.dart';
import 'package:tradule/common/back_button.dart' as common;
import 'package:tradule/common/color.dart';
import 'package:tradule/common/section.dart';
import 'package:tradule/common/place_card.dart';
import 'package:tradule/common/my_text_field.dart';
import 'package:tradule/common/my_text_style.dart';
import 'package:tradule/common/single_child_scroll_fade_view.dart';
import 'package:tradule/tourapi_wrapper/GW.dart';
import 'package:tradule/server_wrapper/data/place_data.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  // final TextEditingController _textController2 = TextEditingController();
  // final Color cGray = const Color(0xff9E9E9E);
  // final SearchController _searchController = SearchController();
  final FocusNode _focusNode = FocusNode();
  // bool suggestionsVisible = false;
  bool firstSearch = true;
  List<Widget> suggestions = [];
  List<Widget> searchResults = [];
  bool searchResultsLoading = false;
  bool suggestionsLoading = false;
  bool suggestionsStop = false;
  bool suggestionsVisible = false;
  String? suggestionsReservedText;
  String? suggestionsPreviousText;
  Map<String, Map<String, dynamic>> suggestionsCache = {};
  String lastSearchText = '';
  int pageNo = 1;
  bool endOfResults = false;
  int totalCount = 0;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {});
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        makeSearchResults();
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text('Search'),
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        leading: common.BackButton(context: context),
        title: Row(
          children: [
            SvgPicture.asset(
              'assets/logo/tradule_text.svg',
              height: 20,
              colorFilter: const ColorFilter.mode(
                cGray,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 14),
            Text(
              '장소 검색',
              style: myTextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: cGray,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: MyTextField(
                  controller: _textController,
                  focusNode: _focusNode,
                  onTap: () {
                    suggestionsVisible = true;
                    setState(() {});
                  },
                  onTapOutside: (event) {
                    // suggestionsVisible = false;
                    _focusNode.unfocus();
                  },
                  onChanged: onChanged,
                  onSubmitted: onEnter,
                  autoFocus: true,
                  hintText:
                      _focusNode.hasFocus ? '주소, 장소, 키워드를 입력하세요' : '어디로 떠나볼까요?',
                )),
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: SingleChildScrollFadeView(
                      scrollController: _scrollController,
                      child: Column(
                        children: [
                          if (!firstSearch)
                            Section(
                              title: Row(
                                spacing: 8,
                                children: [
                                  Text('검색 결과',
                                      style: myTextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      )),
                                  Text(
                                    '총 $totalCount건',
                                    style: myTextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w200,
                                      color: cDark,
                                    ),
                                  ),
                                ],
                              ),
                              content: Column(
                                children: [
                                  for (var item in searchResults)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 16),
                                      child: item,
                                    ),
                                  if (searchResultsLoading)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 16),
                                      child: CircularProgressIndicator(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ),
                                  if (!searchResultsLoading &&
                                      searchResults.isEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 16),
                                      child: Text(
                                        '검색 결과가 없습니다.',
                                        style: myTextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  if (!searchResultsLoading && !endOfResults)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 16),
                                      child: TextButton(
                                        onPressed: makeSearchResults,
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 8,
                                          ),
                                          minimumSize: Size.zero,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            side: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          '더 보기',
                                          style: myTextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  if (!searchResultsLoading &&
                                      searchResults.isNotEmpty &&
                                      endOfResults)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 16),
                                      child: Text(
                                        '더 이상 검색 결과가 없어요!',
                                        style: myTextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  if (suggestionsVisible && _textController.text.isNotEmpty)
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: buildSuggestions(),
                    ),
                  if (firstSearch && _textController.text.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        '어서 검색해 보세요!',
                        style: myTextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> tourApiRequest(
      {required String keyword,
      required int pageNo,
      required int numOfRows}) async {
    var jsonString = await searchKeyword1Request(SearchKeyword1RequestData(
      numOfRows: numOfRows,
      pageNo: pageNo,
      type: 'json',
      keyword: keyword,
    ));
    return json.decode(jsonString);
  }

  onChanged(String text) async {
    suggestionsVisible = true;
    setState(() {});

    if (text.trim().isEmpty) {
      suggestions.clear();
      suggestionsReservedText = null;
      suggestionsPreviousText = null;
      suggestionsStop = true;
      setState(() {});
      return;
    }

    suggestionsStop = false;
    if (suggestionsLoading) {
      suggestionsReservedText = text;
      return;
    }
    text = text.replaceAll(RegExp(r'\s+'), ' ');
    if (text == suggestionsPreviousText) return;
    suggestionsPreviousText = text;

    suggestionsLoading = true;
    setState(() {});

    Map<String, dynamic> jsonData;
    if (suggestionsCache.containsKey(text)) {
      jsonData = suggestionsCache[text]!;
    } else {
      jsonData = await tourApiRequest(
        keyword: text,
        pageNo: 1,
        numOfRows: 5,
      );
      suggestionsCache[text] = jsonData;
    }

    suggestions.clear();

    if (suggestionsStop) {
      suggestionsLoading = false;
      setState(() {});
      return;
    }

    try {
      if (jsonData["response"] != null &&
          jsonData["response"]["body"]["items"].isNotEmpty) {
        Set<String> titles = {};
        var count = 0;
        for (var item in jsonData["response"]["body"]["items"]["item"]) {
          if (titles.contains(item["title"])) continue;
          if (count++ >= 3) break;
          suggestions.add(
            buildSuggestionsItem(
              text: item["title"],
              searchText: text,
            ),
          );
          titles.add(item["title"]);
        }
      }
    } catch (e) {
      print(e);
      print(jsonData);
    }

    suggestionsLoading = false;
    setState(() {});

    if (suggestionsReservedText != null) {
      onChanged(suggestionsReservedText!);
      suggestionsReservedText = null;
    }
  }

  onEnter(String text) async {
    searchResults.clear();
    if (text.trim().isEmpty) {
      setState(() {});
      return;
    }

    suggestionsVisible = false;
    suggestionsStop = true;
    firstSearch = false;
    endOfResults = false;
    pageNo = 0;
    text = text.trim().replaceAll(RegExp(r'\s+'), ' ');
    lastSearchText = text;
    makeSearchResults();
  }

  void makeSearchResults() async {
    if (endOfResults) return;
    if (searchResultsLoading) return; // 중복 요청 방지
    searchResultsLoading = true;
    setState(() {});
    var jsonData = await tourApiRequest(
      keyword: lastSearchText,
      pageNo: ++pageNo,
      numOfRows: 10,
    );

    try {
      if (jsonData["response"] != null) {
        totalCount = jsonData["response"]["body"]["totalCount"];
        if (jsonData["response"]["body"]["items"].isNotEmpty) {
          var items = jsonData["response"]["body"]["items"]["item"];
          if (items.length < 10) endOfResults = true;
          for (var item in items) {
            searchResults.add(
              PlaceCard(
                placeData: PlaceData(
                  id: int.parse(item["contentid"]),
                  title: item["title"],
                  address: item["addr1"],
                  latitude: double.parse(item["mapy"]),
                  longitude: double.parse(item["mapx"]),
                  imageUrl: item["firstimage"],
                  thumbnailUrl: item["firstimage2"],
                  iconColor: const Color(0xFF9CEFFF),
                  isProvided: true,
                ),
              ),
            );
          }
        } else {
          endOfResults = true;
        }
      } else {
        endOfResults = true;
      }
    } catch (e) {
      print(e);
      print(jsonData);
    }
    searchResultsLoading = false;
    setState(() {});
  }

  Widget buildSuggestions() {
    return ClipRect(
      child: BackdropFilter(
        filter: suggestionsVisible
            ? ImageFilter.blur(sigmaX: 5, sigmaY: 5)
            : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
        child: Material(
          color: const Color(0xE0FFFFFF),
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 16,
            ),
            child: Column(
              children: [
                Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '추천 검색어',
                          style: myTextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w200,
                            color: const Color(0xFF50555C),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            suggestionsVisible = false;
                            setState(() {});
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            minimumSize: Size.zero,
                          ),
                          child: Text(
                            '닫기',
                            style: myTextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w200,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (suggestionsLoading)
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    if (suggestions.isEmpty && !suggestionsLoading)
                      const SizedBox.shrink(),
                  ],
                ),
                for (var i = 0; i < suggestions.length; i++) ...[
                  suggestions[i],
                  if (i < suggestions.length - 1)
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xFFD9D9D9),
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSuggestionsItem(
      {required String text, required String searchText}) {
    return ListTile(
      onTap: () {
        _textController.text = text;
        _focusNode.unfocus();
        setState(() {});
        onEnter(text);
      },
      contentPadding: EdgeInsets.zero,
      leading: SvgPicture.asset(
        'assets/icon/jam_map_marker_f.svg',
      ),
      title: buildText(text, searchText),
      trailing: Padding(
        padding: const EdgeInsets.only(right: 8),
        child: SvgPicture.asset(
          'assets/icon/jam_arrow_right.svg',
        ),
      ),
    );
  }

  Widget buildText(String text, String searchText) {
    List<TextSpan> spans = [];
    var defaultStyle = myTextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: const Color(0xFF50555C),
    );
    var searchStyle = myTextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Theme.of(context).colorScheme.primary,
    );
    var textLower = text.toLowerCase();
    var searchTextLower = searchText.toLowerCase();

    // 검색어가 없을 경우 전체 텍스트를 그대로 보여줌
    if (searchText.isEmpty || !textLower.contains(searchTextLower)) {
      spans.add(TextSpan(
        text: text,
        style: defaultStyle,
      ));
    } else {
      int start = 0;
      int index;

      // 검색어가 여러 번 등장할 수 있으므로 반복문을 사용
      while ((index = textLower.indexOf(searchTextLower, start)) != -1) {
        // 검색어 앞부분 추가
        if (index > start) {
          spans.add(TextSpan(
            text: text.substring(start, index),
            style: defaultStyle,
          ));
        }

        // 검색어 부분 추가 (특정 색상 적용)
        spans.add(TextSpan(
          text: text.substring(index, index + searchText.length),
          style: searchStyle,
        ));

        // 다음 검색 시작 위치 갱신
        start = index + searchText.length;
      }

      // 마지막으로 남은 부분 추가
      if (start < text.length) {
        spans.add(TextSpan(
          text: text.substring(start),
          style: defaultStyle,
        ));
      }
    }

    return Text.rich(
      TextSpan(children: spans),
    );
  }
}
