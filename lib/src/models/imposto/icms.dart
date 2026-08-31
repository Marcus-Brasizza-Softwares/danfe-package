import 'dart:convert';

/// Grupo `<ICMS>` de um item.
///
/// No XML este grupo tem exatamente um filho, e o **nome** desse filho é a
/// variante do CST: `ICMS00`, `ICMS10`, `ICMS40`, `ICMS60`, `ICMSSN102`,
/// `ICMSSN500`… São cerca de vinte, cada uma com um subconjunto próprio de
/// campos.
///
/// Modelar uma classe por variante não se paga num pacote de impressão, então
/// a variante é achatada: [grupo] guarda o nome do filho e os demais campos
/// são a união dos valores possíveis, nulos quando a variante não os traz.
class Icms {
  /// Nome do grupo no XML — `ICMS00`, `ICMS40`, `ICMSSN102`…
  String? grupo;

  /// Origem da mercadoria (`orig`).
  String? orig;

  /// Situação tributária — `CST` no regime normal, `CSOSN` no Simples.
  String? cst;

  /// Modalidade de determinação da base de cálculo (`modBC`).
  String? modBC;

  /// Base de cálculo do ICMS (`vBC`).
  String? vBC;

  /// Alíquota do ICMS (`pICMS`).
  String? pICMS;

  /// Valor do ICMS (`vICMS`).
  String? vICMS;

  /// Alíquota do Fundo de Combate à Pobreza (`pFCP`).
  String? pFCP;

  /// Valor do Fundo de Combate à Pobreza (`vFCP`).
  String? vFCP;

  /// Base de cálculo do ICMS ST (`vBCST`).
  String? vBCST;

  /// Valor do ICMS ST (`vST`).
  String? vST;

  /// Construtor da classe `Icms`.
  Icms({
    this.grupo,
    this.orig,
    this.cst,
    this.modBC,
    this.vBC,
    this.pICMS,
    this.vICMS,
    this.pFCP,
    this.vFCP,
    this.vBCST,
    this.vST,
  });

  /// Converte a instância atual em um mapa (`Map<String, dynamic>`).
  Map<String, dynamic> toMap() {
    return {
      'grupo': grupo,
      'orig': orig,
      'cst': cst,
      'modBC': modBC,
      'vBC': vBC,
      'pICMS': pICMS,
      'vICMS': vICMS,
      'pFCP': pFCP,
      'vFCP': vFCP,
      'vBCST': vBCST,
      'vST': vST,
    };
  }

  /// Cria uma instância de `Icms` a partir do grupo `<ICMS>`.
  ///
  /// Aceita tanto o mapa do XML (`{'ICMS00': {...}}`) quanto o mapa plano
  /// gerado por [toMap], para permitir o round-trip via [fromJson].
  ///
  /// ### Exemplo:
  /// ```dart
  /// final icms = Icms.fromMap({
  ///   'ICMS00': {'orig': '0', 'CST': '00', 'vICMS': '3.40'},
  /// });
  /// print(icms.grupo);  // ICMS00
  /// print(icms.vICMS);  // 3.40
  /// ```
  factory Icms.fromMap(Map<String, dynamic> map) {
    // Formato plano vindo de toMap().
    if (map.containsKey('grupo')) {
      return Icms(
        grupo: map['grupo'],
        orig: map['orig'],
        cst: map['cst'],
        modBC: map['modBC'],
        vBC: map['vBC'],
        pICMS: map['pICMS'],
        vICMS: map['vICMS'],
        pFCP: map['pFCP'],
        vFCP: map['vFCP'],
        vBCST: map['vBCST'],
        vST: map['vST'],
      );
    }

    // Formato do XML: uma única variante, cujo nome identifica o CST.
    if (map.isEmpty) {
      return Icms();
    }
    final variante = map.entries.first;
    final valores = variante.value;
    if (valores is! Map) {
      return Icms(grupo: variante.key);
    }

    return Icms(
      grupo: variante.key,
      orig: valores['orig'],
      cst: valores['CST'] ?? valores['CSOSN'],
      modBC: valores['modBC'],
      vBC: valores['vBC'],
      pICMS: valores['pICMS'],
      vICMS: valores['vICMS'],
      pFCP: valores['pFCP'],
      vFCP: valores['vFCP'],
      vBCST: valores['vBCST'],
      vST: valores['vST'],
    );
  }

  /// Converte a instância atual em uma string JSON.
  String toJson() => json.encode(toMap());

  /// Cria uma instância de `Icms` a partir de uma string JSON.
  factory Icms.fromJson(String source) => Icms.fromMap(json.decode(source));
}
