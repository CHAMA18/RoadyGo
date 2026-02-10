import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_taxi_rider/flutter_flow/flutter_flow_animations.dart';
import 'package:go_taxi_rider/flutter_flow/flutter_flow_theme.dart';
import 'package:go_taxi_rider/flutter_flow/flutter_flow_util.dart';
import 'package:go_taxi_rider/index.dart';
import '/l10n/roadygo_i18n.dart';
import 'onboarding_model.dart';
export 'onboarding_model.dart';

class OnboardingWidget extends StatefulWidget {
  const OnboardingWidget({super.key});

  static String routeName = 'Onboarding';
  static String routePath = '/onboarding';

  @override
  State<OnboardingWidget> createState() => _OnboardingWidgetState();
}

class _OnboardingWidgetState extends State<OnboardingWidget>
    with TickerProviderStateMixin {
  late OnboardingModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final animationsMap = <String, AnimationInfo>{};

  static const List<String> _pageImages = [
    'https://lh3.googleusercontent.com/aida-public/AB6AXuAhcHgRtYhOcaF4yic48lxEYUeNUvHJAuvhRq9qVaf7naql-QGYxyKZX2bny4r37jI5TPUCvXNQAQrEjHYMJAU2tL9ZdpFEhh9ezGNDgc2nXuPGhF4e-4RVa6Sov5XHz3p_9KuUY1-7Gbp5uLEmOyuSv7noRGHI_WDbfpi9uaHXIofbA40nOuINQXXYxPbOlx0l13eQqGLGEVjzPRmDr5dlJAf6w7Nqa2ZWQhLmiOieAor76UGzZuIbUq7mPWonfRam3OTPRspd8A',
    'https://lh3.googleusercontent.com/aida-public/AB6AXuCA1Utrypo-SdAeTSAcWUB1yAC-3C7Z6mhT3TQGqwfLGL6lbeQuu1qTNjXvUfT-1u-VQhN7WqfXHWOGbUTQBtrIpt6uksTa5Zd3s9xbhZvV00WHwUCF_nocEltcK4bH0l7EdjDm3OQYtWSi807KMh7ZJiH3AETzVhhJ4Wt8UDILmGjg4iomd5FX-CnzdFzNK6ZlRjwn1Drr834VvMKMwqRI-4sFcbg8mke1XhGng-lViyRjpRkCCvNxlWbwbUofcE5Pe9JXl2cjEw',
    'https://lh3.googleusercontent.com/aida-public/AB6AXuDBS8zteLwgpABks_40Fhb_tp0GmzVmC10JdBOjEdfq4Xrpxoobs_XltXHDjIiB244xGYMJayTtoPFUaLLFMVz8SOF7Ic-smMjG_EGzwhoKpk0_ERrClnipgjxqDgcFwdFbQ0Az_qyeMsVljLvEZMaFW915qhJzt0e1Cy4Fd7gYHtva_LqbfsOUGpm08NFIrqQlKc1G8TtAz6uBDaPoTuBtKn7sOzxRFZUwIfCULnK8NogFoNosfr9ZqgXpotx5feKQD2Pes6JC8A',
  ];

  OnboardingContent _contentFor(BuildContext context, int index) {
    return switch (index) {
      0 => OnboardingContent(
          title: context.tr('onb1_title'),
          highlightedTitle: context.tr('onb1_highlight'),
          description: context.tr('onb1_desc'),
          image: _pageImages[0],
        ),
      1 => OnboardingContent(
          title: context.tr('onb2_title'),
          highlightedTitle: context.tr('onb2_highlight'),
          description: context.tr('onb2_desc'),
          image: _pageImages[1],
        ),
      _ => OnboardingContent(
          title: context.tr('onb3_title'),
          highlightedTitle: context.tr('onb3_highlight'),
          description: context.tr('onb3_desc'),
          image: _pageImages[2],
        ),
    };
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OnboardingModel());

    animationsMap.addAll({
      'contentOnPageLoad': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeOutQuart,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeOutQuart,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: const Offset(0.0, 40.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
    });
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _model.currentPage = index;
    });
  }

  void _nextPage() {
    if (_model.currentPage < _pageImages.length - 1) {
      _model.pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    } else {
      _navigateToAuth();
    }
  }

  void _navigateToAuth() {
    context.goNamed(AuthHomePageWidget.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Stack(
        children: [
          // PageView for onboarding slides
          PageView.builder(
            controller: _model.pageController,
            onPageChanged: _onPageChanged,
            itemCount: _pageImages.length,
            itemBuilder: (context, index) {
              return _buildPage(_contentFor(context, index));
            },
          ),
          // Skip button
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 24,
            child: TextButton(
              onPressed: _navigateToAuth,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: Text(
                context.tr('skip'),
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                      color: Colors.white.withValues(alpha: 0.8),
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.0,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(OnboardingContent content) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background image
        Image.network(
          content.image,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: Colors.black,
          ),
        ),
        // Gradient overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.black.withValues(alpha: 0.9),
                Colors.black.withValues(alpha: 0.6),
                Colors.transparent,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        ),
        // Content
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      content.title,
                      style: FlutterFlowTheme.of(context).displaySmall.override(
                            fontFamily:
                                FlutterFlowTheme.of(context).displaySmallFamily,
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 40.0,
                            lineHeight: 1.1,
                            letterSpacing: -0.5,
                          ),
                    ),
                    Text(
                      content.highlightedTitle,
                      style: FlutterFlowTheme.of(context).displaySmall.override(
                            fontFamily:
                                FlutterFlowTheme.of(context).displaySmallFamily,
                            color: FlutterFlowTheme.of(context).primary,
                            fontWeight: FontWeight.w800,
                            fontSize: 40.0,
                            lineHeight: 1.1,
                            letterSpacing: -0.5,
                          ),
                    ),
                  ],
                ).animateOnPageLoad(animationsMap['contentOnPageLoad']!),
                const SizedBox(height: 16),
                // Description
                Text(
                  content.description,
                  style: FlutterFlowTheme.of(context).bodyLarge.override(
                        fontFamily:
                            FlutterFlowTheme.of(context).bodyLargeFamily,
                        color: Colors.grey[300],
                        fontWeight: FontWeight.normal,
                        fontSize: 16.0,
                        letterSpacing: 0.0,
                        lineHeight: 1.6,
                      ),
                ).animateOnPageLoad(animationsMap['contentOnPageLoad']!),
                const SizedBox(height: 40),
                // Navigation controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Progress indicators
                    Row(
                      children: List.generate(
                        _pageImages.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.only(right: 8),
                          height: 8,
                          width: _model.currentPage == index ? 32 : 8,
                          decoration: BoxDecoration(
                            color: _model.currentPage == index
                                ? FlutterFlowTheme.of(context).primary
                                : Colors.white.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    // Next button
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _nextPage,
                        borderRadius: BorderRadius.circular(28),
                        child: Container(
                          height: 56,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).primary,
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [
                              BoxShadow(
                                color: FlutterFlowTheme.of(context)
                                    .primary
                                    .withValues(alpha: 0.2),
                                blurRadius: 18,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _model.currentPage == _pageImages.length - 1
                                    ? context.tr('get_started')
                                    : context.tr('next'),
                                style: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .titleSmallFamily,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class OnboardingContent {
  final String title;
  final String highlightedTitle;
  final String description;
  final String image;

  OnboardingContent({
    required this.title,
    required this.highlightedTitle,
    required this.description,
    required this.image,
  });
}
