import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:media_gallery/media_gallery.dart';
import 'package:mixins/mixins.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pickers/src/constant_picker.dart';
import 'package:pickers/src/image_picker/camera.dart';

import 'albums.dart';
import 'labels.dart';
import 'medias.dart';
import 'selection.dart';
import 'validate.dart';

class MediaCollectionsPage extends StatefulWidget {
  final String? title;
  const MediaCollectionsPage({super.key, this.title});

  @override
  State<MediaCollectionsPage> createState() => _MediaCollectionsPageState();
}

class _MediaCollectionsPageState extends State<MediaCollectionsPage> with TickerProviderStateMixin {
  List<MediaCollection> collections = [];
  bool isLoading = true;

  Future<void> initGallery() async {
    Mixins.statusBar(); // Set status bar color
    final selection = MediaPickerSelection.of(context);

    try {
      List list = await MediaGallery.listMediaCollections(
        mediaTypes: selection.mediaTypes,
      );

      collections = list.cast<MediaCollection>();
      isLoading = false;

      setState(() {});
    } catch (_) {}
  }

  void openCamera() async {
    PermissionStatus status = await Permission.camera.request();
    clog(status);

    if (status.isGranted) {
      if (!mounted) return;

      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CameraScreen(),
        ),
      );

      clog(result);
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => initGallery());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final MediaPickerSelection selection = MediaPickerSelection.of(context);
    final labels = MediaPickerLabels.of(context);

    selection.tabController = TabController(length: 2, vsync: this);

    MediaCollection? allCollection;

    if (collections.isNotEmpty) {
      allCollection = collections.firstWhere(
        (c) => c.isAllCollection,
      );
    }

    return DefaultTabController(
      length: selection.mediaTypes.length + 1,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Ti.chevron_left, color: Colors.black54),
            onPressed: () => Navigator.pop(context),
          ),
          elevation: .5,
          title: Text(
            widget.title ?? 'Select Image',
            style: PickerConstant.style.copyWith(fontSize: 20, color: Colors.black54),
          ),
          actions: [IconButton(onPressed: () => openCamera(), icon: const Icon(Ti.camera, color: Colors.black54))],
        ),
        body: Stack(
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 44,
                ),
                Expanded(
                  child: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: selection.tabController,
                    children: [
                      ...selection.mediaTypes.map(
                        (e) => allCollection == null
                            ? const SizedBox()
                            : MediaGrid(
                                key: Key(e.toString()),
                                collection: allCollection,
                                mediaType: e,
                              ),
                      ),
                      MediaAlbums(
                        collections: collections
                            .where(
                              (e) => !e.isAllCollection,
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Positioned.fill(child: NavbarImagePicker()),
            Positioned.fill(
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: PickerValidateButton(
                      onValidate: (MediaPickerSelection selection) => {
                        Navigator.pop(context, {
                          'gallery': selection.selectedMedias,
                        }),
                      },
                    ))),
          ],
        ),
      ),
    );
  }
}

class NavbarImagePicker extends StatelessWidget {
  const NavbarImagePicker({super.key});

  @override
  Widget build(BuildContext context) {
    final selection = MediaPickerSelection.of(context);

    // ...selection.mediaTypes.map(
    //         (x) => Tab(
    //           text: x == MediaType.video ? labels.videos : labels.images,
    //         ),
    //       ),
    //       Tab(
    //         text: labels.albums,
    //       ),

    return Align(
      alignment: Alignment.topCenter,
      child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: AnimatedBuilder(
            animation: selection,
            builder: (context, _) => Intrinsic(
              children: List.generate(3, (i) {
                List<IconData> icons = [Ti.grid_dots, Ti.layout_list, Ti.photo];
                int selectionIndex = selection.tabController?.index ?? 0;

                return Expanded(
                  child: Container(
                    decoration: BoxDecoration(border: Br.only(['l'], except: i == 0)),
                    child: InkW(
                      onTap: () {
                        if (i >= 2) return;
                        selection.setTab(i);
                      },
                      padding: Ei.sym(v: 12, h: 15),
                      child: Icon(
                        icons[i],
                        color: i == selectionIndex ? Colors.blueAccent : Colors.black45,
                      ),
                    ),
                  ),
                );
              }),
            ),
          )),
    );
  }
}