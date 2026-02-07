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

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Cities & Areas')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _error!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () async {
                    await _loadCities();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Cities & Areas')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('City / Emirate',
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            _loadingCities
                ? const SizedBox(
                    height: 56,
                    child: Center(child: CircularProgressIndicator()))
                : DropdownButtonFormField<City>(
                    value: _selectedCity,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    hint: const Text('Select city...'),
                    items: _cities
                        .map((c) => DropdownMenuItem<City>(
                            value: c,
                            child:
                                Text(c.name, overflow: TextOverflow.ellipsis)))
                        .toList(),
                    onChanged: (City? city) => _onCityChanged(city),
                  ),
            const SizedBox(height: 24),
            const Text('Area', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            _loadingAreas
                ? const SizedBox(
                    height: 56,
                    child: Center(child: CircularProgressIndicator()))
                : DropdownButtonFormField<Area>(
                    value: _selectedArea,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    hint: Text(_selectedCity == null
                        ? 'Select a city first'
                        : 'Select area...'),
                    items: _areas
                        .map((a) => DropdownMenuItem<Area>(
                            value: a,
                            child:
                                Text(a.name, overflow: TextOverflow.ellipsis)))
                        .toList(),
                    onChanged: _selectedCity == null
                        ? null
                        : (Area? area) {
                            setState(() => _selectedArea = area);
                          },
                  ),
          ],
        ),
      ),
    );
  }
}
