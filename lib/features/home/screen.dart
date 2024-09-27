import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tradule/server_wrapper/server_wrapper.dart';
import 'package:tradule/common/section.dart';
import 'package:tradule/features/login/screen.dart';
import 'package:tradule/features/user/screen.dart';
import 'package:tradule/features/itinerary/screen.dart';
import 'package:tradule/features/itinerary_info/screen.dart';
import 'package:tradule/features/search/screen.dart';
import 'package:elevated_flex/elevated_flex.dart';

import 'package:tradule/common/search_text_field.dart';
// import 'package:tradule/common/color.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: 1,
    );
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: [
          // Center(child: Text('Page 1')),
          // MapWithBottomSheet(),
          CustomBottomSheetMap(),
          MainPage(),
          // LoginScreen(),
          ServerWrapper.isLogin() ? UserScreen() : LoginScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tabController?.index ?? 0,
        onTap: (index) {
          if (index == 2 && !ServerWrapper.isLogin()) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LoginScreen(),
              ),
            ).then((value) {
              setState(() {});
            });
            return;
          }
          _tabController?.animateTo(index);
          setState(() {});
        },
        type: BottomNavigationBarType.fixed,
        enableFeedback: false,
        iconSize: 30.0,
        unselectedItemColor: const Color(0xFFABB0BC),
        selectedItemColor: Theme.of(context).colorScheme.primary,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            // icon: Icon(Icons.location_on_outlined),
            // activeIcon: Icon(Icons.location_on),
            icon: BottomNavigationBarItemIcon('assets/icon/jam_heart.svg'),
            label: '내 장소',
          ),
          BottomNavigationBarItem(
            // icon: Icon(Icons.home_outlined),
            // activeIcon: Icon(Icons.home),
            icon: BottomNavigationBarItemIcon('assets/icon/jam_home.svg'),
            label: '홈 화면',
          ),
          BottomNavigationBarItem(
            // icon: const Icon(Icons.person_outline),
            // activeIcon: const Icon(Icons.person),
            icon: BottomNavigationBarItemIcon('assets/icon/jam_user.svg'),
            label: ServerWrapper.isLogin() ? '내 정보' : '로그인',
          ),
        ],
      ),
    );
  }

  Widget BottomNavigationBarItemIcon(String assetName) {
    return Builder(builder: (context) {
      return SvgPicture.asset(
        assetName,
        colorFilter: ColorFilter.mode(
          IconTheme.of(context).color ?? Colors.black,
          BlendMode.srcIn,
        ),
      );
    });
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with AutomaticKeepAliveClientMixin<MainPage> {
  final ScrollController _scrollController = ScrollController();
  List<String> _events = [];
  bool _isLoading = false;
  int _currentPage = 0;
  double searchY = 108;

  @override
  void initState() {
    super.initState();
    _loadMoreEvents();

    // 스크롤 컨트롤러를 사용하여 스크롤이 최하단에 도달했을 때 추가 일정 로딩
    _scrollController.addListener(() {
      // print('ScrollController: ${_scrollController.position.pixels}');
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadMoreEvents();
      }
    });
  }

  Future<void> _loadMoreEvents() async {
    if (_isLoading) return; // 이미 로딩 중이면 중복 호출 방지
    setState(() {
      _isLoading = true;
    });

    // 서버에서 데이터를 가져오는 임의의 함수 (임시 구현)
    final newEvents = await ServerWrapper.getEvents(_currentPage);
    if (!mounted) return;
    setState(() {
      _currentPage++;
      _events.addAll(newEvents); // 새로운 일정 추가
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        // title: ServerWrapper.isLogin()
        //     ? Text('${ServerWrapper.getUser()!.name}님')
        //     : Text('로그인이 필요합니다.'),
        // title: const Text("Tradule"),
        centerTitle: false,
        titleSpacing: 17,
        title: SvgPicture.asset(
          'assets/logo/tradule_text.svg',
          color: Colors.white,
          width: 80,
        ),
        // flexibleSpace: ClipRect(
        //   child: BackdropFilter(
        //     // AppBar에 투명도 효과를 주기 위한 위젯
        //     filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        //     child: Container(
        //       color: Colors.white.withOpacity(0.3),
        //     ),
        //   ),
        // ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Stack(
          children: [
            Container(
              // color: Theme.of(context).colorScheme.primary,
              height: searchY,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  top: 10,
                  left: 17,
                  right: 17,
                  bottom: 50,
                ),
                child: Row(
                  children: [
                    ServerWrapper.isLogin()
                        ? Row(
                            children: [
                              Text('${ServerWrapper.getUser()!.name}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontFamily: 'NotoSansKR',
                                    fontVariations: [
                                      FontVariation('wght', 500)
                                    ],
                                  )),
                              Text('님 안녕하세요!',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontFamily: 'NotoSansKR',
                                    fontVariations: const [
                                      FontVariation('wght', 400)
                                    ],
                                  )),
                            ],
                          )
                        : Text('로그인이 필요합니다.',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontFamily: 'NotoSansKR',
                              fontVariations: [FontVariation('wght', 400)],
                            )),
                    const Spacer(),
                    ServerWrapper.isLogin()
                        ? ElevatedButton(
                            onPressed: () {
                              ServerWrapper.logout();
                              setState(() {});
                            },
                            child: const Text('로그아웃'),
                          )
                        : ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ),
                              ).then((value) {
                                setState(() {});
                              });
                            },
                            child: const Text('로그인'),
                          ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: searchY - 25,
                right: 17,
                left: 17,
              ),
              child: searchTextField(
                context,
                readOnly: true,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: searchY + 25),
              child: Column(
                children: [
                  Section(
                    title: '내 일정',
                    content: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(32),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                spreadRadius: 1,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ItineraryInfoScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              backgroundColor: Colors.white,
                              elevation:
                                  0, // Material의 elevation을 활용하므로 버튼 자체에서는 그림자 제거
                            ),
                            icon: Icon(Icons.add_circle, color: Colors.black54),
                            label: Text(
                              "새 일정 만들기",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        ..._events.map((event) => ScheduleItem(
                              title: event,
                              date: '10/3 (목)',
                              location: '장소명 1',
                              status: '완료',
                            )),
                        if (_isLoading)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          ),
                      ],
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

  @override
  bool get wantKeepAlive => true;
}

class ScheduleItem extends StatefulWidget {
  final String title;
  final String date;
  final String location;
  final String status;

  const ScheduleItem({
    required this.title,
    required this.date,
    required this.location,
    required this.status,
  });

  @override
  _ScheduleItemState createState() => _ScheduleItemState();
}

class _ScheduleItemState extends State<ScheduleItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 8,
      ),
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    spreadRadius: 1,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.event, color: Colors.black54),
                      SizedBox(width: 10),
                      Text(widget.title, style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  Icon(
                    _isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    color: Colors.black54,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20) +
                const EdgeInsets.only(top: 55),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              height: _isExpanded ? 150 : 0,
              curve: Curves.easeInOut,
              child: Container(
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      spreadRadius: 1,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('날짜: ${widget.date}',
                              style: TextStyle(fontSize: 16)),
                          SizedBox(width: 16),
                          Text('상태: ${widget.status}',
                              style: TextStyle(fontSize: 16)),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 20),
                          SizedBox(width: 8),
                          Text('장소: ${widget.location}',
                              style: TextStyle(fontSize: 16)),
                        ],
                      ),
                      SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            // 일정 수정 로직 구현
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ].reversed.toList(),
      ),
    );
  }
}
