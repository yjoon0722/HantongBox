// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

class ButtonPagae extends StatefulWidget {
  @override
  _ButtonPagaeState createState() => _ButtonPagaeState();
}

class _ButtonPagaeState extends State<ButtonPagae> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
              //color: Colors.black,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: CustomScrollView(
                      physics: BouncingScrollPhysics(),
                      slivers: <Widget>[
                        // 키 패드
                        SliverPadding(
                          padding: EdgeInsets.all(20.0),
                          sliver: SliverGrid(
                              delegate: SliverChildBuilderDelegate(
                                  _buildEventKeyPad, childCount: 18),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  childAspectRatio: 1.6,
                                  crossAxisSpacing: 10.0,
                                  mainAxisSpacing: 10.0)),
                        ),
                      ],
                    ),
                  ),
                ],
              )
          )
      ),
    );
  }


  // 이벤트 - 키패드
  Widget _buildEventKeyPad(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        print('onTap');
      },
      onLongPress: () {
        print('onLongPress');
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.green,
          border: Border.all(color: Colors.pink, width: 1),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        child: LayoutBuilder(builder: (context, constraints) {
          double width = constraints.maxWidth;
          double height = constraints.maxHeight;
          print('$constraints.minWidth : $constraints.maxWidth');
          print('$constraints.minHeight : $constraints.maxHeight');

          return Stack(
            //fit: StackFit.expand,
            alignment: Alignment.center,
            children: <Widget>[
              Positioned(
                top: 0,
                width: width * 0.8,
                height: height * 0.8,
                child: Container(
                  margin: EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    border: Border.all(color: Colors.pink, width: 1),
                    image: DecorationImage(
                      fit: BoxFit.fitWidth,
                      image:AssetImage('assets/img_btn/button_bg_abxy.png'),
                    ),
                  ),
                ),
              ),

              Positioned(
                left: 0,
                right: 0,
                bottom: 4,
                height: height * 0.25,
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.indigoAccent,
                      border: Border.all(color: Colors.pink, width: 1),
                    ),
                    child:
                    //Text('감자고구마'),
                    Text('감자고구마', textAlign: TextAlign.center,
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyText2,)
                ),
              )
            ],
          );
        }),
      ),
    );
  }

  // 키패드
  Widget _buildKeyPad(BuildContext context, int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green,
        border: Border.all(color: Colors.pink, width: 1),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),

/*
      foregroundDecoration: BoxDecoration(
        backgroundBlendMode: BlendMode.exclusion,
        gradient: LinearGradient(
          colors: const [Colors.red, Colors.blue],
        )
      ),
*/

/*
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
              decoration: BoxDecoration(color: Colors.blue, border: Border.all(color: Colors.pink, width: 1),),
              child: Image(image: AssetImage('assets/img_btn/button_bg_abxy.png'),
                fit: BoxFit.cover,),
            ),
            flex: 3,
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 4),
              decoration: BoxDecoration(color: Colors.blue, border: Border.all(color: Colors.pink, width: 1),),
              child: Text('감자고구마', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyText2,),
            ),
            flex: 1,
          )
        ],
      ),
*/

/*
      child: Container(
        margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
        decoration: BoxDecoration(
          color: Colors.blue,
          border: Border.all(color: Colors.pink, width: 1),
          image: DecorationImage(
            fit: BoxFit.contain,
            image:AssetImage('assets/img_btn/button_bg_abxy.png'),
          ),
        ),
      ),
*/

