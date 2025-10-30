import 'package:flutter/material.dart';
import 'package:health_care/ui/doctor/doctor_search_screen.dart';
import 'package:health_care/ui/login_screen/login_screen.dart';
import 'package:health_care/ui/pharmacy/pharmacy_search_screen.dart';

import '../../constants/assets.dart';
import '../../constants/styles.dart';
import '../../shared/widgets/bottom_bar.dart';
import '../home_screen/home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; // Track the selected tab
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Define the screens list, conditionally setting the last screen
    final List<Widget> _screens = <Widget>[
      HomeScreen(),
      PharmacySearchScreen(),
      DoctorSearchScreen(),
      LoginScreen()
    ];

    return Scaffold(
      backgroundColor: AppStyles.primaryColor,
      extendBody: false,
      resizeToAvoidBottomInset: true,
      // appBar: const CustomNavBar(
      //   isBackButtonShown: false,
      // ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _screens,
      ),
      bottomNavigationBar: AppBottomBar(
        icons: [
          Assets.homeIcon,
          Assets.pharmacyIcon,
          Assets.doctorIcon,
          Assets.accountIcon,
        ],
        defaultSelectedIndex: _selectedIndex,
        onItemClicked: (index) {
          setState(() {
            _selectedIndex = index;
            _pageController.jumpToPage(index);
          });
        },
      ),
    );
  }
}
