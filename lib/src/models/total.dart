import 'dart:convert';

import 'total_ibs_cbs.dart';

/// A classe `Total` representa os totais de valores em um documento fiscal.
///
/// A maior parte dos valores vem do grupo `<ICMSTot>`, e os da reforma
/// tributária dos grupos irmãos `<IBSCBSTot>` ([ibsCbs]), `<ISTot>`
/// ([valorIs]) e `<vNFTot>` ([valorTotalNota]). Todos são mantidos como
/// `String` no mesmo formato do XML (ex.: `'0.00'`).
class Total {
  /// Valor total dos produtos (`ICMSTot/vProd`).
  String? valorTotal;

  /// Valor do desconto aplicado ao documento (`ICMSTot/vDesc`).
  String? desconto;

  /// Valor do acréscimo/outras despesas (`ICMSTot/vOutro`).
  String? acrescimo;

  /// Valor total da nota (`ICMSTot/vNF`).
  String? valorPago;

  /// Valor do ICMS (`ICMSTot/vICMS`).
  String? valorIcms;

  /// Valor do frete (`ICMSTot/vFrete`).
  String? valorFrete;

  /// Valor do PIS (`ICMSTot/vPIS`).
  String? valorPis;

  /// Valor do COFINS (`ICMSTot/vCOFINS`).
  String? valorCofins;

  /// Valor do IPI (`ICMSTot/vIPI`).
  String? valorIpi;

  /// Valor do ICMS por substituição tributária (`ICMSTot/vST`).
  String? valorSt;

  /// Valor total dos tributos incidentes (`ICMSTot/vTotTrib`).
  String? valorTotalTributos;

  /// Base de cálculo do ICMS (`ICMSTot/vBC`).
  String? valorBaseCalculo;

  /// Valor do ICMS desonerado (`ICMSTot/vICMSDeson`).
  String? valorIcmsDesonerado;

  /// Base de cálculo do ICMS ST (`ICMSTot/vBCST`).
  String? valorBaseCalculoSt;

  /// Valor do seguro (`ICMSTot/vSeg`).
  String? valorSeguro;

  /// Valor do Fundo de Combate à Pobreza (`ICMSTot/vFCP`).
  String? valorFcp;

  /// Valor do FCP retido por substituição tributária (`ICMSTot/vFCPST`).
  String? valorFcpSt;

  /// Valor do FCP retido anteriormente por ST (`ICMSTot/vFCPSTRet`).
  String? valorFcpStRetido;

  /// Valor do Imposto de Importação (`ICMSTot/vII`).
  String? valorImpostoImportacao;

  /// Valor do IPI devolvido (`ICMSTot/vIPIDevol`).
  String? valorIpiDevolvido;

  /// Totais de IBS e CBS da reforma tributária (`IBSCBSTot`).
  TotalIbsCbs? ibsCbs;

  /// Valor total do Imposto Seletivo (`ISTot/vIS`).
  String? valorIs;

  /// Valor total da nota incluindo IBS, CBS e IS (`vNFTot`).
  ///
  /// Diferente de [valorPago] (`ICMSTot/vNF`), que não considera os tributos
  /// da reforma.
  String? valorTotalNota;

  /// Construtor da classe `Total`.
  Total({
    this.valorTotal,
    this.desconto,
    this.acrescimo,
    this.valorPago,
    this.valorCofins,
    this.valorFrete,
    this.valorIcms,
    this.valorPis,
    this.valorIpi,
    this.valorSt,
    this.valorTotalTributos,
    this.valorBaseCalculo,
    this.valorBaseCalculoSt,
    this.valorIcmsDesonerado,
    this.valorSeguro,
    this.valorFcp,
    this.valorFcpSt,
    this.valorFcpStRetido,
    this.valorImpostoImportacao,
    this.valorIpiDevolvido,
    this.ibsCbs,
    this.valorIs,
    this.valorTotalNota,
  });

