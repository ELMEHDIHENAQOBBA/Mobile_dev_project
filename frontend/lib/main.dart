import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture/core/network/app_network.dart';
import 'package:flutter_clean_architecture/core/theme/app_theme.dart';
import 'package:flutter_clean_architecture/features/auth/providers/auth_providers.dart';
import 'package:flutter_clean_architecture/features/booking/data/datasources/booking_remote_data_source.dart';
import 'package:flutter_clean_architecture/features/booking/presentation/cubit/booking_cubit.dart';
import 'package:flutter_clean_architecture/features/guide_space/presentation/cubit/guide_dashboard_cubit.dart';
import 'package:flutter_clean_architecture/features/guides/data/datasources/guides_remote_data_source.dart';
import 'package:flutter_clean_architecture/features/guides/presentation/cubit/guides_cubit.dart';
import 'package:flutter_clean_architecture/router/app_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final dio = AppNetwork.createDio();

  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<GuidesCubit>(create: (_) => GuidesCubit(GuidesRemoteDataSource(dio))),
          BlocProvider<BookingCubit>(create: (_) => BookingCubit(BookingRemoteDataSource(dio))),
          BlocProvider<GuideDashboardCubit>(create: (_) => GuideDashboardCubit(dio)),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Tourist Guide',
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
    );
  }
}
