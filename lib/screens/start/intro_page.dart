import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:tomato_record/utils/logger.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({Key? key}) : super(key: key);

  void onButtonClick(){
    logger.d('on text button clicked!!!');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('TAMOI',
              style: TextStyle(fontSize: 22, color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),),
            ExtendedImage.asset('assets/img/carrot_intro.png'),
            Text('낚시/캠핑/레저를 한번에!!',
              style: TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.bold)),
            Text('통합 마켓 플랫폼 입니다.\n동네를 인증하고 시작하세요!', style: TextStyle(fontSize: 22, color: Colors.black)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextButton(
                  onPressed: onButtonClick,
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: Text('내 동네 설정하고 시작하기', style: TextStyle(color: Colors.white),),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
