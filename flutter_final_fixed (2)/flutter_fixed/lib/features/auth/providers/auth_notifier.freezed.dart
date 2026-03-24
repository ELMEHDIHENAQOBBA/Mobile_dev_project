// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AuthState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() unauthenticated,
    required TResult Function(User user) authenticated,
    required TResult Function(User user) authenticatedAsGuide,
    required TResult Function() loading,
    required TResult Function(String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? unauthenticated,
    TResult? Function(User user)? authenticated,
    TResult? Function(User user)? authenticatedAsGuide,
    TResult? Function()? loading,
    TResult? Function(String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? unauthenticated,
    TResult Function(User user)? authenticated,
    TResult Function(User user)? authenticatedAsGuide,
    TResult Function()? loading,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Unauthenticated value) unauthenticated,
    required TResult Function(_Authenticated value) authenticated,
    required TResult Function(_AuthenticatedAsGuide value) authenticatedAsGuide,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Error value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Unauthenticated value)? unauthenticated,
    TResult? Function(_Authenticated value)? authenticated,
    TResult? Function(_AuthenticatedAsGuide value)? authenticatedAsGuide,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Error value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Unauthenticated value)? unauthenticated,
    TResult Function(_Authenticated value)? authenticated,
    TResult Function(_AuthenticatedAsGuide value)? authenticatedAsGuide,
    TResult Function(_Loading value)? loading,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthStateCopyWith<$Res> {
  factory $AuthStateCopyWith(AuthState value, $Res Function(AuthState) then) =
      _$AuthStateCopyWithImpl<$Res, AuthState>;
}

/// @nodoc
class _$AuthStateCopyWithImpl<$Res, $Val extends AuthState>
    implements $AuthStateCopyWith<$Res> {
  _$AuthStateCopyWithImpl(this._value, this._then);
  final $Val _value;
  final $Res Function($Val) _then;
}

// ─── _Initial ────────────────────────────────────────────────────────────────

/// @nodoc
abstract class _$$InitialImplCopyWith<$Res> {
  factory _$$InitialImplCopyWith(
          _$InitialImpl value, $Res Function(_$InitialImpl) then) =
      __$$InitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InitialImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$InitialImpl>
    implements _$$InitialImplCopyWith<$Res> {
  __$$InitialImplCopyWithImpl(
      _$InitialImpl _value, $Res Function(_$InitialImpl) _then)
      : super(_value, _then);
}

/// @nodoc
class _$InitialImpl implements _Initial {
  const _$InitialImpl();

  @override
  String toString() => 'AuthState.initial()';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other.runtimeType == runtimeType && other is _$InitialImpl);

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() unauthenticated,
    required TResult Function(User user) authenticated,
    required TResult Function(User user) authenticatedAsGuide,
    required TResult Function() loading,
    required TResult Function(String message) error,
  }) => initial();

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? unauthenticated,
    TResult? Function(User user)? authenticated,
    TResult? Function(User user)? authenticatedAsGuide,
    TResult? Function()? loading,
    TResult? Function(String message)? error,
  }) => initial?.call();

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? unauthenticated,
    TResult Function(User user)? authenticated,
    TResult Function(User user)? authenticatedAsGuide,
    TResult Function()? loading,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) => initial != null ? initial() : orElse();

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Unauthenticated value) unauthenticated,
    required TResult Function(_Authenticated value) authenticated,
    required TResult Function(_AuthenticatedAsGuide value) authenticatedAsGuide,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Error value) error,
  }) => initial(this);

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Unauthenticated value)? unauthenticated,
    TResult? Function(_Authenticated value)? authenticated,
    TResult? Function(_AuthenticatedAsGuide value)? authenticatedAsGuide,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Error value)? error,
  }) => initial?.call(this);

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Unauthenticated value)? unauthenticated,
    TResult Function(_Authenticated value)? authenticated,
    TResult Function(_AuthenticatedAsGuide value)? authenticatedAsGuide,
    TResult Function(_Loading value)? loading,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) => initial != null ? initial(this) : orElse();
}

abstract class _Initial implements AuthState {
  const factory _Initial() = _$InitialImpl;
}

// ─── _Unauthenticated ─────────────────────────────────────────────────────────

/// @nodoc
class _$UnauthenticatedImpl implements _Unauthenticated {
  const _$UnauthenticatedImpl();

