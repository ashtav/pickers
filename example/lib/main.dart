import 'package:flutter/material.dart';
import 'package:mixins/mixins.dart';
import 'package:pickers/pickers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Mixins.setSystemUI(navBarColor: Colors.white);

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
    Mixins.statusBar();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: .5,
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.black54),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
                onPressed: () async {
                  DateTime? dateTime = await Pickers.datePicker(context);
                  logg(dateTime);
                },
                child: const Text('Show Date Picker')),
            const SizedBox(height: 20),
            TextButton(
                onPressed: () async {
                  DateTime? dateTime = await Pickers.timePicker(context);
                  String time = (dateTime ?? DateTime.now()).format('HH:mm');
                  logg(time);
                },
                child: const Text('Show Time Picker')),
            const SizedBox(height: 20),
            TextButton(
                onPressed: () async {
                  List<Media>? images = await Pickers.imagePicker(context,
                      title: 'Pilih Gambar',
                      maxImages: 5,
                      labels: const MediaPickerLabels(
                        textConfirm: 'Pilih',
                      ));
                  if (images != null) {
                    logg(images);
                  }
                },
                child: const Text('Show Image Picker')),
          ],
        ),
      ),
    );
  }
}
