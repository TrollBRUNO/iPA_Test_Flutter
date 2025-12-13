import 'package:first_app_flutter/screens/admin/admin_screen.dart';
import 'package:first_app_flutter/screens/admin/edit_gallery_screen.dart';
import 'package:first_app_flutter/screens/admin/edit_news_screen.dart';
import 'package:first_app_flutter/screens/admin/edit_casino_screen.dart';
import 'package:first_app_flutter/screens/admin/edit_wheel_screen.dart';
import 'package:first_app_flutter/screens/confidential_screen.dart';
import 'package:first_app_flutter/screens/games_screen.dart';
import 'package:first_app_flutter/screens/jackpot_screen.dart';
import 'package:first_app_flutter/layout/layout_scaffold.dart';
import 'package:first_app_flutter/screens/news_screen.dart';
import 'package:first_app_flutter/screens/notification_screen.dart';
import 'package:first_app_flutter/screens/profile_screen.dart';
import 'package:first_app_flutter/screens/settings_screen.dart';
import 'package:first_app_flutter/screens/splash_screen.dart';
import 'package:first_app_flutter/screens/support_screen.dart';
import 'package:first_app_flutter/screens/wheel_screen.dart';
import 'package:first_app_flutter/screens/authorization_screen.dart';
import 'package:first_app_flutter/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),

    GoRoute(
      path: '/registration',
      builder: (context, state) => const RegistrationScreen(),
    ),
    GoRoute(
      path: '/authorization',
      builder: (context, state) => const AuthorizationScreen(),
    ),

    GoRoute(
      path: '/admin',
      builder: (context, state) => const AdminScreen(),
      routes: [
        GoRoute(
          path: '/edit_news',
          builder: (context, state) => const EditNewsPage(title: 'Edit'),
        ),
        GoRoute(
          path: '/edit_gallery',
          builder: (context, state) => const EditGalleryPage(title: 'Edit'),
        ),
        GoRoute(
          path: '/edit_casino',
          builder: (context, state) => const EditCasinoPage(title: 'Edit'),
        ),
        GoRoute(
          path: '/edit_wheel',
          builder: (context, state) => const EditWheelPage(title: 'Edit'),
        ),
        GoRoute(
          path: '/edit_app',
          builder: (context, state) => const EditNewsPage(title: 'Edit'),
        ),
        GoRoute(
          path: '/edit_reports',
          builder: (context, state) => const EditNewsPage(title: 'Edit'),
        ),
        GoRoute(
          path: '/view_statistics',
          builder: (context, state) => const EditNewsPage(title: 'View'),
        ),
      ],
    ),

    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => LayoutScaffold(
        navigationShell: navigationShell,
        body: navigationShell,
      ),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/news',
              builder: (context, state) => const NewsPage(title: 'News'),
            ),
          ],
        ),

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/jackpot',
              builder: (context, state) => const JackpotPage(title: 'Jackpot'),
            ),
          ],
        ),

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/wheel',
              builder: (context, state) => const WheelPage(title: 'Wheel'),
            ),
          ],
        ),

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/games',
              builder: (context, state) => const GamesPage(title: 'Games'),
            ),
          ],
        ),

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfilePage(title: 'Profile'),
              routes: [
                GoRoute(
                  path: '/settings',
                  builder: (context, state) =>
                      const SettingsPage(title: 'Settings'),
                ),
                GoRoute(
                  path: '/notification',
                  builder: (context, state) =>
                      const NotificationPage(title: 'Notification'),
                ),
                GoRoute(
                  path: '/support',
                  builder: (context, state) =>
                      const SupportPage(title: 'Support'),
                ),
                GoRoute(
                  path: '/confidential',
                  builder: (context, state) =>
                      const ConfidentialPage(title: 'Confidential'),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
