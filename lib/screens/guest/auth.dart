import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  final void Function(int, String) onChangedStep;

  const AuthScreen({
    super.key,
    required this.onChangedStep,
  });

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final RegExp emailRegEx = RegExp(
    r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
  );

  String _email = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 30.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: "Everyone has\n".toUpperCase(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                    ),
                    children: [
                      TextSpan(
                        text: "knowledge\n".toUpperCase(),
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: "to share.".toUpperCase(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "It all starts here.",
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text("Enter your email"),
                      const SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        onChanged: (value) => setState(() => _email = value),
                        validator: (value) =>
                            value!.isEmpty || !emailRegEx.hasMatch(value)
                                ? "Please enter a valid email"
                                : null,
                        decoration: InputDecoration(
                          hintText: "Ex: john.doe@domain.tld",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0.0),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0.0),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      OutlinedButton(
                        style: ButtonStyle(
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
                          backgroundColor: !emailRegEx.hasMatch(_email)
                              ? const MaterialStatePropertyAll<Color>(
                                  Colors.grey,
                                )
                              : MaterialStatePropertyAll<Color>(
                                  Theme.of(context).primaryColor,
                                ),
                        ),
                        onPressed: !emailRegEx.hasMatch(_email)
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  // print(_email);
                                  widget.onChangedStep(1, _email);
                                }
                              },
                        child: Text(
                          "continue".toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      // Container(
                      //   padding: const EdgeInsets.symmetric(
                      //     vertical: 15.0,
                      //   ),
                      //   decoration: BoxDecoration(
                      //     color: Theme.of(context).primaryColor,
                      //   ),
                      //   child: Text(
                      //     "continue".toUpperCase(),
                      //     style: const TextStyle(
                      //       color: Colors.white,
                      //     ),
                      //     textAlign: TextAlign.center,
                      //   ),
                      // ),

                      // ElevatedButton(
                      //   style: ButtonStyle(
                      //     backgroundColor: MaterialStatePropertyAll<Color>(
                      //       Theme.of(context).primaryColor,
                      //     ),
                      //   ),
                      //   onPressed: () => print("send"),
                      //   child: Text(
                      //     "continue".toUpperCase(),
                      //     style: TextStyle(
                      //       color: Colors.white,
                      //     ),
                      //   ),
                      // ),
                      // TextButton(
                      //   style: ButtonStyle(
                      //     backgroundColor: MaterialStatePropertyAll<Color>(
                      //       Theme.of(context).primaryColor,
                      //     ),
                      //     padding: MaterialStateProperty.resolveWith(
                      //       (states) => const EdgeInsets.symmetric(
                      //         vertical: 15.0,
                      //       ),
                      //     ),
                      //   ),
                      //   onPressed: () => print("send"),
                      //   child: Text(
                      //     "continue".toUpperCase(),
                      //     style: const TextStyle(
                      //       color: Colors.white,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
