import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'crop_photo_event.dart';
part 'crop_photo_state.dart';

class CropPhotoBloc extends Bloc<CropPhotoEvent, CropPhotoState> {
  CropPhotoBloc() : super(PhotoInitial());

  @override
  Stream<CropPhotoState> mapEventToState(CropPhotoEvent event) async* {
    if (event is GetPhoto) {
      final photo = event.photo;
      yield PhotoSet(photo);
    }
  }
}
