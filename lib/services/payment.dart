import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
    //print(widget.snap['stations'].length);
    int buggieCount = widget.snap['stations'].length;
    List<List<List<int>>> stationsMatrix = [];
    int j = 0;
    int selected_buggie = 0;

    // for (int a = widget.fromIndex;
    //     a < widget.snap['stations'].length - 1;
    //     a++) {

    // matrix stores the available ticket nos of all coaches in a train between From and To
    List<List<int>> matrix = [];
    String fromStation = "${widget.snap['stations'][widget.fromIndex]}";
    String toStation = "${widget.snap['stations'][widget.toIndex]}";
    int seatsPerCoach = widget.snap['seats per couche'];
    int count_passengers = widget.passengers.length;

    for (int i = widget.fromIndex; i < widget.toIndex; i++) {
      //stationName will iterate over all stations from source to destination
      String stationName = widget.snap['stations'][i];
      List<int> seats = widget.snap['station seats availablity'][stationName];
      //store all such ticket nos in a matrix
      matrix.add(seats);
    }

    //find common ticket nos among all the stations
    //this will return the available seats
    List<int> available_seats = findCommonElements(matrix);
    print("Available seats:${available_seats.length}\n");
    print(available_seats);

    if (count_passengers > available_seats.length) {
      ShowMessage().showMessage('max seat limit has reached', context);
      return;
    }

    List<int> levelOrderTraversal = getLevelOrderTraversal(buggieCount);
    List<List<int>> availableSeatsByCoach =
        List.generate(buggieCount, (_) => []);

    //split linear seats into seats in each coach
    for (int i = 0; i <= available_seats.length - 1; i++) {
      int index = (available_seats[i] - 1) ~/ seatsPerCoach;
      availableSeatsByCoach[index].add(available_seats[i]);
    }

    print("Available seats by coach:");
    print(availableSeatsByCoach);

    //go level order traversal to find the coach with the highest availability
    int k =
        count_passengers; //denotes how many passengers are left to be booked
    while (k > 0) {
      int coachIndex = findMeCoach(availableSeatsByCoach, buggieCount);
      List<int> bookedSeats =
          bookSeatsInCoach(availableSeatsByCoach[coachIndex], k);

      //update availableSeatsByCoach
      for (int i = 0; i < bookedSeats.length; i++) {
        availableSeatsByCoach[coachIndex].remove(bookedSeats[i]);
        //add to allocate
        allocatedSeats.add(coachIndex * seatsPerCoach + bookedSeats[i]);
      }

      if (bookedSeats.isEmpty == true) {
        //error message as seats could not be booked
        print("Seat could not be allocated for $k passengers\n");
        break;
      } else if (bookedSeats.length == k) //all seats are booked
        break;
      else {
        k = k - bookedSeats.length;
      }
    }

    ///////////////////////////
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

    widget.passengers.length;

    if (widget.passengers.length >
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

        while (i < widget.passengers.length &&
            l > 0 &&
            h < matrix[selected_buggie].length) {
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

  savebookingDetails(String transactionId) async {
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

    setState(() {
      passengers = snapshot.data()!['passenger'];
      age = snapshot.data()!['age'];
      gender = snapshot.data()!['gender'];
      TransactionId = snapshot.data()!['TransactionId'];
      seats = snapshot.data()!['seats'];
    });

    passengers = passengers + widget.passengers;
    TransactionId = TransactionId + [transactionId];
    age = age + widget.age;
    gender = gender + widget.gender;
    seats = seats + allocatedSeats;

//stroring in the trains database

    await firebaseFirestore
        .collection('users')
        .doc(widget.snap['id'])
        .collection('bookings')
        .doc('bookings')
        .update({
      'TransactionId': TransactionId,
      'passenger': widget.snap[''],
      'age': widget.age,
      'seats': allocatedSeats,
    });

    //storing it for user

    await firebaseFirestore
        .collection('trains')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('my bookings')
        .doc(widget.snap['id'])
        .set({
      'TransactionId': transactionId,
      'passenger': widget.passengers,
      'age': widget.age,
      'seats': allocatedSeats,
    });
  }
}

List<int> findCommonElements(List<List<int>> listOfLists) {
  if (listOfLists.isEmpty) {
    return [];
  }

  Set<int> commonElements = listOfLists.first.toSet();

  for (var list in listOfLists) {
    commonElements = commonElements.intersection(list.toSet());
  }

  return commonElements.toList();
}

List<int> getLevelOrderTraversal(int N) {
  int start = 0;
  int end = N - 1;
  if (end < 0 || start > end) {
    return <int>[];
  }

  List<int> result = [];
  List<List<int>> queue = [];
  queue.add([start, end]);

  while (queue.isNotEmpty) {
    List<int> pair = queue.removeAt(0);
    int a = pair[0];
    int b = pair[1];
    int mid = (b + a) ~/ 2;

    if (a <= b) {
      result.add(mid);
      queue.add([a, mid - 1]); // insert left child
      queue.add([mid + 1, b]); // insert right child
    }
  }

  return result;
}

int findMeCoach(List<List<int>> availableSeatsByCoach, int buggieCount) {
  List<int> levelOrderTraversal = getLevelOrderTraversal(buggieCount);
  int highest = 0;
  for (int i = 1; i < buggieCount; i++) {
    if (availableSeatsByCoach[levelOrderTraversal[highest]].length <
        availableSeatsByCoach[levelOrderTraversal[i]].length) {
      highest = i;
    }
  }
  return levelOrderTraversal[highest];
}

List<int> bookSeatsInCoach(List<int> listSeats, int k) {
  List<int> bookedSeats = [];
  List<int> oddList = [];
  List<int> evenList = [];
  int l = k;

  for (int i = 0; i < listSeats.length; i++) {
    if (listSeats[i] % 2 == 0)
      evenList.add(listSeats[i]);
    else
      oddList.add(listSeats[i]);
  }
  //check if any odd seats available
  if (l <= oddList.length) {
    //pop k elements from odd,listSeats
    //add to booked seats
  } else {
    //pop all odd from odd,listSeats
    //pop k - odd from even,ListSeats
    //if even
  }

  return bookedSeats;
}
