import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewScreen extends StatelessWidget {
  final String k;
  final String value;
  final String ttc;
  NewScreen({this.k, this.value, this.ttc});
  @override
  Widget build(BuildContext context) {
    TextEditingController tc = TextEditingController(text: value ?? "");
    TextEditingController tval = TextEditingController(text: ttc ?? "");
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: TextField(
            maxLines: 1,
            controller: tval,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Title',
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.check),
          onPressed: () {
            Navigator.pop(context,
                <String>[k ?? "", tc.value.text + "~=" + tval.value.text]);
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
                                Navigator.pop(context, <String>[
                                  k ?? "",
                                  tc.value.text + "~=" + tval.value.text
                                ]);
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
