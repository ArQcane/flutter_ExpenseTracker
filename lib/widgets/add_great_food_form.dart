import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import '../services/firestore_service.dart';

class AddGreatFoodForm extends StatefulWidget {
  @override
  State<AddGreatFoodForm> createState() => _AddGreatFoodFormState();
}

class _AddGreatFoodFormState extends State<AddGreatFoodForm> {
  FirestoreService fsService = FirestoreService();
  String? foodName;
  String? storeName;
  File? foodPhoto;
  var form = GlobalKey<FormState>();

  void addGreatFood(context) {
    bool isValid = form.currentState!.validate();
    if (foodPhoto == null) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please include a food image!'),
      ));
      return;
    }
    if (isValid) {
      form.currentState!.save();
      FirebaseStorage.instance
          .ref()
          .child(DateTime.now().toString() + '_' + basename(foodPhoto!.path))
          .putFile(foodPhoto!)
          .then((task) {
        task.ref.getDownloadURL().then((imageUrl) {
          fsService.addGreatFood(foodName, storeName, imageUrl);
          Navigator.of(context).pop();
        });
      });
    }
  }

  Future<void> pickImage(mode) {
    ImageSource chosenSource =
        mode == 0 ? ImageSource.camera : ImageSource.gallery;
    return ImagePicker()
        .pickImage(
            source: chosenSource,
            maxWidth: 600,
            imageQuality: 50,
            maxHeight: 150)
        .then((imageFile) {
      if (imageFile != null) {
        setState(() {
          foodPhoto = File(imageFile.path);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Form(
        key: form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              decoration: InputDecoration(label: Text('Food Name')),
              validator: (value) {
                if (value == null || value.length == 0)
                  return "Please provide a food name.";
                else
                  return null;
              },
              onSaved: (value) {
                foodName = value;
              },
            ),
            TextFormField(
              decoration: InputDecoration(label: Text('Store Name')),
              validator: (value) {
                if (value == null || value.length == 0)
                  return 'Please provide a store name.';
                else
                  return null;
              },
              onSaved: (value) {
                storeName = value;
              },
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    width: 150,
                    height: 100,
                    decoration: BoxDecoration(color: Colors.grey),
                    child: foodPhoto != null
                        ? FittedBox(
                            fit: BoxFit.fill, child: Image.file(foodPhoto!))
                        : Center()),
                Column(
                  children: [
                    TextButton.icon(
                        icon: Icon(Icons.camera_alt),
                        onPressed: () => pickImage(0),
                        label: Text('Take Photo')),
                    TextButton.icon(
                        icon: Icon(Icons.image),
                        onPressed: () => pickImage(1),
                        label: Text('Add Image')),
                  ],
                )
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  addGreatFood(context);
                },
                child: Text('Add Great Food')),
          ],
        ),
      ),
    );
  }
}
