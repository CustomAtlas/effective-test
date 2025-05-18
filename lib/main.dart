import 'package:effective_test/characters/characters_bloc/characters_bloc.dart';
import 'package:effective_test/core/data/api.dart';
import 'package:effective_test/characters/screens/favorite_screen.dart';
import 'package:effective_test/characters/screens/main_screen.dart';
import 'package:effective_test/characters/widgets/navigation_bar_widgets.dart';
import 'package:effective_test/characters/widgets/sort_button_widget.dart';
import 'package:effective_test/characters/widgets/theme_switcher_widget.dart';
import 'package:effective_test/core/local_storages/database.dart';
import 'package:effective_test/core/local_storages/shared_preferences.dart';
import 'package:effective_test/core/providers/theme_provider.dart';
import 'package:effective_test/core/styles/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPrefs.sharedPreferences = await SharedPreferences.getInstance();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final apiClient = ApiClient();
  final database = AppDatabase();

  int index = 0;

  final List<Widget> screens = [
    const MainScreen(),
    const FavoriteScreen(),
  ];

  void onIndexTap(int i) => setState(() => index = i);

  @override
  Widget build(BuildContext context) {
    return ThemeInherited(
      notifier: ThemeProvider(context),
      child: BlocProvider(
        create: (context) => CharactersBloc(apiClient, database)..add(LoadCharactersEvent()),
        child: Builder(
          builder: (context) {
            final isDarkTheme = ThemeInherited.of(context).isDarkTheme;
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(brightness: Brightness.light),
              darkTheme: ThemeData(brightness: Brightness.dark),
              themeMode: isDarkTheme ? ThemeMode.dark : ThemeMode.light,
              home: SafeArea(
                child: Scaffold(
                  appBar: AppBar(
                    backgroundColor: isDarkTheme ? context.colors.invertedScaffold : context.colors.scaffold,
                    centerTitle: true,
                    title: Text(index == 0 ? 'Main' : 'Favorite'),
                    actions: [ThemeSwitcherWidget()],
                    actionsPadding: EdgeInsets.only(right: 16),
                    leading: index == 1 ? SortButtonWidget() : null,
                  ),
                  body: IndexedStack(
                    index: index,
                    children: screens,
                  ),
                  bottomNavigationBar: DecoratedBox(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: context.colors.invertedScaffold.withAlpha(80),
                          blurRadius: 20,
                          offset: const Offset(0, -1),
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: BottomNavigationBar(
                      onTap: onIndexTap,
                      iconSize: 26,
                      currentIndex: index,
                      showUnselectedLabels: false,
                      showSelectedLabels: false,
                      backgroundColor: isDarkTheme ? context.colors.invertedScaffold : context.colors.scaffold,
                      items: [
                        BottomNavigationBarItem(
                          icon: index == 0
                              ? const SelectedBottomBarItem(Icons.home)
                              : const BottomBarItem(Icons.home_outlined),
                          label: '',
                        ),
                        BottomNavigationBarItem(
                          icon: index == 1
                              ? const SelectedBottomBarItem(Icons.star)
                              : const BottomBarItem(Icons.star_border),
                          label: '',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
