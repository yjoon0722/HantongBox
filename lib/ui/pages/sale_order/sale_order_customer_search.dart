import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hantong_cal/models/account_data.dart';
import 'package:hantong_cal/models/sales_status_data.dart';
import 'package:http/http.dart' as http;

class SaleOrderCustomerSearch extends StatefulWidget {
  final ValueChanged<AccountData> onChanged;

  SaleOrderCustomerSearch({
    Key key,
    @required this.onChanged,
  })  : assert(onChanged != null, 'onChanged must not be null'),
        super(key: key);

  @override
  _SaleOrderCustomerSearch createState() => _SaleOrderCustomerSearch();
}

class _SaleOrderCustomerSearch extends State<SaleOrderCustomerSearch> {
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.text = "거래처를 선택하세요.";
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(color: Colors.white),
      controller: _controller,
      decoration: InputDecoration(
        errorText: _controller.text == "거래처를 선택하세요." ? "거래처를 선택하세요." : "",
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
        prefixIcon: Icon(Icons.apartment, color: Colors.white,),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(top: 0, right: 24, bottom: 0),
          child: Icon(Icons.search, color: Colors.white),
        ),
        labelText: "거래처",
        labelStyle: TextStyle(color: Colors.white),
      ),
      onTap: () async {
        final accountData = await showSearch<AccountData>(
          context: context,
          delegate: AccountDataSearchDelegate(),
        );

        if (accountData == null) { return; }

        setState(() {
          _controller.text = accountData.account_name;
        });

        widget.onChanged(accountData);

      },
      readOnly: true,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////

class AccountDataSearchDelegate extends SearchDelegate<AccountData> {

  String get searchFieldLabel => "거래처를 입력하세요.";

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return SizedBox.expand(
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 0.3, 0.7, 1.0],
                colors: [Color(0xFF084172), Color(0xFF084C82), Color(0xFF084C82), Color(0xFF115999)])
        ),
        child: FutureBuilder<List<AccountData>>(
          future: request_mysql(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text("${snapshot.data[index].account_code} / ${snapshot.data[index].account_name} / ${snapshot.data[index].region} / ${snapshot.data[index].account_contact_information1}",
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      close(context, snapshot.data[index]);
                    },
                  );
                },
                itemCount: snapshot.data.length,
              );
            } else {
              return Center(
                child: CircularProgressIndicator(color: Colors.white,),
              );
            }
          },
        ),
      ),
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme.copyWith(
        appBarTheme: AppBarTheme(
          iconTheme: theme.primaryIconTheme.copyWith(color: Colors.white),
        ),
        textTheme: theme.textTheme.copyWith(
          headline5: theme.textTheme.headline5.copyWith(color: theme.primaryTextTheme.headline5.color),
          headline6: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        textSelectionTheme: TextSelectionThemeData(
            cursorColor: Colors.white
        ),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(color: Colors.white30),
          border: UnderlineInputBorder(),
        )
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 0.3, 0.7, 1.0],
              colors: [Color(0xFF084172), Color(0xFF084C82), Color(0xFF084C82), Color(0xFF115999)])
      ),
    );
  }

  Future<List<AccountData>> request_mysql() async{
    var urlString = "https://intosharp.pythonanywhere.com/search_account";
    var body = json.encode({"name" : query});
    try{
      final response = await http.post(urlString, body: body,headers: {'content-type':'application/json'});
      Map<String, dynamic> resultJson = json.decode(response.body);
      final AccountResult result = AccountResult.fromMap(resultJson);
      print(result);
      return result.result_array;
    } catch(e) {
      print('Error: $e');
      AccountResult error = AccountResult(isSuccess: false);
      return [];
    }
  }
}
