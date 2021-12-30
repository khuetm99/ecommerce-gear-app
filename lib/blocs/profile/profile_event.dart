import 'dart:io';

import 'package:ecommerce_app/blocs/profile/bloc.dart';
import 'package:ecommerce_app/data/models/models.dart';
import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Load profile of logged firebase user in firestore
class LoadProfile extends ProfileEvent {}

/// Upload user profile
class OnUpdateUserProfile extends ProfileEvent {
  final File imageFile;
  final String name;
  final String phone;
  final String email;

  OnUpdateUserProfile(
      { required this.imageFile,
      required this.name,
      required this.phone,
      required this.email});
}

/// Upload user profile without image
class OnUpdateUserProfileWithoutImage extends ProfileEvent {
  final String name;
  final String phone;
  final String email;

  OnUpdateUserProfileWithoutImage(
      { required this.name,
        required this.phone,
        required this.email});
}

/// Delivery addresses changed
class AddressListChanged extends ProfileEvent {
  final DeliveryAddressModel deliveryAddress;
  final ListMethod method;

  AddressListChanged({required this.deliveryAddress, required this.method});

  List<Object> get props => [deliveryAddress, method];
}

/// Profile was updated
class ProfileUpdated extends ProfileEvent {
  final UserModel updatedUser;

  ProfileUpdated(this.updatedUser);

  List<Object> get props => [updatedUser];
}
