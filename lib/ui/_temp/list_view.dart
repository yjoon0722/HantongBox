import 'package:flutter/material.dart';

ListPageState pageState;

class ListPage extends StatefulWidget {
  @override
  //ListPageState createState() => _ListPageState();
  ListPageState createState() {
    pageState = ListPageState();
    return pageState;
  }
}

class ListPageState extends State<ListPage> {

  List<String> items = List<String>.generate(10, (index) {
    return 'Item - $index';
  });

  final teController = TextEditingController(
    text: 'good'
  );

  @override
  void dispose() {
    // TODO: implement dispose
    teController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('한통박스')),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.all(10),
                height: 70,
                alignment: Alignment(0, 0),
                color: Colors.orange,
                child: Text(
                  'To remove an item, swipe the title to the right or tap the trash icon.',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Dismissible(
                    key: Key(item),
                    direction: DismissDirection.startToEnd,
                    child: ListTile(
                      title: Text(item),
                      trailing: IconButton(icon: Icon(Icons.delete_forever), onPressed: () {
                        setState(() {
                          items.removeAt(index);
                        });
                      }),
                    ),
                    onDismissed: (direction) {
                      setState(() {
                        items.removeAt(index);
                      });
                    },
                  );
                },
              ),
            ),
            Divider(
              color: Colors.grey,
              height: 5,
              indent: 10,
              endIndent: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                children: <Widget>[
                  Text('Inser Data:'),

                ],
              ),
            )
          ],
        ),
    );
  }

}
