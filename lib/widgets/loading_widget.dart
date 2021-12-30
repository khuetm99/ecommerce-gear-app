import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatefulWidget {
  final double? width;
  final double? height;

  Loading({this.width, this.height});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Center(
        child: Container(
          width: widget.width ?? 40,
          height: widget.height ?? 40,
          child: SpinKitFadingCube(
            color: Theme.of(context).primaryColor,
            duration: Duration(milliseconds: 1000),
          ),
        ),
      ),
    );
  }
}
