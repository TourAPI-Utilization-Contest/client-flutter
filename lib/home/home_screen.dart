import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:tradule/login/login_screen.dart';
import 'package:tradule/provider/auth_provider.dart';
import 'package:tradule/itinerary_planner/itinerary_planner.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLogined = ref.watch(isLoggedInProvider);
    final user = ref.watch(userProvider);
    final userNickname = user?.kakaoAccount?.profile?.nickname ?? 'Unknown';
    final userThumbnail = user?.kakaoAccount?.profile?.thumbnailImageUrl ?? '';
    final authInit = ref.watch(authInitializationProvider);

    // print("$userThumbnail");

    return DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTapDown: (details) {
              if (isLogined) {
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
              }
            },
            child: isLogined
                ? CircleAvatar(
                    backgroundImage: NetworkImage(userThumbnail),
                  )
                : Icon(Icons.person),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (isLogined)
                Text('안녕하세요 $userNickname 님')
              else
                const Text('로그인이 필요합니다'),
            ],
          ),
          actions: [
            Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
              ),
            ),
          ],
        ),
        endDrawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.purple[50],
                ),
                child: Text(
                  '메뉴',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('설정'),
                onTap: () {
                  // 설정을 클릭했을 때의 동작
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('로그아웃'),
                onTap: () {
                  UserApi.instance.logout();
                  ref.read(isLoggedInProvider.notifier).state = false;
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            TabBarView(
              children: [
                Center(child: Text('북마크 장소')),
                Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          children: [
                            Text('장소 검색'),
                            Padding(
                              padding: EdgeInsets.all(16.0),
                              child: TextField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: '장소를 검색하세요',
                                ),
                              ),
                            ),
                          ],
                        ),
                        Wrap(
                          children: [
                            FilledButton(onPressed: () {}, child: Text('카페')),
                            FilledButton(onPressed: () {}, child: Text('식당')),
                            FilledButton(onPressed: () {}, child: Text('술집')),
                            FilledButton(onPressed: () {}, child: Text('편의점')),
                            FilledButton(onPressed: () {}, child: Text('헬스장')),
                            FilledButton(onPressed: () {}, child: Text('학원')),
                            FilledButton(onPressed: () {}, child: Text('기타')),
                          ],
                        ),
                        Text('나의 일정'),
                        if (isLogined)
                          Wrap(
                            children: [
                              ScheduleWidget(),
                            ],
                          )
                        else
                          Text('로그인이 필요합니다'),
                        SizedBox(
                          height: 300,
                          width: 300,
                          child: MapSample(),
                        ),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: isLogined
                      ? Text('유저 정보')
                      : ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()),
                            );
                          },
                          child: Text('로그인'),
                        ),
                ),
              ],
            ),
            if (authInit.isLoading) ...[
              ModalBarrier(
                color: Colors.black.withOpacity(0.3), // 화면을 반투명하게 어둡게 처리
                dismissible: false,
              ),
              Center(
                child: CircularProgressIndicator(),
              ),
            ],
            // 오류 처리
            if (authInit.hasError) Center(child: Text('Error occurred')),
          ],
        ),
        bottomNavigationBar: TabBar(
          tabs: [
            Tab(icon: Icon(Icons.bookmark), text: '내 장소'),
            Tab(icon: Icon(Icons.home), text: '메인 화면'),
            Tab(icon: Icon(Icons.person), text: '유저'),
          ],
        ),
      ),
    );
  }
}

class ScheduleWidget extends StatefulWidget {
  const ScheduleWidget({
    super.key,
  });

  @override
  _ScheduleWidgetState createState() => _ScheduleWidgetState();
}

class _ScheduleWidgetState extends State<ScheduleWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      child: ElevatedButton(
        onPressed: () {},
        child: Text('새 일정 생성'),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // 둥근 모서리 반경
          ),
        ),
      ),
    );
  }
}
