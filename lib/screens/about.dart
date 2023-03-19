import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:xc/bloc/app_info.dart' as app_info;

import '../components/messages.dart';

class About extends StatefulWidget {
  const About({Key? key}) : super(key: key);

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  final bloc = app_info.MyBloc();

  @override
  void initState() {
    bloc.add(app_info.Get());
    super.initState();
  }

  @override
  void dispose() {
    bloc.close();
    super.dispose();
  }

  Widget _fill() {
    return ListView(
      children: <Widget>[
        ListTile(
          title: Text(AppLocalizations.of(context)!.appVersion),
          subtitle:
              Text('${AppLocalizations.of(context)!.title} ${bloc.state.app}'),
          leading: const Icon(Icons.perm_device_information_rounded),
        ),
        const Divider(),
        ListTile(
          title: Text(AppLocalizations.of(context)!.runningOn),
          subtitle: Text(bloc.state.system),
          leading: const Icon(Icons.auto_awesome_outlined),
          onTap: () {
            Navigator.of(context).pushNamed('/about/deviceDetails');
          },
        ),
        const Divider(),
        ListTile(
          title: Text(AppLocalizations.of(context)!.legalInfo),
          subtitle: Text(AppLocalizations.of(context)!.legalData),
          leading: const Icon(Icons.balance_outlined),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.about)),
      body: BlocProvider(
        create: (_) => bloc,
        child: BlocListener<app_info.MyBloc, app_info.State>(
          listener: (context, state) {
            if (state is app_info.Error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.of(context)!.failedToLoadData),
                ),
              );
            }
          },
          child: BlocBuilder<app_info.MyBloc, app_info.State>(
            builder: (context, state) {
              if (state is app_info.Loading) {
                return Message.progressIndicator;
              } else if (state is app_info.Loaded) {
                return _fill();
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }
}
