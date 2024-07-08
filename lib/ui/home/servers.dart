import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_v2y/common/data.dart';
import 'package:flutter_v2y/common/utils.dart';
import 'package:flutter_v2ray/flutter_v2ray.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ServersPage extends StatefulWidget {
  const ServersPage({super.key});

  @override
  State<ServersPage> createState() => _ServersPageState();
}

class _ServersPageState extends State<ServersPage> {
  late Box<Server> box;
  late List<Server> servers;
  String? coreVersion;
  String? value;
  late final FlutterV2ray flutterV2ray;
  List<String> failedServers = [];

  @override
  void initState() {
    super.initState();
    box = Hive.box<Server>(serverBoxName);
    servers = box.values.toList();
    servers.sort((a, b) {
      final pingA = a.ping ?? double.infinity.toInt();
      final pingB = b.ping ?? double.infinity.toInt();
      return pingB.compareTo(pingA);
    });
    flutterV2ray = FlutterV2ray(
      onStatusChanged: (V2RayStatus status) {
        if (mounted) {
          setState(() {
            // print(status.state);
            value = status.state.toString();

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

  Future<int?> delayed(String link) async {
    try {
      int delay;
      // if (value == 'CONNECTED') {
      //   delay = await flutterV2ray.getConnectedServerDelay();
      // } else {
      delay = await flutterV2ray.getServerDelay(config: link);
      // }

      if (!mounted) return null;
      return delay;
    } catch (e) {
      print("Error occurred: $e");
      return -1;
    }
  }

  Future<int?> computePing(String config) async {
    return await delayed(config);
  }

  Future<void> refreshPings() async {
    final box = Hive.box<Server>(serverBoxName);
    List<Server> updatedServers = [];
    for (Server server in servers) {
      final V2RayURL v2rayURL = FlutterV2ray.parseFromURL(server.url);
      String config = v2rayURL.getFullConfiguration();
      int? ping = await computePing(config);
      print(ping);
      if (ping != null && ping > 1) {
        print("yes");
        print(server.url);
        print(server.key);
        box.put(server.key, server.copyWith(ping: ping));
        updatedServers.add(server.copyWith(ping: ping));
      } else {
        print(server.key);
        box.delete(server.key);
        print("delete======");
        print(server.url);
        failedServers.add(server.url);
      }
      if (mounted) {
        setState(() {
          servers = updatedServers;
        });
      }
    }
  }
  @override
  void dispose() {
    servers.clear();
    failedServers.clear();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Servers',
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: Container(
        color: Colors.grey[900],
        child: Column(
          children: [
            const SizedBox(height: 8),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                onPressed: refreshPings,
                child: const Text(
                  'Refresh',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: servers.length,
                itemBuilder: (context, index) {
                  final ping = servers[index].ping;
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () async{
                        print("==============================");
                        final V2RayURL v2rayURL =
                           FlutterV2ray.parseFromURL(servers[index].url);
                        String fullConfig = v2rayURL.getFullConfiguration();
                        print(value);
                        if(value == 'CONNECTED'){
                          print("kir");
                          await flutterV2ray.stopV2Ray();
                        }
                        // این خط صفحه جاری را می‌بندد و fullConfig را به صفحه قبلی برمی‌گرداند
                        Navigator.pop(context, fullConfig);
                      },
                      child: Container(
                        height: 75,
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Text(
                                  "Server $index",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    ping != null ? "$ping ms" : "Loading...",
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  const SizedBox(width: 2),
                                  const Icon(
                                    Icons.signal_cellular_alt_rounded,
                                    color: Colors.white,
                                  ),
                                ],
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
          ],
        ),
      ),
    );
  }
}
