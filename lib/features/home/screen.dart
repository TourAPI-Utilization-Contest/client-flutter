import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:tradule/common/global_value.dart';
import 'package:tradule/common/itinerary_card.dart';
import 'package:tradule/common/sort_widget.dart';
import 'package:tradule/features/itinerary/congestion.dart';
import 'package:tradule/features/itinerary/screen_legacy.dart';
import 'package:tradule/features/my_place/screen.dart';
import 'package:tradule/server_wrapper/server_wrapper.dart';
import 'package:tradule/common/section.dart';
import 'package:tradule/features/login/screen.dart';
import 'package:tradule/features/user/screen.dart';
import 'package:tradule/features/itinerary/screen_legacy.dart' as legacy;
import 'package:tradule/features/itinerary/screen.dart';
import 'package:tradule/features/itinerary_info/screen.dart';
import 'package:tradule/features/search/screen.dart';
// import 'package:elevated_flex/elevated_flex.dart';

import 'package:tradule/server_wrapper/data/user_data.dart';
import 'package:tradule/server_wrapper/data/itinerary_data.dart';
import 'package:tradule/common/search_text_field.dart';
import 'package:tradule/common/color.dart';
import 'package:tradule/common/my_text_style.dart';
import 'package:tradule/common/shadow_box.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  // TabController? _tabController;

  @override
  void initState() {
    super.initState();
    // mainTabController = TabController(
    //   length: 3,
    //   vsync: this,
    //   initialIndex: 1,
    // );
  }

  @override
  void dispose() {
    mainTabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserCubit>.value(
      value: ServerWrapper.userCubit,
      child: BlocBuilder<UserCubit, UserData?>(
        builder: (context, userData) {
          // if (userData == null) {
          //   return Scaffold(
          //     body: Center(
          //       child: CircularProgressIndicator(),
          //     ),
          //   );
          // }
          mainTabController ??= TabController(
            length: 3,
            vsync: this,
            initialIndex: 1,
          )..addListener(() {
              setState(() {});
            });
          return Scaffold(
            body: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: mainTabController,
              children: [
                // Center(child: Text('Page 1')),
                // MapWithBottomSheet(),
                // legacy.CustomBottomSheetMap(),
                MyPlaceScreen(),
                MainPage(),
                UserScreen(),
                // LoginScreen(),
                // ServerWrapper.isLogin() ? UserScreen() : LoginScreen(),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: mainTabController?.index ?? 0,
              onTap: (index) {
                if ((index == 2 || index == 0) && !ServerWrapper.isLogin()) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
                  return;
                }
                mainTabController?.animateTo(index);
                setState(() {});
              },
              type: BottomNavigationBarType.fixed,
              enableFeedback: false,
              iconSize: 30.0,
              unselectedItemColor: cGray3,
              selectedItemColor: Theme.of(context).colorScheme.primary,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  // icon: Icon(Icons.location_on_outlined),
                  // activeIcon: Icon(Icons.location_on),
                  icon:
                      bottomNavigationBarItemIcon('assets/icon/jam_heart.svg'),
                  label: '내 장소',
                ),
                BottomNavigationBarItem(
                  // icon: Icon(Icons.home_outlined),
                  // activeIcon: Icon(Icons.home),
                  icon: bottomNavigationBarItemIcon('assets/icon/jam_home.svg'),
                  label: '홈 화면',
                ),
                BottomNavigationBarItem(
                  // icon: const Icon(Icons.person_outline),
                  // activeIcon: const Icon(Icons.person),
                  icon: bottomNavigationBarItemIcon('assets/icon/jam_user.svg'),
                  // label: ServerWrapper.isLogin() ? '내 정보' : '로그인',
                  label: '내 정보',
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget bottomNavigationBarItemIcon(String assetName) {
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
  // List<String> _events = [];
  List<ItineraryCubit> _itineraryCubitList = [];
  bool _isLoading = false;
  int _currentPage = 0;
  double searchY = 108;

  @override
  void initState() {
    super.initState();
    _loadAllItineraries();

    // // 스크롤 컨트롤러를 사용하여 스크롤이 최하단에 도달했을 때 추가 일정 로딩
    // _scrollController.addListener(() {
    //   // print('ScrollController: ${_scrollController.position.pixels}');
    //   if (_scrollController.position.pixels ==
    //       _scrollController.position.maxScrollExtent) {
    //     _loadMoreEvents();
    //   }
    // });
  }

  // Future<void> _loadMoreEvents() async {
  //   if (_isLoading) return; // 이미 로딩 중이면 중복 호출 방지
  //   setState(() {
  //     _isLoading = true;
  //   });
  //
  //   // // 서버에서 데이터를 가져오는 임의의 함수 (임시 구현)
  //   // final newEvents = await ServerWrapper.getEvents(_currentPage);
  //   // if (!mounted) return;
  //   // setState(() {
  //   //   _currentPage++;
  //   //   // _itineraryCubitList.addAll(newEvents); // 새로운 일정 추가
  //   //   _isLoading = false;
  //   // });
  // }

  Future<void> _loadAllItineraries() async {
    if (_isLoading) return; // 이미 로딩 중이면 중복 호출 방지
    setState(() {
      _isLoading = true;
    });

    _itineraryCubitList = await ServerWrapper.getAllItineraries();
    if (!mounted) return;
    setState(() {
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
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Text(
                '메뉴',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('설정'),
              onTap: () {
                Navigator.pushNamed(context, '/setting');
              },
            ),
            if (!ServerWrapper.isLogin())
              ListTile(
                leading: Icon(Icons.login),
                title: Text('로그인'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
                },
              ),
            if (ServerWrapper.isLogin())
              ListTile(
                leading: Icon(Icons.person),
                title: Text('내 정보'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserScreen(),
                    ),
                  );
                },
              ),
            if (ServerWrapper.isLogin())
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('로그아웃'),
                onTap: () {
                  ServerWrapper.logout();
                  Navigator.pop(context);
                },
              ),
          ],
        ),
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
                padding: const EdgeInsets.only(
                  top: 0,
                  left: 17,
                  right: 17,
                  bottom: 25,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          Text(
                            ServerWrapper.isLogin()
                                ? '${ServerWrapper.getUser()!.nickname}'
                                : '로그인',
                            style: myTextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              ServerWrapper.isLogin() ? '님 안녕하세요!' : '이 필요합니다!',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: myTextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromRGBO(255, 255, 255, 0.8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 12,
                        ),
                        // fixedSize: const Size(46, 21),
                        // maximumSize: const Size(46, 21),
                        minimumSize: const Size(46, 0),
                        textStyle: myTextStyle(
                          height: 1.2,
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                        ),
                        shadowColor: Colors.transparent,
                      ),
                      onPressed: () {
                        if (ServerWrapper.isLogin()) {
                          ServerWrapper.logout();
                          setState(() {});
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                          );
                        }
                      },
                      child: ServerWrapper.isLogin()
                          ? const Text('로그아웃')
                          : const Text('로그인'),
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
              padding: EdgeInsets.only(top: searchY + 50),
              child: Column(
                children: [
                  Section(
                    title: Expanded(
                      child: Row(
                        spacing: 6,
                        children: <Widget>[
                          Text(
                              ServerWrapper.isLogin()
                                  ? '${ServerWrapper.getUser()!.nickname}'
                                  : '로그인',
                              style: const TextStyle(
                                // color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'NotoSansKR',
                                fontVariations: [FontVariation('wght', 500)],
                              )),
                          Expanded(
                            child: Text(
                              ServerWrapper.isLogin()
                                  ? '님의 일정'
                                  : '해서 나만의 일정을 만들어보세요!',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: const TextStyle(
                                // color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'NotoSansKR',
                                fontVariations: [FontVariation('wght', 400)],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    trailing: SortWidget(
                      sortTypes: ['수정순', '날짜순', '이름순'],
                      changeSortType: (index, ascending) async {
                        setState(() {});
                      },
                      ascending: false,
                    ),
                    content: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: BlocProvider.value(
                        value: ServerWrapper.itineraryCubitMapCubit,
                        child: BlocBuilder<ItineraryCubitMapCubit,
                            Map<int, ItineraryCubit>>(
                          builder: (context, itineraryCubitMap) {
                            var sortedItineraryCubitList =
                                itineraryCubitMap.values.toList();
                            itineraryCubitSort(sortedItineraryCubitList);

                            return Column(
                              spacing: 20,
                              children: [
                                ...itineraryCubitMap.map(
                                  (itineraryId, itineraryCubit) {
                                    return MapEntry(
                                      itineraryId,
                                      ItineraryCard(
                                        itineraryCubit: itineraryCubit,
                                        onBodyPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ItineraryEditor(
                                                      itineraryCubit:
                                                          itineraryCubit),
                                            ),
                                          );
                                          ServerWrapper
                                                  .getScheduleDetailWithClear(
                                                      itineraryCubit)
                                              .then((bool value) {
                                            if (!value) return;
                                            refreshRoute(itineraryCubit.state);
                                          });
                                          fetchCongestionData().then((value) {
                                            if (!value) return;
                                            refreshRoute(itineraryCubit.state);
                                          });
                                        },
                                        onEditPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ItineraryInfoScreen(
                                                      itineraryCubit:
                                                          itineraryCubit),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ).values,
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  child: Text(
                                    '더 이상 일정이 없어요!',
                                    style: myTextStyle(
                                      color: cPrimaryDark,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                if (_isLoading)
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CircularProgressIndicator(),
                                  ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Tooltip(
        message: '새 일정 만들기',
        child: FloatingActionButton(
          backgroundColor: cPrimary.withAlpha(130),
          hoverColor: cPrimary.withAlpha(150),
          shape: const CircleBorder(),
          elevation: 0,
          hoverElevation: 0,
          focusElevation: 0,
          highlightElevation: 0,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ItineraryInfoScreen(),
              ),
            );
          },
          child: SvgPicture.asset(
            'assets/icon/jam_plus.svg',
          ),
        ),
      ),
    );
  }

  void itineraryCubitSort(List<ItineraryCubit> itineraryCubitList) {
    // switch (ServerWrapper.itinerarySortType) {
    //   case ItinerarySortType.modified:
    //     itineraryCubitList.sort((a, b) {
    //       return b.modifiedTime.compareTo(a.modifiedTime);
    //     });
    //     break;
    //   case ItinerarySortType.date:
    //     itineraryCubitList.sort((a, b) {
    //       return b.startTime.compareTo(a.startTime);
    //     });
    //     break;
    //   case ItinerarySortType.name:
    //     itineraryCubitList.sort((a, b) {
    //       return a.name.compareTo(b.name);
    //     });
    //     break;
    // }
  }

  @override
  bool get wantKeepAlive => true;
}
