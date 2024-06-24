import 'package:flutter/material.dart';

import 'tools/dialogs.dart';
import 'tools/paddings.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    Paddings.init(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Dialogs.of(context).showAlertDialog(
            subtitle: 'Testing an alert dialog in this new app',
            onContinue: () {},
          );
        },
        child: const Icon(Icons.add),
      ),
      body: const Column(
        children: [],
      ),
    );
  }
}
