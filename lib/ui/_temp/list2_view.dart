import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HantongItem {
  final int index;
  final String title;
  final String subTitle;
  final int price;

  int count = 0;

  HantongItem(
      {this.index, this.title, this.subTitle, this.price, this.count = 0});
}

class HantongItemListPage extends StatefulWidget {
  @override
  _HantongItemListPageState createState() => _HantongItemListPageState();
}

class _HantongItemListPageState extends State<HantongItemListPage> {
  List<HantongItem> _items;

  int total_price = 0;

  @override
  void initState() {

    // TODO: implement initState
    super.initState();

    _items = new List<HantongItem>();

    _items.add(HantongItem(index: 0, title: '주황보온용기', subTitle: '1box 20개', price: 198000));
    _items.add(HantongItem(index: 1, title: '회색보온용기', subTitle: '1box 20개', price: 148000));
    _items.add(HantongItem(index: 2, title: '일회용 식판', subTitle: '1box 50개', price: 150000));
    _items.add(HantongItem(index: 3, title: '다회용 식판', subTitle: '1box 100개', price: 250000));
    _items.add(HantongItem(index: 4, title: '실링 비닐', subTitle: '1box 4개', price: 144000));
    _items.add(HantongItem(index: 5, title: '종이 용기', subTitle: '1box 600개', price: 60000));
    _items.add(HantongItem(index: 6, title: '전용실링기계', subTitle: '1ea', price: 1300000));
    _items.add(HantongItem(index: 7, title: '배송비', subTitle: '택배', price: 5000));
  }

  final formatter = new NumberFormat('#,###');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('한통박스'),
        actions: <Widget>[IconButton(icon: Icon(Icons.loop), onPressed: () {
          setState(() {
            total_price = 0;

            _items.forEach((item) {
              item.count = 0;
            });

          });
        })],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(4.0),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        children: <Widget>[
                          // Left
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(_items[index].title),
                                  Text(formatter.format(_items[index].price) + ' 원'),
                                ],
                              ),
                            ),
                          ),

                          Spacer(),

                          // Right
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                //crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  IconButton(
                                      icon: Icon(Icons.remove_circle_outline),
                                      onPressed: () {
                                        setState(() {
                                          if (_items[index].count > 0) {
                                            _items[index].count--;

                                            total_price -= _items[index].price;
                                          }
                                        });
                                      }),
                                  Spacer(),
                                  Text(formatter.format(_items[index].count)),
                                  Spacer(),
                                  IconButton(
                                      icon: Icon(Icons.add_circle_outline),
                                      onPressed: () {
                                        setState(() {
                                          _items[index].count++;

                                          total_price += _items[index].price;
                                        });
                                      }),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          ),
          Divider(
            color: Colors.grey,
            height: 5,
            indent: 10,
            endIndent: 10,
          ),
          Padding(
            //padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: <Widget>[
                Text('Total'),
                Spacer(),
                Text(formatter.format(total_price) + ' 원'),
              ],
            ),
          )
        ],
      ),
    );
  }
}

/*


//          Expanded(
//              child: ListView.separated(
//                  itemBuilder: (context, index) {
//                    return ListTile(
//                      title: Text(_items[index].title),
//                      subtitle: Text(formatter.format(_items[index].price)),
//                      trailing: Text('e')
//                    );
//                  },
//                  separatorBuilder: (context, index) {
//                    return Divider();
//                  },
//                  itemCount: _items.length)
//          ),

//          Expanded(
//            child: ListView.builder(
//              itemCount: _items.length,
//              itemBuilder: (context, index) {
//                return Card(
//                  child: ListTile(
//                    title: Text(_items[index].title),
//                    subtitle: Text(formatter.format(_items[index].price)),
//                  ),
//                );
//              },
//            ),
//          )


HantongListPageState pageState;

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
      appBar: AppBar(title: Text('한통 계산기')),
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
*/
