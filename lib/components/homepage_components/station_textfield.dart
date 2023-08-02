import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StationTextField extends StatelessWidget {
  final controller;
  final String hintText;

  const StationTextField({
    super.key,
    required this.controller,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        width: 300,
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(width: 1, color: Colors.grey.shade500)),
        child: ListTile(
          leading: Icon(
            Icons.train,
            color: Colors.grey,
          ),
          title: TextField(
            controller: controller,
            style: TextStyle(color: Colors.grey.shade400),
            decoration: InputDecoration(
              border: InputBorder.none,
              filled: true,
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey[500]),
            ),
          ),
          trailing: InkWell(
            onTap: () {},
            child: Icon(CupertinoIcons.xmark),
          ),
        ),
      ),
    );
  }
}
