import 'package:flutter/material.dart';
import 'package:mixins/mixins.dart';
import 'package:pickers/pickers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Pickers',
      home: MyHomePage(title: 'Pickers Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
                onPressed: () async {
                  DateTime? dateTime = await Pickers.datePicker(context);
                  clog(dateTime);
                },
                child: const Text('Show Date Picker')),
            const SizedBox(height: 20),
            TextButton(
                onPressed: () async {
                  DateTime? dateTime = await Pickers.timePicker(context);
                  String time = Mixins.dateFormat(dateTime, format: 'HH:mm');
                  clog(time);
                },
                child: const Text('Show Time Picker')),
            const SizedBox(height: 20),
            TextButton(
                onPressed: () async {
                  List<Media>? images = await Pickers.imagePicker(context, maxImages: 5);
                  if (images != null) {}
                },
                child: const Text('Show Image Picker')),
          ],
        ),
      ),
    );
  }
}
