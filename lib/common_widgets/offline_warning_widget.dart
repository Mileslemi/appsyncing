import 'package:flutter/material.dart';

class OfflineWarning extends StatelessWidget {
  const OfflineWarning({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      left: 15,
      child: Container(
        color: const Color.fromARGB(185, 0, 0, 0),
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.info_outline,
              color: Colors.amber,
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "No Internet.",
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.apply(fontStyle: FontStyle.italic),
                ),
                Text(
                  "Working Offline.",
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.apply(fontStyle: FontStyle.italic),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
