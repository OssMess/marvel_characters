import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../../data/_data_providers.dart';
import '../../../_tools.dart';
import '../../../data/_enums.dart';
import '../../_model_widgets.dart';
import '../../_screens.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({
    super.key,
    required this.authRouteNotifier,
  });

  final ValueNotifier<AuthRoute> authRouteNotifier;

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final GlobalKey<FormState> formKey = GlobalKey();
  String? email;
  String? emailError;

  @override
  Widget build(BuildContext context) {
    return AuthenticationPage(
      onPressedLeadingAppBar: null,
      title: AppLocalizations.of(context)!.reset_password,
      subtitle: AppLocalizations.of(context)!.reset_password_hint,
      formKey: formKey,
      bodyChildren: [
        CustomTextFormField(
          hintText: AppLocalizations.of(context)!.email,
          errorText: emailError,
          keyboardType: TextInputType.emailAddress,
          prefixIcon: AwesomeIconsLight.at,
          validator: Validators.validateEmail,
          onSaved: (value) => email = value,
          onEditingComplete: validateSaveAndCallNext,
        ),
      ],
      labelAuthButton: AppLocalizations.of(context)!.send,
      onPressedAuthButton: next,
      normalTextSpan: AppLocalizations.of(context)!.you_recovered_your_password,
      highlightedTextSpan: AppLocalizations.of(context)!.signin,
      recognizerTextSpan: context.pop,
    );
  }

  Future<void> validateSaveAndCallNext() async {
    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();
    await next();
  }

  Future<void> next() async {
    FocusScope.of(context).unfocus();
    if (emailError.isNotNullOrEmpty) {
      setState(() {
        emailError = null;
      });
    }
    await Dialogs.of(context).runAsyncAction(
      future: () => FirebaseAuthenticationRepository.sendPasswordResetEmail(
          email: email!),
      onCompleteMessage:
          AppLocalizations.of(context)!.a_link_has_been_sent_to_your_email,
      dialogType: DialogType.snackbar,
      onError: (e) {
        setState(() {
          emailError = Functions.of(context).translateException(e);
        });
      },
    );
  }
}
