import 'package:uae_city_areas/uae_city_areas.dart';

/// ViewModel for the cities and areas screen.
/// Holds state and business logic; no UI or BuildContext.
class CitiesAreasViewModel {
  CitiesAreasViewModel({CitiesAreasService? service})
      : _service = service ?? CitiesAreasService();

  final CitiesAreasService _service;

  List<City> cities = [];
  List<Area> areas = [];
  City? selectedCity;
  Area? selectedArea;
  bool loadingCities = false;
  bool loadingAreas = false;
  String? error;

  /// Loads cities from the plugin (uses cache by default).
  Future<void> loadCities() async {
    loadingCities = true;
    error = null;
    try {
      cities = await _service.getCities();
    } catch (e) {
      error = e.toString();
    } finally {
      loadingCities = false;
    }
  }

  /// Sets the selected city and loads areas for it.
  /// Pass null to clear selection and areas.
  Future<void> selectCity(City? city) async {
    selectedCity = city;
    selectedArea = null;
    areas = [];
    if (city == null) return;

    loadingAreas = true;
    error = null;
    try {
      areas = await _service.getAreasByCityId(city.id);
    } catch (e) {
      error = e.toString();
    } finally {
      loadingAreas = false;
    }
  }

  void selectArea(Area? area) {
    selectedArea = area;
  }
}
