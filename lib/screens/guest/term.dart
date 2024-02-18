import 'package:flutter/material.dart';

class TermScreen extends StatefulWidget {
  final void Function(int) onChangedStep;
  final String terms;

  const TermScreen({
    super.key,
    required this.terms,
    required this.onChangedStep,
  });

  @override
  State<TermScreen> createState() => _TermScreenState();
}

class _TermScreenState extends State<TermScreen> {
  late ScrollController _scrollController;
  bool _termsReaded = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    _scrollController.addListener(() {
      if (_scrollController.offset >=
              _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange) {
        setState(() => _termsReaded = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0.0,
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: const Text(
            "Terms & Conditions",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () => widget.onChangedStep(0),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
            right: 20.0,
            bottom: 15.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      Text(widget.terms),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 15.0,
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
                  backgroundColor: _termsReaded
                      ? MaterialStatePropertyAll<Color>(
                          Theme.of(context).primaryColor,
                        )
                      : const MaterialStatePropertyAll<Color>(
                          Colors.grey,
                        ),
                ),
                onPressed: !_termsReaded ? null : () => widget.onChangedStep(2),
                child: Text(
                  "accept & continue".toUpperCase(),
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
