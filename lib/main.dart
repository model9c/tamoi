import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tomato_record/router/locations.dart';
import 'package:tomato_record/screens/auth_screen.dart';
import 'package:tomato_record/screens/home_screen.dart';
import 'package:tomato_record/screens/splash_screen.dart';
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

final _routerDelegate = GoRouter(
  // refreshListenable
  routes: [
    GoRoute(name: 'home', path: '/', builder: (context, state) => HomeScreen())
  ],
);

void main(){
  logger.d('My first Logger!!');
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(const Duration(seconds: 3), () => 100),
      builder: (context, snapshot) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _splashLoadingWidget(snapshot)
        );
      }
    );
  }

  StatelessWidget _splashLoadingWidget(AsyncSnapshot<Object?> snapshot) {
    if(snapshot.hasError){
      print('error occur while loading.');
      return const Text('error occur.');
    } else if(snapshot.hasData) {
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
    return MaterialApp.router(
      theme: ThemeData(primarySwatch: Colors.amber),
    );
  }
}
