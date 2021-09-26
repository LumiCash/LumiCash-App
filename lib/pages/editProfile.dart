import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:lumicash/Config/config.dart';
import 'package:lumicash/DialogBox/loadingDialog.dart';
import 'package:lumicash/models/account.dart';
import 'package:lumicash/widgets/customTextField.dart';


class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {

  Uint8List? _image;
  final picker = ImagePicker();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  bool isBusiness = AppConfig.account!.accountType == "business";


  @override
  void initState() {
    super.initState();

    //checkUserInfo();

    setState(() {
      nameController.text = AppConfig.account!.username!;
      emailController.text = AppConfig.account!.email!;
      phoneController.text = AppConfig.account!.phone!;
    });
  }

  checkUserInfo() async {
    await FirebaseFirestore.instance.collection("users")
        .doc(AppConfig.account!.userID).get().then((querySnapshot) {
          querySnapshot.get("accountType");
    });
  }

  Future getImage(String type) async {
    Navigator.pop(context);

    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);

    //final pickedFile = await picker.getImage(source: type == "camera" ? ImageSource.camera : ImageSource.gallery);

    if(result != null) {
      Uint8List fileBytes = result.files.first.bytes!;

      //String fileName = result.files.first.name;

      // final tempDir = await getTemporaryDirectory();
      // final file = await new File('${tempDir.path}/$fileName').create();
      // file.writeAsBytesSync(fileBytes);

      setState(() {
        _image = fileBytes;
      });
    }

    // setState(() {
    //   if (pickedFile != null) {
    //
    //     _image = File(pickedFile.path);
    //   } else {
    //     print('No image selected.');
    //   }
    // });
  }

  displayAvatar() {
    if(AppConfig.account!.url!.isNotEmpty && _image == null)
      {
        return NetworkImage(AppConfig.account!.url!);
      }
    else if(_image != null)
      {
        return MemoryImage(_image!);
      }
    else
      {
        return AssetImage("assets/profile.png");
      }
  }

  takeImage(mContext) {
    return showDialog(
      context: mContext,
      builder: (context) {
        return SimpleDialog(
          title: Text("Pick Photo",textAlign: TextAlign.center, style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),
          children: <Widget>[
            SimpleDialogOption(
              child: Text("Capture Image with Camera"),
              onPressed: ()=> getImage("camera"),
            ),
            SimpleDialogOption(
              child: Text("Select Image from Gallery"),
              onPressed: ()=> getImage("gallery"),
            ),
            SimpleDialogOption(
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }

  Future<String> uploadPhoto(mImageFile, String postId) async {

    firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;

    var storageReference = storage.ref().child("Profile Photos");

    firebase_storage.UploadTask task = storageReference.child(postId).child("profile_$postId.jpg").putData(mImageFile);

    firebase_storage.TaskSnapshot snapshot = await task;
    Future<String> downloadUrl = snapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  saveToFirestore({String? username, String? url, String? email, String? phone}) async {
    await FirebaseFirestore.instance.collection("users").doc(AppConfig.account!.userID).update(
        {
          "username": username,
          "email": email,
          "url": url,
          "phone": phone,
        });
  }

  updateUserInfo() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingAlertDialog(message: "Updating, Please wait...",);
        }
    );

    try
        {
          if(_image != null)
          {
            String downloadUrl = await uploadPhoto(_image, AppConfig.account!.userID!);

            Account account = Account(
              userID: AppConfig.account!.userID,
              url: downloadUrl,
              username: nameController.text.trim(),
              phone: phoneController.text.trim(),
              email: emailController.text.trim(),
            );

            setState(() {
              AppConfig.account = account;
            });

            await saveToFirestore(
              username: nameController.text.trim(),
              url: downloadUrl,
              email: emailController.text.trim(),
              phone: phoneController.text.trim(),
            );

            Fluttertoast.showToast(msg: "Updated Information Successfully!");
            Navigator.pop(context);
            Navigator.pop(context);
          }
          else
          {
            await saveToFirestore(
              username: nameController.text.trim(),
              url: "",
              email: emailController.text.trim(),
              phone: phoneController.text.trim(),
            );

            Fluttertoast.showToast(msg: "Updated Information Successfully!");
            Navigator.pop(context);
            Navigator.pop(context);
          }
        }
        catch(e) {
          print(e.toString());
          Navigator.pop(context);
          Fluttertoast.showToast(msg: "Error Updating");
        }
  }

  updateAccountType() async {

    String accountType = isBusiness ? "Individual" : "Business";

    await FirebaseFirestore.instance.collection("users").doc(AppConfig.account!.userID).update(
        {
          "accountType": accountType.toLowerCase(),
        }).then((value) => Fluttertoast.showToast(msg: "Switched to $accountType Account"));
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(onPressed: ()=> Navigator.pop(context), icon: Icon(Icons.arrow_back, color: Colors.black,)),
        title: Text("My Profile", style: TextStyle(color: Colors.black),),
        actions: [
          TextButton(
            onPressed: () => updateUserInfo(),
            child: Text("Update", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20.0,),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 90.0,
                    width: 90.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(45.0),
                        image: DecorationImage(
                            image: displayAvatar(),
                            fit: BoxFit.cover
                        )
                    ),
                  ),
                  SizedBox(height: 5.0,),
                  TextButton(
                    onPressed: () => takeImage(context),
                    child: Text("Change Picture", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),),
                  )
                ],
              ),
            ),
            Container(height: 5.0, width: size.width, color: Colors.grey.shade300,),
            CustomTextField(
              controller: nameController,
              data: Icons.person,
              hintText: "Name",
              isObscure: false,
            ),
            CustomTextField(
              controller: emailController,
              data: Icons.email_outlined,
              hintText: "Email Address",
              isObscure: false,
            ),
            CustomTextField(
              controller: phoneController,
              data: Icons.phone_android,
              hintText: "Phone Number",
              isObscure: false,
            ),
            SizedBox(height: 20.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Switch(
                  activeColor: Colors.blue,
                  inactiveThumbColor: Theme.of(context).scaffoldBackgroundColor,
                  inactiveTrackColor: Colors.grey,
                  value: isBusiness,
                  onChanged: (value) async {

                    await updateAccountType();

                    setState(() {
                      isBusiness = value;
                      AppConfig.account!.accountType = isBusiness ? "individual" : "business";
                    });
                  },
                ),
                SizedBox(width: 5.0,),
                Text(
                  isBusiness ? "Switch to Individual Account" : "Switch to Business Account",
                ),
              ],
            ),
            //Text(AppConfig.account.accountType)
          ],
        ),
      ),
    );
  }
}
