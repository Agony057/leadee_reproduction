import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:leadee/firebase_options.dart';
import 'package:leadee/screens/dashboard/home.dart';
import 'package:leadee/screens/guest.dart';
import 'package:leadee/screens/services/user_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final List<CameraDescription> cameras = await availableCameras();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(App(cameras: cameras));
}

class App extends StatelessWidget {
  final UserService _userService = UserService();
  final List<CameraDescription> cameras;

  App({
    super.key,
    required this.cameras,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Leadee',
      home: StreamBuilder(
        stream: _userService.user,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              return HomeScreen(cameras: cameras);
            }

            return GuestSreen(cameras: cameras);
          }

          return const SafeArea(
            child: Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Loading",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
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
          );
        },
      ),
    );
  }
}
