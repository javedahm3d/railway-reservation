import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:railways/pages/mybookings.dart';
import 'package:razorpay_web/razorpay_web.dart';

import '../components/show_message.dart';

class PaymentPage extends StatefulWidget {
  final snap;

  final amount;
  final List<String> passengers;
  final List<int> age;
  final List<String> gender;
  final int fromIndex;
  final int toIndex;
  final originalVlaueOfJ;

  const PaymentPage(
      {super.key,
      required this.amount,
      required this.passengers,
      required this.age,
      required this.snap,
      required this.gender,
      required this.fromIndex,
      required this.toIndex,
      this.originalVlaueOfJ});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  Razorpay? _razorpay;
  List<double> amounts = [];
  double totalAmout = 0;

  //for seat allocation logic build
  List<int> allocatedSeats = [];
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  calcAmount() {
    for (int i = 0; i < widget.passengers.length; i++) {
      if (widget.age[i] < 60) {
        amounts.add(widget.amount);
      } else {
        amounts.add(widget.amount - widget.amount * 0.4);
        widget.passengers[i] = widget.passengers[i] + '(Senior Citizen)';
      }
    }

    setState(() {
      totalAmout = amounts.reduce((a, b) => a + b);
    });
  }

  @override
  void initState() {
    super.initState();
    calcAmount();
    _razorpay = Razorpay();
    _razorpay?.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay?.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay?.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay?.clear();
  }

  void openChecF() async {
    var options = {
      'key': 'rzp_test_CRhj5dmYsc5cKJ',
      'amount': totalAmout * 100,
      'name': 'EasyRail',
      'description': 'Payment',
      'prefill': {'contact': '+91-9834604926', 'email': 'customer@easypay.com'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay?.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print('success');
    print(response.paymentId);

    bookingSeatAllocationLogic();
    savebookingDetails(response.paymentId.toString());

    Fluttertoast.showToast(
        msg: "SUCCESS PAYMENT: ${response.paymentId}", timeInSecForIosWeb: 4);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('error');

    firebaseFirestore
        .collection('trains')
        .doc(widget.snap['id'])
        .update({'Jiteration': widget.originalVlaueOfJ});

    Fluttertoast.showToast(
        msg: "ERROR HERE: ${response.code} - ${response.message}",
        timeInSecForIosWeb: 4);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET IS : ${response.walletName}",
        timeInSecForIosWeb: 4);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('lib/images/doodle_bg1.png'),
              fit: BoxFit.fitWidth)),
      child: Column(
        children: [
          const SizedBox(height: 16.0),
          Center(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 500, vertical: 20),
              child: Card(
                elevation: 15,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.8,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: <Widget>[
                        Card(
                            child: Container(
                          width: 180,
                          height: 150,
                          decoration: BoxDecoration(
                              color: Colors.orangeAccent,
                              borderRadius: BorderRadius.circular(30)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('INR $totalAmout',
                                  style: TextStyle(
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue.shade900)),
                              const SizedBox(height: 10.0),
                              const Text('Total amount',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 136, 136, 136),
                                      fontSize: 20.0)),
                            ],
                          ),
                        )),

                        SizedBox(
                          height: 40,
                        ),

                        Text(
                          'passenger details',
                          style: TextStyle(
                              fontSize: 21,
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w700),
                        ),

                        SizedBox(
                          height: 5,
                        ),

                        Divider(),

                        //passengers list
                        Container(
                          child: Expanded(
                              child: ListView.builder(
                            itemCount: widget.passengers.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 140),
                                    child: ListTile(
                                      title: Text(
                                          widget.passengers[index].toString()),
                                      trailing: Text(
                                        '₹${amounts[index]}',
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey.shade800),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          )),
                        ),
                        Divider(),
                        SizedBox(
                          height: 10,
                        ),

                        //pay button
                        InkWell(
                          onTap: () {
                            openChecF();
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Container(
                              width: double.infinity,
                              height: 50.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25.0),
                                color: Colors.blue.shade900,
                              ),
                              child: Center(
                                child: Text(
                                  'Pay',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
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
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 18.0),
        ],
      ),
    ));
  }

  bookingSeatAllocationLogic() {
    print(widget.snap['stations'].length);
    int buggieCount = widget.snap['stations'].length;
    List<List<List<int>>> stationsMatrix = [];
    int j = 0;
    int selected_buggie = 0;

    // for (int a = widget.fromIndex;
    //     a < widget.snap['stations'].length - 1;
    //     a++) {
    List<List<dynamic>> matrix = [];
    List<int> commonSeats = [];

    for (int i = widget.fromIndex; i < widget.toIndex; i++) {
      matrix.add(widget.snap['station seats availablity']
          ["${widget.snap['stations'][i]}"]);
    }

    commonSeats = getCommonSeats(matrix);
    matrix = [];

    for (int i = 0; i < widget.snap['coaches']; i++) {
      List<int> row = [];
      // print('$i\n');

      while (j < commonSeats.length) {
        if (commonSeats[j] <= widget.snap['seats per couche'] * (i + 1)) {
          row.add(commonSeats[j]);
          j++;
        } else {
          break;
        }
      }
      matrix.add(row);
    }

    print(matrix);

    int k = widget.passengers.length;

    //  seat allocation algorithm

    while (allocatedSeats.length < k) {
      if (widget.passengers.length > commonSeats.length) {
        ShowMessage().showMessage('seats unavailable', context);
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
          for (int i = 0; i < widget.passengers.length; i++) {
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

          while (i < widget.passengers.length
              // &&
              // l > 0 &&
              // h < matrix[selected_buggie].length
              ) {
            if (matrix[selected_buggie][l] % 2 != 0) {
              allocatedSeats.add(matrix[selected_buggie][l]);
              i++;

              if (i >= widget.passengers.length) {
                break;
              }
            }
            if (matrix[selected_buggie][h] % 2 != 0) {
              allocatedSeats.add(matrix[selected_buggie][h]);

              i++;
              if (i >= widget.passengers.length) {
                break;
              }
            }
            if (l > 0) {
              l--;
            }
            if (h < matrix[selected_buggie].length) {
              h++;
            }
          }

          print(matrix);
        }
      }
    }

    print('allocated seats: $allocatedSeats');

    // print('new matrix : $newArray');
    Map newMap = widget.snap['station seats availablity'];

    for (int i = widget.fromIndex; i < widget.toIndex; i++) {
      for (int j = 0; j < allocatedSeats.length; j++) {
        newMap[widget.snap['stations'][i]].remove(allocatedSeats[j]);
      }
    }

    print('New Map :  $newMap');

    firebaseFirestore.collection('trains').doc(widget.snap['id']).update({
      'station seats availablity': newMap,
      'iteration': widget.snap['iteration'] + 1
    });

    return;
  }

  // buggie with highest available seats
  int BuggiewithHighestSeats(List<List<dynamic>> matrix) {
    List<int> seatsAvailable = [];
    for (int i = 0; i < matrix.length; i++) {
      seatsAvailable.add(matrix[i].length);
    }
    int highestNumber = seatsAvailable.reduce(
        (currentMax, element) => currentMax > element ? currentMax : element);
    return seatsAvailable.indexOf(highestNumber);
  }

