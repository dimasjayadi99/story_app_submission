import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../../common/app_const.dart';

class IntroductionPage extends StatelessWidget {
  final VoidCallback onDone;
  IntroductionPage({super.key, required this.onDone});

  final List<PageViewModel> listPagesView = [
    PageViewModel(
      image: buildImage("assets/images/img_first_screen.png"),
      title: AppConst.introductionTitle1,
      body: AppConst.introductionBody1,
    ),
    PageViewModel(
      image: buildImage("assets/images/img_second_screen.png"),
      title: AppConst.introductionTitle2,
      body: AppConst.introductionBody2,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IntroductionScreen(
            pages: listPagesView,
            onDone: () => onDone(),
            globalBackgroundColor: Colors.white,
            scrollPhysics: const ClampingScrollPhysics(),
            showDoneButton: true,
            showNextButton: true,
            showSkipButton: true,
            skip: const Text("Skip"),
            next: const Text("Next"),
            done: const Text("Done"),
            dotsDecorator: getDotsDecorator()),
      ),
    );
  }

  PageDecoration getDecoration() {
    return const PageDecoration(
      imagePadding: EdgeInsets.only(top: 120),
      pageColor: Colors.white,
      bodyPadding: EdgeInsets.only(top: 8, left: 20, right: 20),
      titlePadding: EdgeInsets.only(top: 50),
      bodyTextStyle: TextStyle(color: Colors.black54, fontSize: 15),
    );
  }

  DotsDecorator getDotsDecorator() {
    return const DotsDecorator(
      spacing: EdgeInsets.symmetric(horizontal: 2),
      activeColor: Colors.indigo,
      color: Colors.grey,
      activeSize: Size(12, 5),
      activeShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
      ),
    );
  }
}

Widget buildImage(String imagePath) {
  return Center(
      child: Image.asset(
    imagePath,
    width: 450,
    height: 200,
  ));
}
