import 'package:flutter_dotenv/flutter_dotenv.dart';

class DataManagement{
  static get loadEnvData async => await dotenv.load(fileName: ".env");/// MAke Sure There is a file named as '.env' in root dir

  static String? getEnvData(String key) => dotenv.env[key];

  static get getAppId => getEnvData('appID');
  static get getAppSigningKey => getEnvData('appSignKey');

}
