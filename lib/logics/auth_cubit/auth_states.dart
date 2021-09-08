abstract class AuthStates {}

class MainInitialState extends AuthStates {}

class OnVerificationCompleted extends AuthStates {}

class VerificationLoadingState extends AuthStates {}

class OnVerificationFailed extends AuthStates {
  final String error;

  OnVerificationFailed(this.error);
}

class CodeSentSuccessfully extends AuthStates {}

class CodeAutoRetrievalTimeout extends AuthStates {}

class SubmitOtpSuccessfully extends AuthStates {}

class SubmitOtpError extends AuthStates {
  final String error;

  SubmitOtpError(this.error);
}

class SignOutSuccessfully extends AuthStates {}
