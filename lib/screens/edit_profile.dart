import 'dart:io';

import 'package:flutter/cupertino.dart';
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
  void takePicture() async {
    XFile? value = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 40);
    if (value != null) {
      setState(() {
        image = File(value.path);
      });
    }
  }

  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
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
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        children: [
          image == null
              ? CupertinoButton(
                  onPressed: takePicture,
                  child: const CircleAvatar(
                      backgroundColor: Colors.grey,
                      radius: 70,
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                      )),
                )
              : CupertinoButton(
                  onPressed: takePicture,
                  child: CircleAvatar(
                    backgroundImage: FileImage(image!),
                    radius: 70,
                  ),
                ),
          const SizedBox(
            height: 12.0,
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.grey, borderRadius: BorderRadius.circular(35)),
            child: TextFormField(
              controller: textEditingController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(

                  //decoration of textformfield.
                  //EMAIL TEXTFORM FILED
                  hintText: appProvider.getUserInformation.name,
                  hintStyle: const TextStyle(
                    color: Colors.white,
                  ),
                  prefixIcon: const Icon(
                    //putting an icon.
                    Icons.person_2_outlined,
                    color: Colors.white,
                  ),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(35.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      width: 2,
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(35.0),
                  )),
            ),
          ),
          const SizedBox(
            height: 25.0,
          ),
          const SizedBox(
            height: 40,
          ),
          Container(
            height: 60,
            width: double.infinity,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(35)),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlueAccent,
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
                  ),
                )),
          )
        ],
      ),
    );
  }
}
