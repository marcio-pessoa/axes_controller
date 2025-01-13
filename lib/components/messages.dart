import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class Message {
  // This class is not meant to be instantiated or extended; this constructor
  // prevents instantiation and extension.
  Message._();

  static Widget notFound = __NotFound();
  static Widget error = __Error();
  static Widget progressIndicator = __ProgressIndicator();
  static Widget empty = __Empty();
}

class __ProgressIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class __Empty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/icon/icon.png',
      scale: 1.8,
      color: Colors.white.withValues(alpha: 0.8),
      colorBlendMode: BlendMode.dstOut,
    );
  }
}

Widget __errorMessage({required text, required icon}) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon),
        Text(text),
      ],
    ),
  );
}

class __Error extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return __errorMessage(
      text: AppLocalizations.of(context)!.failedToLoadData,
      icon: Icons.heart_broken_outlined,
    );
  }
}

class __NotFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return __errorMessage(
      text: AppLocalizations.of(context)!.notFound,
      icon: Icons.search_off,
    );
  }
}
