import 'package:flutter/gestures.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_order/generated/locale_keys.g.dart';
import 'package:food_order/presentation/app_icons_icons.dart';
import 'package:food_order/src/controller/user_controller.dart';
import 'package:food_order/src/utils/app_config.dart' as config;
import 'package:easy_localization/easy_localization.dart';
import 'package:food_order/src/utils/validation.dart';
import 'package:food_order/src/widgets/widget.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({
    Key key,
    @required this.controller,
    @required this.onSignUpClicked,
    @required this.onResetPassClicked,
  }) : super(key: key);

  final UserController controller;
  final VoidCallback onResetPassClicked;
  final VoidCallback onSignUpClicked;

  @override
  State<StatefulWidget> createState() => _LoginWidgetSate();
}

class _LoginWidgetSate extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  bool _emailValidated;
  bool _passwordValidated;

  @override
  void initState() {
    super.initState();

    _emailValidated = false;
    _passwordValidated = false;
    if (widget.controller.user.email != null) {
      setState(() {
        _emailController.text = widget.controller.user.email;
        _emailValidated = true;
      });
    }
    if (widget.controller.user.password != null) {
      setState(() {
        _passwordController.text = widget.controller.user.password;
        _passwordValidated = true;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _appConfig = config.AppConfig(context);

    return Container(
      alignment: Alignment.bottomCenter,
      child: Form(
        key: widget.controller.loginFormKey,
        autovalidate: widget.controller.autoValidate,
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            LoginTextInput(
              label: LocaleKeys.hint_email.tr(),
              hint: 'johndoe@email.com',
              validated: _emailValidated,
              textController: _emailController,
              focusNode: _emailFocus,
              nxtFocusNode: _passwordFocus,
              prefixIcon: AppIcons.mail,
              keyboardType: TextInputType.emailAddress,
              inputAction: TextInputAction.next,
              validator: emailValidator,
              onChanged: (input) {
                setState(() {
                  if (emailValidator(input) == null)
                    _emailValidated = true;
                  else
                    _emailValidated = false;
                });
              },
            ),
            SizedBox(height: _appConfig.smallSpace()),
            LoginTextInput(
              label: LocaleKeys.hint_password.tr(),
              hint: '••••••••••',
              validated: _passwordValidated,
              textController: _passwordController,
              focusNode: _passwordFocus,
              prefixIcon: AppIcons.key,
              keyboardType: TextInputType.text,
              inputAction: TextInputAction.done,
              validator: passwordValidator,
              onChanged: (input) {
                setState(() {
                  if (passwordValidator(input) == null)
                    _passwordValidated = true;
                  else
                    _passwordValidated = false;
                });
              },
            ),
            SizedBox(height: _appConfig.hugeSpace()),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: _appConfig.horizontalPadding(6),
              ),
              child: PrimaryButton(
                text: LocaleKeys.action_login.tr(),
                onPressed: validate,
              ),
            ),
            SizedBox(height: _appConfig.smallSpace()),
            GestureDetector(
              onTap: widget.onResetPassClicked,
              child: Text(
                LocaleKeys.action_forgot_password.tr(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.button.copyWith(
                      fontSize: 16.0,
                      color: Theme.of(context).buttonColor,
                    ),
              ),
            ),
            SizedBox(height: _appConfig.extraSmallSpace()),
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: LocaleKeys.not_registered_message.tr(),
                    style: Theme.of(context)
                        .textTheme
                        .caption
                        .copyWith(fontSize: 16.0),
                  ),
                  TextSpan(text: ' '),
                  TextSpan(
                    text: LocaleKeys.action_register.tr(),
                    style: Theme.of(context).textTheme.button.copyWith(
                          fontSize: 16.0,
                          color: Theme.of(context).buttonColor,
                        ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = widget.onSignUpClicked,
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: _appConfig.hugeSpace()),
          ],
        ),
      ),
    );
  }

  void validate() {
    final form = widget.controller.loginFormKey.currentState;
    if (form.validate()) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      setState(() => widget.controller.autoValidate = false);
      widget.controller.user.email = _emailController.text;
      widget.controller.user.password = _passwordController.text;
      widget.controller.loginProcess();
      form.save();
    } else {
      setState(() => widget.controller.autoValidate = true);
    }
  }
}
