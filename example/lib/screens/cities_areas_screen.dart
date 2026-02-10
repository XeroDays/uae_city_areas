import 'package:flutter/material.dart';
import 'package:uae_city_areas/uae_city_areas.dart';

/// Screen with two dropdowns (cities, then areas). Uses basic setState.
class CitiesAreasScreen extends StatefulWidget {
  const CitiesAreasScreen({super.key});

  @override
  State<CitiesAreasScreen> createState() => _CitiesAreasScreenState();
}

class _CitiesAreasScreenState extends State<CitiesAreasScreen> {
  List<City> _cities = [];
  List<Area> _areas = [];
  City? _selectedCity;
  Area? _selectedArea;
  bool _loadingCities = false;
  bool _loadingAreas = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    UAECityAreasPlugin.loggingEnabled = true;

    _loadCities();
  }

  Future<void> _loadCities() async {
    setState(() {
      _loadingCities = true;
      _error = null;
    });
    try {
      final cities = await UAECityAreasPlugin.getCities();

      if (mounted)
        setState(() {
          _cities = cities;
          _loadingCities = false;
        });
    } catch (e) {
      if (mounted)
        setState(() {
          _error = e.toString();
          _loadingCities = false;
        });
    }
  }

  Future<void> _onCityChanged(City? city) async {
    setState(() {
      _selectedCity = city;
      _selectedArea = null;
      _areas = [];
    });
    if (city == null) return;

    setState(() {
      _loadingAreas = true;
      _error = null;
    });
    try {
      final areas = await UAECityAreasPlugin.getAreasByCityId(city.id);
      if (mounted)
        setState(() {
          _areas = areas;
          _loadingAreas = false;
        });
    } catch (e) {
      if (mounted)
        setState(() {
          _error = e.toString();
          _loadingAreas = false;
        });
    }
  }

  // UAE-inspired accent colors
  static const _accentGreen = Color(0xFF007A3D);
  static const _accentGold = Color(0xFFD4AF37);
  static const _surfaceLight = Color(0xFFF8FAF9);
  static const _radius = 16.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (_error != null) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      theme.scaffoldBackgroundColor,
                      theme.scaffoldBackgroundColor.withOpacity(0.95),
                    ]
                  : [
                      _surfaceLight,
                      Colors.white,
                    ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                _buildAppBar(context),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.errorContainer
                                  .withOpacity(0.5),
                              borderRadius: BorderRadius.circular(_radius),
                              border: Border.all(
                                color: theme.colorScheme.error.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Icon(
                              Icons.cloud_off_rounded,
                              size: 48,
                              color: theme.colorScheme.error,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Something went wrong',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _error!,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 24),
                          FilledButton.icon(
                            onPressed: () async => await _loadCities(),
                            icon: const Icon(Icons.refresh_rounded, size: 20),
                            label: const Text('Try again'),
                            style: FilledButton.styleFrom(
                              backgroundColor: _accentGreen,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    theme.scaffoldBackgroundColor,
                    theme.scaffoldBackgroundColor.withOpacity(0.98),
                  ]
                : [
                    _surfaceLight,
                    Colors.white,
                  ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 8),
                      _buildSectionLabel(
                        context,
                        icon: Icons.location_city_rounded,
                        label: 'City / Emirate',
                      ),
                      const SizedBox(height: 12),
                      _buildCityCard(theme),
                      const SizedBox(height: 24),
                      _buildSectionLabel(
                        context,
                        icon: Icons.map_rounded,
                        label: 'Area',
                      ),
                      const SizedBox(height: 12),
                      _buildAreaCard(theme),
                      if (_selectedCity != null && _selectedArea != null) ...[
                        const SizedBox(height: 28),
                        _buildSelectionSummary(theme),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _accentGreen.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.flag_rounded,
              color: _accentGreen,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Cities & Areas',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildSectionLabel(
    BuildContext context, {
    required IconData icon,
    required String label,
  }) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 20, color: _accentGreen),
        const SizedBox(width: 8),
        Text(
          label,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }

  Widget _buildCityCard(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(_radius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: _accentGreen.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_radius),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: _loadingCities
              ? const SizedBox(
                  height: 64,
                  child: Center(
                    child: SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: _accentGreen,
                      ),
                    ),
                  ),
                )
              : DropdownButtonFormField<City>(
                  value: _selectedCity,
                  isExpanded: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: theme.colorScheme.surface,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                  hint: Row(
                    children: [
                      Icon(
                        Icons.place_rounded,
                        size: 20,
                        color:
                            theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Select city...',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant
                              .withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                  items: _cities
                      .map(
                        (c) => DropdownMenuItem<City>(
                          value: c,
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_city_rounded,
                                size: 20,
                                color: _accentGreen.withOpacity(0.8),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  c.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.bodyLarge,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (City? city) => _onCityChanged(city),
                ),
        ),
      ),
    );
  }

  Widget _buildAreaCard(ThemeData theme) {
    final disabled = _selectedCity == null;
    return Opacity(
      opacity: disabled ? 0.7 : 1,
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(_radius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: _accentGreen.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(_radius),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: _loadingAreas
                ? const SizedBox(
                    height: 64,
                    child: Center(
                      child: SizedBox(
                        width: 28,
                        height: 28,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: _accentGreen,
                        ),
                      ),
                    ),
                  )
                : DropdownButtonFormField<Area>(
                    value: _selectedArea,
                    isExpanded: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: theme.colorScheme.surface,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                    hint: Row(
                      children: [
                        Icon(
                          Icons.map_rounded,
                          size: 20,
                          color: theme.colorScheme.onSurfaceVariant
                              .withOpacity(0.7),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          _selectedCity == null
                              ? 'Select a city first'
                              : 'Select area...',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant
                                .withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                    items: _areas
                        .map(
                          (a) => DropdownMenuItem<Area>(
                            value: a,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.push_pin_rounded,
                                  size: 20,
                                  color: _accentGold.withOpacity(0.9),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    a.name,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.bodyLarge,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: disabled
                        ? null
                        : (Area? area) {
                            setState(() => _selectedArea = area);
                          },
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionSummary(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _accentGreen.withOpacity(0.12),
            _accentGreen.withOpacity(0.06),
          ],
        ),
        borderRadius: BorderRadius.circular(_radius),
        border: Border.all(
          color: _accentGreen.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.check_circle_rounded,
                color: _accentGreen,
                size: 22,
              ),
              const SizedBox(width: 8),
              Text(
                'Selected location',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: _accentGreen,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _summaryRow(
            theme,
            icon: Icons.location_city_rounded,
            label: _selectedCity!.name,
          ),
          const SizedBox(height: 8),
          _summaryRow(
            theme,
            icon: Icons.map_rounded,
            label: _selectedArea!.name,
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(ThemeData theme,
      {required IconData icon, required String label}) {
    return Row(
      children: [
        Icon(icon, size: 18, color: _accentGreen.withOpacity(0.8)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