  /// Converte a instância atual em um mapa (`Map<String, dynamic>`).
  ///
  /// Serializa **todos** os campos, de modo que
  /// `Total.fromJson(total.toJson())` seja um round-trip fiel.
  ///
  /// ### Exemplo:
  /// ```dart
  /// Total total = Total(valorTotal: '100.00', desconto: '5.00');
  /// Map<String, dynamic> mapa = total.toMap();
  /// print(mapa['valorTotal']); // Saída: 100.00
  /// ```
  Map<String, dynamic> toMap() {
    return {
      'valorTotal': valorTotal,
      'desconto': desconto,
      'acrescimo': acrescimo,
      'valorPago': valorPago,
      'valorCofins': valorCofins,
      'valorFrete': valorFrete,
      'valorIcms': valorIcms,
      'valorPis': valorPis,
      'valorIpi': valorIpi,
      'valorSt': valorSt,
      'valorTotalTributos': valorTotalTributos,
      'valorBaseCalculo': valorBaseCalculo,
      'valorBaseCalculoSt': valorBaseCalculoSt,
      'valorIcmsDesonerado': valorIcmsDesonerado,
      'valorSeguro': valorSeguro,
      'valorFcp': valorFcp,
      'valorFcpSt': valorFcpSt,
      'valorFcpStRetido': valorFcpStRetido,
      'valorImpostoImportacao': valorImpostoImportacao,
      'valorIpiDevolvido': valorIpiDevolvido,
      'ibsCbs': ibsCbs?.toMap(),
      'valorIs': valorIs,
      'valorTotalNota': valorTotalNota,
    };
  }

  /// Cria uma instância de `Total` a partir do grupo `<total>` do XML.
  ///
  /// Aceita tanto o mapa do `<total>` (com `ICMSTot` aninhado) quanto um mapa
  /// já plano vindo de [toMap], para permitir o round-trip via [fromJson].
  factory Total.fromMap(Map<String, dynamic> map) {
    final icmsTot = map['ICMSTot'];

    /// Lê a chave do grupo `ICMSTot`; se ausente, cai no formato plano do
    /// [toMap] e, por fim, no padrão `'0.00'`.
    String ler(String tagXml, String campo) =>
        icmsTot?[tagXml] ?? map[campo] ?? '0.00';

    // Grupos da reforma, irmãos de `ICMSTot` dentro de `<total>`. O formato
    // Parker devolve string vazia para elemento vazio, daí o `is Map`.
    final ibsCbsTot = map['IBSCBSTot'] ?? map['ibsCbs'];
    final isTot = map['ISTot'];

    return Total(
      ibsCbs: ibsCbsTot is Map<String, dynamic>
          ? TotalIbsCbs.fromMap(ibsCbsTot)
          : null,
      valorIs: (isTot is Map ? isTot['vIS'] : null) ?? map['valorIs'] ?? '0.00',
      valorTotalNota: map['vNFTot'] ?? map['valorTotalNota'],
      valorFcp: ler('vFCP', 'valorFcp'),
      valorFcpSt: ler('vFCPST', 'valorFcpSt'),
      valorFcpStRetido: ler('vFCPSTRet', 'valorFcpStRetido'),
      valorImpostoImportacao: ler('vII', 'valorImpostoImportacao'),
      valorIpiDevolvido: ler('vIPIDevol', 'valorIpiDevolvido'),
      valorTotal: ler('vProd', 'valorTotal'),
      desconto: ler('vDesc', 'desconto'),
      acrescimo: ler('vOutro', 'acrescimo'),
      valorPago: ler('vNF', 'valorPago'),
      valorIcms: ler('vICMS', 'valorIcms'),
      valorFrete: ler('vFrete', 'valorFrete'),
      valorPis: ler('vPIS', 'valorPis'),
      valorCofins: ler('vCOFINS', 'valorCofins'),
      valorIpi: ler('vIPI', 'valorIpi'),
      valorSt: ler('vST', 'valorSt'),
      valorTotalTributos: ler('vTotTrib', 'valorTotalTributos'),
      valorBaseCalculo: ler('vBC', 'valorBaseCalculo'),
      valorBaseCalculoSt: ler('vBCST', 'valorBaseCalculoSt'),
      valorIcmsDesonerado: ler('vICMSDeson', 'valorIcmsDesonerado'),
      valorSeguro: ler('vSeg', 'valorSeguro'),
    );
  }

  /// Converte a instância atual em uma string JSON.
  String toJson() => json.encode(toMap());

  /// Cria uma instância de `Total` a partir de uma string JSON.
  factory Total.fromJson(String source) => Total.fromMap(json.decode(source));
}
