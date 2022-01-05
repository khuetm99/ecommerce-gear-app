import 'package:ecommerce_app/blocs/authentication/bloc.dart';
import 'package:ecommerce_app/blocs/bloc.dart';
import 'package:ecommerce_app/blocs/cart/bloc.dart';
import 'package:ecommerce_app/blocs/discount/discount_bloc.dart';
import 'package:ecommerce_app/blocs/favorites/bloc.dart';
import 'package:ecommerce_app/blocs/login/bloc.dart';
import 'package:ecommerce_app/blocs/profile/bloc.dart';
import 'package:ecommerce_app/configs/routes.dart';
import 'package:ecommerce_app/utils/utils.dart';
import 'package:ecommerce_app/widgets/app_button.dart';
import 'package:ecommerce_app/widgets/app_text_input_blur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Login extends StatefulWidget {
  final Object? from;

  Login({Key? key, this.from}) : super(key: key);

  @override
  _LoginState createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
  final loginBloc = AppBloc.loginBloc;

  final _textEmailController = TextEditingController();
  final _textPassController = TextEditingController();
  final _focusEmail = FocusNode();
  final _focusPass = FocusNode();

  bool _showPassword = false;

  bool get isPopulated =>
      _textEmailController.text.isNotEmpty && _textPassController.text.isNotEmpty;

  bool isLoginButtonEnabled() {
    return loginBloc.state.isFormValid &&
        !loginBloc.state.isSubmitting &&
        isPopulated;
  }

  void onLogin() {
    if (isLoginButtonEnabled()) {
      loginBloc.add(LoginWithCredential(
        email: _textEmailController.text,
        password: _textPassController.text,
      ));
    } else {
      ScaffoldMessenger.of(context).
      showSnackBar(SnackBar(content: Text("Email or password empty")));
    }
  }

  @override
  void initState() {
    _textEmailController.text = "khuetm99@gmail.com";
    _textPassController.text = "123456";

    super.initState();
  }

  ///On navigate forgot password
  void _forgotPassword() {}

  ///On navigate sign up
  void _signUp() {
    Navigator.pushNamed(context, Routes.signUp);
  }

  ///On show message fail
  Future<void> _showMessage(String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            Translate.of(context)!.translate('login'),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  message,
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodyText1,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            AppButton(
              Translate.of(context)!.translate('close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
              type: ButtonType.text,
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        /// Failure
        if (state.isFailure) {
          _showMessage(
           state.message!,
          );
        }

        /// Success
        if (state.isSuccess) {
          AppBloc.authBloc.add(LoggedIn());
          AppBloc.profileBloc.add(LoadProfile());
          AppBloc.cartBloc.add(LoadCart());
          AppBloc.favoriteBloc.add(LoadFavorite());
          Navigator.pop(context, widget.from as String);
        }
      },
      builder: (context, loginState) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              Translate.of(context)!.translate('login'),
            ),
          ),
          body: SafeArea(
            child: Container(
              padding: EdgeInsets.only(left: 16, right: 16),
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    AppTextInputBlur(
                      hintText: Translate.of(context)!.translate('account'),
                      errorText: !loginBloc.state.isEmailValid
                            ? Translate.of(context)!.translate('invalid_email')
                            : null,
                      icon: Icon(Icons.clear),
                      controller: _textEmailController,
                      focusNode: _focusEmail,
                      textInputAction: TextInputAction.next,
                      onChanged: (text) {
                        loginBloc.add(EmailChanged(email: text));
                      },
                      onSubmitted: (text) {
                        UtilOther.fieldFocusChange(
                            context, _focusEmail, _focusPass);
                      },
                      onTapIcon: () async {
                        _textEmailController.clear();
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8),
                    ),
                    AppTextInputBlur(
                      hintText: Translate.of(context)!.translate('password'),
                      errorText: !loginBloc.state.isPasswordValid
                          ? Translate.of(context)!.translate('invalid_password')
                          : null,
                      textInputAction: TextInputAction.done,
                      onChanged: (text) {
                        loginBloc.add(PasswordChanged(password: text));
                      },
                      onSubmitted: (text) {
                        loginBloc.add(PasswordChanged(password: text));
                      },
                      onTapIcon: () {
                        setState(() {
                          _showPassword = !_showPassword;
                        });
                      },
                      obscureText: !_showPassword,
                      icon: Icon(
                        _showPassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      controller: _textPassController,
                      focusNode: _focusPass,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                    ),
                    AppButton(
                      Translate.of(context)!.translate('login'),
                      onPressed: onLogin,
                      loading: loginState.isSubmitting,
                      disabled:  loginState.isSubmitting,
                    ),
                    Padding(padding: EdgeInsets.only(top: 4)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        AppButton(
                          Translate.of(context)!.translate('forgot_password'),
                          onPressed: _forgotPassword,
                          type: ButtonType.text,
                        ),
                        AppButton(
                          Translate.of(context)!.translate('register'),
                          onPressed: _signUp,
                          type: ButtonType.text,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
