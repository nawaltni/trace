import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:trace/src/routing/app_router.dart';
import 'package:trace/src/features/authentication/data/auth_repository.dart';

class CommonDrawer extends ConsumerWidget {
  const CommonDrawer({
    super.key,
    // required this.authRepository,
  });

  // final AuthRepository authRepository;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentProfile = ref.watch(currentProfileProvider);
    final authRepository = ref.watch(authRepositoryProvider);
    return Drawer(
      child: ListView(
        children: [
          currentProfile.when(
            data: (currentProfile) => UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFF11171F),
              ),
              accountName: Text(currentProfile?.name ?? ""),
              accountEmail: Text(currentProfile?.email ?? ""),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  size: 50,
                ),
              ),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => const Center(child: Text('Error')),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text("Dashboard"),
            onTap: () => ref.read(goRouterProvider).push('/dashboard'),
          ),
          ListTile(
            leading: const Icon(Icons.door_sliding),
            title: const Text("Check in"),
            onTap: () => ref.read(goRouterProvider).push('/checkin'),
          ),
          ListTile(
            leading: const Icon(Icons.assignment),
            title: const Text("Encuestas"),
            onTap: () => ref.read(goRouterProvider).push('/survey'),
          ),
          // ListTile(
          //   leading: const Icon(Icons.map),
          //   title: const Text("Itinerario"),
          //   onTap: () {},
          // ),
          // ListTile(
          //   leading: const Icon(Icons.note_add),
          //   title: const Text("Evaluaciones"),
          //   onTap: () {},
          // ),
          // ListTile(
          //   leading: const Icon(Icons.store),
          //   title: const Text("Puntos de Ventas"),
          //   onTap: () {},
          // ),
          // ListTile(
          //   leading: const Icon(Icons.notifications),
          //   title: const Text("Notificaciones"),
          //   onTap: () {},
          // ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Perfil"),
            onTap: () => ref.read(goRouterProvider).push('/profile'),
          ),
          ListTile(
            leading: const Icon(Icons.location_on),
            title: const Text("Ubicación Actual"),
            onTap: () => ref.read(goRouterProvider).push('/currentLocation'),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Sign Out"),
            onTap: () => authRepository.signOut(),
          ),
        ],
      ),
    );
  }
}
