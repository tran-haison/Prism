import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prism/controllers/theme_controller.dart';
import 'package:prism/router/app_router.dart';
import 'package:prism/services/logger.dart';
import 'package:prism/widgets/navigation_bar.dart';
import 'package:prism/widgets/scroll_navigation_bar.dart';
import 'package:provider/provider.dart';
import 'package:scroll_app_bar/scroll_app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = ScrollController();
  @override
  void initState() {
    super.initState();
    logger.d('App init done.');
  }

  void _fabAction() {
    // context.read<ThemeController>().setDarkIsTrueBlack(false);
    context.read<ThemeController>().setSchemeIndex(
          (context.read<ThemeController>().schemeIndex + 1) % 40,
        );
  }

  @override
  Widget build(BuildContext context) {
    final darkAppBarContents =
        Theme.of(context).scaffoldBackgroundColor.computeLuminance() > 0.5;
    return AutoTabsRouter(
        routes: [
          const WallsRoute(),
          SetupsRoute(controller: controller),
          const NotificationsRoute(),
          const ProfileRoute(),
        ],
        homeIndex: 0,
        builder: (context, child, animation) {
          final tabsRouter = AutoTabsRouter.of(context);
          return Scaffold(
            appBar: ScrollAppBar(
              controller: controller,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarIconBrightness:
                      darkAppBarContents ? Brightness.dark : Brightness.light),
              title: Text(
                'Prism',
                style: TextStyle(
                  color: darkAppBarContents
                      ? Theme.of(context)
                          .bottomNavigationBarTheme
                          .unselectedItemColor
                      : Theme.of(context).appBarTheme.titleTextStyle?.color,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.search),
                  color: darkAppBarContents
                      ? Theme.of(context)
                          .bottomNavigationBarTheme
                          .unselectedItemColor
                      : Theme.of(context).appBarTheme.titleTextStyle?.color,
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.filter_list),
                  color: darkAppBarContents
                      ? Theme.of(context)
                          .bottomNavigationBarTheme
                          .unselectedItemColor
                      : Theme.of(context).appBarTheme.titleTextStyle?.color,
                ),
              ],
            ),
            bottomNavigationBar: ScrollNavigationBar(
              elevation: 0,
              controller: controller,
              selectedIndex: tabsRouter.activeIndex,
              onDestinationSelected: (value) {
                tabsRouter.setActiveIndex(value);
                setState(() {});
              },
              backgroundColor:
                  Theme.of(context).bottomNavigationBarTheme.backgroundColor,
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              destinations: const [
                NavigationDestination(
                  selectedIcon: Icon(Icons.image),
                  icon: Icon(Icons.image_outlined),
                  label: 'Walls',
                ),
                NavigationDestination(
                  selectedIcon: Icon(Icons.imagesearch_roller),
                  icon: Icon(Icons.imagesearch_roller_outlined),
                  label: 'Setups',
                ),
                NavigationDestination(
                  selectedIcon: Icon(Icons.notifications),
                  icon: Icon(Icons.notifications_outlined),
                  label: 'Notifications',
                ),
                NavigationDestination(
                  selectedIcon: Icon(Icons.person),
                  icon: Icon(Icons.person_outlined),
                  label: 'Profile',
                ),
              ],
            ),
            body: FadeTransition(
              opacity: animation,
              child: child,
            ),
            floatingActionButton: FloatingActionButton(
              elevation: 10,
              onPressed: _fabAction,
              tooltip: 'Fab',
              child: const Icon(Icons.shuffle),
            ),
          );
        });
  }
}