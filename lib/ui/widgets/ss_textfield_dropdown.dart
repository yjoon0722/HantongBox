import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SSTextFieldDropDown extends StatefulWidget {
  final ValueChanged onChanged;
  // final List<String> items;
   final List<Map<String, String>> items;
  final String labelText;
  final Icon prefixIcon;
  final Icon suffixIcon;

  const SSTextFieldDropDown({
    Key key,
    @required this.onChanged,
    @required this.items,
    @required this.labelText,
    @required this.prefixIcon,
    @required this.suffixIcon,
  }) :  assert(onChanged != null, 'onChanged must not be null'),
        assert(items != null),
        assert(labelText != null),
        assert(prefixIcon != null),
        assert(suffixIcon != null),
        super(key: key);

  @override
  _SSTextFieldDropDownState createState() => _SSTextFieldDropDownState();
}

class _SSTextFieldDropDownState extends State<SSTextFieldDropDown> {

  String _currentSelectedValue;

  @override
  void initState() {
    super.initState();
    _loadCurrentSelectedValue();
  }

  _loadCurrentSelectedValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _currentSelectedValue = widget.labelText == "거래유형" ? widget.items[1].values.first
        : widget.labelText == "출하창고" ? widget.items[3].values.first
        : widget.labelText == "담당자" ? (prefs.getString("selectedEmpCodeValue") ?? widget.items.first.values.first)
        : widget.items.first.values.first;
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      builder: (FormFieldState<String> state) {
        return InputDecorator(
          decoration: InputDecoration(
            errorText: _currentSelectedValue == widget.items.first.values.first ? widget.items.first.values.first : "",
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 1.0),
              borderRadius: BorderRadius.circular(5.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 1.0),
              borderRadius: BorderRadius.circular(5.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 1.0),
              borderRadius: BorderRadius.circular(5.0),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 1.0),
              borderRadius: BorderRadius.circular(5.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 1.0),
              borderRadius: BorderRadius.circular(5.0),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 1.0),
              borderRadius: BorderRadius.circular(5.0),
            ),
            prefixIcon: widget.prefixIcon,
            //suffixIcon: widget.suffixIcon,
            labelText: widget.labelText,
            labelStyle: TextStyle(color: Colors.white),
          ),
          isEmpty: false,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              dropdownColor: Colors.black87,
              iconDisabledColor: Colors.white,
              iconEnabledColor: Colors.white,
              style: TextStyle(color: Colors.white),
              value: _currentSelectedValue,
              isDense: true,
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
              items: widget.items.map((map) {
                return DropdownMenuItem(
                  value: map.values.first,
                  child: Text(map.values.first),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
