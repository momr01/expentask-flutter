import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:payments_management/constants/global_variables.dart';
import 'package:rive/rive.dart' hide Image;

class DefaultScreen extends StatelessWidget {
  const DefaultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalVariables.secondaryColor,
      body: Stack(
        children: [
          Positioned(
            width: MediaQuery.of(context).size.width * 1.7,
            left: 100,
            bottom: 100,
            child: Image.asset(
              "assets/images/Spline.png",
            ),
          ),
          //blur delante de animacion
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: const SizedBox(),
            ),
          ),
          const RiveAnimation.asset(
            "assets/images/riveAssets/shapes.riv",
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: const SizedBox(),
            ),
          ),
          AnimatedPositioned(
            top: 0,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            duration: const Duration(milliseconds: 260),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    Image.asset(
                      "assets/images/expentask-logo-color.png",
                      width: 100,
                    ),
                    const SizedBox(
                      width: 260,
                      child: Column(
                        children: [
                          Text(
                            "Pay \nyour Dues",
                            style: TextStyle(
                                fontSize: 70,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Poppins",
                                height: 1.2,
                                color: GlobalVariables.primaryColor),
                          ),
                          SizedBox(height: 16),
                          Text(
                            "Manage your money in the easiest way.",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(flex: 2),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Text(
                        "2024. MOMR. All rights reserved.",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
