import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/blocs/bloc.dart';
import 'package:ecommerce_app/blocs/profile/bloc.dart';
import 'package:ecommerce_app/data/models/models.dart';
import 'package:ecommerce_app/utils/utils.dart';
import 'package:ecommerce_app/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';

class EditProfile extends StatefulWidget {
  final UserModel user;

  EditProfile({Key? key, required this.user}) : super(key: key);

  @override
  _EditProfileState createState() {
    return _EditProfileState();
  }
}

class _EditProfileState extends State<EditProfile> {
  UserModel get user => widget.user;

  final _textNameController = TextEditingController();
  final _textEmailController = TextEditingController();
  final _textPhoneController = TextEditingController();
  final _textInfoController = TextEditingController();

  final _focusName = FocusNode();
  final _focusEmail = FocusNode();
  final _focusPhone = FocusNode();
  final _focusInfo = FocusNode();
  final picker = ImagePicker();

  File? _image;
  String? _validName;
  String? _validEmail;
  String? _validPhone;
  String? _validInfo;

  @override
  void initState() {
    super.initState();
    _textNameController.text = user.name;
    _textEmailController.text = user.email;
    _textPhoneController.text = user.phoneNumber;
    //_textInfoController.text = Application.user.description;
  }

  ///On async get Image file
  Future _getImage() async {
    final image = await picker.getImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  ///On update image
  Future<void> _update() async {
    UtilOther.hiddenKeyboard(context);
    setState(() {
      _validName = UtilValidator.validate(
        data: _textNameController.text,
      );
      _validEmail = UtilValidator.validate(
        data: _textEmailController.text,
        type: ValidateType.email,
      );
      _validPhone = UtilValidator.validate(
        data: _textPhoneController.text,
      );
      // _validInfo = UtilValidator.validate(
      //   data: _textInfoController.text,
      // );
    });

    if (_image != null) {
      if (_validName == null && _validEmail == null && _validPhone == null) {
        AppBloc.profileBloc.add(
          OnUpdateUserProfile(
            imageFile: _image as File,
            name: _textNameController.text,
            email: _textEmailController.text,
            phone: _textPhoneController.text,
          ),
        );
      }
    } else {
      if (_validName == null && _validEmail == null && _validPhone == null) {
        AppBloc.profileBloc.add(
          OnUpdateUserProfileWithoutImage(
            name: _textNameController.text,
            email: _textEmailController.text,
            phone: _textPhoneController.text,
          ),
        );
      }
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
            Translate.of(context)!.translate('edit_profile'),
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
              type: ButtonType.text,
            ),
          ],
        );
      },
    );
  }

  ///Build Avatar image
  Widget _buildAvatar() {
    if (_image != null) {
      return Container(
        width: 100,
        height: 100,
        child: ClipRRect(
          child: Image.file(
            _image!,
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(50),
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: user.avatar,
      imageBuilder: (context, imageProvider) {
        return Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
      placeholder: (context, url) {
        return Shimmer.fromColors(
          baseColor: Theme.of(context).hoverColor,
          highlightColor: Theme.of(context).highlightColor,
          enabled: true,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
        );
      },
      errorWidget: (context, url, error) {
        return Shimmer.fromColors(
          baseColor: Theme.of(context).hoverColor,
          highlightColor: Theme.of(context).highlightColor,
          enabled: true,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Icon(Icons.error),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, listen) {
        if (listen is ProfileSaveFailure) {
          _showMessage(Translate.of(context)!.translate(listen.error));
        }
        if (listen is ProfileSaveSuccess) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(Translate.of(context)!.translate('edit_profile')),
        ),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: <Widget>[
                            _buildAvatar(),
                            IconButton(
                              icon: Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                              ),
                              onPressed: _getImage,
                            )
                          ],
                        )
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(top: 8)),
                    Padding(
                      padding: EdgeInsets.only(top: 8, bottom: 8),
                      child: Text(
                        Translate.of(context)!.translate('name'),
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    AppTextInputBlur(
                      hintText: Translate.of(context)!.translate('input_name'),
                      errorText: Translate.of(context)!
                          .translate(_validName as String),
                      focusNode: _focusName,
                      textInputAction: TextInputAction.next,
                      onTapIcon: () async {
                        _textNameController.clear();
                      },
                      onSubmitted: (text) {
                        UtilOther.fieldFocusChange(
                          context,
                          _focusName,
                          _focusEmail,
                        );
                      },
                      onChanged: (text) {
                        setState(() {
                          _validName = UtilValidator.validate(
                            data: _textNameController.text,
                          );
                        });
                      },
                      icon: Icon(Icons.clear),
                      controller: _textNameController,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16, bottom: 8),
                      child: Text(
                        Translate.of(context)!.translate('email'),
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    AppTextInputBlur(
                      hintText: Translate.of(context)!.translate('input_email'),
                      errorText: Translate.of(context)!
                          .translate(_validEmail as String),
                      focusNode: _focusEmail,
                      textInputAction: TextInputAction.next,
                      onTapIcon: () async {
                        _textEmailController.clear();
                      },
                      onSubmitted: (text) {
                        UtilOther.fieldFocusChange(
                          context,
                          _focusEmail,
                          _focusPhone,
                        );
                      },
                      onChanged: (text) {
                        setState(() {
                          _validEmail = UtilValidator.validate(
                            data: _textEmailController.text,
                            type: ValidateType.email,
                          );
                        });
                      },
                      icon: Icon(Icons.clear),
                      controller: _textEmailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16, bottom: 8),
                      child: Text(
                        Translate.of(context)!.translate('phone_number'),
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    AppTextInputBlur(
                      hintText: Translate.of(context)!.translate(
                        'input_phone',
                      ),
                      errorText: Translate.of(context)!
                          .translate(_validPhone as String),
                      focusNode: _focusPhone,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.phone,
                      onTapIcon: () async {
                        _textPhoneController.clear();
                      },
                      onSubmitted: (text) {
                        UtilOther.fieldFocusChange(
                          context,
                          _focusPhone,
                          _focusInfo,
                        );
                      },
                      onChanged: (text) {
                        setState(() {
                          _validPhone = UtilValidator.validate(
                            data: _textPhoneController.text,
                          );
                        });
                      },
                      icon: Icon(Icons.clear),
                      controller: _textPhoneController,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16, bottom: 8),
                      child: Text(
                        Translate.of(context)!.translate('information'),
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    AppTextInputBlur(
                      hintText: Translate.of(context)!.translate(
                        'input_information',
                      ),
                      errorText: Translate.of(context)!
                          .translate(_validInfo as String),
                      focusNode: _focusInfo,
                      maxLines: 5,
                      onTapIcon: () async {
                        _textInfoController.clear();
                      },
                      onSubmitted: (text) {
                        _update();
                      },
                      onChanged: (text) {
                        setState(() {
                          _validInfo = UtilValidator.validate(
                            data: _textInfoController.text,
                          );
                        });
                      },
                      icon: Icon(Icons.clear),
                      controller: _textInfoController,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, state) {
                    return AppButton(
                      Translate.of(context)!.translate('confirm'),
                      onPressed: _update,
                      loading: state is ProfileSaving,
                      disabled: state is ProfileSaving,
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
