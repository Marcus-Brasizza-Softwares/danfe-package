import 'dart:convert';

/// Base comum de `<PIS>` e `<COFINS>`.
///
/// Assim como `<ICMS>`, cada um destes grupos tem exatamente um filho cujo
/// **nome** é a variante (`PISAliq`, `PISNT`, `PISQtde`, `PISOutr`, `PISST` e
/// os equivalentes de COFINS). A variante é achatada em [grupo] mais a união
/// dos campos — ver [Icms] para a mesma técnica aplicada ao ICMS.
abstract class Contribuicao {
  /// Nome do grupo no XML — `PISAliq`, `PISNT`, `COFINSAliq`…
  String? grupo;

  /// Código de Situação Tributária (`CST`).
  String? cst;

  /// Base de cálculo (`vBC`).
  String? vBC;

  /// Alíquota em percentual (`pPIS` ou `pCOFINS`).
  String? aliquota;

  /// Valor da contribuição (`vPIS` ou `vCOFINS`).
  String? valor;

  /// Construtor da classe `Contribuicao`.
  Contribuicao({
    this.grupo,
    this.cst,
    this.vBC,
    this.aliquota,
    this.valor,
  });

  /// Converte a instância atual em um mapa (`Map<String, dynamic>`).
  Map<String, dynamic> toMap() {
    return {
      'grupo': grupo,
      'cst': cst,
      'vBC': vBC,
      'aliquota': aliquota,
      'valor': valor,
    };
  }

  /// Converte a instância atual em uma string JSON.
  String toJson() => json.encode(toMap());

  /// Extrai os campos de um grupo `<PIS>`/`<COFINS>`, achatando a variante.
  ///
  /// [sufixo] é `PIS` ou `COFINS`, usado para montar os nomes `p$sufixo` e
  /// `v$sufixo`. Aceita também o mapa plano de [toMap], para o round-trip.
  static Map<String, String?> extrair(
    Map<String, dynamic> map, {
    required String sufixo,
  }) {
    if (map.containsKey('grupo')) {
      return {
        'grupo': map['grupo'],
        'cst': map['cst'],
        'vBC': map['vBC'],
        'aliquota': map['aliquota'],
        'valor': map['valor'],
      };
    }

    if (map.isEmpty) {
      return const {};
    }
    final variante = map.entries.first;
    final valores = variante.value;
    if (valores is! Map) {
      return {'grupo': variante.key};
    }

    return {
      'grupo': variante.key,
      'cst': valores['CST'],
      'vBC': valores['vBC'],
      'aliquota': valores['p$sufixo'],
      'valor': valores['v$sufixo'],
    };
  }
}

/// Grupo `<PIS>` de um item.
class Pis extends Contribuicao {
  /// Construtor da classe `Pis`.
  Pis({super.grupo, super.cst, super.vBC, super.aliquota, super.valor});

  /// Cria uma instância de `Pis` a partir do grupo `<PIS>`.
  ///
  /// ### Exemplo:
  /// ```dart
  /// final pis = Pis.fromMap({
  ///   'PISAliq': {'CST': '01', 'vBC': '85.00', 'pPIS': '1.6500', 'vPIS': '1.40'},
  /// });
  /// print(pis.grupo); // PISAliq
  /// print(pis.valor); // 1.40
  /// ```
  factory Pis.fromMap(Map<String, dynamic> map) {
    final campos = Contribuicao.extrair(map, sufixo: 'PIS');
    return Pis(
      grupo: campos['grupo'],
      cst: campos['cst'],
      vBC: campos['vBC'],
      aliquota: campos['aliquota'],
      valor: campos['valor'],
    );
  }

  /// Cria uma instância de `Pis` a partir de uma string JSON.
  factory Pis.fromJson(String source) => Pis.fromMap(json.decode(source));
}

/// Grupo `<COFINS>` de um item.
class Cofins extends Contribuicao {
  /// Construtor da classe `Cofins`.
  Cofins({super.grupo, super.cst, super.vBC, super.aliquota, super.valor});

  /// Cria uma instância de `Cofins` a partir do grupo `<COFINS>`.
  factory Cofins.fromMap(Map<String, dynamic> map) {
    final campos = Contribuicao.extrair(map, sufixo: 'COFINS');
    return Cofins(
      grupo: campos['grupo'],
      cst: campos['cst'],
      vBC: campos['vBC'],
      aliquota: campos['aliquota'],
      valor: campos['valor'],
    );
  }

  /// Cria uma instância de `Cofins` a partir de uma string JSON.
  factory Cofins.fromJson(String source) => Cofins.fromMap(json.decode(source));
}
