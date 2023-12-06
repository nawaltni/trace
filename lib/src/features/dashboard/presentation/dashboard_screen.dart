import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trace/src/features/authentication/data/firebase_auth_repository.dart';

class Page {
  final String title;
  final IconData icon;
  const Page(this.title, this.icon);
}

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  final List<Page> pages = const <Page>[
    Page('Dashboard', Icons.dashboard),
    Page('Itinerario', Icons.map),
    Page('Evaluaciones', Icons.note_add),
    Page('Puntos de Ventas', Icons.store),
    Page('Notificaciones', Icons.notifications),
    Page('Perfil', Icons.person),
  ];

  void signUserOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authRepository = ref.watch(authRepositoryProvider);
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard"), actions: [
        TextButton(onPressed: () {}, child: const Text("Grupo Q.")),
      ]),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: Text("Drawer Header")),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text("Dashboard"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.map),
              title: const Text("Itinerario"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.note_add),
              title: const Text("Evaluaciones"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.store),
              title: const Text("Puntos de Ventas"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text("Notificaciones"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Perfil"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Sign Out"),
              onTap: () => authRepository.signOut(),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 1.5,
              shrinkWrap: true,
              children: List.generate(pages.length, (index) {
                return Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(pages[index].icon, size: 50),
                        Text(pages[index].title),
                      ],
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 40),
            const Text(
              'Progreso del día',
              style: TextStyle(fontSize: 16),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: const LinearProgressIndicator(
                value: 0.8,
                minHeight: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
