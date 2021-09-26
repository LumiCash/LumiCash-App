import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lumicash/Config/config.dart';
import 'package:lumicash/DialogBox/errorDialog.dart';
import 'package:lumicash/DialogBox/loadingDialog.dart';
import 'package:lumicash/models/categories.dart';
import 'package:lumicash/models/dropDown.dart';
import 'package:lumicash/models/post.dart';
import 'package:lumicash/widgets/customTextField.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
//import 'package:image/image.dart';


class UploadPage extends StatefulWidget {

  // final List<File> imageList;
  //
  // const UploadPage({Key key, this.imageList}) : super(key: key);

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {

  List<Uint8List> _images = [];
  final picker = ImagePicker();
  TextEditingController titleController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController availableSlotsController = TextEditingController();
  TextEditingController timeLimitController = TextEditingController();
  TextEditingController linkController = TextEditingController();
  var productId = Uuid().v4();
  PeriodType period = PeriodType(name: "Day", milliseconds: 8.64e+7.toInt());
  List<String> uploadUrls = [];



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
        _images.add(fileBytes);
      });
    }

    // setState(() {
    //   if (result != null) {
    //
    //
    //     //_image = File(pickedFile.path);
    //   } else {
    //     print('No image selected.');
    //   }
    // });
  }

  Future<String> uploadPhoto(mImageFile, String postId) async {

    firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;

    var storageReference = storage.ref().child("Products");

    firebase_storage.UploadTask task = storageReference.child(postId).child("post_$postId.jpg").putData(mImageFile);

    firebase_storage.TaskSnapshot snapshot = await task;
    Future<String> downloadUrl = snapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  controlUploadAndSave() async {

    showDialog(
        context: context,
        builder: (c) {
          return LoadingAlertDialog(message: "Uploading, Please wait...",);
        }
    );

    if(titleController.text.isNotEmpty
        && priceController.text.isNotEmpty
        && descriptionController.text.isNotEmpty
        && categoryController.text.isNotEmpty
        //&& productSizes.isNotEmpty
        //&& colors.isNotEmpty
        )
      {
        try
            {

              int productPeriod = int.parse(timeLimitController.text.trim()) * period.milliseconds!;

              String downloadUrl = await uploadImages(_images, productId.toString());//uploadPhoto(_image, productId.toString());
              int timestamp = DateTime.now().millisecondsSinceEpoch;

              Product product = Product(
                productId: productId.toString(),
                title: titleController.text.trim(),
                imageUrl: downloadUrl,
                price: priceController.text.trim(),
                description: descriptionController.text,
                period: productPeriod,
                count: int.parse(availableSlotsController.text.trim()),
                category: categoryController.text.trim(),
                timestamp: timestamp,
                searchKey: titleController.text.toLowerCase(),
                link: linkController.text,
                publisherID: AppConfig.account!.userID
              );

              await saveInfoToFirestore(product.productId!, product.toMap());

              Navigator.pop(context);

              Fluttertoast.showToast(msg: "Product Uploaded successfully");

              setState(() {
                titleController.clear();
                priceController.clear();
                descriptionController.clear();
                availableSlotsController.clear();
                timeLimitController.clear();
                categoryController.clear();
                _images.clear();
              });


              Navigator.pop(context);
            }
            catch(e) {
              Navigator.pop(context);
              showDialog(
                  context: context,
                  builder: (c) {
                    return ErrorAlertDialog(message: e.toString(),);
                  }
              );
            }
      }
    else
      {
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (c) {
              return ErrorAlertDialog(message: 'Fill in the Required fields!',);
            }
        );
      }
  }

  saveInfoToFirestore(String id, Map<String, dynamic> map) async {
    await FirebaseFirestore.instance.collection("products").doc(id).set(map);
  }

  takeImage(mContext) {
    return showDialog(
      context: mContext,
      builder: (context) {
        return SimpleDialog(
          title: Text("New Product",textAlign: TextAlign.center, style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),
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

  importantStep(List<Uint8List> imageFiles, String postId) async {
    for(var file in imageFiles) {
      await uploadPhoto(file, postId).then((downloadUrl) {
        uploadUrls.add(downloadUrl.toString());
      });
    }
  }

  Future<String> uploadImages(List<Uint8List> imageFiles, String postId) async {
    String finalString;

    await importantStep(imageFiles, postId);

    finalString = uploadUrls.join("|");

    return finalString;
  }

  displayImages(Size size) {
    if(_images.isEmpty)
      {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: InkWell(
            onTap: ()=> takeImage(context),
            child: Container(
              height: 40.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  gradient: AppConfig.gradient
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Pick Photo", style: TextStyle(color: Colors.white),),
              ),
            ),
          ),
        );
      }
    else
      {
        return Container(
          width: size.width,
          height: size.height*0.2,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: size.height*0.2,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: _images.length,
                    itemBuilder: (context, index) {
                      Uint8List file = _images[index];

                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          height: size.height*0.2,
                          width: size.width*0.6,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                image: MemoryImage(file),
                                fit: BoxFit.cover,
                              )
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: InkWell(
                    onTap: ()=> takeImage(context),
                    child: Container(
                      height: 40.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          gradient: AppConfig.gradient
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Pick Photo", style: TextStyle(color: Colors.white),),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      }
  }

  onSelected(PeriodType periodType) {
    setState(() {
      period = periodType;
    });
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: AppConfig.gradient,
          ),
        ),
        title: Text("Submit Reward"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            displayImages(size),
            SizedBox(height: 10.0,),
            MyCustomTextField(
              controller: titleController,
              hintText: "Product Name",
              keyboardType: TextInputType.text,
            ),
            MyCustomTextField(
              controller: priceController,
              hintText: "CashBack Points",
              keyboardType: TextInputType.number,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: DropdownSearch<String>(
                mode: Mode.DIALOG,
                showSelectedItem: true,
                items: List.generate(category2s.length, (index) => category2s[index].title!),
                label: "Category",
                hint: "Category",
                //popupItemDisabled: (String s) => s.startsWith('I'),
                onChanged: (v) {
                  setState(() {
                    categoryController.text = v!;
                  });
                },
                //selectedItem: "Brazil"
              ),
            ),
            MyCustomTextField(
              controller: descriptionController,
              hintText: "Description",
              keyboardType: TextInputType.text,
            ),
            MyCustomTextField(
              controller: availableSlotsController,
              hintText: "Available Slots",
              keyboardType: TextInputType.number,
            ),
            Row(
              children: [
                Expanded(
                  child: MyCustomTextField(
                    controller: timeLimitController,
                    hintText: "Time Limit",
                    keyboardType: TextInputType.number,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Text(period.name!,),
                ),
                PopupMenuButton<PeriodType>(
                  icon: Icon(Icons.arrow_drop_down_circle_outlined),
                  offset: Offset(0.0, 0.0),
                  onSelected: onSelected,
                  itemBuilder: (BuildContext context){
                    return periods.map((PeriodType periodType){
                      return PopupMenuItem<PeriodType>(
                        value: periodType,
                        child: Text(periodType.name!),
                      );
                    }).toList();
                  },
                )
              ],
            ),
            MyCustomTextField(
              controller: linkController,
              hintText: "Link (Optional)",
              keyboardType: TextInputType.text,
            ),

            InkWell(
              onTap: ()=> controlUploadAndSave(),
              child: Container(
                height: 40.0,
                decoration: AppConfig.buttonDecoration,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text("Submit", style: TextStyle(color: Colors.white),),
                ),
              ),
            ),
            SizedBox(height: 30.0,)
          ],
        ),
      ),
    );
  }
}
