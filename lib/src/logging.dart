/// Optional logging for the UAE City Areas plugin.
///
/// Set [enable] to `true` in your app to print plugin actions to the console.
/// Off by default.
///
/// Example:
/// ```dart
/// void main() {
///   UaeCityAreasLogging.enable = true;  // Enable plugin logging
///   runApp(MyApp());
/// }
/// ```
class UaeCityAreasLogging {
  UaeCityAreasLogging._();

  /// When `true`, the plugin logs actions (API calls, cache hits/misses, etc.) to the console.
  /// Default is `false`.
  static bool enable = false;

  static void log(String message) {
    if (enable) {
      // ignore: avoid_print
      print('[uae_city_areas] $message');
    }
  }
}
