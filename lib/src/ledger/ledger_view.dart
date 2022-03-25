import 'package:flutter/material.dart';

class LedgerView extends StatelessWidget {
  const LedgerView({
    Key? key,
  }) : super(key: key);

  static const routeName = '/ledger';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ledger'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: const [
            ListTile(
              tileColor: Colors.amber,
              title: Text('data'),
              subtitle: Text('data'),
              trailing: Text('\$800'),
            )
          ],
        ),
      ),
    );
  }
}
