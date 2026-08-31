import 'dart:convert';

import 'card_pagamento.dart';

/// A classe `MP` representa uma forma de pagamento (`<detPag>`) de uma
/// Nota Fiscal Eletrônica.
///
/// ### Funcionalidades:
/// - Suporte à conversão para mapas (`Map<String, dynamic>`) e JSON.
/// - Mapeamento de códigos para descrições de formas de pagamento.
class MP {
  /// Descrição da forma de pagamento, já traduzida a partir de `tPag`.
  String? tPag;

  /// Valor associado à forma de pagamento (`vPag`).
  String? vPag;

  /// Dados do cartão, quando o pagamento foi feito com um (`card`).
  CardPagamento? card;

  /// Tabela de códigos de forma de pagamento da NF-e (`tPag`).
  static const Map<String, String> formasPagamento = {
    "01": "Dinheiro",
    "02": "Cheque",
    "03": "Cartão de Crédito",
    "04": "Cartão de Débito",
    "05": "Crédito Loja",
    "10": "Vale Alimentação",
    "11": "Vale Refeição",
    "12": "Vale Presente",
    "13": "Vale Combustível",
    "14": "Duplicata Mercantil",
    "15": "Boleto Bancário",
    "16": "Depósito Bancário",
    "17": "PIX",
    "18": "Transferência Bancária, Carteira Digital",
    "19": "Cashback, Cartão Fidelidade",
    "20": "Programas de Pontos",
    "21": "Crédito Virtual",
    "90": "Sem Pagamento",
    "99": "Outros",
  };

  /// Construtor da classe `MP`.
  ///
  /// ### Parâmetros:
  /// - [tPag]: Descrição da forma de pagamento.
  /// - [vPag]: Valor da forma de pagamento.
  /// - [card]: Dados do cartão utilizado.
  MP({this.tPag, this.vPag, this.card});

  /// Converte a instância atual em um mapa (`Map<String, dynamic>`).
  ///
  /// ### Exemplo:
  /// ```dart
  /// MP mp = MP(tPag: 'Dinheiro', vPag: '100.00');
  /// print(mp.toMap()); // Saída: {tPag: Dinheiro, vPag: 100.00}
  /// ```
  Map<String, dynamic> toMap() {
    return {'tPag': tPag, 'vPag': vPag, 'card': card?.toMap()};
  }

  /// Cria uma instância de `MP` a partir de um `<detPag>`.
  ///
  /// O código de `tPag` é traduzido para a descrição correspondente; códigos
  /// desconhecidos são preservados como vieram.
  ///
  /// ### Exemplo:
  /// ```dart
  /// MP mp = MP.fromMap({'tPag': '01', 'vPag': '100.00'});
  /// print(mp.tPag); // Saída: Dinheiro
  /// ```
  factory MP.fromMap(Map<String, dynamic> map) {
    final codigo = map['tPag'];
    final card = map['card'];
    return MP(
      tPag: formasPagamento[codigo] ?? codigo,
      vPag: map['vPag'],
      card: card is Map<String, dynamic> ? CardPagamento.fromMap(card) : null,
    );
  }

  /// Converte a instância atual em uma string JSON.
  String toJson() => json.encode(toMap());

  /// Cria uma instância de `MP` a partir de uma string JSON.
  factory MP.fromJson(String source) => MP.fromMap(json.decode(source));
}
