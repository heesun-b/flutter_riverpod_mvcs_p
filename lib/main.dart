import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_blog_start/core/constants/http.dart';
import 'package:flutter_riverpod_blog_start/core/constants/move.dart';
import 'package:flutter_riverpod_blog_start/dto/response_dto.dart';
import 'package:flutter_riverpod_blog_start/model/user/user_repository.dart';
import 'package:flutter_riverpod_blog_start/provider/session_provider.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async{
  // MyApp 시작전에 필요한 것 여기서 다 로딩 (동기적 실행)
  // WidgetsFlutterBinding.ensureInitialized() - 다음(child)에 호출되는 함수의 모든 실행이 끝날 때까지 기다리는 명령어
  // 즉, 메모리를 초기화하거나 초기에 서버 연결을 하는 경우 사용
  WidgetsFlutterBinding.ensureInitialized();
  // 1. 시큐어 스토리지에 JWT 있는 확인
  // 2. JWT를 가지고 회원정보를 가져와서!!
  // 3. SessionUser 동기화 (ref에 접근해야함)
  SessionUser sessionUser = await UserRepository().fetchJwtVerify();

  runApp(
    ProviderScope(
      // ProviderScope : 공급자의 상태를 저장하는 위젯
      overrides: [
        // overrides : 선택적으로 일부 공급자의 동작을 변경하도록 지정
        sessionProvider.overrideWithValue(sessionUser)
        // overrideWithValue : 해당 provider에 접근해서 값을 변경(?)
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SessionUser sessionUser = ref.read(sessionProvider);
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      initialRoute: sessionUser.isLogin! ? Move.postHomePage : Move.loginPage,
      routes: getRouters(),
    );
  }
}