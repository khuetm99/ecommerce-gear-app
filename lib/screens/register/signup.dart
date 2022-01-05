import 'package:ecommerce_app/blocs/app_bloc.dart';
import 'package:ecommerce_app/blocs/register/bloc.dart';
import 'package:ecommerce_app/data/models/models.dart';
import 'package:ecommerce_app/utils/utils.dart';
import 'package:ecommerce_app/widgets/app_text_input_blur.dart';
import 'package:ecommerce_app/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUp extends StatefulWidget {
  SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() {
    return _SignUpState();
  }
}

class _SignUpState extends State<SignUp> {
  final nameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final _focusName = FocusNode();
  final _focusPass = FocusNode();
  final _focusEmail = FocusNode();
  final _focusPhone = FocusNode();

  bool _showPassword = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  bool get isPopulated =>
      nameController.text.isNotEmpty &&
      phoneNumberController.text.isNotEmpty &&
      emailController.text.isNotEmpty &&
      passwordController.text.isNotEmpty;

  bool isRegisterButtonEnabled() {
    return AppBloc.registerBloc.state.isFormValid &&
        !AppBloc.registerBloc.state.isSubmitting &&
        isPopulated;
  }

  void onRegister() {
    if (isRegisterButtonEnabled()) {
      UserModel newUser = UserModel(
        id: "",
        avatar: "",
        addresses: [],
        name: nameController.text,
        phoneNumber: phoneNumberController.text,
        email: emailController.text,
      );
      AppBloc.registerBloc.add(
        Submitted(
          newUser: newUser,
          password: passwordController.text,
          confirmPassword: passwordController.text,
        ),
      );
    }
  }

  ///On show message fail
  Future<void> _showMessage(String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            Translate.of(context)!.translate('register'),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodyText1,
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
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          Translate.of(context)!.translate('register'),
        ),
      ),
      body: BlocConsumer<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state.isFailure) {
            _showMessage(
              Translate.of(context)!.translate(state.message!),
            );
          }
          if (state.isSuccess) {
            final snackBar = SnackBar(
              content: Text(
                Translate.of(context)!.translate(
                  'register_success',
                ),
              ),
              action: SnackBarAction(
                label: Translate.of(context)!.translate('login'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            );
            Scaffold.of(context).showSnackBar(snackBar);
          }
        },
        builder: (context, registerState) {
          return SafeArea(
            child: Container(
              padding: EdgeInsets.only(left: 16, right: 16),
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text(
                        Translate.of(context)!.translate('name'),
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    AppTextInputBlur(
                      hintText: Translate.of(context)!.translate('name'),
                      icon: Icon(Icons.clear),
                      controller: nameController,
                      focusNode: _focusName,
                      textInputAction: TextInputAction.next,
                      onTapIcon: () async {
                        nameController.clear();
                      },
                    ),

                    Padding(
                      padding: EdgeInsets.only(bottom: 8, top: 8),
                      child: Text(
                        Translate.of(context)!.translate('phone_number'),
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    AppTextInputBlur(
                      hintText: Translate.of(context)!.translate('phone'),
                      errorText: !AppBloc.registerBloc.state.isPhoneValid
                          ? Translate.of(context)!.translate('invalid_phone')
                          : null,
                      onChanged: (value) {
                        AppBloc.registerBloc.add(PhoneChanged(phone: value));
                      },
                      keyboardType: TextInputType.phone,
                      icon: Icon(Icons.clear),
                      controller: phoneNumberController,
                      focusNode: _focusPhone,
                      textInputAction: TextInputAction.next,
                      onTapIcon: () async {
                        phoneNumberController.clear();
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 8, top: 8),
                      child: Text(
                        Translate.of(context)!.translate('email'),
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    AppTextInputBlur(
                      hintText: Translate.of(context)!.translate('email'),
                      errorText: !AppBloc.registerBloc.state.isEmailValid
                          ? Translate.of(context)!.translate('invalid_email')
                          : null,
                      onChanged: (value) {
                        AppBloc.registerBloc.add(EmailChanged(email: value));
                      },
                      icon: Icon(Icons.clear),
                      controller: emailController,
                      focusNode: _focusEmail,
                      textInputAction: TextInputAction.next,
                      onTapIcon: () async {
                        emailController.clear();
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 8, top: 16),
                      child: Text(
                        Translate.of(context)!.translate('password'),
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    AppTextInputBlur(
                      hintText: Translate.of(context)!.translate(
                        'input_your_password',
                      ),
                      errorText: !AppBloc.registerBloc.state.isPasswordValid
                          ? Translate.of(context)!.translate('invalid_password')
                          : null,
                      textInputAction: TextInputAction.next,
                      onChanged: (value) {
                        AppBloc.registerBloc
                            .add(PasswordChanged(password: value));
                      },
                      onSubmitted: (text) {
                        UtilOther.fieldFocusChange(
                            context, _focusPass, _focusEmail);
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
                      controller: passwordController,
                      focusNode: _focusPass,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                    ),
                    AppButton(
                      Translate.of(context)!.translate('register'),
                      onPressed: onRegister,
                      loading: registerState.isSubmitting,
                      disabled: registerState.isSubmitting,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
