import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:xc/cubit/bluetooth_cubit.dart';
import 'package:xc/cubit/chat_cubit.dart';
import 'package:xc/cubit/comm_cubit.dart';
import 'package:xc/cubit/serial_cubit.dart';
import 'package:xc/cubit/settings_cubit.dart';
import 'package:xc/cubit/settings_state.dart';
import 'package:xc/static/themes.dart';
import 'package:xc/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => BluetoothCubit()),
        BlocProvider(create: (context) => ChatCubit()),
        BlocProvider(create: (context) => CommCubit()),
        BlocProvider(create: (context) => SerialCubit()),
        BlocProvider(create: (context) => SettingsCubit()),
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return MaterialApp(
            title: "Axes Controller",
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
