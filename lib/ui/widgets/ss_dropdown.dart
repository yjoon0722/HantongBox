import 'package:flutter/material.dart';

class SSDropDown extends StatefulWidget {
  final ValueChanged onChanged;
  final List<Map<String, String>> items;

  final String currentSelectedValue;
  final Color labelColor;

  const SSDropDown({
    Key key,
    @required this.onChanged,
    @required this.items,
    this.currentSelectedValue,
    this.labelColor,
  }) :  assert(onChanged != null, 'onChanged must not be null'),
        assert(items != null),
        assert(currentSelectedValue != null),
        assert(labelColor != null),
        super(key: key);

  @override
  _SSDropDown createState() => _SSDropDown();
}

class _SSDropDown extends State<SSDropDown> {

  String _currentSelectedValue;

  @override
  void initState() {
    super.initState();
    _currentSelectedValue = widget.currentSelectedValue;
  }

  @override
  Widget build(BuildContext context) {
    _currentSelectedValue = widget.currentSelectedValue;
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        alignment: Alignment.center,
        dropdownColor: Colors.black87,
        icon: Visibility (visible:false, child: Icon(Icons.arrow_downward)),
        // iconSize: 0.0,
        // iconDisabledColor: Colors.white,
        // iconEnabledColor: Colors.white,
        style: TextStyle(color: Colors.white),
        value: _currentSelectedValue,
        isDense: true,
        isExpanded: true,
        onChanged: (String value) {
          setState(() {
            _currentSelectedValue = value;
          });
          for (var map in widget.items) {
            if (map.containsValue(value)) {
              widget.onChanged(map);
              break;
            }
          }
        },
        selectedItemBuilder: (BuildContext context) {
          return widget.items.map((map) {
            return Text(map.values.first,
              style: TextStyle(color: widget.labelColor, fontSize: 12.0,),
            );
          }).toList();
        },
        items: widget.items.map((map) {
          return DropdownMenuItem(
            value: map.values.first,
            child: Text(map.values.first,
              style: TextStyle(color: Colors.white, fontSize: 12.0,),
            ),
          );
        }).toList(),
      ),
    );
  }
}
