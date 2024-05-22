import 'package:mellotippet/services/mello_tippet_package_info.dart';

class FakeMellotippetPackageInfo implements MellotippetPackageInfo {
  @override
  late String version;

  FakeMellotippetPackageInfo(this.version);

  @override
  Future<void> initialize() async {}
}
