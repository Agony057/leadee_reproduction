import 'package:flutter/material.dart';

class PasswordScreen extends StatefulWidget {
  final void Function(int?, String?) onChangedStep;

  const PasswordScreen({
    super.key,
    required this.onChangedStep,
  });

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isSecret = true;
  String _password = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () => widget.onChangedStep(0, null),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 30.0,
          ),
          child: Column(
            children: [
              Text(
                "password".toUpperCase(),
                style: const TextStyle(
                  fontSize: 30,
                ),
              ),
              const SizedBox(
                height: 50.0,
              ),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text("Enter your password"),
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      onChanged: (value) => setState(() => _password = value),
                      validator: (value) => value!.length < 6
                          ? "Password must be at least 6 characters"
                          : null,
                      obscureText: _isSecret,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isSecret ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isSecret = !_isSecret;
                            });
                          },
                        ),
                        hintText: "Ex: gh!D4Yhd",
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
                        backgroundColor: _password.length < 6
                            ? const MaterialStatePropertyAll<Color>(
                                Colors.grey,
                              )
                            : MaterialStatePropertyAll<Color>(
                                Theme.of(context).primaryColor,
                              ),
                      ),
                      onPressed: _password.length < 6
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                widget.onChangedStep(null, _password);
                              }
                            },
                      child: Text(
                        "continue".toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
