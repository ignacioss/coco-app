import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';

class AppLoadingSkeleton extends StatelessWidget {
  const AppLoadingSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SkeletonAnimation(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(color: Colors.grey[200]),
      ),
      shimmerColor: Colors.grey[100]!.withAlpha(125),
      gradientColor: Colors.grey[50]!.withAlpha(10),
      curve: Curves.fastOutSlowIn,
    );
  }
}
