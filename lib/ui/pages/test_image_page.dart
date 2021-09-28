import 'package:flutter/material.dart';
import 'package:hantong_cal/main.dart';

class ImagePage extends StatefulWidget {
  @override
  _ImagePageState createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        //color: Colors.black,

        child: SizedBox(
          height: 300,
          width: 200,
          child: Container(
            //decoration: BoxDecoration(
            //  color: Colors.red.shade100.withOpacity(0.2),
            //),
            color: Colors.yellow,
            child:
              Image.asset(
                "assets/img/cat.jpg",
//                height: 10.0,
//                width: 10.0,
                fit: BoxFit.contain,
                //color: Colors.pink,
                //colorBlendMode: BlendMode.overlay,
                  //fit: BoxFit.cover,
//                  color: Colors.black87,
//                  colorBlendMode: BlendMode.darken,
            )
            //Image.asset('assets/img/cat.jpg', color: Colors.pink, colorBlendMode: BlendMode.luminosity,),

          ),
        ),
      )
    );

//    return Scaffold(
//      backgroundColor: Colors.black,
//      body: Stack(
//        fit: StackFit.expand,
//        children: <Widget>[
//          Image(
//            image: AssetImage("assets/img/cat.jpg"),
//            //fit: BoxFit.cover,
//            color: Colors.red,
//            colorBlendMode: BlendMode.darken,
//          )
//        ],
//      ),
//    );
  }
}
