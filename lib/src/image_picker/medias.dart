import 'package:flutter/material.dart';
import 'package:media_gallery/media_gallery.dart';
import 'package:mixins/mixins.dart';

import 'labels.dart';
import 'selectable.dart';
import 'selection.dart';
import 'thumbnail.dart';
import 'validate.dart';

class MediasPage extends StatefulWidget {
  final MediaCollection collection;
  const MediasPage({
    super.key,
    required this.collection,
  });

  @override
  State<MediasPage> createState() => _MediaImagesPageState();
}

class _MediaImagesPageState extends State<MediasPage> {
  @override
  Widget build(BuildContext context) {
    final selection = MediaPickerSelection.of(context);
    final labels = MediaPickerLabels.of(context);
    return DefaultTabController(
      length: selection.mediaTypes.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.collection.name),
          // actions: <Widget>[
          //   PickerValidateButton(
          //     onValidate: (selection) => Navigator.pop(context, selection),
          //   ),
          // ],
          bottom: selection.mediaTypes.length > 1
              ? TabBar(
                  tabs: selection.mediaTypes
                      .map(
                        (x) => Tab(
                          text: x == MediaType.video ? labels.videos : labels.images,
                        ),
                      )
                      .toList(),
                )
              : null,
        ),
        body: Stack(
          children: [
            Column(children: [
              Expanded(
                child: TabBarView(
                  children: selection.mediaTypes
                      .map(
                        (x) => MediaGrid(
                          key: Key(x.toString()),
                          collection: widget.collection,
                          mediaType: x,
                        ),
                      )
                      .toList(),
                ),
              ),
            ]),
            Positioned.fill(
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: PickerValidateButton(
                      onValidate: (MediaPickerSelection selection) => {},
                    ))),
          ],
        ),
      ),
    );
  }
}

class MediaGrid extends StatefulWidget {
  final MediaCollection collection;
  final MediaType mediaType;

  const MediaGrid({
    Key? key,
    required this.mediaType,
    required this.collection,
  }) : super(key: key);

  @override
  State<MediaGrid> createState() => _MediaGridState();
}

class _MediaGridState extends State<MediaGrid> with AutomaticKeepAliveClientMixin {
  List<MediaPage> pages = [];
  bool isLoading = false;

  bool get canLoadMore => !isLoading && pages.isNotEmpty && (!pages.last.isLast);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initAsync();
    });
    super.initState();
  }

  Future<void> initAsync() async {
    setState(() {
      isLoading = true;
    });
    try {
      pages.add(
        await widget.collection.getMedias(
          mediaType: widget.mediaType,
          take: 50,
        ),
      );
      setState(() {});
    } catch (_) {
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> loadMore() async {
    setState(() {
      isLoading = true;
    });
    try {
      final nextPage = await pages.last.nextPage();
      pages.add(nextPage);
    } catch (_) {
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final mediaQuery = MediaQuery.of(context);
    final allMedias = pages.expand((x) => x.items);
    final crossAxisCount = (mediaQuery.size.width / 128).ceil();
    final selection = MediaPickerSelection.of(context);
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (canLoadMore && scrollInfo.metrics.pixels + mediaQuery.size.height >= scrollInfo.metrics.maxScrollExtent) {
          loadMore();
        }
        return false;
      },
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView(
              padding: Ei.all(0),
              physics: BounceScroll(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: 1.0,
              ),
              children: <Widget>[
                ...allMedias.map<Widget>(
                  (e) => AnimatedBuilder(
                    key: Key(e.id),
                    animation: selection,
                    builder: (context, _) => InkWell(
                      onTap: () => selection.toggle(e),
                      child: Selectable(
                        isSelected: selection.contains(e),
                        number: (selection.selectedMedias.indexWhere((m) => m.id == e.id) + 1),
                        child: MediaThumbnailImage(
                          media: e,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
