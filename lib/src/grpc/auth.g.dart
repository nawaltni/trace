// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$nawaltAuthAPIHash() => r'45c1fea7ee27a74620a77e4cbc33b2a9d2a2bb7d';

/// See also [nawaltAuthAPI].
@ProviderFor(nawaltAuthAPI)
final nawaltAuthAPIProvider = Provider<NawaltAuthAPI>.internal(
  nawaltAuthAPI,
  name: r'nawaltAuthAPIProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$nawaltAuthAPIHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef NawaltAuthAPIRef = ProviderRef<NawaltAuthAPI>;
String _$pairDeviceHash() => r'ff46727cad2a949843ef2b334192c4700b6e0d8f';

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

/// See also [pairDevice].
@ProviderFor(pairDevice)
const pairDeviceProvider = PairDeviceFamily();

/// See also [pairDevice].
class PairDeviceFamily extends Family<AsyncValue<String>> {
  /// See also [pairDevice].
  const PairDeviceFamily();

  /// See also [pairDevice].
  PairDeviceProvider call({
    required String token,
  }) {
    return PairDeviceProvider(
      token: token,
    );
  }

  @override
  PairDeviceProvider getProviderOverride(
    covariant PairDeviceProvider provider,
  ) {
    return call(
      token: provider.token,
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
  String? get name => r'pairDeviceProvider';
}

/// See also [pairDevice].
class PairDeviceProvider extends FutureProvider<String> {
  /// See also [pairDevice].
  PairDeviceProvider({
    required String token,
  }) : this._internal(
          (ref) => pairDevice(
            ref as PairDeviceRef,
            token: token,
          ),
          from: pairDeviceProvider,
          name: r'pairDeviceProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$pairDeviceHash,
          dependencies: PairDeviceFamily._dependencies,
          allTransitiveDependencies:
              PairDeviceFamily._allTransitiveDependencies,
          token: token,
        );

  PairDeviceProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.token,
  }) : super.internal();

  final String token;

  @override
  Override overrideWith(
    FutureOr<String> Function(PairDeviceRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PairDeviceProvider._internal(
        (ref) => create(ref as PairDeviceRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        token: token,
      ),
    );
  }

  @override
  FutureProviderElement<String> createElement() {
    return _PairDeviceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PairDeviceProvider && other.token == token;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, token.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin PairDeviceRef on FutureProviderRef<String> {
  /// The parameter `token` of this provider.
  String get token;
}

class _PairDeviceProviderElement extends FutureProviderElement<String>
    with PairDeviceRef {
  _PairDeviceProviderElement(super.provider);

  @override
  String get token => (origin as PairDeviceProvider).token;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
