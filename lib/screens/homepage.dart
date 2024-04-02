import 'package:flutter/material.dart';
import 'package:iocl_app/screens/dashboardpage.dart';
import 'package:iocl_app/screens/profilepage.dart';
import 'package:iocl_app/screens/requestspage.dart';
import '../utils/consts.dart';
import 'adminpage.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    const DashboardPage(),
    const ProfilePage(),
    const RequestsPage(),
    const AdminPage(),

  ];
  Future<bool> checkIsUserAdmin () async {

    final querySnapshot = await db
        .collection("admin").where("email", isEqualTo: currentUser?.email)
        .get();
    isUserAdmin = querySnapshot.docs.isNotEmpty;
    final userSnapshot = await db
        .collection("user").where("emailId", isEqualTo: currentUser?.email)
        .get();
    print(userSnapshot.docs);
    if(userSnapshot.docs.isNotEmpty) {
      loggedInUser = userSnapshot.docs[0].data();
    }
    return isUserAdmin;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _pages[_selectedIndex],
      bottomNavigationBar: FutureBuilder<bool>(
        future: checkIsUserAdmin(),
        builder: (context, snapshot) {
          return BottomNavigationBar(
            selectedItemColor: const Color(0xffED6B21),
            unselectedItemColor: Colors.black,
            items:  snapshot.data == true ? [
              const BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ) ,
              const BottomNavigationBarItem(
                icon: Icon(Icons.admin_panel_settings),
                label: 'Admin',

              ) ,
              const BottomNavigationBarItem(
                icon: Icon(Icons.request_page_outlined),
                label: 'Requests',
              ),

            ] : [
              const BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),

              const BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped
          );
        }
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

}
