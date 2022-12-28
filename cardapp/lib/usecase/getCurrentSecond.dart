import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

String getCurrentSecond() {
  DateTime now = DateTime.now(); // 저장하기 누르면 반환
  String formatDate = DateFormat('"yyyy-MM-dd HH:mm:ss').format(now).toString();
  return formatDate;
}
