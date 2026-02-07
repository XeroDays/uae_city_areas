import 'package:flutter/material.dart';
import 'package:uae_city_areas/uae_city_areas.dart';
import '../viewmodels/cities_areas_viewmodel.dart';

/// View: two dropdowns (cities, then areas). All logic in [CitiesAreasViewModel].
class CitiesAreasScreen extends StatefulWidget {
  const CitiesAreasScreen({super.key});

  @override
  State<CitiesAreasScreen> createState() => _CitiesAreasScreenState();
}

class _CitiesAreasScreenState extends State<CitiesAreasScreen> {
  late final CitiesAreasViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = CitiesAreasViewModel();
    _loadCities();
  }

  Future<void> _loadCities() async {
    await _viewModel.loadCities();
    if (mounted) setState(() {});
  }

  Future<void> _onCityChanged(City? city) async {
    await _viewModel.selectCity(city);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_viewModel.error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Cities & Areas')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _viewModel.error!,
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
            const Text('City / Emirate', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            _viewModel.loadingCities
                ? const SizedBox(height: 56, child: Center(child: CircularProgressIndicator()))
                : DropdownButtonFormField<City>(
                    value: _viewModel.selectedCity,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    hint: const Text('Select city...'),
                    items: _viewModel.cities
                        .map((c) => DropdownMenuItem<City>(value: c, child: Text(c.name)))
                        .toList(),
                    onChanged: (City? city) => _onCityChanged(city),
                  ),
            const SizedBox(height: 24),
            const Text('Area', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            _viewModel.loadingAreas
                ? const SizedBox(height: 56, child: Center(child: CircularProgressIndicator()))
                : DropdownButtonFormField<Area>(
                    value: _viewModel.selectedArea,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    hint: Text(_viewModel.selectedCity == null
                        ? 'Select a city first'
                        : 'Select area...'),
                    items: _viewModel.areas
                        .map((a) => DropdownMenuItem<Area>(value: a, child: Text(a.name)))
                        .toList(),
                    onChanged: _viewModel.selectedCity == null
                        ? null
                        : (Area? area) {
                            _viewModel.selectArea(area);
                            setState(() {});
                          },
                  ),
          ],
        ),
      ),
    );
  }
}
