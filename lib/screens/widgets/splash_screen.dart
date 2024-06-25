import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:students_app_provider/constant/color.dart';
import 'package:students_app_provider/provider/splash_p.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<SplashProvider>(context, listen: false).goToLogin(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'STUDENTS DETAILS',
              style: GoogleFonts.montserrat(
                  color: color1, fontSize: 26, fontWeight: FontWeight.bold),
            ),
            Lottie.asset(
              'Assets/Animation - 1719149331300.json',
              width: 320,
              height: 320,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }
}
