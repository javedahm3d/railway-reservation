import 'package:flutter/material.dart';

trainListInfoCard(String title, String number) {
  return Card(
    child: Container(
      width: 130,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Center(
                child: Text(
              title,
              style: TextStyle(color: Colors.grey.shade500),
              textAlign: TextAlign.center,
            )),
          ),
          Spacer(),
          Center(
              child: Text(number,
                  style: TextStyle(fontSize: 30, color: Colors.grey.shade700))),
        ],
      ),
    ),
  );
}
