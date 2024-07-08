import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Column(
              children: [
        Text("Welcome to Applications"),
        Text("This Application Vpn Free"),
              ],
            ),
      ),
    );
  }
}
