import 'package:intl/intl.dart';

class AppFormatters {
  static final currency = NumberFormat.currency(symbol: '\$');
  
  static String formatCurrency(double amount) {
    return currency.format(amount);
  }

  static String formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('MMM dd, yyyy').format(date);
  }

  static String formatHours(double hours) {
    return '${hours.toStringAsFixed(1)} hrs';
  }
}
