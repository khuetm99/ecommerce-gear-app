import 'dart:async';

import 'package:dialogflow_grpc/dialogflow_grpc.dart';
import 'package:ecommerce_app/blocs/message/bloc.dart';
import 'package:ecommerce_app/constants/constants.dart';
import 'package:ecommerce_app/data/repository/auth_repository/firebase_auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sound_stream/sound_stream.dart';
import 'package:dialogflow_grpc/generated/google/cloud/dialogflow/v2beta1/session.pb.dart';


class ChatInputField extends StatefulWidget {
  const ChatInputField({
    Key? key,
  }) : super(key: key);

  @override
  _ChatInputFieldState createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  TextEditingController messageController = TextEditingController();
  final authRepository = FirebaseAuthRepository();

  List<Asset> images = <Asset>[];
  String error = 'No Error Dectected';


  bool _isRecording = false;

  RecorderStream _recorder = RecorderStream();
  StreamSubscription? _recorderStatus;
  StreamSubscription<List<int>>? _audioStreamSubscription;
  BehaviorSubject<List<int>>? _audioStream;

  // TODO DialogflowGrpcV2Beta1 class instance
  late DialogflowGrpcV2Beta1 dialogflow;

  @override
  void initState() {
    super.initState();
    initPlugin();
  }

  @override
  void dispose() {
    messageController.dispose();
    _recorderStatus?.cancel();
    _audioStreamSubscription?.cancel();
    super.dispose();
  }


  Future<void> initPlugin() async {
    _recorderStatus = _recorder.status.listen((status) {
      if (mounted)
        setState(() {
          _isRecording = status == SoundStreamStatus.Playing;
        });
    });

    await Future.wait([
      _recorder.initialize()
    ]);

    // TODO Get a Service account
    final serviceAccount = ServiceAccount.fromString(
        '${(await rootBundle.loadString('assets/chatbot_credential/credentials.json'))}');
    dialogflow = DialogflowGrpcV2Beta1.viaServiceAccount(serviceAccount);
  }

  void stopStream() async {
    await _recorder.stop();
    await _audioStreamSubscription?.cancel();
    await _audioStream?.close();
  }


  void sendMessage() async{
    if (images.isNotEmpty) {
      BlocProvider.of<MessageBloc>(context).add(SendImageMessage(
        images: images,
        text: messageController.text,
      ));
    } else if (messageController.text.isNotEmpty) {
      BlocProvider.of<MessageBloc>(context).add(SendTextMessage(
        text: messageController.text,
        senderId: authRepository.loggedFirebaseUser.uid,
      ));

      DetectIntentResponse data = await dialogflow.detectIntent(messageController.text, 'en-US');
      String fulfillmentText = data.queryResult.fulfillmentText;
      if(fulfillmentText.isNotEmpty) {

        BlocProvider.of<MessageBloc>(context).add(SendTextMessage(
          text: fulfillmentText,
          senderId: "admin",
        ));

      }
    }
    // Clear input
    setState(() {
      messageController.clear();
      images = [];
    });
  }


  void handleStream() async {
    _recorder.start();

    _audioStream = BehaviorSubject<List<int>>();
    _audioStreamSubscription = _recorder.audioStream.listen((data) {
      print(data);
      _audioStream!.add(data);
    });

    // TODO Create SpeechContexts
    // Create an audio InputConfig
    var biasList = SpeechContextV2Beta1(
        phrases: [
          'Dialogflow CX',
          'Dialogflow Essentials',
          'Action Builder',
          'HIPAA'
        ],
        boost: 20.0
    );

    // See: https://cloud.google.com/dialogflow/es/docs/reference/rpc/google.cloud.dialogflow.v2#google.cloud.dialogflow.v2.InputAudioConfig
    var config = InputConfigV2beta1(
        encoding: 'AUDIO_ENCODING_LINEAR_16',
        languageCode: 'en-US',
        sampleRateHertz: 16000,
        singleUtterance: false,
        speechContexts: [biasList]
    );

    // TODO Make the streamingDetectIntent call, with the InputConfig and the audioStream
    // TODO Get the transcript and detectedIntent and show on screen
    final responseStream = dialogflow.streamingDetectIntent(config, _audioStream!);
    // Get the transcript and detectedIntent and show on screen
    responseStream.listen((data) {
      //print('----');
      setState(() {
        //print(data);
        String transcript = data.recognitionResult.transcript;
        String queryText = data.queryResult.queryText;
        String fulfillmentText = data.queryResult.fulfillmentText;

        if(fulfillmentText.isNotEmpty) {

          BlocProvider.of<MessageBloc>(context).add(SendTextMessage(
            text: queryText,
            senderId: authRepository.loggedFirebaseUser.uid,
          ));

          BlocProvider.of<MessageBloc>(context).add(SendTextMessage(
            text: fulfillmentText,
            senderId: "admin",
          ));

          messageController.clear();
        }
        if(transcript.isNotEmpty) {
          messageController.text = transcript;
        }

      });
    },onError: (e){
      //print(e);
    },onDone: () {
      //print('done');
    });
  }

  void selectImage() async {
    List<Asset> resultList = <Asset>[];

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 3,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#3ac5c9",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      error = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 32,
            color: COLOR_CONST.cardShadowColor.withOpacity(0.5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 8,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (images.isNotEmpty) _buildImages(),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: messageController,
                          textInputAction: TextInputAction.send,
                          onSubmitted: (text) => sendMessage,
                          onEditingComplete: sendMessage,
                          decoration: InputDecoration(
                            hintText: "Type message",
                            border: InputBorder.none,
                          ),
                          maxLines: null,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.image),
                        onPressed: selectImage,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.send, color: Theme.of(context).primaryColor),
            onPressed: sendMessage,
          ),
          IconButton(
            icon: Icon(_isRecording ? Icons.mic_off : Icons.mic),
            color: Theme.of(context).accentColor,
            onPressed: _isRecording ? stopStream : handleStream,
          ),
        ],
      ),
    );
  }

  _buildImages() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(images.length, (index) {
          Asset asset = images[index];
          return Padding(
            padding: EdgeInsets.only(
              top: 8,
              right: 8,
            ),
            child: Stack(
              children: [
                AssetThumb(asset: asset, width: 100, height: 100),
                Positioned(
                  right: 0,
                  top: 0,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        images.removeAt(index);
                      });
                    },
                    child: Icon(Icons.close, color: COLOR_CONST.borderColor),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