/*
      child: LayoutBuilder(builder: (context, constraints) =>
        Container(
          margin: EdgeInsets.all(constraints.maxHeight * 0.05),
          decoration: BoxDecoration(
            color: Colors.blue,
            border: Border.all(color: Colors.pink, width: 1),
            image: DecorationImage(
              fit: BoxFit.contain,
              image:AssetImage('assets/img_btn/button_bg_abxy.png'),
            ),
          ),
        )
      ),
*/
      child: LayoutBuilder(builder: (context, constraints) {
        double width = constraints.maxWidth;
        double height = constraints.maxHeight;
        print('$constraints.minWidth : $constraints.maxWidth');
        print('$constraints.minHeight : $constraints.maxHeight');

        return Stack(
          //fit: StackFit.expand,
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              top: 0,
              width: width * 0.8,
              height: height * 0.8,
              child: Container(
                margin: EdgeInsets.all(0),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  border: Border.all(color: Colors.pink, width: 1),
                  image: DecorationImage(
                    fit: BoxFit.fitWidth,
                    image:AssetImage('assets/img_btn/button_bg_abxy.png'),
                  ),
                ),
              ),
            ),

            Positioned(
              left: 0,
              right: 0,
              bottom: 4,
              height: height * 0.25,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.indigoAccent,
                  border: Border.all(color: Colors.pink, width: 1),
                ),
                child:
                //Text('감자고구마'),
                Text('감자고구마', textAlign: TextAlign.center,
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodyText2,)
              ),
            )
          ],
        );
      }),
    );
  }
}





































// This app is a stateful, it tracks the user's current choice.
//class BasicAppBarSample extends StatefulWidget {
//  @override
//  _BasicAppBarSampleState createState() => _BasicAppBarSampleState();
//}
//
//class _BasicAppBarSampleState extends State<BasicAppBarSample> {
//  Choice _selectedChoice = choices[0]; // The app's "state".
//
//  void _select(Choice choice) {
//    // Causes the app to rebuild with the new _selectedChoice.
//    setState(() {
//      _selectedChoice = choice;
//    });
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      home: Scaffold(
//        appBar: AppBar(
//          title: const Text('Basic AppBar'),
//          actions: <Widget>[
//            // action button
//            IconButton(
//              icon: Icon(choices[0].icon),
//              onPressed: () {
//                _select(choices[0]);
//              },
//            ),
//            // action button
//            IconButton(
//              icon: Icon(choices[1].icon),
//              onPressed: () {
//                _select(choices[1]);
//              },
//            ),
//            // overflow menu
//            PopupMenuButton<Choice>(
//              onSelected: _select,
//              itemBuilder: (BuildContext context) {
//                return choices.skip(2).map((Choice choice) {
//                  return PopupMenuItem<Choice>(
//                    value: choice,
//                    child: Text(choice.title),
//                  );
//                }).toList();
//              },
//            ),
//          ],
//        ),
//        body: Padding(
//          padding: const EdgeInsets.all(16.0),
//          child: ChoiceCard(choice: _selectedChoice),
//        ),
//      ),
//    );
//  }
//}
//
//class Choice {
//  const Choice({this.title, this.icon});
//
//  final String title;
//  final IconData icon;
//}
//
//const List<Choice> choices = const <Choice>[
//  const Choice(title: 'Car', icon: Icons.directions_car),
//  const Choice(title: 'Bicycle', icon: Icons.directions_bike),
//  const Choice(title: 'Boat', icon: Icons.directions_boat),
//  const Choice(title: 'Bus', icon: Icons.directions_bus),
//  const Choice(title: 'Train', icon: Icons.directions_railway),
//  const Choice(title: 'Walk', icon: Icons.directions_walk),
//];
//
//class ChoiceCard extends StatelessWidget {
//  const ChoiceCard({Key key, this.choice}) : super(key: key);
//
//  final Choice choice;
//
//  @override
//  Widget build(BuildContext context) {
//    final TextStyle textStyle = Theme.of(context).textTheme.display1;
//    return Card(
//      color: Colors.white,
//      child: Center(
//        child: SizedBox(
//          width: 100,
//          height: 100,
//          child: Container(
//            color: Colors.yellow,
//            child: Column(
//              //mainAxisSize: MainAxisSize.min,
//              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//              //crossAxisAlignment: CrossAxisAlignment.center,
//              children: <Widget>[
//                //Expanded(child:
//                  Image(image: AssetImage('assets/img_btn/button_bg_abxy.png'))
//                //),
//                ,Text('감자고구