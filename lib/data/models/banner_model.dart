import 'package:equatable/equatable.dart';

class BannerModel extends Equatable {
  final String id;
  final String imageUrl;
  final String linkUrl;

  BannerModel({required this.id, required this.imageUrl,required this.linkUrl});

  /// Json data from server turns into model data
  static BannerModel fromMap(Map<String, dynamic> data) {
    return BannerModel(
      id: data["id"] ?? "",
      imageUrl: data["imageUrl"] ?? "",
      linkUrl: data["linkUrl"] ?? "",
    );
  }

  /// From model data turns into json data => server
  Map<String, dynamic> toMap() {
    return {
      "id": this.id,
      "name": this.imageUrl,
      "linkUrl": this.linkUrl,
    };
  }

  @override
  String toString() {
    return 'BannerModel{id: $id, url: $imageUrl, linkUrl: $linkUrl}';
  }

  @override
  List<Object?> get props => [id, imageUrl, linkUrl];
}
