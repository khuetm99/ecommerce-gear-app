import 'package:ecommerce_app/blocs/message/bloc.dart';
import 'package:ecommerce_app/constants/constants.dart';
import 'package:ecommerce_app/screens/message/list_messages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import 'chat_input_field.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({Key? key}) : super(key: key);

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MessageBloc()..add(LoadMessages()),
      child: Scaffold(
        appBar: _buildAppBar(),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(child: ListMessages()),
              ChatInputField(),
            ],
          ),
        ),
      ),
    );
  }

  _buildAppBar() {
    return AppBar(
      title: Row(
        children: [
          CircleAvatar(backgroundImage: AssetImage(IMAGE_CONST.DEFAULT_AVATAR)),
          SizedBox(width:8),
          Text(
            "Peachy",
            style: Theme.of(context).textTheme.headline6!.copyWith(color: Colors.white),
          ),
        ],
      ),
      centerTitle: false,
      actions: [
        IconButton(
          icon: Icon(Icons.local_phone),
          onPressed: () async {
            await _makePhoneCall("0938185899");
          },
        ),
        SizedBox(width: 5),
      ],
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    if (await canLaunch("tel:$phoneNumber")) {
      await launch("tel:$phoneNumber");
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }
}




