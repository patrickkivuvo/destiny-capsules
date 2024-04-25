import 'dart:io';

import 'package:destiny_capsules/constants/appstyle.dart';
import 'package:destiny_capsules/constants/colors.dart';
import 'package:destiny_capsules/common_widgets/app_icons_buttons/back_button.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool _downloading = false;

  Future<void> _downloadBook(
      String url, String filename, BuildContext context) async {
    setState(() {
      _downloading = true;
    });

    try {
      final response = await http.get(Uri.parse(url));
      final bytes = response.bodyBytes;
      final dir = await getExternalStorageDirectory();
      final file = File('${dir!.path}/$filename');
      await file.writeAsBytes(bytes, flush: true);

      setState(() {
        _downloading = false;
      });

      print('Book downloaded successfully!');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Book downloaded successfully!'),
      ));
    } catch (e) {
      setState(() {
        _downloading = false;
      });
      print('Error downloading book: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error downloading book: $e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const AppBackButton(),
        backgroundColor: Colors.white,
        title: Text(
          "Your Orders",
          style: appstyleWithHt(18, AppColors.black, FontWeight.bold, 1.5),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _downloading
                  ? null
                  : () {
                      _downloadBook(
                        'https://destinycapsules.co.ke/api/users/books/download',
                        'book.pdf',
                        context,
                      );
                    },
              child: const Text('Download Book'),
            ),
            if (_downloading) const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
