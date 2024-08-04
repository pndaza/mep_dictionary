import 'package:flutter/material.dart';
import '../../../data/constants.dart';

class InfoDialog extends StatelessWidget {
  const InfoDialog({super.key});

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
      content: const SingleChildScrollView(child: Text(kInfoText)),
      actions: <Widget>[
        ElevatedButton(
          child: const Text('OK'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
