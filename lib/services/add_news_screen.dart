import 'dart:io';

import 'package:e_commerce/services/loading_dialog.dart';
import 'package:e_commerce/services/news_screen.dart';
import 'package:e_commerce/services/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AddNewsScreen extends StatefulWidget {
  const AddNewsScreen({super.key, required this.onSomethingChanged});
  final VoidCallback onSomethingChanged;



  @override
  State<AddNewsScreen> createState() => _AddNewsScreenState();
}

class _AddNewsScreenState extends State<AddNewsScreen> {


  String? _imageUrl;
  File? image;
  Future pickImage() async {
    try {
      showLoading(context: context);
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(context.mounted){
        hideLoading(dialogContext:context);
      }
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }
  Future pickCamera() async {
    try {
      showLoading(context: context);
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }
  Future<void> _uploadImage() async {
    showLoading(context: context);
    String? downloadUrl = await uploadImageToFirebase(image);
    if(context.mounted){
      hideLoading(dialogContext:context);
    }
    setState(() {
      _imageUrl = downloadUrl;
    });
  }

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add News",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 10,
                      )
                    ]),
                child: TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.title_outlined),
                      hintText: "Title",
                      border: OutlineInputBorder()),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.black, blurRadius: 10)
                    ]),
                child: TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.description_outlined),
                      hintText: "Description",
                      border: OutlineInputBorder()),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              SizedBox(
                height: 60,
                width: 150,
                child: TextButton(
                  onPressed: ()async {
                    await pickImage();
                  },
                  child: Text("Select Image"),
                  style: TextButton.styleFrom(backgroundColor: Colors.black),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              SizedBox(
                height: 60,
                width: 150,
                child: TextButton(
                  onPressed: () async{
                    await _uploadImage();
                   if(titleController.text.isNotEmpty && descriptionController.text.isNotEmpty && _imageUrl!=null){
                     await  ApiProvider.sendFCMNotification(titleController.text,descriptionController.text,_imageUrl!);
                     widget.onSomethingChanged.call();
                     if(context.mounted)Navigator.pop(context);
                   }
                   else {
                     if(context.mounted){
                       ScaffoldMessenger.of(context).showSnackBar(
                         const SnackBar(
                           duration: Duration(milliseconds: 500),
                           backgroundColor: Colors.red,
                           margin: EdgeInsets.symmetric(
                             vertical: 100,
                             horizontal: 20,
                           ),
                           behavior: SnackBarBehavior.floating,
                           content: Text(
                             "Maydonlari to'ldiring!!!",
                             style: TextStyle(
                               color: Colors.white,
                               fontWeight: FontWeight.w600,
                               fontSize: 22,
                             ),
                           ),
                         ),
                       );
                     }
                   }
                  },
                  style: TextButton.styleFrom(backgroundColor: Colors.black),
                  child: const Text("Save News"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ApiProvider {
  static Future<void> sendFCMNotification(String title,String description,String image) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'key=AAAAV-sOZLg:APA91bHEBbjntxEWoOfVmjg6ygBVbCMjcTDuE9bkwBWun5eTKCHSuTrMFHS35PVwdp0UHnvx-PUqEpYI0ycj07uw6MbsAY_5DS-bvnxHCTRKmKBcdDxr38uXLx-_2nPVO0FjxcEnrDJ7',
    };

    final response = await http.post(
      Uri.parse("https://fcm.googleapis.com/fcm/send"),
      headers: headers,
      body: jsonEncode(Post(
          to:
              "eRc4K8JbR2O94K6HpG4vL8:APA91bHWzpuKYMSXoJzCCxtUzOXqZzBCvejaIwGzpv_wWNt0u6lGlhWjlg2TWEQ9udXb4sQHdHTwmsgWqDHYY0vy99WmSokYODvV5TT0KcC5Guz0OOQVtBz2FIN9OotpGgs_BRx5zOJN",
          notification: Notification(
              title: "News",
              body: "The Best",
              image: "https://daryo.uz/logo/logo.svg"),
          data: Data(
              title: title,
              description: description,
              image: image))),
    );

    if (response.statusCode == 200) {
      print('Notification sent successfully');
    } else {
      print('Failed to send notification. Status code: ${response.statusCode}');
    }
  }
}



class Post {
  String to;
  Notification notification;
  Data data;

  Post({
    required this.to,
    required this.notification,
    required this.data,
  });

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        to: json["to"],
        notification: Notification.fromJson(json["notification"]),
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "to": to,
        "notification": notification.toJson(),
        "data": data.toJson(),
      };
}

class Data {
  String title;
  String description;
  String image;

  Data({
    required this.title,
    required this.description,
    required this.image,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        title: json["title"],
        description: json["description"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "image": image,
      };
}

class Notification {
  String title;
  String body;
  String image;

  Notification({
    required this.title,
    required this.body,
    required this.image,
  });

  factory Notification.fromJson(Map<String, dynamic> json) => Notification(
        title: json["title"],
        body: json["body"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "body": body,
        "image": image,
      };
}
