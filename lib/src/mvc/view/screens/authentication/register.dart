import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../business_logic/cubits.dart';
import '../../../../tools.dart';
import '../../../controller/services.dart';
import '../../../../data/enums.dart';
import '../../model_widgets.dart';
import '../../screens.dart';

class Register extends StatefulWidget {
  const Register({
    super.key,
    required this.authRouteNotifier,
  });

  final ValueNotifier<AuthRoute> authRouteNotifier;

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GlobalKey<FormState> formKey = GlobalKey();
  bool obscureText = true;
  bool checkbox = false;
  String? email, password, passwordRetype;
  String? emailError, passwordError, passwordRetypeError;

  @override
  Widget build(BuildContext context) {
    return AuthenticationPage(
      onPressedLeadingAppBar: null,
      title: AppLocalizations.of(context)!.register,
      subtitle: AppLocalizations.of(context)!.register_hint,
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
            return Column(
              children: [
                CustomTextFormField(
                  hintText: AppLocalizations.of(context)!.password,
                  errorText: passwordError,
                  keyboardType: TextInputType.visiblePassword,
                  prefixIcon: AwesomeIconsLight.lock_keyhole,
                  textInputAction: TextInputAction.next,
                  validator: (value) =>
                      Validators.of(context).validateNotNullMinLength(
                    value: value,
                    minLength: 6,
                  ),
                  onSaved: (value) => password = value,
                  suffixIcon: obscureText
                      ? AwesomeIconsLight.eye_slash
                      : AwesomeIconsLight.eye,
                  obscureText: obscureText,
                  suffixOnTap: () => setState(() => obscureText = !obscureText),
                ),
                CustomTextFormField(
                  hintText: AppLocalizations.of(context)!.confirm_password,
                  errorText: passwordRetypeError,
                  keyboardType: TextInputType.visiblePassword,
                  prefixIcon: AwesomeIconsLight.lock_keyhole,
                  validator: Validators.validateNotNull,
                  onSaved: (value) => passwordRetype = value,
                  suffixIcon: obscureText
                      ? AwesomeIconsLight.eye_slash
                      : AwesomeIconsLight.eye,
                  obscureText: obscureText,
                  suffixOnTap: () => setState(() => obscureText = !obscureText),
                  onEditingComplete: validateSaveAndCallNext,
                ),
              ],
            );
          },
        ),
        StatefulBuilder(
          builder: (context, setState) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  visualDensity: VisualDensity.compact,
                  value: checkbox,
                  onChanged: (value) =>
                      setState(() => checkbox = value ?? false),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.sp),
                  ),
                ),
                8.widthW,
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: context.h5b1.copyWith(height: 1.5),
                      children: [
                        TextSpan(
                          text: AppLocalizations.of(context)!.i_read_accept,
                        ),
                        TextSpan(
                          text:
                              ' ${AppLocalizations.of(context)!.terms_of_user}',
                          style: context.h5b1.copyWith(
                            color: context.secondary,
                            height: 1.5,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => launchUrl(
                                  Uri.parse('https://github.com'),
                                ),
                        ),
                        TextSpan(
                          text: ' ${AppLocalizations.of(context)!.and} ',
                        ),
                        TextSpan(
                          text: AppLocalizations.of(context)!.privacy_policy,
                          style: context.h5b1.copyWith(
                            color: context.secondary,
                            height: 1.5,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => launchUrl(
                                  Uri.parse('https://github.com'),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
      labelAuthButton: AppLocalizations.of(context)!.register,
      onPressedAuthButton: next,
      normalTextSpan: AppLocalizations.of(context)!.you_already_have_an_account,
      highlightedTextSpan: AppLocalizations.of(context)!.signin,
      recognizerTextSpan: () =>
          widget.authRouteNotifier.value = AuthRoute.signin,
    );
  }

  Future<void> validateSaveAndCallNext() async {
    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();
    await next();
  }

  Future<void> next() async {
    FocusScope.of(context).unfocus();
    if (emailError.isNotNullOrEmpty ||
        passwordError.isNotNullOrEmpty ||
        passwordRetypeError.isNotNullOrEmpty) {
      setState(() {
        emailError = null;
        passwordError = null;
        passwordRetypeError = null;
      });
    }
    if (password != passwordRetype) {
      setState(() {
        passwordRetypeError =
            AppLocalizations.of(context)!.please_confirm_your_password;
      });
      return;
    }
    if (!checkbox) {
      context.showSnackBar(
        AppLocalizations.of(context)!.please_read_accept_terms_of_user,
      );
      return;
    }
    await Dialogs.of(context).runAsyncAction(
      future: () =>
          FirebaseAuthenticationRepository.createUserWithEmailAndPassword(
        email: email!,
        password: password!,
      ),
      onComplete: (_) => BlocProvider.of<UserCubit>(context).emitUserLoading(),
      onError: (e) {
        setState(() {
          emailError = Functions.of(context).translateException(e);
        });
      },
    );
  }
}
