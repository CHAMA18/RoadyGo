import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:collection/collection.dart';
import 'package:http/http.dart' as http;
import 'package:go_taxi_rider/flutter_flow/flutter_flow_theme.dart';
import 'package:go_taxi_rider/flutter_flow/flutter_flow_util.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/l10n/roadygo_i18n.dart';

// Web-specific imports
import 'places_service_stub.dart'
    if (dart.library.js_interop) 'places_service_web.dart' as places_web;

/// A world-class destination picker with beautiful animations and UX
class DestinationPickerWidget extends StatefulWidget {
  const DestinationPickerWidget({
    super.key,
    required this.onSelect,
    required this.iOSGoogleMapsApiKey,
    required this.androidGoogleMapsApiKey,
    required this.webGoogleMapsApiKey,
    this.title = 'Where to?',
    this.hintText = 'Search destination...',
    this.currentLocation,
  });

  final Function(FFPlace place) onSelect;
  final String iOSGoogleMapsApiKey;
  final String androidGoogleMapsApiKey;
  final String webGoogleMapsApiKey;
  final String title;
  final String hintText;
  final LatLng? currentLocation;

  @override
  State<DestinationPickerWidget> createState() =>
      _DestinationPickerWidgetState();
}

class _DestinationPickerWidgetState extends State<DestinationPickerWidget>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  List<PlaceSearchResult> _searchResults = [];
  bool _isLoading = false;
  bool _showResults = false;
  final List<SavedLocation> _customSavedLocations = <SavedLocation>[];
  GoogleMapsPlaces? _places;
  Timer? _debounceTimer;
  String get googleMapsApiKey {
    if (kIsWeb) {
      return widget.webGoogleMapsApiKey;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return widget.iOSGoogleMapsApiKey;
      case TargetPlatform.android:
        return widget.androidGoogleMapsApiKey;
      default:
        return widget.webGoogleMapsApiKey;
    }
  }

  List<PopularDestination> _popularDestinations(BuildContext context) => [
        PopularDestination(
          name: 'Charging Station',
          icon: Icons.ev_station_rounded,
          category: 'electric_vehicle_charging_station',
          color: Color(0xFF5C6BC0),
        ),
        PopularDestination(
          name: 'Care Tire',
          icon: Icons.car_repair_rounded,
          category: 'car_repair',
          color: Color(0xFFEC407A),
        ),
        PopularDestination(
          name: 'Car Battery',
          icon: Icons.battery_charging_full_rounded,
          category: 'car_repair',
          color: Color(0xFFEF5350),
        ),
        PopularDestination(
          name: 'Parking Lot',
          icon: Icons.local_parking_rounded,
          category: 'parking',
          color: Color(0xFFFF7043),
        ),
        PopularDestination(
          name: 'Petrol Station',
          icon: Icons.local_gas_station_rounded,
          category: 'gas_station',
          color: Color(0xFF26A69A),
        ),
        PopularDestination(
          name: 'Car Repair Shop',
          icon: Icons.build_rounded,
          category: 'car_repair',
          color: Color(0xFF42A5F5),
        ),
      ];

  List<SavedLocation> _savedLocations(BuildContext context) =>
      List<SavedLocation>.from(_customSavedLocations);

  @override
  void initState() {
    super.initState();
    _initPlaces();
    _initAnimations();
    _loadSavedLocations();

    // Auto focus the search field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  Future<void> _loadSavedLocations() async {
    try {
      if (currentUserReference == null) return;
      final records = await querySavedPlaceRecordOnce(
        parent: currentUserReference,
        queryBuilder: (q) => q.orderBy('created_time', descending: true),
      );
      final parsed = records
          .map(
            (record) => SavedLocation(
              name: record.name,
              address: record.address,
              icon: Icons.bookmark_rounded,
              latLng: LatLng(record.latitude, record.longitude),
            ),
          )
          .toList();

      if (!mounted) return;
      setState(() {
        _customSavedLocations
          ..clear()
          ..addAll(parsed);
      });
    } catch (e) {
      debugPrint('Error loading saved places: $e');
    }
  }

  void _initPlaces() async {
    if (!kIsWeb) {
      _places = GoogleMapsPlaces(
        apiKey: googleMapsApiKey,
        apiHeaders: await const GoogleApiHeaders().getHeaders(),
      );
    }
  }

  void _initAnimations() {
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    _slideController.forward();
    _fadeController.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _slideController.dispose();
    _fadeController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      _searchPlaces(query);
    });
  }

  Future<void> _searchPlaces(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _showResults = false;
      });
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (kIsWeb) {
        // Use JavaScript Places API for web
        final results = await places_web.searchPlaces(
          query,
          googleMapsApiKey,
          widget.currentLocation?.latitude ?? -15.4167,
          widget.currentLocation?.longitude ?? 28.2833,
        );

        setState(() {
          _searchResults = results;
          _showResults = true;
          _isLoading = false;
        });
      } else {
        // Use google_maps_webservice for mobile
        final response = await _places?.autocomplete(
          query,
          language: 'en',
          location: widget.currentLocation != null
              ? Location(
                  lat: widget.currentLocation!.latitude,
                  lng: widget.currentLocation!.longitude,
                )
              : null,
          radius: 50000,
        );

        if (response?.status == 'OK' && response?.predictions != null) {
          setState(() {
            _searchResults = response!.predictions
                .map((p) => PlaceSearchResult(
                      placeId: p.placeId ?? '',
                      mainText: p.structuredFormatting?.mainText ??
                          p.description ??
                          '',
                      secondaryText:
                          p.structuredFormatting?.secondaryText ?? '',
                    ))
                .toList();
            _showResults = true;
            _isLoading = false;
          });
        } else {
          setState(() {
            _searchResults = [];
            _showResults = query.isNotEmpty;
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      debugPrint('Error searching places: $e');
      setState(() {
        _isLoading = false;
        _showResults = query.isNotEmpty;
      });
    }
  }

  Future<void> _searchByCategory(String category) async {
    setState(() => _isLoading = true);

    try {
      if (kIsWeb) {
        final results = await places_web.searchNearbyPlaces(
          category,
          googleMapsApiKey,
          widget.currentLocation?.latitude ?? -15.4167,
          widget.currentLocation?.longitude ?? 28.2833,
        );

        setState(() => _isLoading = false);

        if (results.isNotEmpty) {
          _showCategoryResults(results, category);
        }
      } else {
        final response = await _places?.searchNearbyWithRadius(
          Location(
            lat: widget.currentLocation?.latitude ?? -15.4167,
            lng: widget.currentLocation?.longitude ?? 28.2833,
          ),
          25000,
          type: category,
          language: 'en',
        );

        if (response?.status == 'OK' && response?.results != null) {
          final results = response!.results.take(10).map((place) {
            return PlaceSearchResult(
              placeId: place.placeId,
              mainText: place.name,
              secondaryText: place.formattedAddress ?? place.vicinity ?? '',
              lat: place.geometry?.location.lat ?? 0,
              lng: place.geometry?.location.lng ?? 0,
            );
          }).toList();

          setState(() => _isLoading = false);
          _showCategoryResults(results, category);
        } else {
          setState(() => _isLoading = false);
        }
      }
    } catch (e) {
      debugPrint('Error searching category: $e');
      setState(() => _isLoading = false);
    }
  }

  void _showCategoryResults(List<PlaceSearchResult> results, String category) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _CategoryResultsSheet(
        results: results,
        category: category,
        onSelect: (result) async {
          Navigator.pop(context);
          await _selectSearchResult(result);
        },
      ),
    );
  }

  Future<void> _selectSearchResult(PlaceSearchResult result) async {
    if (result.placeId.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final place = await _resolvePlaceFromResult(result);
      if (!mounted) return;
      if (place != null) {
        _selectPlace(place);
      }
    } catch (e) {
      debugPrint('Error getting place details: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _saveSearchResultAsSavedPlace(PlaceSearchResult result) async {
    if (result.placeId.isEmpty) return;
    setState(() => _isLoading = true);
    try {
      final place = await _resolvePlaceFromResult(result);
      if (!mounted) return;
      if (place == null) return;
      await _savePlaceAsSavedLocation(place);
    } catch (e) {
      debugPrint('Error saving place: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<FFPlace?> _resolvePlaceFromResult(PlaceSearchResult result) async {
    // Nearby/category results can already include coordinates.
    if (result.lat != null && result.lng != null) {
      return FFPlace(
        latLng: LatLng(result.lat!, result.lng!),
        name: result.mainText,
        address: result.secondaryText,
      );
    }

    if (kIsWeb) {
      return places_web.getPlaceDetails(
        result.placeId,
        googleMapsApiKey,
      );
    }

    final detail = await _places?.getDetailsByPlaceId(
      result.placeId,
      language: 'en',
    );
    if (detail?.result == null) return null;
    final res = detail!.result;
    return FFPlace(
      latLng: LatLng(
        res.geometry?.location.lat ?? 0,
        res.geometry?.location.lng ?? 0,
      ),
      name: res.name,
      address: res.formattedAddress ?? '',
      city: res.addressComponents
              .firstWhereOrNull((e) => e.types.contains('locality'))
              ?.shortName ??
          res.addressComponents
              .firstWhereOrNull((e) => e.types.contains('sublocality'))
              ?.shortName ??
          '',
      state: res.addressComponents
              .firstWhereOrNull(
                  (e) => e.types.contains('administrative_area_level_1'))
              ?.shortName ??
          '',
      country: res.addressComponents
              .firstWhereOrNull((e) => e.types.contains('country'))
              ?.shortName ??
          '',
      zipCode: res.addressComponents
              .firstWhereOrNull((e) => e.types.contains('postal_code'))
              ?.shortName ??
          '',
    );
  }

  Future<void> _savePlaceAsSavedLocation(FFPlace place) async {
    if (currentUserReference == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sign in to save places.'),
          duration: Duration(milliseconds: 1600),
        ),
      );
      return;
    }

    final normalizedAddress = place.address.trim();
    final alreadySaved = _savedLocations(context).any((saved) {
      final sameLat = (saved.latLng.latitude - place.latLng.latitude).abs() <
          0.00001;
      final sameLng = (saved.latLng.longitude - place.latLng.longitude).abs() <
          0.00001;
      final sameAddress = normalizedAddress.isNotEmpty &&
          saved.address.toLowerCase() == normalizedAddress.toLowerCase();
      return (sameLat && sameLng) || sameAddress;
    });

    if (alreadySaved) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This place is already in Saved Places.'),
          duration: Duration(milliseconds: 1600),
        ),
      );
      return;
    }

    final label = place.name.trim().isNotEmpty ? place.name.trim() : 'Saved Place';
    final address = normalizedAddress.isNotEmpty
        ? normalizedAddress
        : 'Lat ${place.latLng.latitude.toStringAsFixed(5)}, Lng ${place.latLng.longitude.toStringAsFixed(5)}';

    final newSavedLocation = SavedLocation(
      name: label,
      address: address,
      icon: Icons.bookmark_rounded,
      latLng: place.latLng,
    );

    try {
      await SavedPlaceRecord.createDoc(currentUserReference!).set(
        createSavedPlaceRecordData(
          name: newSavedLocation.name,
          address: newSavedLocation.address,
          latitude: newSavedLocation.latLng.latitude,
          longitude: newSavedLocation.latLng.longitude,
          createdTime: getCurrentTimestamp,
        ),
      );

      setState(() {
        _customSavedLocations.insert(
          0,
          newSavedLocation,
        );
        _searchController.clear();
        _searchResults = [];
        _showResults = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Saved as Saved Place.'),
          duration: Duration(milliseconds: 1600),
        ),
      );
    } catch (e) {
      debugPrint('Error writing saved place to firestore: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not save place. Please try again.'),
          duration: Duration(milliseconds: 1800),
        ),
      );
    }
  }

  void _selectPlace(FFPlace place) {
    widget.onSelect(place);
    Navigator.pop(context);
  }

  Future<String?> _reverseGeocode(LatLng latLng) async {
    if (googleMapsApiKey.isEmpty) return null;

    final uri = Uri.https(
      'maps.googleapis.com',
      '/maps/api/geocode/json',
      {
        'latlng': '${latLng.latitude},${latLng.longitude}',
        'key': googleMapsApiKey,
        'language': 'en',
      },
    );

    final res = await http.get(uri);
    if (res.statusCode != 200) return null;

    final body = jsonDecode(res.body) as Map<String, dynamic>;
    if (body['status'] != 'OK') return null;

    final results = (body['results'] as List?) ?? const [];
    if (results.isEmpty) return null;

    final first = results.first as Map<String, dynamic>;
    final formatted = first['formatted_address'] as String?;
    if (formatted != null && formatted.isNotEmpty) return formatted;

    return null;
  }

  Future<void> _useCurrentLocation() async {
    setState(() => _isLoading = true);
    try {
      final loc = widget.currentLocation ?? await queryCurrentUserLocation();
      if (loc == null) {
        throw Exception('Location unavailable');
      }

      final resolvedAddress = await _reverseGeocode(loc);
      final fallbackAddress =
          'Lat ${loc.latitude.toStringAsFixed(5)}, Lng ${loc.longitude.toStringAsFixed(5)}';
      final destinationText = (resolvedAddress != null &&
              resolvedAddress.trim().isNotEmpty)
          ? resolvedAddress
          : fallbackAddress;
      _searchController.text = destinationText;

      _selectPlace(
        FFPlace(
          latLng: loc,
          name: destinationText,
          address: destinationText,
        ),
      );
    } catch (e) {
      debugPrint('Error getting current location: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.tr('location_permission_denied'))),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: Column(
        children: [
          _buildHeader(theme),
          _buildSearchField(theme),
          _buildUseCurrentLocation(theme),
          Expanded(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: _showResults && _searchResults.isNotEmpty
                    ? _buildSearchResults(theme)
                    : _buildDefaultContent(theme),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(FlutterFlowTheme theme) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Column(
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.alternate,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: theme.headlineMedium.override(
                  fontFamily: theme.headlineMediumFamily,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0,
                  useGoogleFonts: !theme.headlineMediumIsCustom,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.alternate.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close_rounded,
                    color: theme.primaryText,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField(FlutterFlowTheme theme) {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.primaryBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _searchFocusNode.hasFocus ? theme.secondary : theme.lineColor,
          width: _searchFocusNode.hasFocus ? 2 : 1,
        ),
        boxShadow: _searchFocusNode.hasFocus
            ? [
                BoxShadow(
                  color: theme.secondary.withValues(alpha: 0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            child: Icon(
              Icons.search_rounded,
              color: _searchFocusNode.hasFocus
                  ? theme.secondary
                  : theme.secondaryText,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              onChanged: _onSearchChanged,
              style: theme.bodyLarge.override(
                fontFamily: theme.bodyLargeFamily,
                letterSpacing: 0,
                useGoogleFonts: !theme.bodyLargeIsCustom,
              ),
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: theme.bodyLarge.override(
                  fontFamily: theme.bodyLargeFamily,
                  color: theme.secondaryText,
                  letterSpacing: 0,
                  useGoogleFonts: !theme.bodyLargeIsCustom,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(theme.secondary),
                ),
              ),
            )
          else if (_searchController.text.isNotEmpty)
            GestureDetector(
              onTap: () {
                _searchController.clear();
                setState(() {
                  _searchResults = [];
                  _showResults = false;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Icon(
                  Icons.cancel_rounded,
                  color: theme.secondaryText,
                  size: 20,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildUseCurrentLocation(FlutterFlowTheme theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
      child: InkWell(
        onTap: _useCurrentLocation,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: theme.primaryBackground,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: theme.lineColor,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.my_location_rounded,
                color: theme.secondary,
                size: 20,
              ),
              const SizedBox(width: 10),
              Text(
                context.tr('use_current_location'),
                style: theme.bodyMedium.override(
                  fontFamily: theme.bodyMediumFamily,
                  color: theme.primaryText,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0,
                  useGoogleFonts: !theme.bodyMediumIsCustom,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultContent(FlutterFlowTheme theme) {
    final popularDestinations = _popularDestinations(context);
    final savedLocations = _savedLocations(context);
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quick categories
          Text(
            '✨ ${context.tr('quick_search')}',
            style: theme.titleMedium.override(
              fontFamily: theme.titleMediumFamily,
              fontWeight: FontWeight.w600,
              letterSpacing: 0,
              useGoogleFonts: !theme.titleMediumIsCustom,
            ),
          ),
          const SizedBox(height: 12),
          _buildCategoryGrid(theme, popularDestinations),
          const SizedBox(height: 24),

          // Saved places
          Text(
            '📍 ${context.tr('saved_places')}',
            style: theme.titleMedium.override(
              fontFamily: theme.titleMediumFamily,
              fontWeight: FontWeight.w600,
              letterSpacing: 0,
              useGoogleFonts: !theme.titleMediumIsCustom,
            ),
          ),
          const SizedBox(height: 12),
          if (savedLocations.isEmpty)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.primaryBackground,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: theme.lineColor,
                  width: 1,
                ),
              ),
              child: Text(
                'No saved places yet. Use the bookmark icon in search results to add one.',
                style: theme.bodySmall.override(
                  fontFamily: theme.bodySmallFamily,
                  color: theme.secondaryText,
                  letterSpacing: 0,
                  useGoogleFonts: !theme.bodySmallIsCustom,
                ),
              ),
            )
          else
            ...savedLocations.asMap().entries.map((entry) {
              final index = entry.key;
              return TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: Duration(milliseconds: 300 + (index * 100)),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(0, 20 * (1 - value)),
                    child: Opacity(
                      opacity: value,
                      child: child,
                    ),
                  );
                },
                child: _buildSavedLocationTile(entry.value, theme),
              );
            }),
          const SizedBox(height: 24),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildCategoryGrid(
    FlutterFlowTheme theme,
    List<PopularDestination> popularDestinations,
  ) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.1,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: popularDestinations.length,
      itemBuilder: (context, index) {
        final destination = popularDestinations[index];
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 300 + (index * 50)),
          curve: Curves.easeOutBack,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: child,
            );
          },
          child: _buildCategoryCard(destination, theme),
        );
      },
    );
  }

  Widget _buildCategoryCard(
      PopularDestination destination, FlutterFlowTheme theme) {
    return GestureDetector(
      onTap: () => _searchByCategory(destination.category),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: destination.color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: destination.color.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: destination.color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                destination.icon,
                color: destination.color,
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              destination.name,
              style: theme.labelMedium.override(
                fontFamily: theme.labelMediumFamily,
                color: theme.primaryText,
                fontWeight: FontWeight.w500,
                letterSpacing: 0,
                useGoogleFonts: !theme.labelMediumIsCustom,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSavedLocationTile(
      SavedLocation location, FlutterFlowTheme theme) {
    return GestureDetector(
      onTap: () {
        _selectPlace(FFPlace(
          latLng: location.latLng,
          name: location.name,
          address: location.address,
        ));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.primaryBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.lineColor,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: theme.secondary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                location.icon,
                color: theme.secondary,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    location.name,
                    style: theme.bodyLarge.override(
                      fontFamily: theme.bodyLargeFamily,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0,
                      useGoogleFonts: !theme.bodyLargeIsCustom,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    location.address,
                    style: theme.bodySmall.override(
                      fontFamily: theme.bodySmallFamily,
                      color: theme.secondaryText,
                      letterSpacing: 0,
                      useGoogleFonts: !theme.bodySmallIsCustom,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: theme.secondaryText,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults(FlutterFlowTheme theme) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final result = _searchResults[index];
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 200 + (index * 50)),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: Opacity(
                opacity: value,
                child: child,
              ),
            );
          },
          child: _buildSearchResultTile(result, theme),
        );
      },
    );
  }

  Widget _buildSearchResultTile(
      PlaceSearchResult result, FlutterFlowTheme theme) {
    return GestureDetector(
      onTap: () => _selectSearchResult(result),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.primaryBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.lineColor,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: theme.secondary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.location_on_rounded,
                color: theme.secondary,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    result.mainText,
                    style: theme.bodyLarge.override(
                      fontFamily: theme.bodyLargeFamily,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0,
                      useGoogleFonts: !theme.bodyLargeIsCustom,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (result.secondaryText.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      result.secondaryText,
                      style: theme.bodySmall.override(
                        fontFamily: theme.bodySmallFamily,
                        color: theme.secondaryText,
                        letterSpacing: 0,
                        useGoogleFonts: !theme.bodySmallIsCustom,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  tooltip: 'Save as Saved Place',
                  onPressed: () => _saveSearchResultAsSavedPlace(result),
                  icon: Icon(
                    Icons.bookmark_add_outlined,
                    color: theme.secondaryText,
                    size: 20,
                  ),
                ),
                Icon(
                  Icons.north_east_rounded,
                  color: theme.secondary,
                  size: 18,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Helper classes
class PopularDestination {
  final String name;
  final IconData icon;
  final String category;
  final Color color;

  PopularDestination({
    required this.name,
    required this.icon,
    required this.category,
    required this.color,
  });
}

class SavedLocation {
  final String name;
  final String address;
  final IconData icon;
  final LatLng latLng;

  SavedLocation({
    required this.name,
    required this.address,
    required this.icon,
    required this.latLng,
  });
}

/// Unified search result class
class PlaceSearchResult {
  final String placeId;
  final String mainText;
  final String secondaryText;
  final double? lat;
  final double? lng;

  PlaceSearchResult({
    required this.placeId,
    required this.mainText,
    required this.secondaryText,
    this.lat,
    this.lng,
  });
}

// Category results sheet
class _CategoryResultsSheet extends StatelessWidget {
  final List<PlaceSearchResult> results;
  final String category;
  final Function(PlaceSearchResult) onSelect;

  const _CategoryResultsSheet({
    required this.results,
    required this.category,
    required this.onSelect,
  });

  String get categoryTitle {
    switch (category) {
      case 'electric_vehicle_charging_station':
        return 'Charging Stations';
      case 'parking':
        return 'Parking Lots';
      case 'gas_station':
        return 'Petrol Stations';
      case 'car_repair':
        return 'Car Repair Shops';
      default:
        return 'Nearby Places';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.alternate,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      categoryTitle,
                      style: theme.headlineSmall.override(
                        fontFamily: theme.headlineSmallFamily,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0,
                        useGoogleFonts: !theme.headlineSmallIsCustom,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: theme.alternate.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close_rounded,
                          color: theme.primaryText,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: results.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_off_rounded,
                          size: 48,
                          color: theme.secondaryText,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          context.tr('no_places_found_nearby'),
                          style: theme.bodyLarge.override(
                            fontFamily: theme.bodyLargeFamily,
                            color: theme.secondaryText,
                            letterSpacing: 0,
                            useGoogleFonts: !theme.bodyLargeIsCustom,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      final result = results[index];
                      return TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: Duration(milliseconds: 200 + (index * 50)),
                        curve: Curves.easeOutCubic,
                        builder: (context, value, child) {
                          return Transform.translate(
                            offset: Offset(0, 20 * (1 - value)),
                            child: Opacity(
                              opacity: value,
                              child: child,
                            ),
                          );
                        },
                        child: GestureDetector(
                          onTap: () => onSelect(result),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: theme.primaryBackground,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: theme.lineColor,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color:
                                        theme.secondary.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.location_on_rounded,
                                    color: theme.secondary,
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        result.mainText,
                                        style: theme.bodyLarge.override(
                                          fontFamily: theme.bodyLargeFamily,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0,
                                          useGoogleFonts:
                                              !theme.bodyLargeIsCustom,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        result.secondaryText,
                                        style: theme.bodySmall.override(
                                          fontFamily: theme.bodySmallFamily,
                                          color: theme.secondaryText,
                                          letterSpacing: 0,
                                          useGoogleFonts:
                                              !theme.bodySmallIsCustom,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: theme.secondaryText,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

/// Shows the destination picker as a bottom sheet
Future<void> showDestinationPicker({
  required BuildContext context,
  required Function(FFPlace place) onSelect,
  required String iOSGoogleMapsApiKey,
  required String androidGoogleMapsApiKey,
  required String webGoogleMapsApiKey,
  String title = 'Where to?',
  String hintText = 'Search destination...',
  LatLng? currentLocation,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => DestinationPickerWidget(
      onSelect: onSelect,
      iOSGoogleMapsApiKey: iOSGoogleMapsApiKey,
      androidGoogleMapsApiKey: androidGoogleMapsApiKey,
      webGoogleMapsApiKey: webGoogleMapsApiKey,
      title: title,
      hintText: hintText,
      currentLocation: currentLocation,
    ),
  );
}
