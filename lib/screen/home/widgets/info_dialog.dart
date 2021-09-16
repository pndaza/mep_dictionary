import 'package:flutter/material.dart';
import 'package:mep_dictionary/data/constants.dart';

class InfoDialog extends StatelessWidget {
  const InfoDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Container(
          color: Theme.of(context).colorScheme.primary,
          child: Center(
              child: Text(
            'သိကောင်းစရာ',
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
          ))),
      content: SingleChildScrollView(child: Text(kInfoText)),
      actions: <Widget>[
        ElevatedButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
