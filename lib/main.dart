import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tomato_record/router/locations.dart';
import 'package:tomato_record/screens/start_screen.dart';
import 'package:tomato_record/screens/home_screen.dart';
import 'package:tomato_record/screens/splash_screen.dart';
import 'package:tomato_record/states/user_notifier.dart';
import 'package:tomato_record/states/user_provider.dart';
import 'package:tomato_record/utils/logger.dart';

/*final _routerDelegate = BeamerDelegate(
  guards: [
    BeamGuard(
      pathPatterns: ['/'],
      check: (context, location){
        return false;
      },
      showPage: BeamPage(
        child: AuthScreen()
      )
    )
  ],
  locationBuilder: BeamerLocationBuilder(
    beamLocations: [HomeLocation()]
  )
);*/

final UserNotifier _userNotifier = UserNotifier();

final _router = GoRouter(
    routes: [
      GoRoute(
          name: "home", path: "/", builder: (context, state) => HomeScreen()),
      GoRoute(
          name: "auth",
          path: "/auth",
          builder: (context, state) => StartScreen()),
    ],
    refreshListenable: _userNotifier,
    redirect: (context, state) {
      // final currentPath = state.subloc == '/auth';
      final currentPath = state.matchedLocation.contains('/auth');
      // final userState = _userNotifier.user;
      const userState = null;
      if (userState == null && !currentPath) {
        return '/auth';
      }
      if (userState != null && currentPath) {
        return "/";
      }
      return null;
    });

void main() {
  logger.d('My first Logger!!');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.delayed(const Duration(milliseconds: 300), () => 100),
        builder: (context, snapshot) {
          return AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _splashLoadingWidget(snapshot));
        });
  }

  StatelessWidget _splashLoadingWidget(AsyncSnapshot<Object?> snapshot) {
    if (snapshot.hasError) {
      print('error occur while loading.');
      return const Text('error occur.');
    } else if (snapshot.hasData) {
      return const TamoiApp();
    } else {
      return const SplashScreen();
    }
  }
}

class TamoiApp extends StatelessWidget {
  const TamoiApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserProvider>(
      // providers: [
      //   // ChangeNotifierProvider<UserNotifier>.value(value: _userNotifier)
      // ],
      create: (BuildContext context) {
        return UserProvider();
      },
      child: MaterialApp.router(
        routeInformationProvider: _router.routeInformationProvider,
        routeInformationParser: _router.routeInformationParser,
        routerDelegate: _router.routerDelegate,
        theme: ThemeData(
          primarySwatch: Colors.amber,
          fontFamily: 'Jalnan',
          hintColor: Colors.grey[350],
          textTheme: TextTheme(labelLarge: TextStyle(color: Colors.white)),
          textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
            backgroundColor: Colors.red,
            primary: Colors.white,
            minimumSize: Size(48, 48),
          )),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 2,
            titleTextStyle: TextStyle(color: Colors.black87),
            actionsIconTheme: IconThemeData(color: Colors.black87),
          ),
        ),
      ),
    );
  }
}
