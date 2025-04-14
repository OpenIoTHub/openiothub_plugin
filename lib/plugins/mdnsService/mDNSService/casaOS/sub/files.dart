import 'package:flutter/material.dart';

class FileManagerPage extends StatefulWidget {
  const FileManagerPage({super.key});

  @override
  State<FileManagerPage> createState() => _FileManagerPageState();
}

class _FileManagerPageState extends State<FileManagerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Files"),
        ),
        body: Center(
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: ListView(
              children: [],
            ),
          ),
        ));
  }
}
