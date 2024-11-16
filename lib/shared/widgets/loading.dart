import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'gap.dart';

class Loading {
  Widget listVerticalShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.white70,
      highlightColor: Colors.white10,
      child: ListView.separated(
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                color: Colors.grey[300],
              ),
              width: double.infinity,
              height: 300,
            );
          },
          itemCount: 5,
          shrinkWrap: true,
          separatorBuilder: (context, index) => const Gap.v(h: 16)),
    );
  }

  Widget imageLoading(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget imageError(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.error, color: Colors.red),
          Gap.v(h: 4),
          Text("Image Error")
        ],
      )),
    );
  }
}
