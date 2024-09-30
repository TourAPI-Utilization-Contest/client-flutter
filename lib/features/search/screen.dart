import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

import 'package:tradule/common/search_text_field.dart';
import 'package:tradule/common/back_button.dart' as common;
import 'package:tradule/common/color.dart';
import 'package:tradule/common/section.dart';
import 'package:tradule/common/place_card.dart';
import 'package:tradule/tourapi_wrapper/GW.dart';
import 'package:tradule/server_wrapper/data/place_data.dart';

// class SearchScreen extends StatefulWidget {
//   const SearchScreen({super.key});
//
//   @override
//   _SearchScreenState createState() => _SearchScreenState();
// }
//
// class _SearchScreenState extends State<SearchScreen> {
//   final TextEditingController _textController = TextEditingController();
//   final TextEditingController _textController2 = TextEditingController();
//   // final Color cGray = const Color(0xff9E9E9E);
//   final SearchController _searchController = SearchController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         // title: const Text('Search'),
//         backgroundColor: Colors.white,
//         leading: common.BackButton(context: context),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             searchTextField(context, readOnly: false),
//             const SizedBox(height: 16),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: SearchAnchor(
//                 searchController: _searchController,
//                 builder: (BuildContext context, SearchController controller) {
//                   return SearchBar(
//                     controller: controller,
//                     // padding: const MaterialStatePropertyAll<EdgeInsets>(
//                     //     EdgeInsets.symmetric(horizontal: 16.0)),
//                     onTap: () {
//                       controller.openView();
//                     },
//                     onChanged: (_) {
//                       controller.openView();
//                     },
//                     side: const WidgetStatePropertyAll<BorderSide>(
//                       BorderSide(
//                         color: cAqua, // 테두리 색상
//                         width: 2.0, // 테두리 두께
//                       ),
//                     ),
//                     constraints: const BoxConstraints(
//                       maxHeight: 50.0,
//                       minHeight: 50.0,
//                     ),
//                     backgroundColor: const WidgetStatePropertyAll<Color>(
//                       cGray2,
//                     ),
//                     hintText: '어디로 떠나볼까요?',
//                     hintStyle: const WidgetStatePropertyAll<TextStyle>(
//                       TextStyle(
//                         color: cGray,
//                         fontSize: 16,
//                         fontFamily: 'NotoSansKR',
//                         fontVariations: [FontVariation('wght', 200)],
//                       ),
//                     ),
//                     // leading: const Icon(Icons.search),
//                     // surfaceTintColor: const WidgetStatePropertyAll<Color>(
//                     //   Colors.white,
//                     // ),
//                     overlayColor: const WidgetStatePropertyAll<Color>(
//                       Colors.transparent,
//                     ),
//                     trailing: <Widget>[
//                       Tooltip(
//                         message: '검색하기',
//                         child: IconButton(
//                           // isSelected: isDark,
//                           onPressed: () {},
//                           icon: SvgPicture.asset(
//                             'assets/icon/search.svg',
//                             colorFilter:
//                                 ColorFilter.mode(cGray, BlendMode.srcIn),
//                             height: 19.9,
//                           ),
//                         ),
//                       )
//                     ],
//                   );
//                 },
//
//                 dividerColor: Colors.transparent,
//
//                 // viewSide: BorderSide(
//                 //   color: Colors.blue, // 테두리 색상
//                 //   width: 2.0, // 테두리 두께
//                 // ),
//                 viewTrailing: <Widget>[
//                   Tooltip(
//                     message: '초기화',
//                     child: IconButton(
//                       icon: SvgPicture.asset(
//                         'assets/icon/jam_close_circle_f.svg',
//                         colorFilter: ColorFilter.mode(cGray, BlendMode.srcIn),
//                         height: 19.9,
//                       ),
//                       onPressed: () {
//                         // _controller.closeView(null);
//                         _textController.clear();
//                       },
//                     ),
//                   )
//                 ],
//                 viewSide: const BorderSide(
//                   color: cAqua, // 테두리 색상
//                   width: 2.0, // 테두리 두께
//                 ),
//                 suggestionsBuilder:
//                     (BuildContext context, SearchController controller) {
//                   return List<ListTile>.generate(5, (int index) {
//                     final String item = 'item $index';
//                     return ListTile(
//                       title: Text(item),
//                       onTap: () {
//                         setState(() {
//                           controller.closeView(item);
//                         });
//                       },
//                     );
//                   });
//                 },
//                 viewLeading: Container(),
//                 viewHintText: '주소, 장소, 키워드를 입력하세요',
//                 viewSurfaceTintColor: Colors.white,
//                 viewConstraints: const BoxConstraints(
//                   minHeight: 50.0,
//                   maxHeight: 200.0,
//                 ),
//                 viewBackgroundColor: Colors.white,
//                 textCapitalization: TextCapitalization.none,
//                 viewBuilder: (viewBuilder) {
//                   return Column(
//                     children: <Widget>[
//                       const Divider(
//                         height: 1.0,
//                         color: cGray2,
//                       ),
//                     ],
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SearchBar(
                controller: _textController,
                // padding: const MaterialStatePropertyAll<EdgeInsets>(
                //     EdgeInsets.symmetric(horizontal: 16.0)),
                focusNode: _focusNode,
                autoFocus: true,
                onTap: () {
                  setState(() {});
                },
                onSubmitted: (value) async {
                  // var r = await searchKeyword1Request(SearchKeyword1RequestData(
                  //   numOfRows: 3,
                  //   pageNo: 1,
                  //   type: 'json',
                  //   keyword: value,
                  // ));
                  // print(r);
                  onEnter(value);
                  setState(() {});
                },
                onChanged: (_) {
                  setState(() {});
                },
                side: const WidgetStatePropertyAll<BorderSide>(
                  BorderSide(
                    color: cAqua,
                    width: 2.0,
                  ),
                ),
                constraints: const BoxConstraints(
                  maxHeight: 50.0,
                  minHeight: 50.0,
                ),
                backgroundColor: const WidgetStatePropertyAll<Color>(
                  cGray2,
                ),
                hintText:
                    _focusNode.hasFocus ? '주소, 장소, 키워드를 입력하세요' : '어디로 떠나볼까요?',
                hintStyle: const WidgetStatePropertyAll<TextStyle>(
                  TextStyle(
                    // color: _focusNode.hasFocus ? Colors.black38 : cGray,
                    color: cGray,
                    fontSize: 16,
                    fontFamily: 'NotoSansKR',
                    fontVariations: [FontVariation('wght', 200)],
                  ),
                ),

                // leading: const Icon(Icons.search),
                // surfaceTintColor: const WidgetStatePropertyAll<Color>(
                //   Colors.white,
                // ),
                overlayColor: const WidgetStatePropertyAll<Color>(
                  Colors.transparent,
                ),
                trailing: <Widget>[
                  _textController.text.isEmpty
                      ? Tooltip(
                          message: '검색하기',
                          child: IconButton(
                            // isSelected: isDark,
                            onPressed: () {},
                            icon: SvgPicture.asset(
                              'assets/icon/search.svg',
                              colorFilter:
                                  ColorFilter.mode(cGray, BlendMode.srcIn),
                              height: 19.9,
                            ),
                          ),
                        )
                      : Tooltip(
                          message: '초기화',
                          child: IconButton(
                            icon: SvgPicture.asset(
                              'assets/icon/jam_close_circle_f.svg',
                              colorFilter:
                                  ColorFilter.mode(cGray, BlendMode.srcIn),
                              height: 19.9,
                            ),
                            onPressed: () {
                              // _controller.closeView(null);
                              _textController.clear();
                              setState(() {});
                            },
                          ),
                        )
                ],
              ),
            ),
            Column(
              children: [
                // searchTextField(context, readOnly: false),
                // if (_focusNode.hasFocus)
                //   Container(
                //     color: Colors.white,
                //     child: Column(
                //       children: [
                //         for (var item in suggestions)
                //           Padding(
                //             padding: const EdgeInsets.all(8.0),
                //             child: item,
                //           ),
                //       ],
                //     ),
                //   ),
                Section(
                  title: const Text('검색 결과'),
                  //searchResults
                  content: Column(
                    children: [
                      for (var item in searchResults)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: item,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  onEnter(String text) async {
    searchResults.clear();
    var jsonString = await searchKeyword1Request(SearchKeyword1RequestData(
      numOfRows: 3,
      pageNo: 1,
      type: 'json',
      keyword: text,
    ));
    Map<String, dynamic> jsonData = json.decode(jsonString);
    print(jsonString);
    if (jsonData["response"]["body"]["items"].isEmpty) {
      return;
    }

    for (var item in jsonData["response"]["body"]["items"]["item"]) {
      print(item);
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
    setState(() {});
  }

  onChanged(String text) {
    print(text);
  }
}
