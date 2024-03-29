import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:food_order/generated/locale_keys.g.dart';
import 'package:food_order/src/controller/user_controller.dart';
import 'package:food_order/src/utils/app_config.dart' as config;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_order/src/widgets/widget.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpVerifyScreen extends StatefulWidget {
  OtpVerifyScreen({
    Key key,
    @required this.controller,
  });

  final UserController controller;

  @override
  State<StatefulWidget> createState() => _OtpVerifyState();
}

class _OtpVerifyState extends State<OtpVerifyScreen> {
  String _otpCode = '';
  int _otpCodeLength;
  bool _enableCodeButton;
  bool _enableButton;

  final _codeController = TextEditingController();
  StreamController<ErrorAnimationType> _errorController;

  Timer _timer;
  @override
  void initState() {
    _enableButton = false;
    _otpCodeLength = 6;
    _setTimer();
    _errorController = StreamController<ErrorAnimationType>();

    super.initState();
  }

  @override
  void dispose() {
    _errorController.close();
    _timer.cancel();

    super.dispose();
  }

  _setTimer() {
    setState(() {
      _enableCodeButton = false;
    });
    _timer = Timer(Duration(minutes: 1), () {
      setState(() {
        _enableCodeButton = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final _appConfig = config.AppConfig(context);

    return Container(
      alignment: Alignment.bottomCenter,
      margin: EdgeInsets.symmetric(
        horizontal: _appConfig.horizontalSpace(),
      ),
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          PinCodeTextField(
            autoFocus: true,
            autoDismissKeyboard: true,
            autoDisposeControllers: true,
            beforeTextPaste: (text) => true,
            length: _otpCodeLength,
            backgroundColor: Theme.of(context).backgroundColor,
            errorAnimationController: _errorController,
            controller: _codeController,
            animationType: AnimationType.slide,
            animationDuration: Duration(milliseconds: 300),
            textStyle: Theme.of(context).textTheme.bodyText2,
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              fieldHeight: 80,
              selectedColor: Theme.of(context).buttonColor,
              activeColor: Colors.grey,
              inactiveColor: Colors.grey[300],
              disabledColor: Colors.grey[100],
            ),
            onChanged: (input) {
              if (_codeController.text.length == _otpCodeLength) {
                _enableButton = true;
              }
            },
          ),
          SizedBox(height: _appConfig.hugeSpace()),
          _enableCodeButton
              ? RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: LocaleKeys.not_received_code.tr(),
                        style: Theme.of(context)
                            .textTheme
                            .caption
                            .copyWith(fontSize: 16.0),
                      ),
                      TextSpan(text: ' '),
                      TextSpan(
                        text: LocaleKeys.action_resend_code.tr(),
                        style: Theme.of(context).textTheme.button.copyWith(
                            fontSize: 16.0,
                            color: Theme.of(context).buttonColor),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            widget.controller.mobileProcess();
                            _setTimer();
                          },
                      ),
                    ],
                  ),
                  textAlign: TextAlign.start,
                )
              : Offstage(),
          SizedBox(height: _appConfig.smallSpace()),
          PrimaryButton(
            text: LocaleKeys.action_verify_code.tr(),
            color: !_enableButton ? Colors.grey : null,
            onPressed: () {
              if (_enableButton) {
                widget.controller.verifyOtpProcess(_otpCode);
              }
            },
          ),
          SizedBox(height: _appConfig.hugeSpace()),
        ],
      ),
    );
  }
}