// function to select common seats in between stations
  List<int> getCommonSeats(List<List<dynamic>> matrix) {
    if (matrix.isEmpty) {
      return [];
    }
    Set<int> commonSeats = Set.from(matrix.first);

    for (var i = 1; i < matrix.length; i++) {
      Set<int> currentSet = Set.from(matrix[i]);

      commonSeats = commonSeats.intersection(currentSet);
    }

    return commonSeats.toList();
  }

//saving data in firebase
  savebookingDetails(String transactionId) async {
    print('controll is in savebookingDetails');
    List<String> passengers = [];
    List<String> TransactionId = [];
    List<int> age = [];
    List<String> gender = [];
    List<int> seats = [];

    var snapshot = await firebaseFirestore
        .collection('trains')
        .doc(widget.snap['id'])
        .collection('bookings')
        .doc('bookings')
        .get();

    print(snapshot);

    if (snapshot.exists) {
      print('control has snap data');

      // Check if the snapshot exists and has data before accessing it
      var data = snapshot.data();

      setState(() {
        try {
          passengers = data!['passenger'] ?? [];
          age = data['age'] ?? [];
          gender = data['gender'] ?? [];
          TransactionId = data['TransactionId'] ?? '';
          seats = data['seats'] ?? [];
        } catch (e) {
          print(e);
        }
      });

      setState(() {
        passengers = passengers + widget.passengers;
        TransactionId = TransactionId + [transactionId];
        age = age + widget.age;
        gender = gender + widget.gender;
        seats = seats + allocatedSeats;
      });

      print(passengers);
      print(transactionId);
      print(age);
      print(gender);
      print(seats);

      //stroring in the trains database

      await firebaseFirestore
          .collection('trains')
          .doc(widget.snap['id'])
          .collection('bookings')
          .doc(widget.snap['stations'][widget.fromIndex])
          .update({
        'TransactionId': TransactionId,
        'passenger': passengers,
        'age': age,
        'seats': seats,
      });
    } else {
      print('control no snap data');
      // Handle the case when the document doesn't exist or has no data

      //storing in the trains database
      await firebaseFirestore
          .collection('trains')
          .doc(widget.snap['id'])
          .collection('bookings')
          .doc(widget.snap['stations'][widget.fromIndex])
          .set({
        'TransactionId': [transactionId],
        'passenger': widget.passengers,
        'age': widget.age,
        'seats': allocatedSeats,
      });
    }

    //storing it for user
    await firebaseFirestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('bookings')
        .doc(transactionId)
        .set({
      'TrainId': widget.snap['id'],
      'TransactionId': transactionId,
      'amount': totalAmout,
      'individual amount': amounts,
      'passenger': widget.passengers,
      'age': widget.age,
      'seats': allocatedSeats,
      'from station index': widget.fromIndex,
      'to station index': widget.toIndex
    });

    Navigator.of(context)
      ..pop()
      ..pop()
      ..pop();
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => MyBookingsPage(),
    ));
  }
}
