part of 'crop_photo_bloc.dart';

abstract class CropPhotoState extends Equatable {
  const CropPhotoState();
  @override
  List<Object> get props => [];
}

class PhotoInitial extends CropPhotoState {}

class PhotoSet extends CropPhotoState {
  final File photo;

  PhotoSet(this.photo);

  @override
  List<Object> get props => [photo];
}
