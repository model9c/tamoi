import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tomato_record/screens/home/items_page.dart';
import 'package:tomato_record/screens/home/webview_map.dart';
import 'package:tomato_record/states/user_provider.dart';
import 'package:tomato_record/utils/logger.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _bottomSelectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _bottomSelectedIndex,
        children: [
          ItemsPage(),
          WebviewMap(),
          Container(
            color: Colors.accents[6],
          ),
          Container(
            color: Colors.accents[9],
          ),
          Container(
            color: Colors.accents[12],
          ),
        ],
      ),
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          '기흥구',
          style: AppBarTheme.of(context).titleTextStyle,
        ),
        actions: [
          IconButton(
              onPressed: () {
                context.read<UserProvider>().setUserAuth(false);
              },
              icon: Icon(CupertinoIcons.nosign)),
          IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.bell)),
          // IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.heart_fill, color: Colors.pink,),),
          IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.search)),
          IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.text_justify)),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomSelectedIndex,
        type: BottomNavigationBarType.fixed, // 4 items 이상 시 필수 옵션

        items: [
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage(
                _bottomSelectedIndex == 0 ? 'assets/imgs/photo-camera_fill.png' : 'assets/imgs/photo-camera.png')),
            label: 'feed',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage(
                _bottomSelectedIndex == 1 ? 'assets/imgs/placeholder_fill.png' : 'assets/imgs/placeholder.png')),
            label: 'map',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
                AssetImage(_bottomSelectedIndex == 2 ? 'assets/imgs/price-tag_fill.png' : 'assets/imgs/price-tag.png')),
            label: 'shop',
          ),
          BottomNavigationBarItem(
            icon:
                ImageIcon(AssetImage(_bottomSelectedIndex == 3 ? 'assets/imgs/chat_fill.png' : 'assets/imgs/chat.png')),
            label: 'chat',
          ),
          BottomNavigationBarItem(
            icon:
                ImageIcon(AssetImage(_bottomSelectedIndex == 4 ? 'assets/imgs/user_fill.png' : 'assets/imgs/user.png')),
            label: 'my',
          ),
        ],
        onTap: (index) {
          setState(() {
            _bottomSelectedIndex = index;
            logger.d('Bottom Selected Index - $_bottomSelectedIndex');
          });
        },
      ),
    );
  }
}
