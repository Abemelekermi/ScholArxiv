// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    super.key,
    required this.topPadding,
  });

  final double topPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: Center(
        child: CircularProgressIndicator(
          color: ThemeProvider.themeOf(context).data.textTheme.bodyLarge?.color,
        ),
      ),
    );
  }
}
