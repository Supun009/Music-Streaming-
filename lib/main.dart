import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music/core/theme/theme.dart';
import 'package:music/features/auth/model/current_user_notifier.dart';

import 'package:music/features/auth/viewmodel/auth_view_model.dart';
import 'package:music/features/home/view/pages/home_page.dart';

import 'features/auth/view/pages/login_page.dart';

// import 'package:music/features/auth/view/pages/sign_up_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final container = ProviderContainer();
  await container.read(authViewModelProvider.notifier).initSharedPref();
  await container.read(authViewModelProvider.notifier).getUSerData();

  runApp(UncontrolledProviderScope(
    container: container,
    child: const MyApp(),
  ));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserNotifierProvider);

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkThemeMode,
        home: currentUser == null ? const LoginPage() : const HomePage());
  }
}
