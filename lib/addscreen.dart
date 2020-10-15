import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewScreen extends StatelessWidget {
  final String k;
  final String value;
  NewScreen({this.k, this.value});
  @override
  Widget build(BuildContext context) {
    TextEditingController tc = TextEditingController(text: value ?? "");
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text("Some Text"),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.check),
          onPressed: () {
            Navigator.pop(context, <String>[k ?? "", tc.value.text]);
          },
        ),
        body: WillPopScope(
          onWillPop: () async {
            Future.delayed(
                Duration(milliseconds: 100),
                () => showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Save changes?"),
                        content: Text(
                            "You have unsaved changes. Would you like to save or discard these changes?"),
                        actions: [
                          FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: Text("Discard")),
                          FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pop(
                                    context, <String>[k ?? "", tc.value.text]);
                              },
                              child: Text("Save"))
                        ],
                      );
                    }));

            return false;
          },
          child: TextField(
            maxLines: 9000,
            controller: tc,
            autofocus: true,
          ),
        ));
  }
}
