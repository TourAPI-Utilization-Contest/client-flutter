import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: SearchExample(),
    );
  }
}

class SearchExample extends StatefulWidget {
  @override
  _SearchExampleState createState() => _SearchExampleState();
}

class _SearchExampleState extends State<SearchExample> {
  bool readOnly = false;
  List<String> suggestions = [];
  String previousText = '';
  TextEditingController _searchController = TextEditingController();

  void _onTextChanged(String value) {
    // 여기에서 추천 검색어를 업데이트합니다.
    setState(() {
      if (value.isEmpty) {
        suggestions = [];
      } else {
        // 예시: 간단한 추천 검색어 목록 필터링
        final allSuggestions = [
          'Apple',
          'Banana',
          'Cherry',
          'Date',
          'Elderberry',
        ];
        suggestions = allSuggestions
            .where((item) => item.toLowerCase().contains(value.toLowerCase()))
            .toList();
      }
    });
  }

  void _onEnter(String value) {
    // 검색 실행
    print('검색 실행: $value');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('검색창 예시'),
      ),
      body: Column(
        children: [
          searchTextField(
            context,
            readOnly: readOnly,
            controller: _searchController,
            onChange: _onTextChanged,
            onEnter: _onEnter,
          ),
          // 추천 검색어 목록 표시
          if (suggestions.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: suggestions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(suggestions[index]),
                    onTap: () {
                      // 추천 검색어를 선택하면 검색창에 반영하고 검색 실행
                      setState(() {
                        _searchController.text = suggestions[index];
                        suggestions = [];
                      });
                      _onEnter(suggestions[index]);
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget searchTextField(BuildContext context,
      {required bool readOnly,
      required TextEditingController controller,
      void Function(String value)? onEnter,
      void Function(String value)? onChange}) {
    FocusNode _focusNode = FocusNode();
    String previousText = '';

    return MouseRegion(
      cursor: readOnly ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        behavior: HitTestBehavior.deferToChild,
        onTap: readOnly
            ? () {
                // _go(context); // 필요 시 구현
              }
            : null,
        child: Container(
          height: 50,
          padding: const EdgeInsets.only(left: 16, right: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F8F8),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: const Color(0xFF9CEFFF),
              width: 2,
            ),
            boxShadow: readOnly
                ? const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.25),
                      blurRadius: 2,
                      offset: Offset(1, 1),
                    ),
                  ]
                : null,
          ),
          child: IgnorePointer(
            ignoring: readOnly,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: KeyboardListener(
                      focusNode: _focusNode,
                      onKeyEvent: (event) {
                        if (!readOnly) return;
                        if (event is KeyDownEvent &&
                            event.logicalKey == LogicalKeyboardKey.enter) {
                          // _go(context); // 엔터 키 눌렀을 때 실행할 동작
                        }
                      },
                      child: TextField(
                        autofocus: !readOnly,
                        readOnly: readOnly,
                        controller: controller,
                        onChanged: (value) {
                          var text = controller.value;
                          if (text.composing.isCollapsed) {
                            onChange?.call(text.text);
                          } else {
                            if (text.text.length > previousText.length) {
                              onChange?.call(text.text);
                            }
                          }
                          previousText = text.text;
                        },
                        onSubmitted: !readOnly ? onEnter : null,
                        decoration: const InputDecoration(
                          hintText: '어디로 떠나볼까요?',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontFamily: 'NotoSansKR',
                            fontVariations: [FontVariation('wght', 200)],
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => onEnter?.call(controller.text),
                  icon: SvgPicture.asset(
                    'assets/icon/search.svg',
                    colorFilter:
                        const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                    height: 19.9,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
