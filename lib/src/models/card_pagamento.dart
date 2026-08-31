import 'dart:convert';

/// Grupo `<card>` de uma forma de pagamento (`pag/detPag/card`).
///
/// Presente quando o pagamento foi feito com cartão — traz a bandeira e o
/// código de autorização da operadora.
class CardPagamento {
  /// Tipo de integração do processo de pagamento (`tpIntegra`):
  /// 1 = integrado com o sistema de automação, 2 = não integrado (POS avulso).
  String? tpIntegra;

  /// CNPJ da credenciadora do cartão (`CNPJ`).
  String? cnpj;

  /// Bandeira da operadora do cartão (`tBand`).
  String? tBand;

  /// Número de autorização da transação (`cAut`).
  String? cAut;

  /// Construtor da classe `CardPagamento`.
  ///
  /// ### Parâmetros:
  /// - [tpIntegra]: Tipo de integração do pagamento.
  /// - [cnpj]: CNPJ da credenciadora.
  /// - [tBand]: Bandeira do cartão.
  /// - [cAut]: Número de autorização da transação.
  CardPagamento({this.tpIntegra, this.cnpj, this.tBand, this.cAut});

  /// Converte a instância atual em um mapa (`Map<String, dynamic>`).
  Map<String, dynamic> toMap() {
    return {
      'tpIntegra': tpIntegra,
      'cnpj': cnpj,
      'tBand': tBand,
      'cAut': cAut,
    };
  }

  /// Cria uma instância de `CardPagamento` a partir do grupo `<card>`.
  ///
  /// ### Exemplo:
  /// ```dart
  /// final card = CardPagamento.fromMap({'tBand': '02', 'cAut': '362667'});
  /// print(card.tBand); // 02
  /// ```
  factory CardPagamento.fromMap(Map<String, dynamic> map) {
    return CardPagamento(
      tpIntegra: map['tpIntegra'],
      cnpj: map['CNPJ'] ?? map['cnpj'],
      tBand: map['tBand'],
      cAut: map['cAut'],
    );
  }

  /// Converte a instância atual em uma string JSON.
  String toJson() => json.encode(toMap());

  /// Cria uma instância de `CardPagamento` a partir de uma string JSON.
  factory CardPagamento.fromJson(String source) =>
      CardPagamento.fromMap(json.decode(source));
}
