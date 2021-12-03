import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class PathProviderPage extends StatefulWidget {
  @override
  _PathProviderPageState createState() => _PathProviderPageState();
}

class _PathProviderPageState extends State<PathProviderPage> {
  late Future<Directory> _tempDirectory;
  late Future<Directory> _appSupportDirectory;
  late Future<Directory> _appLibraryDirectory;
  late Future<Directory> _appDocumentsDirectory = Future.value();
  late Future<Directory> _externalStorageDirectory = Future.value();
  late Future<List<Directory>> _externalStorageDirectories = Future.value();
  late Future<List<Directory>> _externalCacheDirectories = Future.value();
  late Future<Directory> _downloadDirectory = Future.value();

  @override
  void initState() {
    super.initState();
    setState(() {
      _tempDirectory = getTemporaryDirectory();
      _appSupportDirectory = getApplicationSupportDirectory();
      _appLibraryDirectory = getLibraryDirectory();
      _appDocumentsDirectory = getApplicationDocumentsDirectory();
      getExternalStorageDirectory().then((value) {
          if (value != null) {
            _externalStorageDirectory = Future.value(value);
          }
      });
      getExternalCacheDirectories().then((value) {
        if (value != null) {
          _externalCacheDirectories = Future.value(value);
        }
      });
      getExternalStorageDirectories().then((value) {
        if (value != null) {
          _externalStorageDirectories = Future.value(value);
        }
      });
      getDownloadsDirectory().then((value) {
        if (value != null) {
          _downloadDirectory = Future.value(value);
        }
      });
    });
  }

  Widget _buildDirectory(
      BuildContext context, AsyncSnapshot<Directory?> snapshot) {
    Text text = const Text('');
    if (snapshot.connectionState == ConnectionState.done) {
      if (snapshot.hasError) {
        text = Text('Error: ${snapshot.error}');
      } else if (snapshot.hasData) {
        text = Text('path: ${snapshot.data?.path}');
      } else {
        text = const Text('path unavailable');
      }
    }
    return Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: text);
  }

  Widget _buildDirectories(
      BuildContext context, AsyncSnapshot<List<Directory>> snapshot) {
    Text text = const Text('');
    if (snapshot.connectionState == ConnectionState.done) {
      if (snapshot.hasError) {
        text = Text('Error: ${snapshot.error}');
      } else if (snapshot.hasData) {
        final String combined =
        snapshot.data!.map((Directory d) => d.path).join(', ');
        text = Text('paths: $combined');
      } else {
        text = const Text('path unavailable');
      }
    }
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16), child: text);
  }

  Widget _buildItem(String title, Future<Directory> future) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(title),
        ),
        FutureBuilder<Directory>(future: future, builder: _buildDirectory),
      ],
    );
  }

  Widget _buildItem1(String title, Future<List<Directory>> future) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(title),
        ),
        FutureBuilder<List<Directory>>(
            future: future,
            builder: _buildDirectories),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('path_provider 使用'),
      ),
      body: Center(
        child: ListView(
          itemExtent: 120,
          children: <Widget>[
            _buildItem('getTemporaryDirectory', _tempDirectory),
            _buildItem('getApplicationSupportDirectory', _appSupportDirectory),
            _buildItem('getLibraryDirectory', _appLibraryDirectory),
            _buildItem(
                'getApplicationDocumentsDirectory', _appDocumentsDirectory),
            _buildItem(
                'getExternalStorageDirectory', _externalStorageDirectory),
            _buildItem('getDownloadsDirectory', _downloadDirectory),

            _buildItem1('getExternalStorageDirectories',_externalStorageDirectories),
            _buildItem1('getExternalCacheDirectories',_externalCacheDirectories),

          ],
        ),
      ),
    );
  }

}