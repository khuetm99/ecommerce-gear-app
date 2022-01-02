import 'package:ecommerce_app/blocs/message/bloc.dart';
import 'package:ecommerce_app/configs/size_config.dart';
import 'package:ecommerce_app/data/models/models.dart';
import 'package:ecommerce_app/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'message_card.dart';

class ListMessages extends StatefulWidget {
  const ListMessages({Key? key}) : super(key: key);
  @override
  _ListMessagesState createState() => _ListMessagesState();
}

class _ListMessagesState extends State<ListMessages> {
  ScrollController scrollController = ScrollController();
  List<MessageModel> messages = [];

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!scrollController.hasClients) return;
    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.offset;

    if (currentScroll > maxScroll - SizeConfig.defaultSize * 7) {
      BlocProvider.of<MessageBloc>(context).add(
        LoadPreviousMessages(messages[messages.length - 1]),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MessageBloc, MessageState>(
      buildWhen: (preState, currState) => currState is DisplayMessages,
      builder: (context, state) {
        if (state is DisplayMessages) {
          if (state.loading) {
            return Loading();
          }
          if (state.messages != null) {
            if (state.isPrevious) {
              messages.addAll(state.messages!);
            } else {
              messages = state.messages!;
            }
            return ListView.builder(
              //physics: BouncingScrollPhysics(),
              controller: scrollController,
              shrinkWrap: true,
              reverse: true,
              padding: EdgeInsets.only(
                left: SizeConfig.defaultPadding,
                right: SizeConfig.defaultPadding,
                bottom: SizeConfig.defaultPadding,
              ),
              itemCount:
                  state.hasReachedMax ? messages.length : messages.length + 1,
              itemBuilder: (context, index) {
                return index == messages.length
                    ? Loading()
                    : MessageCard(message: messages[index]);
              },
            );
          }
          if (state.msg.isNotEmpty) {
            return Center(child: Text('Loaded failure'));
          }
        }

        return Container();
      },
    );
  }
}
