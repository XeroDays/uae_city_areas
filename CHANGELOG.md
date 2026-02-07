# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-01-XX

### Added
- Initial release
- `CitiesAreasService` class for fetching cities and areas
- `City` model with id, name, and nameArabic fields
- `Area` model with id, name, and emirateId fields
- Persistent storage caching using `shared_preferences`
- Force refresh option to bypass cache
- Optional cache TTL (time-to-live) support
- Error handling with custom exceptions
- Example Flutter app demonstrating usage
- Support for custom base URL and headers
- Cache management methods (clearCache, clearCitiesCache, clearAreasCache)

### Features
- Fetch cities/emirates from `/api/geoemirates/get`
- Fetch areas from `/api/geoemirates/GetAreasByEmirateId/{id}`
- Persistent cache that survives app restarts
- Offline support with cached data
- Simple and intuitive API
