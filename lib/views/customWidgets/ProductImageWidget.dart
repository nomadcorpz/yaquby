import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';

class ProductImageWidget extends StatefulWidget {
  final String imageUrl;
  final String errorImageUrl;

  ProductImageWidget({required this.imageUrl, required this.errorImageUrl});

  @override
  _ProductImageWidgetState createState() => _ProductImageWidgetState();
}

class _ProductImageWidgetState extends State<ProductImageWidget> {
  bool _imageLoaded = false;

  @override
  void initState() {
    super.initState();

    // Set up a timer for the timeout
    Timer(Duration(seconds: 5), () {
      if (!_imageLoaded) {
        setState(() {
          // Display the error image if the image hasn't loaded within 10 seconds
          _imageLoaded = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_imageLoaded) {
      return CachedNetworkImage(
        imageUrl: widget.imageUrl,
        height: 50,
        width: 50,
        fit: BoxFit.cover,
        errorWidget: (context, url, error) {
          // This errorWidget will be called either on error or on timeout
          return Image.asset(
            widget.errorImageUrl,
            height: 50,
            width: 50,
            fit: BoxFit.cover,
          );
        },
        imageBuilder: (context, imageProvider) {
          // This callback is called when the image successfully loads
          return Image(image: imageProvider);
        },
      );
    } else {
      return Image.asset(
        widget.errorImageUrl,
        height: 50,
        width: 50,
        fit: BoxFit.cover,
      ); // Replace with your desired text
    }
  }
}

// void main() {
//   runApp(MaterialApp(
//     home: Scaffold(
//       appBar: AppBar(title: Text('Image Timeout Example')),
//       body: Center(
//         child: MyWidget(
//           imageUrl: 'https://example.com/your-image-url.jpg',
//           errorImageUrl: 'assets/images/image_not_found.png',
//         ),
//       ),
//     ),
//   ));
// }
