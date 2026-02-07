# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0+2]

### Changed
- Documentation updated

## [1.0.0+1]

### Added
- Initial release to pub.dev

## [1.0.0]

### Added
- Initial release
- `UAECityAreasPlugin` static API for fetching cities and areas
- `City` model with id, name, and nameArabic fields
- `Area` model with id, name, and emirateId fields
- Persistent storage caching using `shared_preferences`
- Force refresh option to bypass cache
- Error handling with custom exceptions
- Example Flutter app with city and area dropdowns
- Cache management: `clearCache`, `clearCitiesCache`, `clearAreasCache`
- Optional logging via `UAECityAreasPlugin.loggingEnabled`

### Features
- Fetch cities/emirates via `UAECityAreasPlugin.getCities()`
- Fetch areas via `UAECityAreasPlugin.getAreasByCityId()` and `getAreasByCity()`
- Persistent cache that survives app restarts
- Offline support with cached data
- Simple static API, no object creation required
