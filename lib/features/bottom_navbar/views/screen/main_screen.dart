import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/core/services/notification_service.dart';
import 'package:fluxfoot_user/features/account/views/screens/account_screen.dart';
import 'package:fluxfoot_user/features/bottom_navbar/view_model/bloc/navigation_bloc.dart';
import 'package:fluxfoot_user/features/bottom_navbar/views/widgets/custom_bottom_nav_bar.dart';
import 'package:fluxfoot_user/features/cart/views/screen/carts_views.dart';
import 'package:fluxfoot_user/features/home/views/screens/home_screen.dart';
import 'package:fluxfoot_user/features/wishlists/views/screens/favorite_view.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    _syncNotificationToken();
  }

  /// Ensures the current device's FCM token is saved to Firestore
  Future<void> _syncNotificationToken() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final token = await NotificationService.getDeviceToken();
        if (token != null) {
          log("MainScreen: Syncing token to Firestore for ${user.uid}");
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({'fcmToken': token}, SetOptions(merge: true));
        }
      }
    } catch (e) {
      log("MainScreen: Error syncing token: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return BlocProvider(
      create: (context) => NavigationBloc(),
      child: Builder(
        builder: (context) {
          final navigationBloc = context.read<NavigationBloc>();

          return Scaffold(
            body: Stack(
              children: [
                // 1. The Main App UI
                PageView(
                  controller: navigationBloc.pageController,
                  onPageChanged: (index) {
                    navigationBloc.add(NavigationTabChanged(index));
                  },
                  children: const [
                    HomeScreen(),
                    CartsViews(),
                    Favourites(),
                    AccountScreen(),
                  ],
                ),

                // 2. The Invisible Notification Listener (PERMANENT FIX)
                if (user != null)
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uid)
                        .collection('notifications')
                        .where('isRead', isEqualTo: false)
                        .snapshots(),
                    builder: (context, snapshot) {
                      // Whenever a new notification document arrives...
                      if (snapshot.hasData && snapshot.data!.docChanges.isNotEmpty) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          for (var change in snapshot.data!.docChanges) {
                            if (change.type == DocumentChangeType.added) {
                              final data = change.doc.data() as Map<String, dynamic>?;
                              if (data != null) {
                                // Show the banner
                                NotificationService.showInstantNotification(
                                  title: data['title'] ?? "Order Update",
                                  body: data['body'] ?? "Your order status has changed.",
                                );
                                // Mark as read
                                change.doc.reference.update({'isRead': true});
                              }
                            }
                          }
                        });
                      }
                      return const SizedBox.shrink(); // Invisible
                    },
                  ),
              ],
            ),
            bottomNavigationBar: const CustomBottomNavBar(),
          );
        },
      ),
    );
  }
}
