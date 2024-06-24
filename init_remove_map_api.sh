#chmod 755 init_remove_map_api.sh
#bash init_remove_map_api.sh
rm lib/src/mvc/controller/services/google_maps_api.dart
rm -R lib/src/mvc/model/maps_models
sed -i '' "s/google_maps_flutter/#google_maps_flutter/g"  pubspec.yaml
sed -i '' "s/geolocator/#geolocator/g"  pubspec.yaml
sed -i '' "s/dart_geohash/#dart_geohash/g"  pubspec.yaml
sed -i '' "s/export 'extensions\/map_extensions.dart';//g"  lib/src/extensions.dart

rm lib/src/extensions/map_extensions.dart
rm lib/src/mvc/model/maps_models.dart
rm init_remove_map_api.sh