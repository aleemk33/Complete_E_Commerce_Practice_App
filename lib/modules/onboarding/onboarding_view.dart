import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../app/routes/app_routes.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final pageController = PageController();
  final box = GetStorage();
  int index = 0;

  final pages = [
    _OnboardPage(
      title: 'onboard_title_1'.tr,
      subtitle: 'onboard_sub_1'.tr,
      icon: Icons.auto_awesome,
    ),
    _OnboardPage(
      title: 'onboard_title_2'.tr,
      subtitle: 'onboard_sub_2'.tr,
      icon: Icons.search,
    ),
    _OnboardPage(
      title: 'onboard_title_3'.tr,
      subtitle: 'onboard_sub_3'.tr,
      icon: Icons.shopping_bag,
    ),
  ];

  void finish() {
    // Persist flag so onboarding is shown only once.
    box.write('onboarding_seen', true);
    Get.offAllNamed(AppRoutes.home);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(onPressed: finish, child: Text('skip'.tr)),
            ),
            Expanded(
              // Swipeable pages for onboarding content.
              child: PageView.builder(
                controller: pageController,
                itemCount: pages.length,
                onPageChanged: (i) => setState(() => index = i),
                itemBuilder: (_, i) => pages[i],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              // Dots indicator for current page.
              children: List.generate(
                pages.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: index == i ? 18 : 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: index == i
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  if (index > 0)
                    TextButton(
                      // Back only shown after the first page.
                      onPressed: () => pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      ),
                      child: Text('back'.tr),
                    ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      // Finish on last page; otherwise advance.
                      if (index == pages.length - 1) {
                        finish();
                      } else {
                        pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                      }
                    },
                    child: Text(
                      index == pages.length - 1
                          ? 'get_started'.tr
                          : 'next'.tr,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardPage extends StatelessWidget {
  const _OnboardPage({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon badge for each onboarding highlight.
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withAlpha(30),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
