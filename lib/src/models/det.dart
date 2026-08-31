import 'dart:convert';

import 'imposto/imposto.dart';
import 'prod.dart';

/// A classe `Det` representa os detalhes de um item em um documento fiscal.
///
/// ### Funcionalidades:
/// - Suporte à conversão para mapas (`Map<String, dynamic>`) e JSON.
/// - Permite inicialização a partir de mapas e strings JSON.
class Det {
  /// Informações do produto associado ao item.
  Prod? prod;

  /// Grupo de tributos do item (`<imposto>`).
  ///
  /// É aqui que entram os grupos IBS/CBS da reforma tributária — ver [Imposto].
  Imposto? imposto;

  /// Número sequencial do item no documento fiscal.
  String? sNItem;

  /// Valor total do item (`<det><vItem>`), do Grupo VB da NT 2025.002.
  ///
  /// Não confundir com o `Prod.vItem` do SAT, removido na 3.0.0: aquele ficava
  /// em `det/prod/vItem` e tinha outro significado. Este é filho direto de
  /// `<det>`.
  String? vItem;

  /// Construtor da classe `Det`.
  ///
  /// ### Parâmetros:
  /// - [prod]: Informações do produto.
  /// - [imposto]: Grupo de tributos do item.
  /// - [sNItem]: Número sequencial do item.
  /// - [vItem]: Valor total do item.
  Det({this.prod, this.imposto, this.sNItem, this.vItem});

  /// Converte a instância atual em um mapa (`Map<String, dynamic>`).
  ///
  /// ### Retorno:
  /// - Um mapa contendo os valores das propriedades de `Det`.
  ///
  /// ### Exemplo:
  /// ```dart
  /// Det det = Det(prod: Prod(nome: 'Produto A'), sNItem: '001');
  /// Map<String, dynamic> mapa = det.toMap();
  /// print(mapa); // Saída: {prod: {...}, sNItem: 001}
  /// ```
  Map<String, dynamic> toMap() {
    return {
      'prod': prod?.toMap(),
      'imposto': imposto?.toMap(),
      'sNItem': sNItem,
      'vItem': vItem,
    };
  }

  /// Cria uma instância de `Det` a partir de um mapa (`Map<String, dynamic>`).
  ///
  /// ### Parâmetros:
  /// - [map]: Um mapa contendo as chaves e valores correspondentes às propriedades de `Det`.
  ///
  /// ### Retorno:
  /// - Uma instância de `Det` populada com os valores fornecidos no mapa.
  ///
  /// ### Exemplo:
  /// ```dart
  /// Map<String, dynamic> mapa = {'prod': {...}, '_nItem': '001'};
  /// Det det = Det.fromMap(mapa);
  /// print(det.sNItem); // Saída: 001
  /// ```
  factory Det.fromMap(Map<String, dynamic> map) {
    final prod = map['prod'];
    final imposto = map['imposto'];

    return Det(
      prod: prod is Map<String, dynamic> ? Prod.fromMap(prod) : null,
      imposto: imposto is Map<String, dynamic>
          ? Imposto.fromMap(imposto)
          : null,
      sNItem: map['_nItem'] ?? map['sNItem'],
      vItem: map['vItem'],
    );
  }

  /// Converte a instância atual em uma string JSON.
  ///
  /// ### Retorno:
  /// - Uma string JSON contendo os dados de `Det`.
  ///
  /// ### Exemplo:
  /// ```dart
  /// Det det = Det(prod: Prod(nome: 'Produto A'), sNItem: '001');
  /// String json = det.toJson();
  /// print(json); // Saída: {"prod":{...},"sNItem":"001"}
  /// ```
  String toJson() => json.encode(toMap());

  /// Cria uma instância de `Det` a partir de uma string JSON.
  ///
  /// ### Parâmetros:
  /// - [source]: Uma string JSON contendo os dados para a classe.
  ///
  /// ### Retorno:
  /// - Uma instância de `Det` populada com os valores fornecidos na string JSON.
  ///
  /// ### Exemplo:
  /// ```dart
  /// String json = '{"prod":{...},"_nItem":"001"}';
  /// Det det = Det.fromJson(json);
  /// print(det.sNItem); // Saída: 001
  /// ```
  factory Det.fromJson(String source) => Det.fromMap(json.decode(source));
}
