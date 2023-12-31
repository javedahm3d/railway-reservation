import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:railways/admin_pages/admin_homepage.dart';
import 'package:railways/login/login_or_register.dart';
import 'package:railways/pages/homepage.dart';
import 'package:railways/pages/mybookings.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 80,
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.black),
      title: Row(
        children: [
          //app logo
          Icon(
            Icons.train,
            size: 40,
            color: Colors.orange,
          ),

          InkWell(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => HomePage(),
            )),
            child: Text(
              'EasyRail',
              style: GoogleFonts.aBeeZee(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Colors.black),
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Center(
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => MyBookingsPage(),
                ));
              },
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
        FirebaseAuth.instance.currentUser!.uid == "Jzbfb9HkJ4YeRGSGNX5VVu9y3Sz1"
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Center(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AdminHomePage(),
                      ));
                    },
                    child: Text('admin page',
                        style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.black)),
                  ),
                ),
              )
            : Container()
      ],
    );
  }
}
