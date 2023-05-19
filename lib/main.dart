import 'package:flutter/material.dart';
import 'package:tomato_record/splash_screen.dart';
import 'package:tomato_record/utils/logger.dart';

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
    return Container(
      color: Colors.amber,
    );
  }
}
