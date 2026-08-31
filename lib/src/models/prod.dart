import 'dart:convert';

/// A classe `Prod` representa os detalhes de um produto em um documento fiscal.
///
/// ### Funcionalidades:
/// - Suporte à conversão para mapas (`Map<String, dynamic>`) e JSON.
/// - Permite inicialização a partir de mapas e strings JSON.
class Prod {
  /// Código do produto.
  String? cProd;

  /// Descrição do produto.
  String? xProd;

  /// Nomenclatura Comum do Mercosul (NCM).
  String? nCM;

  /// Código Fiscal de Operações e Prestações (CFOP).
  String? cFOP;

  /// Unidade comercializada.
  String? uCom;

  /// Quantidade comercializada.
  String? qCom;

  /// Valor unitário comercializado.
  String? vUnCom;

  /// Valor total do produto.
  String? vProd;

  /// Valor do desconto aplicado ao item.
  String? vDesc;

  /// GTIN (código de barras) do produto — `SEM GTIN` quando não houver.
  String? cEAN;

  /// GTIN da unidade tributável.
  String? cEANTrib;

  /// Código Especificador da Substituição Tributária (`CEST`).
  String? cest;

  /// Indicador de escala relevante (`indEscala`).
  String? indEscala;

  /// Código do benefício fiscal na UF (`cBenef`).
  String? cBenef;

  /// Unidade tributável.
  String? uTrib;

  /// Quantidade tributável.
  String? qTrib;

  /// Valor unitário de tributação.
  String? vUnTrib;

  /// Indica se o valor do item compõe o total da nota (`indTot`).
  String? indTot;

  /// Número do item no pedido de compra (`nItemPed`).
  String? nItemPed;

  /// Construtor da classe `Prod`.
  ///
  /// ### Parâmetros:
  /// - [cProd]: Código do produto.
  /// - [xProd]: Descrição do produto.
  /// - [nCM]: NCM do produto.
  /// - [cFOP]: CFOP do produto.
  /// - [uCom]: Unidade comercializada.
  /// - [qCom]: Quantidade comercializada.
  /// - [vUnCom]: Valor unitário.
  /// - [vProd]: Valor total do produto.
  /// - [vDesc]: Valor do desconto.
  Prod({
    this.cProd,
    this.xProd,
    this.nCM,
    this.cFOP,
    this.uCom,
    this.qCom,
    this.vUnCom,
    this.vProd,
    this.vDesc,
    this.cEAN,
    this.cEANTrib,
    this.cest,
    this.indEscala,
    this.cBenef,
    this.uTrib,
    this.qTrib,
    this.vUnTrib,
    this.indTot,
    this.nItemPed,
  });

  /// Converte a instância atual em um mapa (`Map<String, dynamic>`).
  ///
  /// ### Retorno:
  /// - Um mapa contendo os valores das propriedades de `Prod`.
  ///
  /// ### Exemplo:
  /// ```dart
  /// Prod prod = Prod(cProd: '001', xProd: 'Produto A', vProd: '100.00');
  /// Map<String, dynamic> mapa = prod.toMap();
  /// print(mapa); // Saída: {cProd: 001, xProd: Produto A, vProd: 100.00}
  /// ```
  Map<String, dynamic> toMap() {
    return {
      'cProd': cProd,
      'xProd': xProd,
      'nCM': nCM,
      'cFOP': cFOP,
      'uCom': uCom,
      'qCom': qCom,
      'vUnCom': vUnCom,
      'vProd': vProd,
      'vDesc': vDesc,
      'cEAN': cEAN,
      'cEANTrib': cEANTrib,
      'cest': cest,
      'indEscala': indEscala,
      'cBenef': cBenef,
      'uTrib': uTrib,
      'qTrib': qTrib,
      'vUnTrib': vUnTrib,
      'indTot': indTot,
      'nItemPed': nItemPed,
    };
  }

  /// Cria uma instância de `Prod` a partir de um mapa (`Map<String, dynamic>`).
  ///
  /// ### Parâmetros:
  /// - [map]: Um mapa contendo as chaves e valores correspondentes às propriedades de `Prod`.
  ///
  /// ### Retorno:
  /// - Uma instância de `Prod` populada com os valores fornecidos no mapa.
  ///
  /// ### Exemplo:
  /// ```dart
  /// Map<String, dynamic> mapa = {'cProd': '001', 'xProd': 'Produto A', 'vProd': '100.00'};
  /// Prod prod = Prod.fromMap(mapa);
  /// print(prod.xProd); // Saída: Produto A
  /// ```
  factory Prod.fromMap(Map<String, dynamic> map) {
    return Prod(
      cProd: map['cProd'],
      xProd: map['xProd'],
      nCM: map['NCM'] ?? map['nCM'],
      cFOP: map['CFOP'] ?? map['cFOP'],
      uCom: map['uCom'],
      qCom: map['qCom'],
      vUnCom: map['vUnCom'],
      vProd: map['vProd'],
      cEAN: map['cEAN'],
      cEANTrib: map['cEANTrib'],
      cest: map['CEST'] ?? map['cest'],
      indEscala: map['indEscala'],
      cBenef: map['cBenef'],
      uTrib: map['uTrib'],
      qTrib: map['qTrib'],
      vUnTrib: map['vUnTrib'],
      indTot: map['indTot'],
      nItemPed: map['nItemPed'],
      vDesc: map['vDesc'] ?? '',
    );
  }

  /// Converte a instância atual em uma string JSON.
  ///
  /// ### Retorno:
  /// - Uma string JSON contendo os dados de `Prod`.
  ///
  /// ### Exemplo:
  /// ```dart
  /// Prod prod = Prod(cProd: '001', xProd: 'Produto A', vProd: '100.00');
  /// String json = prod.toJson();
  /// print(json); // Saída: {"cProd":"001","xProd":"Produto A","vProd":"100.00"}
  /// ```
  String toJson() => json.encode(toMap());

  /// Cria uma instância de `Prod` a partir de uma string JSON.
  ///
  /// ### Parâmetros:
  /// - [source]: Uma string JSON contendo os dados para a classe.
  ///
  /// ### Retorno:
  /// - Uma instância de `Prod` populada com os valores fornecidos na string JSON.
  ///
  /// ### Exemplo:
  /// ```dart
  /// String json = '{"cProd":"001","xProd":"Produto A","vProd":"100.00"}';
  /// Prod prod = Prod.fromJson(json);
  /// print(prod.vProd); // Saída: 100.00
  /// ```
  factory Prod.fromJson(String source) => Prod.fromMap(json.decode(source));
}
