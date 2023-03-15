import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(10),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.shade200,
                        spreadRadius: 5,
                        offset: const Offset(5, 5),
                        blurRadius: 10,
                      )
                    ],
                  ),
                  child: const Text(
                    "About Information",
                    style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        letterSpacing: 2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DottedBorder(
                    color: Colors.orange,
                    strokeWidth: 2,
                    dashPattern: [12, 2],
                    radius: const Radius.circular(10),
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(12),
                      child: const Text(
                        textAlign: TextAlign.justify,
                        "Garage Parking And Parking Tracking lets you easily find and pay for parking using our free app or online for spaces across the country. You can find us anywhere you park your car.",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    "Developer Information:",
                    style: TextStyle(
                        color: Colors.green,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40.0, right: 40),
                  child: Divider(
                    color: Colors.orange.shade200,
                    thickness: 3,
                  ),
                ),
                _devInfo("Mufizul Islam", "191002086",'asset/image/Mufizul.jpg'),
                const Padding(
                  padding: EdgeInsets.only(left: 40.0, right: 40),
                  child: Divider(),
                ),
                _devInfo("Md. Touhidul Islam", "191002314",'asset/image/tohidul.jpeg'),
                const Padding(
                  padding: EdgeInsets.only(left: 40.0, right: 40),
                  child: Divider(),
                ),
                _devInfo("Md. Habibur Rahman", "182002117",'asset/image/habibor.jpg'),
                const Padding(
                  padding: EdgeInsets.only(left: 40.0, right: 40),
                  child: Divider(),
                ),
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    "Green University Of Bangladesh",
                    style: TextStyle(
                        color: Colors.green,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                   ),
                  ),
                ),
                   const Text(
                    "Department Of CSE",
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                SizedBox(height: 20)

              ],
            ),
          ],
        ),
      ),
    );
  }

  Padding _devInfo(String name, String id,String url) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
               Container(
                height: 80,width: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  image: DecorationImage(image: AssetImage(url),fit: BoxFit.fitHeight)
                ),
              ),
              SizedBox(height: 10),
              Text(
                "$name",
                style: GoogleFonts.libreBaskerville(fontSize: 20,color: Colors.orange),
              ),
              SizedBox(height: 5),
              Text(
                "ID : $id",
                style: GoogleFonts.karla(fontSize: 16,color: Colors.orange),
              ),
            ],
          )
        ],
      ),
    );
  }
}
