import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:xc/cubit/bluetooth_cubit.dart';
import 'package:xc/cubit/comm_cubit.dart';
import 'package:xc/cubit/settings_cubit.dart';
import 'package:xc/cubit/settings_state.dart';
import 'package:xc/static/themes.dart';
import 'package:xc/routes.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SettingsCubit()),
        BlocProvider(create: (context) => BluetoothCubit()),
        BlocProvider(create: (context) => CommCubit()),
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return MaterialApp(
            title: "xC",
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: state.theme,
            locale: state.locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            routes: routes,
            initialRoute: "/",
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
