#chmod 755 init_remove_api.sh
#bash init_remove_api.sh
rm lib/src/mvc/controller/hives/auth_state_change.dart
rm lib/src/mvc/controller/hives/cookies.dart
rm lib/src/home.dart
rm lib/src/mvc/controller/hives.dart
rm lib/src/mvc/model/models/user_api_session.dart
rm init_config_api.sh
sed -i '' "s/hive/#hive/g" pubspec.yaml
sed -i '' "s/hive_flutter/#hive_flutter/g" pubspec.yaml
sed -i '' "s/export 'models\/user_api_session.dart';//g" pubspec.yaml
rm init_remove_api.sh
