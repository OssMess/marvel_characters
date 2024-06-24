#chmod 755 firebase_config_distribution.sh  
#dart pub global activate flutterfire_cli
#bash firebase_config_distribution.sh

#Variables
# Firebase release config
androidPackageNameRelease='com.android.skeleton_release'
iOSPackageNameRelease='com.ios.skeleton_release'
reservedClientIdRelease='REVERSED_CLIENT_ID_RELEASE'
clientIdRelease='CLIENT_ID_RELEASE'
projectNameRelease='firebase-project-name-release'

# Firebase Dev config
androidPackageNameDev='com.android.skeleton_dev'
iOSPackageNameDev='com.ios.skeleton_dev'
reservedClientIdDev='REVERSED_CLIENT_ID_DEV'
clientIdDev='CLIENT_ID_DEV'
projectNameDev='firebase-project-name-dev'


# Delete old firebase config
rm lib/firebase_options.dart
rm ios/Runner/GoogleService-Info.plist
rm ios/firebase_app_id_file.json
rm android/app/google-services.json
# Android app package name
flutter pub run change_app_package_name:main $androidPackageNameRelease
# iOS app bundle
sed -i '' "s/$iOSPackageNameDev/$iOSPackageNameRelease/g" ios/Runner.xcodeproj/project.pbxproj
# GIDClientID
sed -i '' "s/$clientIdDev/$clientIdRelease/g" ios/Runner/Info.plist
# REVERSED_CLIENT_ID
sed -i '' "s/$reservedClientIdDev/$reservedClientIdRelease/g" ios/Runner/Info.plist
# Dynamic links
sed -i '' "s/$androidPackageNameDev/$androidPackageNameRelease/g" lib/src/mvc/controller/services/dynamic_links_service.dart
sed -i '' "s/$iOSPackageNameDev/$iOSPackageNameRelease/g" lib/src/mvc/controller/services/dynamic_links_service.dart

# Change icon
sed -i '' "s/logo_debug.png/logo.png/g" pubspec.yaml
flutter pub run flutter_launcher_icons

# Configure on development project
flutterfire configure --project=$projectNameRelease