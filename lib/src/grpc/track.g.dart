// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$nawaltTrackingAPIHash() => r'3f8c4acdd4ce577a070b79cf0047ceb26c194e86';

/// See also [nawaltTrackingAPI].
@ProviderFor(nawaltTrackingAPI)
final nawaltTrackingAPIProvider = Provider<NawaltTrackingClientGRPC>.internal(
  nawaltTrackingAPI,
  name: r'nawaltTrackingAPIProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$nawaltTrackingAPIHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef NawaltTrackingAPIRef = ProviderRef<NawaltTrackingClientGRPC>;
String _$recordPositionHash() => r'6bad22fae9ce226a0e8323f0b8f492e738208c5f';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [recordPosition].
@ProviderFor(recordPosition)
const recordPositionProvider = RecordPositionFamily();

/// See also [recordPosition].
class RecordPositionFamily extends Family<AsyncValue<void>> {
  /// See also [recordPosition].
  const RecordPositionFamily();

  /// See also [recordPosition].
  RecordPositionProvider call({
    required AuthData auth,
    required UserPositionReport request,
  }) {
    return RecordPositionProvider(
      auth: auth,
      request: request,
    );
  }

  @override
  RecordPositionProvider getProviderOverride(
    covariant RecordPositionProvider provider,
  ) {
    return call(
      auth: provider.auth,
      request: provider.request,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'recordPositionProvider';
}

/// See also [recordPosition].
class RecordPositionProvider extends FutureProvider<void> {
  /// See also [recordPosition].
  RecordPositionProvider({
    required AuthData auth,
    required UserPositionReport request,
  }) : this._internal(
          (ref) => recordPosition(
            ref as RecordPositionRef,
            auth: auth,
            request: request,
          ),
          from: recordPositionProvider,
          name: r'recordPositionProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$recordPositionHash,
          dependencies: RecordPositionFamily._dependencies,
          allTransitiveDependencies:
              RecordPositionFamily._allTransitiveDependencies,
          auth: auth,
          request: request,
        );

  RecordPositionProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.auth,
    required this.request,
  }) : super.internal();

  final AuthData auth;
  final UserPositionReport request;

  @override
  Override overrideWith(
    FutureOr<void> Function(RecordPositionRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RecordPositionProvider._internal(
        (ref) => create(ref as RecordPositionRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        auth: auth,
        request: request,
      ),
    );
  }

  @override
  FutureProviderElement<void> createElement() {
    return _RecordPositionProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RecordPositionProvider &&
        other.auth == auth &&
        other.request == request;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, auth.hashCode);
    hash = _SystemHash.combine(hash, request.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin RecordPositionRef on FutureProviderRef<void> {
  /// The parameter `auth` of this provider.
  AuthData get auth;

  /// The parameter `request` of this provider.
  UserPositionReport get request;
}

class _RecordPositionProviderElement extends FutureProviderElement<void>
    with RecordPositionRef {
  _RecordPositionProviderElement(super.provider);

  @override
  AuthData get auth => (origin as RecordPositionProvider).auth;
  @override
  UserPositionReport get request => (origin as RecordPositionProvider).request;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
