import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:railways/components/my_appbar.dart';
import 'package:railways/components/show_message.dart';

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
                  // if (passengerList.isEmpty) {
                  //   ShowMessage().showMessage(
                  //       'Please add atleast one passenger', context);
                  // } else {
                  //   if (emailController.text.isEmpty) {
                  //     ShowMessage()
                  //         .showMessage('Please enter your email id', context);
                  //   }
                  //   if (!EmailValidator.validate(emailController.text, true)) {
                  //     ShowMessage().showMessage(
                  //         'Please enter a valid email id', context);
                  //   }
                  // }

                  bookticketlogic();
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

//booking logic

  bookticketlogic() {
    print(widget.snap['stations'].length);
    int buggieCount = widget.snap['stations'].length;
    List<List<List<int>>> stationsMatrix = [];
    int j = 0;
    int selected_buggie = 0;

    // for (int a = widget.fromIndex;
    //     a < widget.snap['stations'].length - 1;
    //     a++) {
    List<List<int>> matrix = [];

    for (int i = 0; i < widget.snap['coaches']; i++) {
      List<int> row = [];
      print('$i\n');

      while (j <
          widget
              .snap['station seats availablity']
                  ["${widget.snap['stations'][widget.fromIndex]}"]
              .length) {
        if (widget.snap['station seats availablity']
                ["${widget.snap['stations'][widget.fromIndex]}"][j] <=
            widget.snap['seats per couche'] * (i + 1)) {
          row.add(widget.snap['station seats availablity']
              ["${widget.snap['stations'][widget.fromIndex]}"][j]);
          j++;
        } else {
          break;
        }
      }
      matrix.add(row);
    }

    print(matrix);

    if (passengerList.length >
        widget
            .snap['station seats availablity']
                ["${widget.snap['stations'][widget.fromIndex]}"]
            .length) {
      ShowMessage().showMessage('max seat limit has reached', context);
    } else {
      //selecting buggie for the first time

      if (widget.snap['iteration'] < widget.snap['coaches']) {
        print('control is here');
        int mid = (widget.snap['coaches'] - 1) / 2;

        if (widget.snap['iteration'] < widget.snap['coaches']) {
          if (widget.snap['iteration'] == 0) {
            //allocate seat in middle buggie
            setState(() {
              selected_buggie = mid;
            });
          } else if (widget.snap['iteration'] % 2 == 0) {
            setState(() {
              selected_buggie =
                  mid - int.parse(widget.snap['Jiteration'].toString());
              firebaseFirestore
                  .collection('trains')
                  .doc(widget.snap['id'])
                  .update({'Jiteration': widget.snap['Jiteration'] - 1});
            });
          } else {
            setState(() {
              selected_buggie =
                  mid + int.parse(widget.snap['Jiteration'].toString());
            });
          }
        }
      } else {
        setState(() {
          selected_buggie = BuggiewithHighestSeats(matrix);
        });
      }

      print('selected buggie : $selected_buggie');

// if all lower birth are filled already
      if (matrix[selected_buggie].length <
          widget.snap['seats per couche'] / 2) {
        for (int i = 0; i < passengerList.length; i++) {
          print('my controller 1');
          int midRef = matrix[selected_buggie].length ~/ 2;

          allocatedSeats.add(matrix[selected_buggie][midRef]);
          // matrix[selected_buggie].removeAt(midRef);
        }
      }

//if lower birth are available
      else {
        print('my controller');
        int midRef = matrix[selected_buggie].length ~/ 2;
        int l = midRef - 1;
        int h = midRef + 1;
        int i = 0;

        if (matrix[selected_buggie][midRef] % 2 != 0) {
          allocatedSeats.add(matrix[selected_buggie][midRef]);
          i++;
        }

        while (i < passengerList.length &&
            l > 0 &&
            h < matrix[selected_buggie].length) {
          if (matrix[selected_buggie][l] % 2 != 0) {
            allocatedSeats.add(matrix[selected_buggie][l]);
            i++;
          }
          if (matrix[selected_buggie][h] % 2 != 0) {
            allocatedSeats.add(matrix[selected_buggie][h]);
            i++;
          }
          l--;
          h++;
        }

        print(matrix);
      }
    }

    List<int> newArray = matrix.expand((row) => row).toList();

    print('allocated seats: $allocatedSeats');

    for (int i = 0; i < allocatedSeats.length; i++) {
      newArray.remove(allocatedSeats[i]);
    }

    print('new matrix : $newArray');
    Map newMap = widget.snap['station seats availablity'];

    for (int i = widget.fromIndex; i < widget.toIndex; i++) {
      newMap[widget.snap['stations'][i]] = newArray;
    }

    print('New Map :  $newMap');

    firebaseFirestore.collection('trains').doc(widget.snap['id']).update({
      'station seats availablity': newMap,
      'iteration': widget.snap['iteration'] + 1
    });

    // firebaseFirestore
    //     .collection('trains')
    //     .doc(widget.snap['id'])
    //     .collection('bookings')
    //     .doc('bookings')
    //     .update({});
  }

  // buggie with highest available seats
  int BuggiewithHighestSeats(List<List<int>> matrix) {
    List<int> seatsAvailable = [];
    for (int i = 0; i < matrix.length; i++) {
      seatsAvailable.add(matrix[i].length);
    }
    int highestNumber = seatsAvailable.reduce(
        (currentMax, element) => currentMax > element ? currentMax : element);
    return seatsAvailable.indexOf(highestNumber);
  }
}
