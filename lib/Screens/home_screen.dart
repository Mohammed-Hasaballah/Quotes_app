// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'dart:ui';
import 'dart:async';

import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:share_plus/share_plus.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:quotes_app/services/images.dart';
import 'package:quotes_app/services/quotes.dart';

class HomeScreen extends StatefulWidget {
  QuoteModel quoteInfo;
  ImageModel imageInfo;
  HomeScreen({
    Key? key,
    required this.quoteInfo,
    required this.imageInfo,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String imageURL;
  late String quote;
  late String authorName;

  QuoteModel quoteModel = QuoteModel();
  ImageModel imageModel = ImageModel();

  void updateUI(QuoteModel quoteModel, ImageModel imageModel) {
    imageURL = imageModel.url;
    quote = quoteModel.content;
    authorName = quoteModel.author;
  }

  @override
  void initState() {
    updateUI(widget.quoteInfo, widget.imageInfo);
    super.initState();
  }

  GlobalKey globalKey = GlobalKey();
  Uint8List? pngBytes;

  Future<void> _capturePng() async {
    RenderRepaintBoundary boundary =
        globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    // if (boundary.debugNeedsPaint) {
    if (kDebugMode) {
      print("Waiting for boundary to be painted.");
    }
    await Future.delayed(const Duration(milliseconds: 20));
    ui.Image image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    pngBytes = byteData!.buffer.asUint8List();
    if (kDebugMode) {
      print(pngBytes);
    }
    if (mounted) {
      _onShareXFileFromAssets(context, byteData);
      // }
    }
  }

  void _onShareXFileFromAssets(BuildContext context, ByteData? data) async {
    final box = context.findRenderObject() as RenderBox?;
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    // final data = await rootBundle.load('assets/flutter_logo.png');
    final buffer = data!.buffer;
    final shareResult = await Share.shareXFiles(
      [
        XFile.fromData(
          buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
          name: 'screen_shot.png',
          mimeType: 'image/png',
        ),
      ],
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );

    scaffoldMessenger.showSnackBar(getResultSnackBar(shareResult));
  }

  SnackBar getResultSnackBar(ShareResult result) {
    return SnackBar(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Share result: ${result.status}"),
          if (result.status == ShareResultStatus.success)
            Text("Shared to: ${result.raw}")
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _capturePng,
        label: const Text('Take screenshot'),
        icon: const Icon(Icons.share_rounded),
      ),
      body: RepaintBoundary(
        key: globalKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SafeArea(
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(imageURL),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                          Colors.white.withOpacity(0.8), BlendMode.dstATop),
                    ),
                  ),
                  constraints: const BoxConstraints.expand(),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.4),
                              Colors.white.withOpacity(0.0)
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter),
                      ),
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () async {
                      await quoteModel.getRandomQoute();
                      await imageModel.getRandomImage(quoteModel.tag);
                      updateUI(quoteModel, imageModel);
                      setState(() {});
                    },
                    icon: const Icon(
                      Icons.restart_alt,
                      size: 30,
                    )),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              SizedBox(
                                width: 200,
                                height: 200,
                                child: Opacity(
                                  opacity: 0.3,
                                  child: Image.asset(
                                    'images/quote_left.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              AutoSizeText(
                                '\'$quote\'',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 3,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Colors.grey,
                            ),
                            child: Text(
                              authorName,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ]),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
