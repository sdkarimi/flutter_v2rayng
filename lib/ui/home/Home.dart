import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_v2y/data/repo/config_repository.dart';
import 'package:flutter_v2y/theme.dart';
import 'package:flutter_v2y/ui/about/about.dart';
import 'package:flutter_v2y/ui/home/bloc/home_bloc.dart';
import 'package:flutter_v2y/ui/home/servers.dart';
import 'package:flutter_v2ray/flutter_v2ray.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool tapIcon = false;
  dynamic serverSelected;

  void _navigateToServersPage(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ServersPage()),
    );

    if (result != null && mounted) {
      setState(() {
        serverSelected = result;
      });
      print(result.runtimeType);
    }
  }

  @override
  Widget build(BuildContext context) {
    const String root = "assets/img";
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: BlocProvider(
          create: (context) {
            final homeBloc = HomeBloc(configRepository: configRepository);
            homeBloc.add(HomeStarted());
            return homeBloc;
          },
          child: Scaffold(
            appBar: AppBar(
              title: Center(child: Text('SafeNet',
                  style: FontStyleDark.fonstMedium!.copyWith(
                      color: DarkTheme.foregroundColor, fontSize: 20))),
              leading: Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon: SvgPicture.asset("$root/icons/Ic_menu.svg"),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  );
                },
              ),
            ),
            drawer: const _Drawer(),
            backgroundColor: DarkTheme.backgroundColor,
            body: Column(
              children: [
                const SizedBox(
                  height: 16,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: DarkTheme.foregroundColor),
                      onPressed: () => _navigateToServersPage(context),
                      child: Text(
                        'Servers',
                        style: FontStyleDark.fonstMedium
                            .copyWith(color: DarkTheme.backgroundColor),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // اعمال عملیات مربوط به فشار دادن دکمه
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: DarkTheme.foregroundColor),
                      child: const Icon(
                        Icons.refresh,
                        color: DarkTheme.backgroundColor,
                      ),
                    ),
                  ],
                ),
                CustomExpandedWidget(
                  tapIcon: tapIcon,
                  onIconTap: () {
                    if (mounted) {
                      setState(() {
                        tapIcon = !tapIcon;
                      });
                    }
                  },
                  serverSelected: serverSelected ?? 'No server selected',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomExpandedWidget extends StatefulWidget {
  final bool tapIcon;
  final Function() onIconTap;
  final String serverSelected;

  const CustomExpandedWidget({
    Key? key,
    required this.tapIcon,
    required this.onIconTap,
    required this.serverSelected,
  }) : super(key: key);

  @override
  State<CustomExpandedWidget> createState() => _CustomExpandedWidgetState();
}

class _CustomExpandedWidgetState extends State<CustomExpandedWidget> {
  var v2rayStatus = ValueNotifier<V2RayStatus>(V2RayStatus());
  late final FlutterV2ray flutterV2ray;
  String? coreVersion;
  String? value;
  bool isConnecting = false;

  @override
  void initState() {
    super.initState();

    flutterV2ray = FlutterV2ray(
      onStatusChanged: (V2RayStatus status) {
        if (mounted) {
          setState(() {
            v2rayStatus.value =
                status; // Directly assign the V2RayStatus object
            if (status.state == 'CONNECTED') {
              isConnecting = false;
            }
          });
        }
      },
    );


    flutterV2ray.initializeV2Ray().then((_) async {
      coreVersion = await flutterV2ray.getCoreVersion();
      if (mounted) {
        setState(() {});
      }
    });
  }

  connect(String server, String nameServer) async {
    if (await flutterV2ray.requestPermission()) {
      setState(() {
        isConnecting = true;
      });
      await flutterV2ray.startV2Ray(
        remark: nameServer,
        config: server,
        proxyOnly: false,
      );
      if (mounted) {
        setState(() {
          isConnecting = false;
          widget.onIconTap(); // Toggle icon state
        });
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Permission Denied'),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    flutterV2ray.stopV2Ray();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const String root = "assets/img";
    return ValueListenableBuilder<V2RayStatus>(
      valueListenable: v2rayStatus,
      builder: (context, value, child) {
        return Expanded(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: SvgPicture.asset(
                  "$root/images/background.svg",
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                ),
              ),
              Positioned(
                bottom: 210,
                left: MediaQuery
                    .of(context)
                    .size
                    .width / 2 - 125,
                child: GestureDetector(
                  onTap: () async {
                    if (widget.serverSelected != "No server selected") {
                      if (widget.tapIcon == false) {
                        await connect(widget.serverSelected, 'serverName');
                        flutterV2ray =FlutterV2ray(
                            onStatusChanged: (V2RayStatus status) {
                              v2rayStatus.value=status;

                            });
                      } else {
                        await flutterV2ray.stopV2Ray();
                        setState(() {
                          isConnecting = false;
                          widget.onIconTap(); // Toggle icon state
                        });
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('No server selected'),
                        ),
                      );
                    }
                  },
                  child: AnimatedSwitcher(
                    duration: const Duration(seconds: 1),
                    child: SvgPicture.asset(
                      widget.tapIcon
                          ? "$root/icons/Ic_on.svg"
                          : "$root/icons/Ic_off.svg",
                      key: ValueKey<bool>(widget.tapIcon),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 120,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Speed: ',
                      style: FontStyleDark.fonstMedium.copyWith(
                          color: DarkTheme.backgroundColor),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      value.uploadSpeed,
                      style: FontStyleDark.fonstMedium.copyWith(
                          color: DarkTheme.backgroundColor),
                    ),
                    Text(
                      '↑',
                      style: FontStyleDark.fonstMedium.copyWith(
                          color: DarkTheme.backgroundColor),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      value.downloadSpeed.toString(),
                      style: FontStyleDark.fonstMedium.copyWith(
                          color: DarkTheme.backgroundColor),
                    ),
                    Text(
                      '↓',
                      style: FontStyleDark.fonstMedium.copyWith(
                          color: DarkTheme.backgroundColor),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 90,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Traffic:',
                      style: FontStyleDark.fonstMedium.copyWith(
                          color: DarkTheme.backgroundColor),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      value.upload.toString(),
                      style: FontStyleDark.fonstMedium.copyWith(
                          color: DarkTheme.backgroundColor),
                    ),
                    Text(
                      '↑',
                      style: FontStyleDark.fonstMedium.copyWith(
                          color: DarkTheme.backgroundColor),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      value.download.toString(),
                      style: FontStyleDark.fonstMedium.copyWith(
                          color: DarkTheme.backgroundColor),
                    ),
                    Text(
                      '↓',
                      style: FontStyleDark.fonstMedium.copyWith(
                          color: DarkTheme.backgroundColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Drawer extends StatelessWidget {
  const _Drawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: DarkTheme.backgroundColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: DarkTheme.foregroundColor,
            ),
            child: Center(
              child: Text(
                'SafeNet',
                style: FontStyleDark.fonstMedium!.copyWith(
                    fontSize: 30, color: DarkTheme.backgroundColor),
              ),
            ),
          ),
          ListTile(
            leading: SvgPicture.asset(
              "assets/img/icons/Ic_about.svg",
              colorFilter: const ColorFilter.mode(
                  DarkTheme.foregroundColor, BlendMode.srcIn),
            ),
            title: Text(
              'About',
              style: FontStyleDark.fonstMedium.copyWith(
                  color: DarkTheme.foregroundColor),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AboutScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}