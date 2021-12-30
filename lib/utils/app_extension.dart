
import 'formatter.dart';

extension PriceParsing on int {
  String toPrice() {
    return "${UtilFormatter.formatNumber(this)}₫";
  }
}
