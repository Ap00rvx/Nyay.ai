import 'package:flutter/material.dart';

import '../../../features/ai_chat/view/ai_chat_page.dart';
import '../../../features/case_intake/view/case_intake_page.dart';
import '../../track/view/track_page.dart';

class DashboardShell extends StatefulWidget {
  const DashboardShell({super.key});

  static const routePath = '/dashboard';

  @override
  State<DashboardShell> createState() => _DashboardShellState();
}

class _DashboardShellState extends State<DashboardShell>
    with TickerProviderStateMixin {
  int index = 2; // default to New Case (AI=0, Track=1, New=2, Profile=3)

  late final pages = <Widget>[
    const AiChatPage(),
    const TrackPage(),
    const CaseIntakePage(),
    const _ProfileTab(),
  ];

  String _titleFor(int i) => switch (i) {
    0 => 'AI Assistant',
    1 => 'Your Cases',
    2 => 'Start a New Case',
    _ => 'Profile',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Image.asset("assets/images/logo.png"),
        ),
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: Text(_titleFor(index), key: ValueKey(index)),
        ),
        centerTitle: false,
      ),
      body: Stack(
        children: [
          // Keeps state of each tab
          IndexedStack(index: index, children: pages),
          // subtle gradient top overlay for depth
          IgnorePointer(
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 12,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Theme.of(context).colorScheme.surface.withOpacity(0.0),
                      Theme.of(context).colorScheme.surface.withOpacity(0.02),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) => setState(() => index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.smart_toy_outlined),
            label: 'AI',
          ),
          NavigationDestination(
            icon: Icon(Icons.timeline_outlined),
            label: 'Track',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline),
            label: 'New',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// Track tab UI is provided by TrackPage.

class _ProfileTab extends StatelessWidget {
  const _ProfileTab();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundColor: theme.colorScheme.primary,
            child: const Icon(Icons.person, color: Colors.white),
          ),
          title: const Text('Your Name'),
          subtitle: const Text('Client'),
          trailing: const Icon(Icons.edit_outlined),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.settings_outlined),
          title: const Text('Settings'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.privacy_tip_outlined),
          title: const Text('Privacy & Terms'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Log out'),
          onTap: () {},
        ),
      ],
    );
  }
}
