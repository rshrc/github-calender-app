import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:calender_app/src/functions/common.dart' as c;
import 'package:calender_app/src/functions/errorHandling.dart';
import 'package:calender_app/src/style/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../calender/calender1.dart' as calender;
import '../signInDialog.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

TextEditingController _nameController = TextEditingController();
TextEditingController _phoneController = TextEditingController();
// TextEditingController _carNumberController = TextEditingController();
// TextEditingController _carTypeController = TextEditingController();
// TextEditingController _emailController = TextEditingController();
bool _isLoading = false;
DatabaseReference _database;
var _uid;
var _userData;
bool _imageExists = false;

class _EditProfileState extends State<EditProfile> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    verifyUser();
    if (_userData != null)
      _imageExists = _userData["image"] != null;
    else
      _imageExists = false;
  }

  Future<void> verifyUser() async {
    await FirebaseAuth.instance.currentUser().then((user) async {
      if (user != null) {
        // // print("$user");
        _uid = user.uid;

        _database = FirebaseDatabase.instance.reference().child('user');
        await _database.child(_uid).once().then((DataSnapshot data) {
          _userData = data.value;
          // // print("000000 ${data.key}");
          // // print("0000001 ${data.value}");
          if (_userData == null) {
            _phoneController.text = "Login to use";
            _nameController.text = "Login to use";
          }
          _phoneController.text = _userData["phoneNo"];
          _nameController.text = _userData["fName"];
          // _carNumberController.text = _userData["carNumber"];
          // _carTypeController.text = _userData["carType"];
          // _emailController.text = _userData["email"];
          setState(() {
            _imageExists = _userData["image"] != null;
            delete = !_imageExists;
          });

          // if (data.value != null) exist = true;// check this condition
        });
      } else {
        _phoneController.text = "Login to use";
        _nameController.text = "Login to use";
      }
    });
  }

  Future<void> updateUser(String _imageUrl) async {
    _database = FirebaseDatabase.instance.reference().child('user').child(_uid);

    Map<String, dynamic> data = {
      "fName": _nameController.text,
      "phoneNo": _userData["phoneNo"],
      "image": _imageUrl,
    };
    // print("user Updating");
    _database.update(data);

    // print("user Updated");
  }

  File _image;
  bool delete = true;

  Future getImage(context) async {
    var image = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxHeight: 150,
      maxWidth: 120,
    );

    setState(() {
      _image = image;
      delete = false;
    });

    // _imageData = await uploadProfilePic(context, _image, widget.sId);
    Navigator.pop(context);
  }

  Future getImageGallery(context) async {
    var image = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 150,
      maxWidth: 120,
    );

    setState(() {
      _image = image;
      delete = false;
    });
    // print("_image");
    // print(_image.toString());
    // _imageData = await uploadProfilePic(context, _image, widget.sId);
    Navigator.pop(context);
  }

  deleteProfileImage(context) {
    setState(() {
      delete = true;
      _imageExists = false;
    });
    Navigator.pop(context);
  }

  Future<String> uploadImage(File image) async {
    FirebaseStorage _storage = FirebaseStorage.instance;
    StorageReference reference = _storage.ref().child("user/$_uid/");
    StorageUploadTask uploadTask = reference.putFile(image);
    String downloadUrl =
        await (await uploadTask.onComplete).ref.getDownloadURL();
    // print('img location $downloadUrl');
    return downloadUrl;
  }

  Future<void> deleteCheck() async {
    // print("image Deleting");
    FirebaseStorage _storage = FirebaseStorage.instance;
    StorageReference reference =
        _storage.ref().child("user/$_uid/${_userData["image"]}");
    var deleteTask = reference.delete().catchError((e) {
      // print("Cannot Delete Image");
    });
    deleteTask.then((val) {
      // print("deleted");
    });
    // print("image Deleted");
  }

  void _showBottomSheet(context) {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new ListTile(
                leading: new Icon(Icons.image),
                title: new Text('Gallery'),
                onTap: () => getImageGallery(context),
              ),
              new ListTile(
                leading: new Icon(Icons.camera),
                title: new Text('Camera'),
                onTap: () => getImage(context),
              ),
              delete
                  ? Container()
                  : new ListTile(
                      leading: new Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      title: new Text(
                        'Delete',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                      onTap: () => deleteProfileImage(context),
                    ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // double cHeight = MediaQuery.of(context).size.height;
    // double c.cWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      backgroundColor:
          c.theme == 0 ? Style.backgreyColor : Style.backInvertGreyColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          calender.uid != null ? 'Profile' : '',
          style: TextStyle(
            fontSize: 20,
            color: Style.primaryColor,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Style.primaryColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 8,
            ),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color:
                  c.theme == 0 ? Style.primaryColor : Style.invertPrimaryColor,
              onPressed: () {
                bool login = calender.uid == null ? true : false;

                calender.uid = null;
                return login
                    ? Navigator.of(context).pushNamedAndRemoveUntil(
                        '/loginPage',
                        (Route<dynamic> route) => false,
                      )
                    : FirebaseAuth.instance.signOut().then((action) {
                        print("action here si ");
                        Navigator.of(context)
                            .pushReplacementNamed('/calenderApp');
                      }).catchError((e) {
                        // print(e);
                      });
              },
              child: Text(
                calender.uid == null ? "LogIn / SignUp" : "LogOut",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: c.theme == 1
                      ? Style.primaryColor
                      : Style.invertPrimaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 0.25,
                  width: MediaQuery.of(context).size.width,
                  color: Style.secondaryColor,
                  child: Stack(
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Container(
                                width: calender.uid == null
                                    ? 0.0
                                    : c.cWidth * 0.09,
                              ),
                              CircleAvatar(
                                radius: 70,

                                // backgroundColor:  Color(0xff1a2e43),
                                child: _image == null
                                    ? _imageExists
                                        ? ClipOval(
                                            child: CachedNetworkImage(
                                              placeholder: (context, url) =>
                                                  // Image.asset(
                                                  //   "assets/searching.gif",
                                                  // ),
                                                  CircularProgressIndicator(),
                                              fadeInDuration: Duration(
                                                seconds: 3,
                                              ),
                                              imageUrl: _userData["image"],
                                              fit: BoxFit.cover,
                                              width: 170,
                                              height: 170,
                                            ),
                                            // FadeInImage.memoryNetwork(
                                            //   placeholder: kTransparentImage,
                                            //   image: _userData["image"],
                                            //   fit: BoxFit.cover,
                                            //   width: 170.0,
                                            //   height: 170.0,
                                            // ),
                                          )
                                        : Icon(
                                            Icons.person,
                                            size: 110,
                                            color: Style.secondaryColor,
                                          )
                                    : delete
                                        ? Container()
                                        : ClipOval(
                                            child: Image.file(
                                              _image,
                                              fit: BoxFit.cover,
                                              width: 170.0,
                                              height: 170.0,
                                            ),
                                          ),
                              ),
                              calender.uid == null
                                  ? Container()
                                  : IconButton(
                                      onPressed: () =>
                                          _showBottomSheet(context),
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                      ),
                                    ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: <Widget>[
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.06,
                                ),
                                Text(
                                  "Full Name",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    //     c.theme == 0 ? Style.subtitleColor : Style.invertSubtitleColor,
                                    fontFamily: "Poppins-Medium",
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: c.cWidth * 0.06,
                              ),
                              child: TextFormField(
                                enabled: calender.uid == null ? false : true,
                                controller: _nameController,
                                style: TextStyle(
                                  fontFamily: "Poppins-Medium",
                                  color: Style.secondaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.06,
                                ),
                                Text(
                                  "Phone Number",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: "Poppins-Medium",
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: c.cWidth * 0.06,
                              ),
                              child: TextFormField(
                                enabled: false,
                                controller: _phoneController,
                                keyboardType: TextInputType.numberWithOptions(),
                                style: TextStyle(
                                  fontFamily: "Poppins-Medium",
                                  color: Colors.grey,
                                ),
                                maxLength: 10,
                                decoration: InputDecoration(counterText: ""),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.08,
            width: MediaQuery.of(context).size.width * 0.5,
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              color: Style.secondaryColor,
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.white,
                      ),
                    )
                  : RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      color: Style.secondaryColor,
                      onPressed: () {
                        if (calender.uid == null) {
                          _phoneController.text = "Login to use";
                          _nameController.text = "Login to use";
                          return signInDialog(
                            context,
                            "Confirm",
                            "\nYou have to log in to edit Profile",
                          );
                        }
                        setState(() {
                          _isLoading = true;
                        });
                        if (_image != null) {
                          return uploadImage(_image).then((value) async {
                            await updateUser(value).then((val) {
                              errorDialog(context, "Success",
                                  "Profile successfully updated");
                              setState(() {
                                _isLoading = false;
                              });
                            }).catchError((e) {
                              errorDialog(context, "Try Again", e.toString());
                              setState(() {
                                _isLoading = false;
                              });
                            });
                            ;
                          }).catchError((e) {
                            errorDialog(context, "Try Again", e.toString());
                            setState(() {
                              _isLoading = false;
                            });
                          });
                        } else {
                          if (delete) {
                            return deleteCheck().then((val) async {
                              await updateUser(null).then((val) {
                                errorDialog(context, "Success",
                                    "Profile successfully updated");
                                setState(() {
                                  _isLoading = false;
                                });
                              }).catchError((e) {
                                errorDialog(context, "Try Again", e.toString());
                                setState(() {
                                  _isLoading = false;
                                });
                              });
                              ;
                            });
                          } else {
                            return updateUser(_userData["image"]).then((val) {
                              errorDialog(context, "Success",
                                  "Profile successfully updated");
                              setState(() {
                                _isLoading = false;
                              });
                            }).catchError((e) {
                              errorDialog(context, "Try Again", e.toString());
                              setState(() {
                                _isLoading = false;
                              });
                            });
                          }
                        }
                      },
                      // elevation: 10,
                      child: Text(
                        "Save",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontFamily: "Poppins-Medium",
                        ),
                      ),
                    ),
            ),
          ),
          SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }
}
