import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trace/domain/profile.dart';
import 'package:trace/src/features/authentication/data/firebase_auth_repository.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // var authProvider = ref.watch(authRepositoryProvider);
    AsyncValue<UserProfile?> userProfile = ref.watch(currentProfileProvider);
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return userProfile.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => const Center(child: Text("Error")),
        data: (profile) => Scaffold(
              appBar: AppBar(
                leading: IconButton(
                    // onPressed: () => Get.back(),
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_ios_new)),
                // icon: const Icon(LineAwesomeIcons.angle_left)),
                title: const Text("Profile"),
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.light),
                  ),
                  // icon: Icon(isDark ? LineAwesomeIcons.sun : LineAwesomeIcons.moon))
                ],
              ),
              body: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      /// -- IMAGE
                      Stack(
                        children: [
                          SizedBox(
                            width: 120,
                            height: 120,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: const Image(
                                    image: AssetImage("lib/images/profile.png"),
                                    fit: BoxFit.cover)),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Colors.redAccent),
                              child: const Icon(
                                Icons.person_pin_circle,
                                // LineAwesomeIcons.alternate_pencil,

                                color: Colors.black,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(profile!.name),

                      const SizedBox(height: 10),
                      Text(profile.email),

                      const SizedBox(height: 20),

                      /// -- BUTTON
                      SizedBox(
                        width: 200,
                        child: ElevatedButton(
                          onPressed: () => {},
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              side: BorderSide.none,
                              shape: const StadiumBorder()),
                          child: const Text("Edit Profile",
                              style: TextStyle(color: Colors.yellow)),
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Divider(),
                      const SizedBox(height: 10),

                      // /// -- MENU
                      // ProfileMenuWidget(
                      //     title: "Settings",
                      //     icon: LineAwesomeIcons.cog,
                      //     onPress: () {}),
                      // ProfileMenuWidget(
                      //     title: "Billing Details",
                      //     icon: LineAwesomeIcons.wallet,
                      //     onPress: () {}),
                      // ProfileMenuWidget(
                      //     title: "User Management",
                      //     icon: LineAwesomeIcons.user_check,
                      //     onPress: () {}),
                      // const Divider(),
                      // const SizedBox(height: 10),
                      // ProfileMenuWidget(
                      //     title: "Information",
                      //     icon: LineAwesomeIcons.info,
                      //     onPress: () {}),
                      // ProfileMenuWidget(
                      //     title: "Logout",
                      //     icon: LineAwesomeIcons.alternate_sign_out,
                      //     textColor: Colors.red,
                      //     endIcon: false,
                      //     onPress: () {
                      //       Get.defaultDialog(
                      //         title: "LOGOUT",
                      //         titleStyle: const TextStyle(fontSize: 20),
                      //         content: const Padding(
                      //           padding: EdgeInsets.symmetric(vertical: 15.0),
                      //           child: Text("Are you sure, you want to Logout?"),
                      //         ),
                      //         confirm: Expanded(
                      //           child: ElevatedButton(
                      //             onPressed: () =>
                      //                 AuthenticationRepository.instance.logout(),
                      //             style: ElevatedButton.styleFrom(
                      //                 backgroundColor: Colors.redAccent,
                      //                 side: BorderSide.none),
                      //             child: const Text("Yes"),
                      //           ),
                      //         ),
                      //         cancel: OutlinedButton(
                      //             onPressed: () => Get.back(), child: const Text("No")),
                      //       );
                      //     }),
                    ],
                  ),
                ),
              ),
            ));
  }
}
