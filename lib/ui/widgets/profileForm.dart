import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lovely/repositories/userRepository.dart';
import 'package:lovely/ui/widgets/gender.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileForm extends StatefulWidget {
  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? gender;
  String? interestedIn;
  // DateTime age = DateTime(1999);
  File? photo;
  String? age;
  String? birthay;
  String umsVerifyInfo = 'Not Verified';

  @override
  void initState() {
    umsVerifyname();
    super.initState();
  }

  void umsVerifyname() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('UmsVerifyName') != null) {
      setState(() {
        umsVerifyInfo = prefs.getString('UmsVerifyName')!.toString();
      });
    } else {
      print(prefs.getString('UmsVerifyName').toString());
      setState(() {
        umsVerifyInfo = 'Not Verifed';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userRepository = Provider.of<UserRepository>(context);
    Size size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Form(
        key: _formKey,
        child: Container(
          width: size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(shape: BoxShape.circle),
                child: CircleAvatar(
                  radius: size.width * 0.2,
                  child: GestureDetector(
                    onTap: () async {
                      XFile? getPic = await ImagePicker().pickImage(
                        source: ImageSource.gallery,
                        maxHeight: 1000,
                        maxWidth: 1000,
                      );
                      if (getPic != null) {
                        setState(() {
                          photo = File(getPic.path);
                        });
                      }
                    },
                    child: Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: size.width * 0.5,
                            backgroundImage: photo == null
                                ? AssetImage('avatar.png') as ImageProvider
                                : FileImage(photo!),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 4,
                            child: Icon(
                              Icons.image,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextFormField(
                  controller: _nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 3) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.always,
                  decoration: InputDecoration(
                      labelText: 'Your Lovely App Name',
                      labelStyle: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                      ),
                      focusedBorder: UnderlineInputBorder()),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.pink[800]!,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Center(
                          child: Text('Ums Verification Details : ',
                              style: TextStyle(fontSize: 10)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Center(
                          child: Text(
                            umsVerifyInfo.toString(),
                            style: TextStyle(fontSize: 20),
                            maxLines: 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: ElevatedButton(
                  onPressed: () {
                    DatePicker.showDatePicker(context,
                        theme: DatePickerTheme(
                          containerHeight: 210.0,
                        ),
                        showTitleActions: true,
                        minTime: DateTime(1980, 1, 1),
                        maxTime: DateTime(2003, 3, 9), onConfirm: (date) {
                      print('confirm $date');
                      age = '${date.year} ';
                      print('age is {$age}');
                      setState(() {});
                    }, currentTime: DateTime.now(), locale: LocaleType.en);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 50.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.date_range,
                                    size: 18.0,
                                  ),
                                  Text(
                                    age ?? 'Click to enter birthday',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Text(
                          " Change",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Card(
                  elevation: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: size.height * 0.02),
                        child: Text(
                          "You Are",
                          style: TextStyle(fontSize: size.width * 0.09),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          genderWidget(
                              FontAwesomeIcons.venus, "Female", size, gender,
                              () {
                            setState(() {
                              gender = "Female";
                            });
                          }),
                          genderWidget(
                              FontAwesomeIcons.mars, "Male", size, gender, () {
                            setState(() {
                              gender = "Male";
                            });
                          }),
                          genderWidget(
                            FontAwesomeIcons.transgender,
                            "Transgender",
                            size,
                            gender,
                            () {
                              setState(
                                () {
                                  gender = "Transgender";
                                },
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: size.height * 0.02),
                        child: Text(
                          "Looking For",
                          style: TextStyle(fontSize: size.width * 0.09),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          genderWidget(FontAwesomeIcons.venus, "Female", size,
                              interestedIn, () {
                            setState(() {
                              interestedIn = "Female";
                            });
                          }),
                          genderWidget(
                              FontAwesomeIcons.mars, "Male", size, interestedIn,
                              () {
                            setState(() {
                              interestedIn = "Male";
                            });
                          }),
                          genderWidget(
                            FontAwesomeIcons.transgender,
                            "Transgender",
                            size,
                            interestedIn,
                            () {
                              setState(
                                () {
                                  interestedIn = "Transgender";
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextFormField(
                  maxLines: 3,
                  controller: _aboutController,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.length > 70 ||
                        value.length < 5) {
                      return 'Please enter about yourself in less than 70 words' +
                          '\n' +
                          'and more than 5 words.';
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.always,
                  decoration: InputDecoration(
                      labelText: 'About You',
                      labelStyle: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                      ),
                      focusedBorder: UnderlineInputBorder()),
                ),
              ),
              userRepository.status == Status.Authenticating
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(10),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if (gender != null) {
                              if (age != null) {
                                if (photo != null) {
                                  if (await userRepository.profileSetup(
                                      age: age!,
                                      gender: gender!,
                                      interestedIn: interestedIn!,
                                      name: _nameController.text,
                                      photo: photo!,
                                      userId: userRepository.getUser(),
                                      about: _aboutController.text,
                                      umsVerifyInfo: umsVerifyInfo)) {
                                  } else {
                                    ScaffoldMessenger.of(context)
                                      ..hideCurrentSnackBar()
                                      ..showSnackBar(
                                          SnackBar(content: Text('Failed')));
                                  }
                                } else {
                                  ScaffoldMessenger.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(SnackBar(
                                        content:
                                            Text('Please enter your Photo')));
                                }
                              } else {
                                ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(SnackBar(
                                      content: Text(
                                          'Please enter your Birthaday ! ')));
                              }
                            } else {
                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(SnackBar(
                                    content: Text('Please enter your gender')));
                            }
                          } else {
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(SnackBar(
                                  content: Text(
                                      'Please enter your Lovely Name and about ')));
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(),
                          child: Center(
                            child: Text(
                              'Save',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat'),
                            ),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
