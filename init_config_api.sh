#chmod 755 init_config.sh
#bash init_config_api.sh
#Variables

# Old config params
oldAppName='Flutter Skeleton App'
oldProjectName='flutter_skeleton'
oldAndroidPackageName='com.android.skeleton_dev'
oldIOSPackageName='com.ios.skeleton_dev'

# New config params
newAppName='APP NAME'
newProjectName='project_name'
newAndroidPackageName='com.android.skeleton_dev_new'
newIOSPackageName='com.ios.skeleton_dev_new'


# Android app package name
flutter pub run change_app_package_name:main $newAndroidPackageName

# iOS app bundle
sed -i '' "s/$oldIOSPackageName/$newIOSPackageName/g" ios/Runner.xcodeproj/project.pbxproj

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
