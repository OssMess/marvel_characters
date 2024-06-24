#chmod 755 init_config.sh
#bash init_config_firebase.sh
#Variables

# Old config params
oldAppName='Flutter Skeleton App'
oldProjectName='flutter_skeleton'
oldAndroidPackageName='com.android.skeleton_dev'
oldIOSPackageName='com.ios.skeleton_dev'

#Flutter project config
newAppName='APP NAME'
newProjectName='project_name'

# Firebase release config
androidPackageNameRelease='com.android.skeleton_release'
iOSPackageNameRelease='com.ios.skeleton_release'
reservedClientIdRelease='REVERSED_CLIENT_ID_RELEASE'
projectNameRelease='firebase-project-name-release'

# Firebase Dev config
androidPackageNameDev='com.android.skeleton_dev'
iOSPackageNameDev='com.ios.skeleton_dev'
reservedClientIdDev='REVERSED_CLIENT_ID_DEV'
projectNameDev='firebase-project-name-dev'

sed -i '' "s/com.android.skeleton_release/$androidPackageNameRelease/g" firebase_config_development.sh
sed -i '' "s/com.ios.skeleton_release/$iOSPackageNameRelease/g" firebase_config_development.sh
sed -i '' "s/REVERSED_CLIENT_ID_RELEASE/$reservedClientIdRelease/g" firebase_config_development.sh
sed -i '' "s/firebase-project-name-release/$projectNameRelease/g" firebase_config_development.sh

sed -i '' "s/com.android.skeleton_dev/$androidPackageNameDev/g" firebase_config_development.sh
sed -i '' "s/com.ios.skeleton_dev/$iOSPackageNameDev/g" firebase_config_development.sh
sed -i '' "s/REVERSED_CLIENT_ID_DEV/$reservedClientIdDev/g" firebase_config_development.sh
sed -i '' "s/firebase-project-name-dev/$projectNameDev/g" firebase_config_development.sh

# Android app package name
flutter pub run change_app_package_name:main $androidPackageNameDev

# iOS app bundle
sed -i '' "s/$oldIOSPackageName/$iOSPackageNameDev/g" ios/Runner.xcodeproj/project.pbxproj

# App Name
sed -i '' "s/$oldAppName/$newAppName/g" android/app/src/main/AndroidManifest.xml
sed -i '' "s/$oldAppName/$newAppName/g" lib/src/localization/app_en.arb
sed -i '' "s/$oldAppName/$newAppName/g" ios/Runner.xcodeproj/project.pbxproj
sed -i '' "s/$oldAppName/$newAppName/g" ios/Runner/Info.plist

# Permissions
sed -i '' "s/$oldAppName/$newAppName/g" lib/src/localization/app_en.arb

#Project Name
sed -i '' "s/$oldProjectName/$newProjectName/g" pubspec.yaml
sed -i '' "s/$oldProjectName/$newProjectName/g" android/app/src/main/kotlin/com/optasoft/$oldProjectName/MainActivity.kt
cp android/app/src/main/kotlin/com/optasoft/$oldProjectName/ android/app/src/main/kotlin/com/optasoft/$newProjectName/
sed -i '' "s/$oldProjectName/$newProjectName/g" README.md

#Remove un needed scripts
rm init_remove_firebase.sh
rm init_config_api.sh