import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tomato_record/constants/common_size.dart';
import 'package:tomato_record/utils/logger.dart';

class AddressPage extends StatelessWidget {
  const AddressPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: EdgeInsets.only(left: common_padding, right: common_padding), // left and right padding 주기
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                // focusedBorder: UnderlineInputBorder(
                //     borderSide: BorderSide(color: Colors.blue)),
                hintText: '도로명으로 검색',
                hintStyle: TextStyle(color: Theme.of(context).hintColor),
                prefixIconConstraints: BoxConstraints(
                  minWidth: 24,
                  minHeight: 24,
                )),
          ),
          TextButton.icon(
            onPressed: () {},
            icon: Icon(
              CupertinoIcons.compass,
              color: Colors.white,
              size: 20,
            ),
            label: Text(
              '현재위치로 찾기',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: common_padding),
              itemBuilder: (context, index) {
                logger.d('index : $index');
                return ListTile(
                  // leading: Icon(Icons.image),
                  // trailing: ExtendedImage.asset('assets/img/tamoi.png'),
                  title: Text('address : $index'),
                  subtitle: Text('sub Title : $index'),
                );
              },
              itemCount: 30,
            ),
          ),
        ],
      ),
    );
  }
}
