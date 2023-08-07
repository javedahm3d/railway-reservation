import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:railways/components/my_appbar.dart';
import 'package:railways/components/show_message.dart';
import 'package:railways/services/payment.dart';

class PassengerAndContactDeatilsPage extends StatefulWidget {
  final snap;
  final int fromIndex;
  final int toIndex;
  const PassengerAndContactDeatilsPage(
      {super.key,
      required this.snap,
      required this.fromIndex,
      required this.toIndex});

  @override
  _PassengerAndContactDeatilsPageState createState() =>
      _PassengerAndContactDeatilsPageState();
}

class _PassengerAndContactDeatilsPageState
    extends State<PassengerAndContactDeatilsPage> {
  // int scheduleId = 0;
  // String trainId = '';
  List<String> passengerList = [];
  List<int> age = [];
  List<String> gender = [];
  List<int> allocatedSeats = [];
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  int origialJvalue = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    origialJvalue = widget.snap['Jiteration'];
  }

  void addDetails() {
    setState(() {
      passengerList.add('');
      age.add(0);
      gender.add('');
    });
  }

  removeDetails(int index) {
    setState(() {
      passengerList.removeAt(index);
      age.removeAt(index);
      gender.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(221, 209, 225, 238),
      appBar: MyAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 10),
          child: Column(
            children: [
              //add passenger details container
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 16),
                    Text(
                      'Passengers detail',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: passengerList.length,
                          itemBuilder: (context, index) {
                            int num = index + 1;
                            return Card(
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      SizedBox(width: 15),
                                      Expanded(
                                        child: TextField(
                                          decoration: InputDecoration(
                                              labelText:
                                                  'Passenger Name ${index + 1}'),
                                          onChanged: (value) {
                                            setState(() {
                                              passengerList[index] = value;
                                            });
                                          },
                                        ),
                                      ),
                                      SizedBox(width: 60),
                                      Expanded(
                                        child: TextField(
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          decoration:
                                              InputDecoration(labelText: 'Age'),
                                          onChanged: (value) {
                                            setState(() {
                                              age[index] = int.parse(value);
                                            });
                                          },
                                        ),
                                      ),
                                      SizedBox(width: 60),
                                      Expanded(
                                        child: TextField(
                                          // autofillHints: <String>['male', 'female'],

                                          decoration: InputDecoration(
                                              labelText: 'Gender'),
                                          onChanged: (value) {
                                            setState(() {
                                              gender[index] = value;
                                            });
                                          },
                                        ),
                                      ),
                                      SizedBox(width: 15),
                                      IconButton(
                                          onPressed: () {
                                            removeDetails(index);
                                          },
                                          icon:
                                              Icon(CupertinoIcons.xmark_circle))
                                    ],
                                  )),
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: addDetails,
                      child: Container(
                          width: 120,
                          height: 45,
                          child: Row(
                            children: [
                              Icon(CupertinoIcons.add_circled_solid),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: Text('Add Traveller'),
                              )
                            ],
                          )),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),

              SizedBox(
                height: 30,
              ),

              //add contact details container
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Contact Information',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextField(
                          controller: phoneController,
                          decoration:
                              InputDecoration(labelText: 'phone number'),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                        ),
                        TextField(
                          controller: emailController,
                          decoration: InputDecoration(labelText: 'Email Id'),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 0)
                              .copyWith(top: 30),
                          child: Text(
                            'your ticket will be sent on this email id',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey.shade600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              //submit button
              InkWell(
                onTap: () {
                  if (passengerList.isEmpty) {
                    ShowMessage().showMessage(
                        'Please add atleast one passenger', context);
                  } else {
                    if (emailController.text.isEmpty) {
                      ShowMessage()
                          .showMessage('Please enter your email id', context);
                    } else if (!EmailValidator.validate(
                        emailController.text, true)) {
                      ShowMessage().showMessage(
                          'Please enter a valid email id', context);
                    } else {
                      double amount = widget.snap['fair'] *
                          (widget.snap['distance'][widget.toIndex] -
                              widget.snap['distance'][widget.fromIndex]);

                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PaymentPage(
                            amount: amount,
                            passengers: passengerList,
                            age: age,
                            snap: widget.snap,
                            gender: gender,
                            fromIndex: widget.fromIndex,
                            toIndex: widget.toIndex),
                      ));
                    }
                  }

                  // bookticketlogic();
                },
                child: Container(
                  width: 400,
                  height: 60,
                  decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(20)),
                  child: Center(
                    child: Text(
                      'Book Ticket',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
