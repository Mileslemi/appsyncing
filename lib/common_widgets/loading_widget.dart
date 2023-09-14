import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.height * .35,
        height: MediaQuery.of(context).size.height * .35,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: const Color.fromARGB(170, 0, 0, 0),
            borderRadius: BorderRadius.circular(25),
            boxShadow: const [
              BoxShadow(
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
                color: Color.fromARGB(90, 0, 0, 0),
              )
            ]),
        child: const CircularProgressIndicator(),
      ),
    );
  }
}
