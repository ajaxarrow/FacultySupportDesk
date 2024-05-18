import 'package:facultysupportdesk/models/app_user.dart';
import 'package:facultysupportdesk/themes/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key, required this.index, required this.content, required this.title});
  final int index;
  final Widget content;
  final String title;

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

const _navBarItems = [
  BottomNavigationBarItem(
    icon: PhosphorIcon(PhosphorIconsRegular.chatsTeardrop),
    activeIcon: PhosphorIcon(PhosphorIconsFill.chatsTeardrop),
    label: 'Consultation Requests',
  ),
  BottomNavigationBarItem(
    icon: PhosphorIcon(PhosphorIconsRegular.hourglass),
    activeIcon: PhosphorIcon(PhosphorIconsFill.hourglass),
    label: 'History',
  ),
  BottomNavigationBarItem(
    icon: PhosphorIcon(PhosphorIconsRegular.calendar),
    activeIcon: PhosphorIcon(PhosphorIconsFill.calendar),
    label: 'Calendar View',
  ),
  BottomNavigationBarItem(
    icon: PhosphorIcon(PhosphorIconsRegular.listChecks),
    activeIcon: PhosphorIcon(PhosphorIconsFill.listChecks),
    label: 'Activities',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.logout), // Logout icon
    label: 'Logout',
  ),
];


var _navBarItemLinks = [
  '/main',
  '/history',
  '/calendar',
  '/activities',
  '/logout'
];


class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;
  String facultyName = 'User';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _selectedIndex = widget.index;
    });
    AppUser().getUserById(FirebaseAuth.instance.currentUser!.uid).then((value){
      setState(() {
        facultyName = value.name!;
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final railWidth = width * 0.20;
    final mainContainerWidth = width * 0.78;
    final bool isSmallScreen = width < 600;
    final bool isLargeScreen = width > 1200;

    return Scaffold(

      bottomNavigationBar: isSmallScreen
          ? BottomNavigationBar(
          backgroundColor: bgColor,
          selectedItemColor: primaryColor,
          unselectedItemColor: secondaryColor,
          items: _navBarItems,
          currentIndex: _selectedIndex,
          onTap: (int index) {
            if (index == _navBarItems.length - 1) {
              FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacementNamed('/redirect');
            } else {
              setState(() {
                _selectedIndex = index;
                Navigator.of(context).pushReplacementNamed(_navBarItemLinks[index]);
              });
            }
          })
          : null,
      body: SizedBox(
        height: double.infinity,
        width: width,
        child: Row(
          children: <Widget>[
            if (!isSmallScreen)
              SizedBox(
                width: railWidth,
                child: NavigationRail(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (int index) {
                    if (index == _navBarItems.length - 1) {
                      FirebaseAuth.instance.signOut();
                      Navigator.of(context).pushReplacementNamed('/redirect');
                    } else {
                      Navigator.of(context).pushReplacementNamed(_navBarItemLinks[index]);
                    }
                  },
                  extended: isLargeScreen,
                  leading: SizedBox(
                    height: 100, // Adjust the height as needed
                    child: Center(
                      child: isLargeScreen ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          PhosphorIcon(PhosphorIconsFill.chalkboardTeacher, size: 26), // Example icon
                          SizedBox(width: 8), // Space between icon and text
                          Text(
                            'Faculty Support Desk',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ) : const PhosphorIcon(PhosphorIconsDuotone.chalkboardTeacher, size: 50),
                    ),
                  ),
                  destinations: _navBarItems
                      .map((item) => NavigationRailDestination(
                      icon: item.icon,
                      selectedIcon: item.activeIcon,
                      label: Text(
                        item.label!,
                      )))
                      .toList(),
                ),
              ),
            const VerticalDivider(thickness: 1, width: 1),
            // This is the main content.
            SizedBox(
              width: isSmallScreen ? width * 0.99 : mainContainerWidth,
              child: Column(
                children: [
                  Card(
                    margin: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 15
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15), // Adjust the value as needed
                    ),
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 20
                        ),
                        child: SizedBox(
                          width: 1225,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(widget.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Row(
                                  children: [
                                    const PhosphorIcon(PhosphorIconsRegular.user),
                                    const SizedBox(width: 5),
                                    Text( facultyName,
                                      style: const TextStyle(
                                          fontSize: 16,
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          )
                        )
                    ),
                  ),
                  Expanded(
                    child: widget.content,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
