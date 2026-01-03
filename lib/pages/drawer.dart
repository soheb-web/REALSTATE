import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:realstate/Controller/userProfileController.dart';
import 'package:realstate/Model/userProfileResModel.dart';
import 'package:realstate/pages/editProfile.page.dart';
import 'package:realstate/pages/login.page.dart';
import 'package:shimmer/shimmer.dart';

class AppDrawer extends ConsumerStatefulWidget {
  final AsyncValue<UserProfileResModel> profileController;
  const AppDrawer({super.key, required this.profileController});

  @override
  ConsumerState<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends ConsumerState<AppDrawer> {
  Future<void> showLogoutDialog() {
    var box = Hive.box("userdata");
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                box.clear();
                Fluttertoast.showToast(msg: "Log out Sucessfull");
                Navigator.pushAndRemoveUntil(
                  context,
                  CupertinoPageRoute(builder: (context) => LoginPage()),
                  (route) => false,
                );
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var box = Hive.box("userdata");
    final profileController = ref.watch(userProfileController);
    return Drawer(
      width: MediaQuery.of(context).size.width / 1.6,
      child: profileController.when(
        data: (user) {
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                width: double.infinity,
                height: 230.h,
                padding: EdgeInsets.only(left: 20.w, top: 20.h),
                decoration: BoxDecoration(color: Color(0xffFF6A2A)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(
                            user.data!.image ?? "https://i.pravatar.cc/150",
                          ), // optional
                        ),
                        Positioned(
                          top: 0,
                          bottom: -40,
                          right: -8,
                          child: Center(
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => EditProfilePage(),
                                  ),
                                );
                              },
                              child: Container(
                                width: 35.w,
                                height: 35.h,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.blueGrey,
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 20.sp,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Welcome, ${user.data!.name ?? "User"}',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${user.data!.email ?? "user@example.com"}',
                      style: GoogleFonts.inter(
                        color: Colors.white70,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              ),
              // Drawer Header (user profile या logo)

              // Menu Items
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Home'),
                selected: ModalRoute.of(context)?.settings.name == '/',
                onTap: () {
                  // Navigator.pop(context);  // drawer close
                  // setState(() => bottomIndex = 0);  // अगर state access हो तो
                },
              ),
              ListTile(
                leading: const Icon(Icons.description),
                title: const Text('My Listings'),
                onTap: () {
                  Navigator.pop(context);
                  // bottomIndex = 1; change करें (state access के लिए key use करें या provider)
                },
              ),
              ListTile(
                leading: const Icon(Icons.call),
                title: const Text('Call Us'),
                onTap: () {
                  Navigator.pop(context);
                  // bottomIndex = 2;
                },
              ),
              ListTile(
                leading: const Icon(Icons.bookmark),
                title: const Text('Saved'),
                onTap: () {
                  Navigator.pop(context);
                  // bottomIndex = 3;
                },
              ),

              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {
                  Navigator.pop(context);
                  // Settings page पर navigate
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () {
                  showLogoutDialog();
                },
              ),
            ],
          );
        },
        error: (error, stackTrace) {
          log(stackTrace.toString());
          return Center(child: Text(error.toString()));
        },
        loading: () {
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                width: double.infinity,
                height: 230.h,
                padding: EdgeInsets.only(left: 20.w, top: 20.h),
                decoration: const BoxDecoration(color: Color(0xffFF6A2A)),
                child: Shimmer.fromColors(
                  baseColor: Colors.white.withOpacity(0.4),
                  highlightColor: Colors.white.withOpacity(0.8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Profile image shimmer
                      Container(
                        width: 80,
                        height: 80,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(width: 160, height: 16, color: Colors.white),
                      const SizedBox(height: 8),
                      Container(width: 200, height: 14, color: Colors.white),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20.h),
              const DrawerMenuShimmer(),
            ],
          );
        },
      ),
    );
  }
}

class DrawerMenuShimmer extends StatelessWidget {
  const DrawerMenuShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey,
      highlightColor: Colors.grey,
      child: Column(
        children: List.generate(6, (index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // icon placeholder
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                const SizedBox(width: 16),

                // text placeholder
                Expanded(child: Container(height: 14, color: Colors.grey)),
              ],
            ),
          );
        }),
      ),
    );
  }
}