  @override
  String toString() => 'AuthState.unauthenticated()';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other.runtimeType == runtimeType && other is _$UnauthenticatedImpl);

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() unauthenticated,
    required TResult Function(User user) authenticated,
    required TResult Function(User user) authenticatedAsGuide,
    required TResult Function() loading,
    required TResult Function(String message) error,
  }) => unauthenticated();

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? unauthenticated,
    TResult? Function(User user)? authenticated,
    TResult? Function(User user)? authenticatedAsGuide,
    TResult? Function()? loading,
    TResult? Function(String message)? error,
  }) => unauthenticated?.call();

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? unauthenticated,
    TResult Function(User user)? authenticated,
    TResult Function(User user)? authenticatedAsGuide,
    TResult Function()? loading,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) => unauthenticated != null ? unauthenticated() : orElse();

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Unauthenticated value) unauthenticated,
    required TResult Function(_Authenticated value) authenticated,
    required TResult Function(_AuthenticatedAsGuide value) authenticatedAsGuide,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Error value) error,
  }) => unauthenticated(this);

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Unauthenticated value)? unauthenticated,
    TResult? Function(_Authenticated value)? authenticated,
    TResult? Function(_AuthenticatedAsGuide value)? authenticatedAsGuide,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Error value)? error,
  }) => unauthenticated?.call(this);

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Unauthenticated value)? unauthenticated,
    TResult Function(_Authenticated value)? authenticated,
    TResult Function(_AuthenticatedAsGuide value)? authenticatedAsGuide,
    TResult Function(_Loading value)? loading,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) => unauthenticated != null ? unauthenticated(this) : orElse();
}

abstract class _Unauthenticated implements AuthState {
  const factory _Unauthenticated() = _$UnauthenticatedImpl;
}

// ─── _Authenticated ───────────────────────────────────────────────────────────

/// @nodoc
class _$AuthenticatedImpl implements _Authenticated {
  const _$AuthenticatedImpl(this.user);

  @override
  final User user;

  @override
  String toString() => 'AuthState.authenticated(user: $user)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other.runtimeType == runtimeType &&
          other is _$AuthenticatedImpl &&
          (identical(other.user, user) || other.user == user));

  @override
  int get hashCode => Object.hash(runtimeType, user);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() unauthenticated,
    required TResult Function(User user) authenticated,
    required TResult Function(User user) authenticatedAsGuide,
    required TResult Function() loading,
    required TResult Function(String message) error,
  }) => authenticated(user);

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? unauthenticated,
    TResult? Function(User user)? authenticated,
    TResult? Function(User user)? authenticatedAsGuide,
    TResult? Function()? loading,
    TResult? Function(String message)? error,
  }) => authenticated?.call(user);

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? unauthenticated,
    TResult Function(User user)? authenticated,
    TResult Function(User user)? authenticatedAsGuide,
    TResult Function()? loading,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) => authenticated != null ? authenticated(user) : orElse();

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Unauthenticated value) unauthenticated,
    required TResult Function(_Authenticated value) authenticated,
    required TResult Function(_AuthenticatedAsGuide value) authenticatedAsGuide,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Error value) error,
  }) => authenticated(this);

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Unauthenticated value)? unauthenticated,
    TResult? Function(_Authenticated value)? authenticated,
    TResult? Function(_AuthenticatedAsGuide value)? authenticatedAsGuide,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Error value)? error,
  }) => authenticated?.call(this);

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Unauthenticated value)? unauthenticated,
    TResult Function(_Authenticated value)? authenticated,
    TResult Function(_AuthenticatedAsGuide value)? authenticatedAsGuide,
    TResult Function(_Loading value)? loading,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) => authenticated != null ? authenticated(this) : orElse();
}

abstract class _Authenticated implements AuthState {
  const factory _Authenticated(final User user) = _$AuthenticatedImpl;
  User get user;
}

// ─── _AuthenticatedAsGuide ────────────────────────────────────────────────────

/// @nodoc
class _$AuthenticatedAsGuideImpl implements _AuthenticatedAsGuide {
  const _$AuthenticatedAsGuideImpl(this.user);

  @override
  final User user;

  @override
  String toString() => 'AuthState.authenticatedAsGuide(user: $user)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other.runtimeType == runtimeType &&
          other is _$AuthenticatedAsGuideImpl &&
          (identical(other.user, user) || other.user == user));

  @override
  int get hashCode => Object.hash(runtimeType, user);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() unauthenticated,
    required TResult Function(User user) authenticated,
    required TResult Function(User user) authenticatedAsGuide,
    required TResult Function() loading,
    required TResult Function(String message) error,
  }) => authenticatedAsGuide(user);

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? unauthenticated,
    TResult? Function(User user)? authenticated,
    TResult? Function(User user)? authenticatedAsGuide,
    TResult? Function()? loading,
    TResult? Function(String message)? error,
  }) => authenticatedAsGuide?.call(user);

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? unauthenticated,
    TResult Function(User user)? authenticated,
    TResult Function(User user)? authenticatedAsGuide,
    TResult Function()? loading,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) => authenticatedAsGuide != null ? authenticatedAsGuide(user) : orElse();

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Unauthenticated value) unauthenticated,
    required TResult Function(_Authenticated value) authenticated,
    required TResult Function(_AuthenticatedAsGuide value) authenticatedAsGuide,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Error value) error,
  }) => authenticatedAsGuide(this);

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Unauthenticated value)? unauthenticated,
    TResult? Function(_Authenticated value)? authenticated,
    TResult? Function(_AuthenticatedAsGuide value)? authenticatedAsGuide,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Error value)? error,
  }) => authenticatedAsGuide?.call(this);

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Unauthenticated value)? unauthenticated,
    TResult Function(_Authenticated value)? authenticated,
    TResult Function(_AuthenticatedAsGuide value)? authenticatedAsGuide,
    TResult Function(_Loading value)? loading,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) => authenticatedAsGuide != null ? authenticatedAsGuide(this) : orElse();
}

