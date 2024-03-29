// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:media_gallery/media_gallery.dart';
import 'package:mixins/mixins.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pickers/src/image_picker/labels.dart';
import 'package:pickers/src/image_picker/picker.dart';
import 'package:pickers/src/image_picker/selection.dart';

import 'cupertino_datepicker.dart';
import 'cupertino_timepicker.dart';

class Pickers {
  /* ------------------------------------------------------------
  | DATE PICKER
  ------------------------------------ */

  static Future<DateTime?> datePicker(BuildContext context,
      {DateTime? initialDate,
      DateTime? firstDate,
      DateTime? lastDate,
      String confirmLabel = 'Confirm',
      bool useShortMonths = false,
      bool monthYearOnly = false,
      bool yearOnly = false,
      AlignmentGeometry? alignment}) async {
    if (firstDate != null && lastDate != null && firstDate.isAfter(lastDate)) {
      logg('[Pickers] - First date must be smaller than last date');
      return null;
    }

    DateTime? result = await showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (c) => CupertinoDatePickerWidget(
            initialDate: initialDate,
            firstDate: firstDate,
            lastDate: lastDate,
            useShortMonths: useShortMonths,
            monthYearOnly: monthYearOnly,
            yearOnly: yearOnly,
            alignment: alignment,
            confirmLabel: confirmLabel));

    return result;
  }

  /* ------------------------------------------------------------
  | TIME PICKER
  ------------------------------------ */

  static Future<DateTime?> timePicker(
    BuildContext context, {
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    String confirmLabel = 'Confirm',
  }) async {
    if (firstDate != null && lastDate != null && firstDate.isAfter(lastDate)) {
      logg('[Pickers] - First date must be smaller than last date');
      return null;
    }

    DateTime? result = await showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (c) => CupertinoTimePickerWidget(initialDate: initialDate, firstDate: firstDate, lastDate: lastDate, confirmLabel: confirmLabel));

    return result;
  }

  /* ------------------------------------------------------------
  | IMAGE PICKER
  ------------------------------------ */

  static Future<List<Media>?> imagePicker(BuildContext context,
      {String? title, int maxImages = 1, MediaPickerLabels? labels, List<Media>? selectedMedias}) async {
    bool isGranted = false;

    if (Platform.isIOS) {
      PermissionStatus mediaStatus = await Permission.photos.status;
      isGranted = mediaStatus.isGranted;

      if (mediaStatus.isDenied) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Not authorized'),
            content: const Text("This app can't have access to user media gallery. You must update authorizations in app settings."),
            actions: <Widget>[
              TextButton(
                child: const Text('Open Settings'),
                onPressed: () => openAppSettings(),
              ),
            ],
          ),
        );
      }
    } else {
      isGranted = await Permission.storage.request().isGranted;
    }

    List<Media>? result;

    if (isGranted) {
      result = await AppNavigator.open(
          context,
          MediaPicker(
            title: title,
            labels: labels,
            initialSelection: MediaPickerSelection(mediaTypes: [
              MediaType.image,
              // MediaType.video,
            ], maxItems: maxImages, selectedMedias: selectedMedias),
          ));
    }

    return result;
  }
}

class AppNavigator {
  static Future open(BuildContext context, Widget child) async {
    return Navigator.push(context, MaterialPageRoute(builder: (context) => child));
  }
}
