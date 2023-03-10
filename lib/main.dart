// ignore_for_file: prefer_const_constructors

import 'dart:developer';
//import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter/material.dart';
import 'package:github/github.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Application name
      title: 'Domipoke\'s Store',
      // Application theme data, you can set the colors for the application as
      // you want
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // A widget which will be started on application startup
      home: const MyHomePage(title: 'Domipoke\'s Store'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // The title text which will be shown on the action bar
        title: Text(title),
      ),
      body: Center(
        child: FutureBuilder<List<Widget>>(
          future: getRows(),
          builder: (context, AsyncSnapshot<List<Widget>> snapshot) {
            if (snapshot.hasData) {
              return Column(children: snapshot.data??[]);
            } else {
              return SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  Future<List<Widget>> getRows() async {
    List<Future<Release>> frs = await fetchRep();
    List<Row> rs = [];
    for (var f in frs) {
      rs.add(card(await f));
    }
    return rs;
  }

  Row card(Release app) {
    return Row(children: [
      Expanded(
        child: OutlinedButton(
          onPressed: () => {download(app)},
          child: Column(
            children: [
              Text((app.assets?.first.name??"").split(".")[0]),
              Text(app.name ?? ""),
            ],
          )
        )
      ),
    ]);
  }

  Future<void> download(Release app) async {
    // var github = GitHub(auth: Authentication.anonymous());
    // print((app.url ?? "") +
    //     (app.htmlUrl ?? "") +
    //     (app.assetsUrl ?? "") +
    //     (app.uploadUrl ?? "") +
    //     (app.tarballUrl ?? "") +
    //     (app.zipballUrl ?? ""));
    String? url=app.assets?.first.browserDownloadUrl;
    if (url!=null){
      
    }else{print("Nothing Found");}
  }

  Future<List<Future<Release>>> fetchRep() async {
    var github = GitHub(auth: Authentication.anonymous());

    var x = await github.users.getUser("DomipokeApk");
    return await github.repositories
        .listUserRepositories("DomipokeApk")
        .map((element) async => await github.repositories.listReleases(element.slug()).first)
        .toList();
  }
}
