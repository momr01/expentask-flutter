// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:payments_management/common/widgets/custom_app_bar.dart';
import 'package:payments_management/common/widgets/drawer/custom_drawer.dart';
import 'package:payments_management/constants/global_variables.dart';
import 'package:payments_management/features/alerts/screens/alerts_screen.dart';
import 'package:payments_management/features/alerts/services/alerts_services.dart';
import 'package:payments_management/features/generate/screens/generate_main_screen.dart';
import 'package:payments_management/features/home/screens/home_screen.dart';
import 'package:payments_management/features/names/screens/names_screen.dart';

class BottomBar extends StatefulWidget {
  static const String routeName = '/actual-home';
  final int page;
  const BottomBar({
    Key? key,
    required this.page,
  }) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  int _page = 0;
  int numberOfAlerts = 0;
  double bottomBarWidth = 42;
  double bottomBarBorderWidth = 5;

  List<Widget> pages = [
    // const HomeScreen(),
    const HomeScreenProvider(),
    const NamesScreen(),
    const GenerateMainScreen(),
    const AlertsScreen()
  ];

  AlertsServices alertsServices = AlertsServices();

  @override
  void initState() {
    super.initState();
    _page = widget.page;

    getNumberOfAlerts();
  }

  void updatePage(int page) {
    setState(() {
      _page = page;
    });
  }

  getNumberOfAlerts() async {
    numberOfAlerts = await alertsServices.numberOfAlerts(context: context);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context),
      drawer: const CustomDrawer(),
      body: pages[_page],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _page,
        selectedItemColor: GlobalVariables
            .secondaryColor, //GlobalVariables.selectedNavBarColor
        unselectedItemColor:
            GlobalVariables.whiteColor, //GlobalVariables.unselectedNavBarColor,
        onTap: updatePage,
        backgroundColor: GlobalVariables.primaryColor,
        iconSize: 40,
        items: [
          //HOME
          const BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              label: 'INICIO',
              backgroundColor: GlobalVariables.primaryColor),
          //NAMES
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.save_sharp,
            ),
            label: 'NOMBRES',
            backgroundColor: GlobalVariables.primaryColor,
          ),
          //GENERATE
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.add_task_sharp,
            ),
            label: 'GENERAR',
            backgroundColor: GlobalVariables.primaryColor,
          ),
          //ALERTS
          BottomNavigationBarItem(
            icon: badges.Badge(
                badgeContent: Text(
                  numberOfAlerts.toString(),
                  style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
                badgeStyle: const badges.BadgeStyle(
                    badgeColor: Colors.white, elevation: 0),
                child: const Icon(Icons.notification_important_sharp)),
            label: 'ALERTAS',
            backgroundColor: GlobalVariables.primaryColor,
          ),
        ],
      ),
    );
  }
}
