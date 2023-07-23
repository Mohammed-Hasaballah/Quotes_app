// ignore_for_file: avoid_print

import 'networking.dart';

class QuoteModel {
  late String content;
  late String author;
  late String tag;

  Future<void> getRandomQoute() async {
    Map<String, dynamic> quoteInfo =
        await NetworkHelper(url: 'https://api.quotable.io/random').getData();

    print(quoteInfo);
    content = quoteInfo['content'];
    author = quoteInfo['author'];
    tag = quoteInfo['tags'][0];
  }
   
}
