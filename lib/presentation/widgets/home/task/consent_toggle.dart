/*import 'package:flutter/material.dart';
import '../../../../data/smart_contract.dart';
//import '../../data/smart_contract.dart';  // Import the SmartContract class

class ConsentToggle extends StatelessWidget {
  final String user;
  final SmartContract smartContract;

  ConsentToggle({required this.user, required this.smartContract});

  @override
  Widget build(BuildContext context) {
    // Get the current consent status (default to false if not set)
    bool consent = smartContract.userConsent[user] ?? false;

    return SwitchListTile(
      title: const Text('Consent to Receive Tokens'),
      value: consent,
      onChanged: (bool value) {
        if (value) {
          smartContract.agreeToReceiveTokens(user);  // User agrees to receive tokens
        } else {
          smartContract.revokeConsent(user);  // User revokes consent
        }
      },
    );
  }
}
*/
import 'package:flutter/material.dart';
import '../../../../data/smart_contract.dart';
//import '../../data/smart_contract.dart';  // Import the SmartContract class

class ConsentToggle extends StatefulWidget {
  final String user;
  final SmartContract smartContract;

  ConsentToggle({required this.user, required this.smartContract});

  @override
  _ConsentToggleState createState() => _ConsentToggleState();
}

class _ConsentToggleState extends State<ConsentToggle> {
  late bool consent;

  @override
  void initState() {
    super.initState();
    // Initialize the toggle state based on the current consent value
    consent = widget.smartContract.userConsent[widget.user] ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: const Text('Consent to Receive Tokens'),
      value: consent,
      onChanged: (bool value) {
        setState(() {
          consent = value;
        });
        // Update the smart contract state based on the user's choice
        if (consent) {
          widget.smartContract.agreeToReceiveTokens(widget.user);
        } else {
          widget.smartContract.revokeConsent(widget.user);
        }
      },
    );
  }
}
