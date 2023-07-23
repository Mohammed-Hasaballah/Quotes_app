import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:quotes_app/services/images.dart';
import 'package:quotes_app/services/quotes.dart';

import 'home_screen.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  void getData() async {
    QuoteModel quote = QuoteModel();
    ImageModel image = ImageModel();
    await quote.getRandomQoute();
    await image.getRandomImage(quote.tag);
    if (mounted) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: ((context) => HomeScreen(
                    quoteInfo: quote,
                    imageInfo: image,
                  ))));
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Quotify',
              style: TextStyle(
                color: Colors.white,
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              'Discover and Collect Inspiring Quotes',
              style: TextStyle(
                  color: Color.fromARGB(255, 202, 199, 199),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Spartan MB'),
            ),
            SizedBox(
              height: 40,
            ),
            SpinKitFadingCube(
              color: Colors.white,
              size: 50.0,
            ),
          ],
        ),
      ),
    );
  }
}
