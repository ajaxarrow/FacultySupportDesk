import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key, required this.index, required this.content});
  final int index;
  final Widget content;

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
];

var _navBarItemLinks = [
  '/main',
  '/history',
  '/calendar'
];


class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      _selectedIndex = widget.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isSmallScreen = width < 600;
    final bool isLargeScreen = width > 800;

    return Scaffold(
      bottomNavigationBar: isSmallScreen
          ? BottomNavigationBar(
          items: _navBarItems,
          currentIndex: _selectedIndex,
          onTap: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          })
          : null,
      body: Row(
        children: <Widget>[
          if (!isSmallScreen)
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (int index) {
                Navigator.of(context).pushReplacementNamed(_navBarItemLinks[index]);
              },
              extended: isLargeScreen,
              leading: Container(
                height: 100, // Adjust the height as needed
                child: const Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PhosphorIcon(PhosphorIconsFill.chalkboardTeacher, size: 26), // Example icon
                      SizedBox(width: 8), // Space between icon and text
                      Text(
                        'Faculty Support Desk',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
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
          const VerticalDivider(thickness: 1, width: 1),
          // This is the main content.
          Expanded(
            child: Center(
              child: widget.content
            ),
          )
        ],
      ),
    );
  }
}
