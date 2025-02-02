import 'package:shared_preferences/shared_preferences.dart';
import '../common/constant.dart';

class LocalStorageUtils {
  static final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  //从缓存中获取token
  static Future<String> getToken() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(TOKEN_STORAGE_KEY) ?? '';
    // 测试数据
    // return 'eyJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE3MjE0MDMxMzMsInN1YiI6IntcImF2YXRlclwiOlwiL3N0YXRpYy91c2VyL2F2YXRlci_lkLTmgKjlkLTmgpQuanBnXCIsXCJiaXJ0aGRheVwiOlwiMTk5MC0xMC04XCIsXCJjcmVhdGVEYXRlXCI6MTU2NTYyNTYwMDAwMCxcImRpc2FibGVkXCI6MCxcImVtYWlsXCI6XCIyNzUwMTg3MjNAcXEuY29tXCIsXCJwZXJtaXNzaW9uXCI6MSxcInJvbGVcIjpcImFkbWluXCIsXCJzZXhcIjpcIjFcIixcInNpZ25cIjpcIuaXoOaAqO-8jOacieaClFwiLFwidGVsZXBob25lXCI6XCIxNTMwMjY4Njk0N1wiLFwidXBkYXRlRGF0ZVwiOjE3MTM3OTgwMzMwMDAsXCJ1c2VySWRcIjpcIuWQtOaAqOWQtOaClFwiLFwidXNlcm5hbWVcIjpcIuWQtOaAqOWQtOaClFwifSIsImV4cCI6MTcyMzk5NTEzM30.pB3xyg5-gnwzGerKDyeK2646l4FpHTwzpoRplKQg0zk';
  }

  //保存token
  static Future setToken(String token) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString(TOKEN_STORAGE_KEY, token);
  }
}
