import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/models/user.dart';
import 'package:tutorconnect/routes/app_routes.dart';
import 'package:tutorconnect/providers/auth_provider.dart';
import 'package:tutorconnect/providers/user_provider.dart';
import 'package:tutorconnect/widgets/notifications_widget.dart';
import 'package:tutorconnect/widgets/profile_widget.dart';
import 'package:tutorconnect/widgets/tutoring_widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final currentUserAsync = ref.watch(currentUserProvider);

    return currentUserAsync.when(
      data: (customUser) {
        if (customUser == null) {
          return const Scaffold(
            body: Center(child: Text('User not found or not logged in')),
          );
        }

        final List<Widget> pages = <Widget>[
          const TutoringWidget(),
          const NotificationsWidget(),
          ProfileWidget(customUser: customUser),
        ];

        return Scaffold(
          appBar: AppBar(
            title: const Text('TutorConnect'),
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                tooltip: 'Log Out',
                onPressed: () async {
                  await ref.read(signOutProvider.future);
                  Navigator.pushReplacementNamed(context, AppRoutes.login);
                },
              ),
            ],
          ),
          body: pages[_selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.school),
                label: 'Tutoring',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications),
                label: 'Notifications',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        body: Center(child: Text('Error: $error')),
      ),
    );
  }
}