abstract class _AuthenticatedAsGuide implements AuthState {
  const factory _AuthenticatedAsGuide(final User user) = _$AuthenticatedAsGuideImpl;
  User get user;
}

// ─── _Loading ─────────────────────────────────────────────────────────────────

/// @nodoc
class _$LoadingImpl implements _Loading {
  const _$LoadingImpl();

  @override
  String toString() => 'AuthState.loading()';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other.runtimeType == runtimeType && other is _$LoadingImpl);

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() unauthenticated,
    required TResult Function(User user) authenticated,
    required TResult Function(User user) authenticatedAsGuide,
    required TResult Function() loading,
    required TResult Function(String message) error,
  }) => loading();

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? unauthenticated,
    TResult? Function(User user)? authenticated,
    TResult? Function(User user)? authenticatedAsGuide,
    TResult? Function()? loading,
    TResult? Function(String message)? error,
  }) => loading?.call();

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? unauthenticated,
    TResult Function(User user)? authenticated,
    TResult Function(User user)? authenticatedAsGuide,
    TResult Function()? loading,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) => loading != null ? loading() : orElse();

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Unauthenticated value) unauthenticated,
    required TResult Function(_Authenticated value) authenticated,
    required TResult Function(_AuthenticatedAsGuide value) authenticatedAsGuide,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Error value) error,
  }) => loading(this);

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Unauthenticated value)? unauthenticated,
    TResult? Function(_Authenticated value)? authenticated,
    TResult? Function(_AuthenticatedAsGuide value)? authenticatedAsGuide,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Error value)? error,
  }) => loading?.call(this);

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Unauthenticated value)? unauthenticated,
    TResult Function(_Authenticated value)? authenticated,
    TResult Function(_AuthenticatedAsGuide value)? authenticatedAsGuide,
    TResult Function(_Loading value)? loading,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) => loading != null ? loading(this) : orElse();
}

abstract class _Loading implements AuthState {
  const factory _Loading() = _$LoadingImpl;
}

// ─── _Error ───────────────────────────────────────────────────────────────────

/// @nodoc
class _$ErrorImpl implements _Error {
  const _$ErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() => 'AuthState.error(message: $message)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other.runtimeType == runtimeType &&
          other is _$ErrorImpl &&
          (identical(other.message, message) || other.message == message));

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() unauthenticated,
    required TResult Function(User user) authenticated,
    required TResult Function(User user) authenticatedAsGuide,
    required TResult Function() loading,
    required TResult Function(String message) error,
  }) => error(message);

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? unauthenticated,
    TResult? Function(User user)? authenticated,
    TResult? Function(User user)? authenticatedAsGuide,
    TResult? Function()? loading,
    TResult? Function(String message)? error,
  }) => error?.call(message);

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? unauthenticated,
    TResult Function(User user)? authenticated,
    TResult Function(User user)? authenticatedAsGuide,
    TResult Function()? loading,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) => error != null ? error(message) : orElse();

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Unauthenticated value) unauthenticated,
    required TResult Function(_Authenticated value) authenticated,
    required TResult Function(_AuthenticatedAsGuide value) authenticatedAsGuide,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Error value) error,
  }) => error(this);

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Unauthenticated value)? unauthenticated,
    TResult? Function(_Authenticated value)? authenticated,
    TResult? Function(_AuthenticatedAsGuide value)? authenticatedAsGuide,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Error value)? error,
  }) => error?.call(this);

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Unauthenticated value)? unauthenticated,
    TResult Function(_Authenticated value)? authenticated,
    TResult Function(_AuthenticatedAsGuide value)? authenticatedAsGuide,
    TResult Function(_Loading value)? loading,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) => error != null ? error(this) : orElse();
}

abstract class _Error implements AuthState {
  const factory _Error(final String message) = _$ErrorImpl;
  String get message;
}
