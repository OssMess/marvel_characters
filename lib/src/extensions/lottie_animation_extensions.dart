import '../data/_enums.dart';

extension LottieAnimationExtensions on LottieAnimation {
  String get valueToString {
    switch (this) {
      case LottieAnimation.check:
        return 'assets/lotties/check.json';
      case LottieAnimation.question:
        return 'assets/lotties/question.json';
      case LottieAnimation.error:
        return 'assets/lotties/error.json';
      case LottieAnimation.uploading:
        return 'assets/lotties/upload.json';
      default:
        throw Exception('Value not in range');
    }
  }
}
