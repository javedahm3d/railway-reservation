import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 80,
      backgroundColor: Colors.white,
      title: Row(
        children: [
          //app logo
          Icon(
            Icons.train,
            size: 40,
            color: Colors.orange,
          ),

          Text(
            'EasyRail',
            style: GoogleFonts.aBeeZee(
                fontWeight: FontWeight.bold, fontSize: 30, color: Colors.black),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Center(
            child: InkWell(
              onTap: () {},
              child: Text('my bookings',
                  style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.black)),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Center(
            child: InkWell(
              onTap: () async {
                await FirebaseAuth.instance.signOut();
              },
              child: Text('logout',
                  style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.black)),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Center(
            child: InkWell(
              onTap: () {},
              child: Text('admin login',
                  style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.black)),
            ),
          ),
        )
      ],
    );
  }
}
