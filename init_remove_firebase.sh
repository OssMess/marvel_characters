#chmod 755 init_remove_firebase.sh
#bash init_remove_firebase.sh
# Remove files
rm lib/src/mvc/controller/services/authentication_service.dart
rm lib/src/mvc/controller/services/chats_service.dart
rm lib/src/mvc/controller/services/app_notifications_service.dart
rm lib/src/mvc/controller/services/dynamic_links_service.dart
rm lib/src/mvc/controller/services/user_firebase_session_service.dart
rm lib/src/mvc/controller/services/user_presence_service.dart
rm lib/src/mvc/controller/services/google_sign_in_service.dart
rm lib/src/mvc/model/models/user_firebase_session.dart
rm lib/src/mvc/model/models/user_presence.dart
rm lib/src/mvc/model/change_notifiers/notifier_remote_config.dart

# Update pubspec.yaml
sed -i '' "s/cloud_firestore/#cloud_firestore/g" pubspec.yaml
sed -i '' "s/cloud_functions/#cloud_functions/g"  pubspec.yaml
sed -i '' "s/firebase_app_check/#firebase_app_check/g"  pubspec.yaml
sed -i '' "s/firebase_auth/#firebase_auth/g"  pubspec.yaml
sed -i '' "s/firebase_core/#firebase_core/g"  pubspec.yaml
sed -i '' "s/google_sign_in/#google_sign_in/g"  pubspec.yaml
sed -i '' "s/firebase_database/#firebase_database/g"  pubspec.yaml
sed -i '' "s/firebase_dynamic_links/#firebase_dynamic_links/g"  pubspec.yaml
sed -i '' "s/firebase_in_app_messaging/#firebase_in_app_messaging/g"  pubspec.yaml
sed -i '' "s/firebase_messaging/#firebase_messaging/g"  pubspec.yaml
sed -i '' "s/firebase_remote_config/#firebase_remote_config/g"  pubspec.yaml
sed -i '' "s/firebase_storage/#firebase_storage/g"  pubspec.yaml
sed -i '' "s/flutter_local_notifications/#flutter_local_notifications/g"  pubspec.yaml

# Update AppDelegate
sed -i '' "s/import Firebase/\/\/ import Firebase/g" ios/Runner/AppDelegate.swift
sed -i '' "s/FirebaseApp.configure()/\/\/ FirebaseApp.configure()/g" ios/Runner/AppDelegate.swift

# Update Podfile
sed -i '' "s/pod 'Firebase\/Analytics'/# pod 'Firebase\/Analytics'/g"  ios/Podfile
sed -i '' "s/pod 'Firebase\/Storage'/# pod 'Firebase\/Storage'/g"  ios/Podfile
sed -i '' "s/pod 'Firebase\/Auth'/# pod 'Firebase\/Auth'/g"  ios/Podfile
sed -i '' "s/pod 'Firebase\/Core'/# pod 'Firebase\/Core'/g"  ios/Podfile
sed -i '' "s/pod 'Firebase\/Firestore'/# pod 'Firebase\/Firestore'/g"  ios/Podfile
sed -i '' "s/pod 'Firebase\/Messaging'/# pod 'Firebase\/Messaging'/g"  ios/Podfile
sed -i '' "s/pod 'Firebase\/Database'/# pod 'Firebase\/Database'/g"  ios/Podfile
sed -i '' "s/pod 'Firebase\/DynamicLinks'/# pod 'Firebase\/DynamicLinks'/g"  ios/Podfile
sed -i '' "s/pod 'FirebaseAppCheck'/# pod 'FirebaseAppCheck'/g"  ios/Podfile

rm init_remove_firebase.sh
