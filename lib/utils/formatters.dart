import 'package:intl/intl.dart';

class Formatters {
  static String moeda(double valor) {
    final formatador = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$ ');
    return formatador.format(valor);
  }

  static String telefoneBR(String telefone) {
    if (telefone.length == 11) {
      return "(${telefone.substring(0, 2)}) "
          "${telefone.substring(2, 7)}-"
          "${telefone.substring(7)}";
    } else if (telefone.length == 10) {
      return "(${telefone.substring(0, 2)}) "
          "${telefone.substring(2, 6)}-"
          "${telefone.substring(6)}";
    }
    return telefone;
  }
}
