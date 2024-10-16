import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:tech_trove_shop/models/user_model.dart';
import 'package:tech_trove_shop/provider/app_provider.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File? image;
  TextEditingController textEditingController = TextEditingController();

  void takePicture() async {
    XFile? value = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 40);
    if (value != null) {
      setState(() {
        image = File(value.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);

    // Responsive dimensions
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlueAccent, Colors.lightBlue.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
          children: [
            Center(
              child: image == null
                  ? GestureDetector(
                      onTap: takePicture,
                      child: const CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: 70,
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: takePicture,
                      child: CircleAvatar(
                        backgroundImage: FileImage(image!),
                        radius: 70,
                      ),
                    ),
            ),
            const SizedBox(height: 20.0),

            // User Name Field
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(35),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextFormField(
                controller: textEditingController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  hintText: appProvider.getUserInformation.name,
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                  ),
                  prefixIcon: const Icon(
                    Icons.person_2_outlined,
                    color: Colors.lightBlueAccent,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(35.0),
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(35.0),
                    borderSide: const BorderSide(
                      width: 2,
                      color: Colors.lightBlueAccent,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30.0),

            // Update Button
            SizedBox(
              height: 60,
              width: screenWidth * 0.8, // 80% of screen width
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35),
                  ),
                  elevation: 5,
                ),
                onPressed: () async {
                  UserModel userModel = appProvider.getUserInformation
                      .copyWith(name: textEditingController.text);
                  appProvider.updateUserInfor(context, userModel, image);
                },
                child: const Text(
                  "Update",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),

            // Additional Padding for visual spacing
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
