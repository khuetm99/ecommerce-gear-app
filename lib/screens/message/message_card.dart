import 'package:ecommerce_app/blocs/app_bloc.dart';
import 'package:ecommerce_app/blocs/profile/bloc.dart';
import 'package:ecommerce_app/configs/config.dart';
import 'package:ecommerce_app/configs/size_config.dart';
import 'package:ecommerce_app/constants/constants.dart';
import 'package:ecommerce_app/data/models/models.dart';
import 'package:ecommerce_app/utils/utils.dart';
import 'package:flutter/material.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({Key? key, required this.message}) : super(key: key);

  final MessageModel message;

  @override
  _MessageCardState createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    bool isSender = false;
    ProfileState profileState = AppBloc.profileBloc.state;
    if (profileState is ProfileLoaded &&
        profileState.loggedUser.id == widget.message.senderId) {
      isSender = true;
    }

    Widget contentWidget = Container();

    if (widget.message is TextMessageModel) {
      contentWidget = _buildTextMessage(
        widget.message as TextMessageModel,
        isSender,
      );
    } else if (widget.message is ImageMessageModel) {
      contentWidget = _buildImageMessage(
        widget.message as ImageMessageModel,
        isSender,
      );
    } else {
      contentWidget = _buildTextMessage(
        widget.message as TextMessageModel,
        isSender,
      );
    }

    return GestureDetector(
      onTap: () {},
      child: Align(
        alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: EdgeInsets.only(
            left: isSender ? SizeConfig.defaultSize * 5 : 0,
            right: isSender ? 0 : SizeConfig.defaultSize * 5,
            top: 10,
          ),
          padding: EdgeInsets.all(SizeConfig.defaultPadding),
          decoration: BoxDecoration(
            color:
                Theme.of(context).primaryColor.withOpacity(isSender ? 1 : 0.15),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: !isSender ? Radius.circular(10) : Radius.circular(0),
              bottomLeft: !isSender ? Radius.circular(0) : Radius.circular(10),
              bottomRight:  Radius.circular(10),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              contentWidget,
              const SizedBox(height: 5),
              Text(
                UtilFormatter.formatTimeStamp(widget.message.createdAt),
                style: TextStyle(
                  fontSize: 12,
                  color: isSender
                      ? Theme.of(context).backgroundColor
                      : COLOR_CONST.textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildTextMessage(TextMessageModel message, bool isSender) {
    return SelectableText(
      message.text,
      style: isSender
          ? Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(color: Theme.of(context).backgroundColor)
          : Theme.of(context).textTheme.bodyText1!.copyWith(),
      maxLines: null,
      textWidthBasis: TextWidthBasis.longestLine,
    );
  }

  _buildImageMessage(ImageMessageModel message, bool isSender) {
    var textPart = message.text!.isNotEmpty
        ? Text(
            message.text!,
            style: isSender
                ? Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: Theme.of(context).backgroundColor)
                : Theme.of(context).textTheme.bodyText1!.copyWith(),
            maxLines: null,
            textWidthBasis: TextWidthBasis.longestLine,
          )
        : Container();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textPart,
        const SizedBox(height: 5),
        Wrap(
          children: List.generate(message.images.length, (index) {
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  Routes.gallery,
                  arguments: {
                    "products": message.images[index],
                    "index": index
                  },
                );
              },
              child: Image.network(
                message.images[index],
                fit: BoxFit.cover,
                width: 100,
                height: 100,
              ),
            );
          }),
        )
      ],
    );
  }
}
