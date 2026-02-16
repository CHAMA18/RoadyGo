import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../l10n/roadygo_i18n.dart';

import '/components/destination_picker/destination_picker_widget.dart';
import 'flutter_flow_widgets.dart';
import 'flutter_flow_util.dart';

class FlutterFlowPlacePicker extends StatefulWidget {
  const FlutterFlowPlacePicker({
    Key? key,
    required this.iOSGoogleMapsApiKey,
    required this.androidGoogleMapsApiKey,
    required this.webGoogleMapsApiKey,
    required this.defaultText,
    this.icon,
    required this.buttonOptions,
    required this.onSelect,
    this.proxyBaseUrl,
  }) : super(key: key);

  final String iOSGoogleMapsApiKey;
  final String androidGoogleMapsApiKey;
  final String webGoogleMapsApiKey;
  final String? defaultText;
  final Widget? icon;
  final FFButtonOptions buttonOptions;
  final Function(FFPlace place) onSelect;
  final String? proxyBaseUrl;

  @override
  _FFPlacePickerState createState() => _FFPlacePickerState();
}

class _FFPlacePickerState extends State<FlutterFlowPlacePicker> {
  String? _selectedPlace;

  String get googleMapsApiKey {
    if (kIsWeb) {
      return widget.webGoogleMapsApiKey;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        return '';
      case TargetPlatform.iOS:
        return widget.iOSGoogleMapsApiKey;
      case TargetPlatform.android:
        return widget.androidGoogleMapsApiKey;
      default:
        return widget.webGoogleMapsApiKey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FFButtonWidget(
      text: _selectedPlace ?? widget.defaultText ?? 'Search places',
      icon: widget.icon,
      onPressed: () async {
        // Use one unified picker on all platforms so Google Places search and
        // "Use Current Location" behave consistently.
        await _showWebPlacePicker(context);
      },
      options: widget.buttonOptions,
    );
  }

  Future<void> _showWebPlacePicker(BuildContext context) async {
    final currentLocation = await getCurrentUserLocation(
      defaultLocation: const LatLng(0.0, 0.0),
      cached: true,
    );
    await showDestinationPicker(
      context: context,
      onSelect: (place) {
        if (mounted) {
          setState(() {
            _selectedPlace = place.name.isNotEmpty ? place.name : place.address;
          });
        }
        widget.onSelect(place);
      },
      iOSGoogleMapsApiKey: widget.iOSGoogleMapsApiKey,
      androidGoogleMapsApiKey: widget.androidGoogleMapsApiKey,
      webGoogleMapsApiKey: widget.webGoogleMapsApiKey,
      title: widget.defaultText ?? context.tr('search'),
      hintText: widget.defaultText ?? 'Search places...',
      currentLocation: currentLocation,
    );
  }
}
