import 'package:go_taxi_rider/flutter_flow/flutter_flow_model.dart';
import 'package:flutter/material.dart';
import 'onboarding_widget.dart';

class OnboardingModel extends FlutterFlowModel<OnboardingWidget> {
  int currentPage = 0;
  late PageController pageController;

  @override
  void initState(BuildContext context) {
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
  }
}
