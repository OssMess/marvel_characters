import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../business_logic/cubits.dart';
import '../../../data/data_providers.dart';
import '../../../tools.dart';
import '../../../data/enums.dart';
import '../../model_widgets.dart';
import '../../screens.dart';

class Signin extends StatefulWidget {
  const Signin({
    super.key,
    required this.authRouteNotifier,
  });

  final ValueNotifier<AuthRoute> authRouteNotifier;

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final GlobalKey<FormState> formKey = GlobalKey();
  bool obscureText = true;
  bool checkbox = false;
  String? email, password;
  String? emailError, passwordError;

  @override
  Widget build(BuildContext context) {
    return AuthenticationPage(
      onPressedLeadingAppBar: null,
      title: AppLocalizations.of(context)!.signin,
      subtitle: AppLocalizations.of(context)!.signin_hint,
      formKey: formKey,
      bodyChildren: [
        CustomTextFormField(
          hintText: AppLocalizations.of(context)!.email,
          errorText: emailError,
          keyboardType: TextInputType.emailAddress,
          prefixIcon: AwesomeIconsLight.at,
          textInputAction: TextInputAction.next,
          validator: Validators.validateEmail,
          onSaved: (value) => email = value,
        ),
        StatefulBuilder(
          builder: (context, setState) {
            return CustomTextFormField(
              hintText: AppLocalizations.of(context)!.password,
              errorText: passwordError,
              keyboardType: TextInputType.visiblePassword,
              prefixIcon: AwesomeIconsLight.lock_keyhole,
              validator: Validators.validateNotNull,
              onSaved: (value) => password = value,
              suffixIcon: obscureText
                  ? AwesomeIconsLight.eye_slash
                  : AwesomeIconsLight.eye,
              obscureText: obscureText,
              suffixOnTap: () => setState(() => obscureText = !obscureText),
              onEditingComplete: validateSaveAndCallNext,
            );
          },
        ),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: RichText(
            text: TextSpan(
              style: context.h5b1.copyWith(height: 1.5),
              children: [
                TextSpan(
                  text: AppLocalizations.of(context)!.forgot_your_password,
                  style: context.h5b1.copyWith(
                    color: context.secondary,
                    height: 1.5,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => context.push(
                          widget: ForgotPassword(
                            authRouteNotifier: widget.authRouteNotifier,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ],
      labelAuthButton: AppLocalizations.of(context)!.signin,
      onPressedAuthButton: next,
      normalTextSpan: AppLocalizations.of(context)!.you_dont_have_an_account,
      highlightedTextSpan: AppLocalizations.of(context)!.register,
      recognizerTextSpan: () =>
          widget.authRouteNotifier.value = AuthRoute.register,
    );
  }

  Future<void> validateSaveAndCallNext() async {
    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();
    await next();
  }

  Future<void> next() async {
    FocusScope.of(context).unfocus();
    if (emailError.isNotNullOrEmpty || passwordError.isNotNullOrEmpty) {
      setState(() {
        emailError = null;
        passwordError = null;
      });
    }
    await Dialogs.of(context).runAsyncAction(
      future: () => FirebaseAuthenticationRepository.signInWithEmailAndPassword(
        email: email!,
        password: password!,
      ),
      onComplete: (_) => context.read<UserCubit>().emitUserLoading(),
      onError: (e) {
        try {
          throw e;
        } on FirebaseException catch (e) {
          switch (e.code) {
            case 'weak-password':
            case 'wrong-password':
              passwordError =
                  Functions.of(context).translateExceptionKey(e.code);
              break;
            default:
              emailError = Functions.of(context).translateExceptionKey(e.code);
          }
          setState(() {});
        } catch (e) {
          setState(() {
            emailError = AppLocalizations.of(context)!.unknown_error;
          });
        }
      },
    );
  }
}
