import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:provider/provider.dart';
import 'package:tomato_record/constants/common_size.dart';
import 'package:tomato_record/states/user_provider.dart';

class AuthPage extends StatefulWidget {
  AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

const duration = Duration(milliseconds: 300);

class _AuthPageState extends State<AuthPage> {
  final inputBorder =
      OutlineInputBorder(borderSide: BorderSide(color: Colors.grey));

  final TextEditingController _phoneNumberController =
      TextEditingController(text: "010");

  final TextEditingController _codeController = TextEditingController(text: "");

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  VerificationStatus _verificationStatus = VerificationStatus.none;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        Size size = MediaQuery.of(context).size;

        return IgnorePointer(
          ignoring: _verificationStatus == VerificationStatus.verifying,
          child: Form(
            key: _formKey,
            child: Scaffold(
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
                            '휴대폰 번호로 가입을 할 수 있습니다.\n해당 정보는 안전하게 보관되며,\n외부에 절대 공개하지 않습니다.'),
                      ],
                    ),
                    SizedBox(height: common_padding),
                    TextFormField(
                      controller: _phoneNumberController,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [MaskedInputFormatter("000 0000 0000")],
                      decoration: InputDecoration(
                          focusedBorder: inputBorder, border: inputBorder),
                      validator: (phoneNumber) {
                        if (phoneNumber != null && phoneNumber.length == 13) {
                          return null; // null 을 리턴하면 오류가 없다고 판단.
                        } else {
                          // error
                          return '전화번호를 입력해주세요.';
                        }
                      },
                    ),
                    SizedBox(height: common_sm_padding),
                    TextButton(
                        onPressed: () {
                          if (_formKey.currentState != null) {
                            bool passed = _formKey.currentState!.validate();
                            print(passed);
                            if (passed) {
                              setState(() {
                                _verificationStatus =
                                    VerificationStatus.codeSent;
                              });
                            }
                          } else {}
                        },
                        child: Text("인증문자 발송")),
                    SizedBox(height: common_padding),
                    AnimatedOpacity(
                      duration: duration,
                      opacity: (_verificationStatus == VerificationStatus.none)
                          ? 0
                          : 1,
                      child: AnimatedContainer(
                        duration: duration,
                        curve: Curves.easeInOut,
                        height: getVerificationHeight(_verificationStatus),
                        child: TextFormField(
                          controller: _codeController,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [MaskedInputFormatter("000000")],
                          decoration: InputDecoration(
                              focusedBorder: inputBorder, border: inputBorder),
                        ),
                      ),
                    ),
                    // SizedBox(width: common_sm_padding),
                    AnimatedContainer(
                        duration: duration,
                        curve: Curves.easeInOut,
                        height: getVerificationBtnHeight(_verificationStatus),
                        child: TextButton(
                            onPressed: () {
                              attemptVerify();
                            },
                            child: (_verificationStatus ==
                                    VerificationStatus.verifying)
                                ? CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : Text("인증 확인"))),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  double getVerificationHeight(VerificationStatus status) {
    switch (status) {
      case VerificationStatus.none:
        return 0;
      case VerificationStatus.codeSent:
      case VerificationStatus.verifying:
      case VerificationStatus.verificationDone:
        return 60 + common_sm_padding;
    }
  }

  double getVerificationBtnHeight(VerificationStatus status) {
    switch (status) {
      case VerificationStatus.none:
        return 0;
      case VerificationStatus.codeSent:
      case VerificationStatus.verifying:
      case VerificationStatus.verificationDone:
        return 48 + common_sm_padding;
    }
  }

  void attemptVerify() async {
    setState(() {
      _verificationStatus = VerificationStatus.verifying;
    });

    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _verificationStatus = VerificationStatus.verificationDone;
    });

    context
        .read<UserProvider>()
        .setUserAuth(true); //notify 함수를 호출할 경우에는 무조건 read로 호출.
  }
}

enum VerificationStatus { none, codeSent, verifying, verificationDone }
