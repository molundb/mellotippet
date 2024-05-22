import 'package:package_info_plus/package_info_plus.dart';

abstract class MellotippetPackageInfo {
  late String version;

  Future<void> initialize() async {}
}

class MellotippetPackageInfoImplementation implements MellotippetPackageInfo {
  @override
  late String version;

  @override
  Future<void> initialize() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
  }
}