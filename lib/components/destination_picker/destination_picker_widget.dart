import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:collection/collection.dart';
import 'package:go_taxi_rider/flutter_flow/flutter_flow_theme.dart';
import 'package:go_taxi_rider/flutter_flow/place.dart';
import 'package:go_taxi_rider/flutter_flow/lat_lng.dart';
import 'package:uuid/uuid.dart';

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
  State<DestinationPickerWidget> createState() => _DestinationPickerWidgetState();
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
  GoogleMapsPlaces? _places;
  Timer? _debounceTimer;
  final String _sessionToken = const Uuid().v4();

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

  // Popular destinations with categories
  final List<PopularDestination> _popularDestinations = [
    PopularDestination(
      name: 'Airport',
      icon: Icons.flight_takeoff_rounded,
      category: 'airport',
      color: Color(0xFF5C6BC0),
    ),
    PopularDestination(
      name: 'Mall',
      icon: Icons.shopping_bag_rounded,
      category: 'shopping_mall',
      color: Color(0xFFEC407A),
    ),
    PopularDestination(
      name: 'Hospital',
      icon: Icons.local_hospital_rounded,
      category: 'hospital',
      color: Color(0xFFEF5350),
    ),
    PopularDestination(
      name: 'Restaurant',
      icon: Icons.restaurant_rounded,
      category: 'restaurant',
      color: Color(0xFFFF7043),
    ),
    PopularDestination(
      name: 'Hotel',
      icon: Icons.hotel_rounded,
      category: 'lodging',
      color: Color(0xFF26A69A),
    ),
    PopularDestination(
      name: 'Station',
      icon: Icons.train_rounded,
      category: 'train_station',
      color: Color(0xFF42A5F5),
    ),
  ];

  // Recent/Saved locations (sample data)
  final List<SavedLocation> _savedLocations = [
    SavedLocation(
      name: 'Home',
      address: '123 Main Street, Downtown',
      icon: Icons.home_rounded,
      latLng: LatLng(-15.4167, 28.2833),
    ),
    SavedLocation(
      name: 'Work',
      address: 'Business Park, Tower A',
      icon: Icons.work_rounded,
      latLng: LatLng(-15.3875, 28.3228),
    ),
    SavedLocation(
      name: 'Gym',
      address: 'Fitness Center, East Mall',
      icon: Icons.fitness_center_rounded,
      latLng: LatLng(-15.4000, 28.3000),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initPlaces();
    _initAnimations();
    
    // Auto focus the search field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
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
            _searchResults = response!.predictions.map((p) => PlaceSearchResult(
              placeId: p.placeId ?? '',
              mainText: p.structuredFormatting?.mainText ?? p.description ?? '',
              secondaryText: p.structuredFormatting?.secondaryText ?? '',
            )).toList();
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
      // If we already have lat/lng from nearby search, use it
      if (result.lat != null && result.lng != null) {
        _selectPlace(FFPlace(
          latLng: LatLng(result.lat!, result.lng!),
          name: result.mainText,
          address: result.secondaryText,
        ));
        return;
      }

      if (kIsWeb) {
        final details = await places_web.getPlaceDetails(
          result.placeId,
          googleMapsApiKey,
        );
        
        if (details != null) {
          _selectPlace(details);
        }
      } else {
        final detail = await _places?.getDetailsByPlaceId(
          result.placeId,
          language: 'en',
        );

        if (detail?.result != null) {
          final res = detail!.result;
          _selectPlace(FFPlace(
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
          ));
        }
      }
    } catch (e) {
      debugPrint('Error getting place details: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _selectPlace(FFPlace place) {
    widget.onSelect(place);
    Navigator.pop(context);
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
          color: _searchFocusNode.hasFocus
              ? theme.secondary
              : theme.lineColor,
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

  Widget _buildDefaultContent(FlutterFlowTheme theme) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quick categories
          Text(
            '✨ Quick Search',
            style: theme.titleMedium.override(
              fontFamily: theme.titleMediumFamily,
              fontWeight: FontWeight.w600,
              letterSpacing: 0,
              useGoogleFonts: !theme.titleMediumIsCustom,
            ),
          ),
          const SizedBox(height: 12),
          _buildCategoryGrid(theme),
          const SizedBox(height: 24),
          
          // Saved places
          Text(
            '📍 Saved Places',
            style: theme.titleMedium.override(
              fontFamily: theme.titleMediumFamily,
              fontWeight: FontWeight.w600,
              letterSpacing: 0,
              useGoogleFonts: !theme.titleMediumIsCustom,
            ),
          ),
          const SizedBox(height: 12),
          ..._savedLocations.asMap().entries.map((entry) {
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
          
          // Recent destinations
          Text(
            '🕐 Recent Destinations',
            style: theme.titleMedium.override(
              fontFamily: theme.titleMediumFamily,
              fontWeight: FontWeight.w600,
              letterSpacing: 0,
              useGoogleFonts: !theme.titleMediumIsCustom,
            ),
          ),
          const SizedBox(height: 12),
          _buildRecentDestinations(theme),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildCategoryGrid(FlutterFlowTheme theme) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.1,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: _popularDestinations.length,
      itemBuilder: (context, index) {
        final destination = _popularDestinations[index];
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

  Widget _buildCategoryCard(PopularDestination destination, FlutterFlowTheme theme) {
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

  Widget _buildSavedLocationTile(SavedLocation location, FlutterFlowTheme theme) {
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

  Widget _buildRecentDestinations(FlutterFlowTheme theme) {
    final recentPlaces = [
      {'name': 'Downtown Mall', 'address': 'Cairo Road, Lusaka', 'time': '2 days ago'},
      {'name': 'Kenneth Kaunda Airport', 'address': 'Airport Road', 'time': '1 week ago'},
      {'name': 'University of Zambia', 'address': 'Great East Road', 'time': '2 weeks ago'},
    ];

    return Column(
      children: recentPlaces.asMap().entries.map((entry) {
        final index = entry.key;
        final place = entry.value;
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 400 + (index * 100)),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(20 * (1 - value), 0),
              child: Opacity(
                opacity: value,
                child: child,
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: GestureDetector(
              onTap: () {
                // For demo purposes, select with dummy coordinates
                _selectPlace(FFPlace(
                  latLng: LatLng(-15.4167 + (index * 0.01), 28.2833 + (index * 0.01)),
                  name: place['name']!,
                  address: place['address']!,
                ));
              },
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.alternate.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.history_rounded,
                      color: theme.secondaryText,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          place['name']!,
                          style: theme.bodyMedium.override(
                            fontFamily: theme.bodyMediumFamily,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0,
                            useGoogleFonts: !theme.bodyMediumIsCustom,
                          ),
                        ),
                        Text(
                          place['address']!,
                          style: theme.bodySmall.override(
                            fontFamily: theme.bodySmallFamily,
                            color: theme.secondaryText,
                            letterSpacing: 0,
                            useGoogleFonts: !theme.bodySmallIsCustom,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    place['time']!,
                    style: theme.labelSmall.override(
                      fontFamily: theme.labelSmallFamily,
                      color: theme.secondaryText,
                      letterSpacing: 0,
                      useGoogleFonts: !theme.labelSmallIsCustom,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
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

  Widget _buildSearchResultTile(PlaceSearchResult result, FlutterFlowTheme theme) {
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
            Icon(
              Icons.north_east_rounded,
              color: theme.secondary,
              size: 18,
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
      case 'airport':
        return '✈️ Airports';
      case 'shopping_mall':
        return '🛍️ Shopping Malls';
      case 'hospital':
        return '🏥 Hospitals';
      case 'restaurant':
        return '🍽️ Restaurants';
      case 'lodging':
        return '🏨 Hotels';
      case 'train_station':
        return '🚂 Train Stations';
      default:
        return '📍 Nearby Places';
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
                          'No places found nearby',
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
