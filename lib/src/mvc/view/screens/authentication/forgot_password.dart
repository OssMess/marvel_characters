import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../../../tools.dart';
import '../../../controller/services.dart';
import '../../../model/enums.dart';
import '../../../model/models.dart';
import '../../model_widgets.dart';
import '../../screens.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({
    super.key,
    required this.userSession,
    required this.authRouteNotifier,
  });

  final UserSession userSession;
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
      userSession: widget.userSession,
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
      future: () =>
          FirebaseAuthenticationService.sendPasswordResetEmail(email: email!),
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
