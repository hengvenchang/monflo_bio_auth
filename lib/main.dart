import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BiometricAuth(),
    );
  }
}

class BiometricAuth extends StatefulWidget {
  @override
  _BiometricAuthState createState() => _BiometricAuthState();
}

class _BiometricAuthState extends State<BiometricAuth> {
  final LocalAuthentication auth = LocalAuthentication();
  late bool _canCheckBiometrics;
  late List<BiometricType> _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticated = false;

  Future<void> _checkBiometrics() async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } catch (e) {
      canCheckBiometrics = false;
    }
    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
  }

  Future<void> _getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } catch (e) {
      availableBiometrics = [];
    }
    setState(() {
      _availableBiometrics = availableBiometrics;
    });
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
        localizedReason: 'Scan your fingerprint to authenticate',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      authenticated = false;
    }
    setState(() {
      _authorized = authenticated ? 'Authorized' : 'Not Authorized';
      _isAuthenticated = authenticated;
    });
  }

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
    _getAvailableBiometrics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Biometric Authentication'),
      ),
      body: Center(
        child: _isAuthenticated
            ? _buildBalanceScreen(context)
            : _buildAuthScreen(),
      ),
    );
  }

  Widget _buildAuthScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Can check biometrics: $_canCheckBiometrics\n'),
        ElevatedButton(
          onPressed: _authenticate,
          child: Text('Authenticate'),
        ),
        Text('Available biometrics: $_availableBiometrics\n'),
        Text('Current State: $_authorized\n'),
      ],
    );
  }

  Widget _buildBalanceScreen(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Cards',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('2 physical, 1 virtual'),
            SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.credit_card, size: 40, color: Colors.orange),
                        Spacer(),
                        Text(
                          '08/23',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      '2,629.80',
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                    Text('Total Balance (USD)'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.refresh),
                    label: Text('Refill'),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.send),
                    label: Text('Transfer'),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.phone_iphone),
                    label: Text('Recharge'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Quickpay',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ListTile(
              leading: Icon(Icons.phone_android),
              title: Text('Mobile Phone'),
              subtitle: Text('+1 829 736 1002'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.wifi),
              title: Text('Internet'),
              subtitle: Text('N°899 203 910'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.phone_android),
              title: Text('Mobile Phone'),
              subtitle: Text('+1 102 221 0294'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.wifi),
              title: Text('Internet'),
              subtitle: Text('N°899 203 910'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isAuthenticated = false;
                  });
                },
                child: Text('Logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
