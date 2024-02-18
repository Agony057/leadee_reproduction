import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:leadee/models/user_model.dart';
import 'package:leadee/screens/dashboard/home.dart';
import 'package:leadee/screens/guest/auth.dart';
import 'package:leadee/screens/guest/password.dart';
import 'package:leadee/screens/guest/term.dart';
import 'package:leadee/screens/services/common_service.dart';
import 'package:leadee/screens/services/user_service.dart';

class GuestSreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const GuestSreen({
    super.key,
    required this.cameras,
  });

  @override
  State<GuestSreen> createState() => _GuestSreenState();
}

class _GuestSreenState extends State<GuestSreen> {
  final CommonService _commonService = CommonService();
  final UserService _userService = UserService();

  final List<Widget> _widgets = [];
  int _indexSelected = 0;

  String _email = '';

  @override
  void initState() {
    super.initState();

    AuthScreen authScreen = AuthScreen(
      onChangedStep: (index, value) async {
        StateRegistration stateRegistration =
            await _userService.mailinglist(value);

        setState(() {
          _indexSelected = index;
          _email = value;

          if (stateRegistration == StateRegistration.complete) {
            _indexSelected = _widgets.length - 1;
          }
        });
      },
    );

    PasswordScreen passwordScreen = PasswordScreen(
      onChangedStep: (index, value) async {
        if (value != null) {
          // UserModel connectedUserModel =
          await _userService.auth(
            UserModel(
              email: _email,
              password: value,
            ),
          );
        }
        setState(() {
          if (index != null) {
            _indexSelected = index;
          }

          if (index == null && value != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(cameras: widget.cameras),
              ),
            );
          }
        });
      },
    );

    _commonService.terms.then(
      (terms) => setState(() {
        _widgets.addAll([
          authScreen,
          TermScreen(
            terms: terms,
            onChangedStep: (index) => setState(() => _indexSelected = index),
          ),
          passwordScreen,
        ]);
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _widgets.isEmpty
          ? const SafeArea(
              child: Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Loading",
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SpinKitThreeBounce(
                        color: Colors.black,
                        size: 12.0,
                      ),
                    ],
                  ),
                ),
              ),
            )
          : _widgets.elementAt(_indexSelected),
    );
  }
}
