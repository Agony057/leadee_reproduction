import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:leadee/screens/camera.dart';
import 'package:leadee/screens/guest.dart';
import 'package:leadee/screens/services/user_service.dart';

class HomeScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const HomeScreen({
    super.key,
    required this.cameras,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final UserService _userService = UserService();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              OutlinedButton(
                style: ButtonStyle(
                  minimumSize: MaterialStatePropertyAll<Size>(
                    Size(
                      MediaQuery.of(context).size.width * 0.8,
                      MediaQuery.of(context).size.height * 0.1,
                    ),
                  ),
                  padding: const MaterialStatePropertyAll<EdgeInsets>(
                    EdgeInsets.symmetric(
                      vertical: 15.0,
                    ),
                  ),
                  shape: MaterialStatePropertyAll<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                  ),
                  backgroundColor: MaterialStatePropertyAll<Color>(
                    Theme.of(context).primaryColor,
                  ),
                ),
                onPressed: () async {
                  await _userService.logout();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GuestSreen(
                        cameras: widget.cameras,
                      ),
                    ),
                    (route) => false,
                  );
                },
                child: Text(
                  "logout".toUpperCase(),
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              OutlinedButton(
                style: ButtonStyle(
                  minimumSize: MaterialStatePropertyAll<Size>(
                    Size(
                      MediaQuery.of(context).size.width * 0.8,
                      MediaQuery.of(context).size.height * 0.1,
                    ),
                  ),
                  padding: const MaterialStatePropertyAll<EdgeInsets>(
                    EdgeInsets.symmetric(
                      vertical: 15.0,
                    ),
                  ),
                  shape: MaterialStatePropertyAll<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                  ),
                  backgroundColor: MaterialStatePropertyAll<Color>(
                    Theme.of(context).primaryColor,
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CameraScreen(
                        cameras: widget.cameras,
                      ),
                    ),
                  );
                },
                child: Text(
                  "camera".toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
