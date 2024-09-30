import 'dart:convert';
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
import 'package:tradule/tourapi_wrapper/GW.dart';
import 'package:tradule/server_wrapper/data/place_data.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _textController2 = TextEditingController();
  // final Color cGray = const Color(0xff9E9E9E);
  final SearchController _searchController = SearchController();
  final FocusNode _focusNode = FocusNode();
  // bool suggestionsVisible = false;
  List<Widget> suggestions = [];
  List<Widget> searchResults = [];
  bool searchResultsLoading = false;
  bool suggestionsLoading = false;
  bool suggestionsStop = false;
  String? suggestionsReservedText;
  String? suggestionsPreviousText;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {});
    });
    var p = PlaceData(
      id: "1234",
      title: "경복궁",
      address: "주소",
      latitude: 1234,
      longitude: 1234,
      imageUrl: "",
      iconColor: 0xFF9CEFFF,
    );
    setState(() {
      searchResults.add(
        PlaceCard(
          placeData: p,
        ),
      );
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _textController2.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text('Search'),
        backgroundColor: Colors.white,
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MyTextField(
                    controller: _textController,
                    focusNode: _focusNode,
                    onChanged: onChanged,
                    onSubmitted: onEnter,
                    hintText: _focusNode.hasFocus
                        ? '주소, 장소, 키워드를 입력하세요'
                        : '어디로 떠나볼까요?',
                  )),
              Column(
                children: [
                  // searchTextField(context, readOnly: false),
                  if (_focusNode.hasFocus)
                    // Container(
                    //   color: Colors.white,
                    //   child: Column(
                    //     children: [
                    //       for (var item in suggestions)
                    //         Padding(
                    //           padding: const EdgeInsets.all(8.0),
                    //           child: item,
                    //         ),
                    //     ],
                    //   ),
                    // ),
                    buildSuggestions(),
                  Section(
                    title: Text('검색 결과',
                        style: myTextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        )),
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
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        if (!searchResultsLoading && searchResults.isEmpty)
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
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
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
    if (text.trim().isEmpty) {
      suggestions.clear();
      suggestionsReservedText = null;
      suggestionsStop = true;
      setState(() {});
      return;
    }

    suggestionsStop = false;
    text = text.trim().replaceAll(RegExp(r'\s+'), ' ');
    if (text == suggestionsPreviousText) return;
    suggestionsPreviousText = text;
    if (suggestionsLoading) {
      suggestionsReservedText = text;
      return;
    }

    suggestionsLoading = true;
    setState(() {});

    var jsonData = await tourApiRequest(
      keyword: text,
      pageNo: 1,
      numOfRows: 5,
    );

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
        for (var item in jsonData["response"]["body"]["items"]["item"]) {
          if (titles.contains(item["title"])) continue;
          suggestions.add(
            SuggestionsItem(
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

    if (searchResultsLoading) return; // 중복 요청 방지
    searchResultsLoading = true;
    setState(() {});

    text = text.trim().replaceAll(RegExp(r'\s+'), ' ');
    var jsonData = await tourApiRequest(
      keyword: text,
      pageNo: 1,
      numOfRows: 10,
    );

    try {
      if (jsonData["response"] != null &&
          jsonData["response"]["body"]["items"].isNotEmpty) {
        for (var item in jsonData["response"]["body"]["items"]["item"]) {
          searchResults.add(
            PlaceCard(
              placeData: PlaceData(
                id: item["contentid"],
                title: item["title"],
                address: item["addr1"],
                latitude: double.parse(item["mapy"]),
                longitude: double.parse(item["mapx"]),
                imageUrl: item["firstimage"],
                iconColor: 0xFF9CEFFF,
              ),
            ),
          );
        }
      }
    } catch (e) {
      print(e);
      print(jsonData);
    }

    searchResultsLoading = false;
    setState(() {});
  }

  Widget buildSuggestions() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          for (var item in suggestions)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: item,
            ),
        ],
      ),
    );
  }
}

class SuggestionsItem extends StatelessWidget {
  final String text;
  final String searchText;
  const SuggestionsItem({
    super.key,
    required this.text,
    required this.searchText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: buildText(context),
    );
  }

  Widget buildText(BuildContext context) {
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

    // 검색어가 없을 경우 전체 텍스트를 그대로 보여줌
    if (searchText.isEmpty || !text.contains(searchText)) {
      spans.add(TextSpan(
        text: text,
        style: defaultStyle,
      ));
    } else {
      int start = 0;
      int index;

      // 검색어가 여러 번 등장할 수 있으므로 반복문을 사용
      while ((index = text.indexOf(searchText, start)) != -1) {
        // 검색어 앞부분 추가
        if (index > start) {
          spans.add(TextSpan(
            text: text.substring(start, index),
            style: defaultStyle,
          ));
        }

        // 검색어 부분 추가 (특정 색상 적용)
        spans.add(TextSpan(
          text: searchText,
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
