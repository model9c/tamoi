import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:tomato_record/constants/common_size.dart';

class AuthPage extends StatelessWidget {
  AuthPage({Key? key}) : super(key: key);

  final inputBorder =
      OutlineInputBorder(borderSide: BorderSide(color: Colors.grey));
  final TextEditingController _textEditingController =
      TextEditingController(text: "010");

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        Size size = MediaQuery.of(context).size;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              '전화번호로 로그인',
              style: Theme.of(context).appBarTheme.titleTextStyle,
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(common_padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    ExtendedImage.asset(
                      'assets/imgs/padlock.png',
                      width: size.width * 0.15,
                      height: size.width * 0.15,
                    ),
                    SizedBox(width: common_sm_padding),
                    Text(
                        '타모이는 휴대폰 번호로 가입을 할 수 있습니다.\n번호는 안전하게 보관되며,\n개인정보보호법에 의하여 외부에 공개하지 않습니다.'),
                  ],
                ),
                SizedBox(width: common_padding),

                TextFormField(
                  controller: _textEditingController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [MaskedInputFormatter("000 0000 0000")],
                  decoration: InputDecoration(
                      focusedBorder: inputBorder, border: inputBorder),
                ),
                SizedBox(width: common_sm_padding),
                TextButton(onPressed: () {}, child: Text("인증문자 발송")),

                SizedBox(width: common_padding),

                TextFormField(

                  keyboardType: TextInputType.phone,
                  inputFormatters: [MaskedInputFormatter("000000")],
                  decoration: InputDecoration(
                      focusedBorder: inputBorder, border: inputBorder),
                ),
                SizedBox(width: common_sm_padding),
                TextButton(onPressed: () {}, child: Text("인증 확인")),
              ],
            ),
          ),
        );
      },
    );
  }
}
