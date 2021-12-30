part of 'crop_photo_bloc.dart';

abstract class CropPhotoEvent extends Equatable {
  const CropPhotoEvent();
}

class GetPhoto extends CropPhotoEvent {
  final File photo;

  GetPhoto(this.photo);

  @override
  List<Object> get props =>[photo];
}
