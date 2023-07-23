import 'networking.dart';

class ImageModel {
  late String url;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;

    return data;
  }

  Future<void> getRandomImage(String category) async {
    Map<String, dynamic> imageInfo = await NetworkHelper(
            url:
                'https://random.imagecdn.app/v1/image?category=$category&format=json')
        .getData();
    url = imageInfo['url'];
  }
}
