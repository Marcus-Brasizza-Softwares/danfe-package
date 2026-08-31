import 'dart:convert';

/// Grupo `<gRed>` — redução de alíquota aplicada a um tributo do IBS/CBS.
class ReducaoAliquota {
  /// Percentual de redução da alíquota (`pRedAliq`).
  String? pRedAliq;

  /// Alíquota efetiva após a redução (`pAliqEfet`).
  String? pAliqEfet;

  /// Construtor da classe `ReducaoAliquota`.
  ///
  /// ### Parâmetros:
  /// - [pRedAliq]: Percentual de redução da alíquota.
  /// - [pAliqEfet]: Alíquota efetiva após a redução.
  ReducaoAliquota({this.pRedAliq, this.pAliqEfet});

  /// Converte a instância atual em um mapa (`Map<String, dynamic>`).
  Map<String, dynamic> toMap() {
    return {'pRedAliq': pRedAliq, 'pAliqEfet': pAliqEfet};
  }

  /// Cria uma instância de `ReducaoAliquota` a partir do grupo `<gRed>`.
  factory ReducaoAliquota.fromMap(Map<String, dynamic> map) {
    return ReducaoAliquota(
      pRedAliq: map['pRedAliq'],
      pAliqEfet: map['pAliqEfet'],
    );
  }

  /// Converte a instância atual em uma string JSON.
  String toJson() => json.encode(toMap());

  /// Cria uma instância de `ReducaoAliquota` a partir de uma string JSON.
  factory ReducaoAliquota.fromJson(String source) =>
      ReducaoAliquota.fromMap(json.decode(source));
}

/// Um dos três tributos do grupo `<gIBSCBS>` de um item: `<gIBSUF>`,
/// `<gIBSMun>` ou `<gCBS>`.
///
/// Os três têm exatamente a mesma forma — alíquota, redução e valor — mudando
/// apenas o sufixo das tags (`pIBSUF`/`vIBSUF`, `pIBSMun`/`vIBSMun`,
/// `pCBS`/`vCBS`). Por isso uma única classe atende aos três, parametrizada
/// pelo sufixo em [TributoIbsCbs.fromMap].
class TributoIbsCbs {
  /// Alíquota do tributo (`pIBSUF`, `pIBSMun` ou `pCBS`).
  String? aliquota;

  /// Redução de alíquota, quando houver (`gRed`).
  ReducaoAliquota? reducao;

  /// Valor do tributo (`vIBSUF`, `vIBSMun` ou `vCBS`).
  String? valor;

  /// Valor diferido (`gDif`).
  String? valorDiferido;

  /// Valor devolvido ao contribuinte (`gDevTrib`).
  String? valorDevolvido;

  /// Crédito presumido (`gCredPres`).
  String? creditoPresumido;

  /// Construtor da classe `TributoIbsCbs`.
  TributoIbsCbs({
    this.aliquota,
    this.reducao,
    this.valor,
    this.valorDiferido,
    this.valorDevolvido,
    this.creditoPresumido,
  });

  /// Converte a instância atual em um mapa (`Map<String, dynamic>`).
  Map<String, dynamic> toMap() {
    return {
      'aliquota': aliquota,
      'reducao': reducao?.toMap(),
      'valor': valor,
      'valorDiferido': valorDiferido,
      'valorDevolvido': valorDevolvido,
      'creditoPresumido': creditoPresumido,
    };
  }

  /// Lê um valor que pode vir dentro de um subgrupo (`{'gDif': {'vDif': …}}`)
  /// ou direto no mapa (`{'vDif': …}`).
  ///
  /// A NT 2025.002 ainda está em revisão e as duas formas aparecem conforme o
  /// nível do documento — no total, por exemplo, `vDif` é filho direto de
  /// `<gIBSUF>`. Aceitar ambas evita depender de uma versão do leiaute.
  static String? _lerSubgrupo(
    Map<String, dynamic> map,
    String grupo,
    String tag,
  ) {
    final valor = map[grupo];
    if (valor is Map<String, dynamic>) {
      return valor[tag];
    }
    return map[tag];
  }

  /// Cria uma instância a partir de `<gIBSUF>`, `<gIBSMun>` ou `<gCBS>`.
  ///
  /// ### Parâmetros:
  /// - [map]: Conteúdo do grupo.
  /// - [sufixo]: Sufixo das tags do grupo — `IBSUF`, `IBSMun` ou `CBS`.
  ///
  /// ### Exemplo:
  /// ```dart
  /// final cbs = TributoIbsCbs.fromMap(map['gCBS'], sufixo: 'CBS');
  /// print(cbs.aliquota); // conteúdo de <pCBS>
  /// ```
  factory TributoIbsCbs.fromMap(
    Map<String, dynamic> map, {
    required String sufixo,
  }) {
    final gRed = map['gRed'];
    return TributoIbsCbs(
      // A segunda chave de cada par permite reconstruir a instância a partir
      // do mapa plano gerado por [toMap] (round-trip via fromJson).
      aliquota: map['p$sufixo'] ?? map['aliquota'],
      valor: map['v$sufixo'] ?? map['valor'],
      reducao: gRed is Map<String, dynamic>
          ? ReducaoAliquota.fromMap(gRed)
          : map['reducao'] is Map<String, dynamic>
          ? ReducaoAliquota.fromMap(map['reducao'])
          : null,
      valorDiferido: _lerSubgrupo(map, 'gDif', 'vDif') ?? map['valorDiferido'],
      valorDevolvido:
          _lerSubgrupo(map, 'gDevTrib', 'vDevTrib') ?? map['valorDevolvido'],
      creditoPresumido:
          _lerSubgrupo(map, 'gCredPres', 'vCredPres') ??
          map['creditoPresumido'],
    );
  }

  /// Converte a instância atual em uma string JSON.
  String toJson() => json.encode(toMap());
}

/// Grupo `<gIBSCBS>` — os valores de IBS e CBS de um item.
class GrupoIbsCbs {
  /// Base de cálculo do IBS/CBS (`vBC`).
  String? vBC;

  /// IBS de competência estadual (`gIBSUF`).
  TributoIbsCbs? ibsUf;

  /// IBS de competência municipal (`gIBSMun`).
  TributoIbsCbs? ibsMun;

  /// Valor total do IBS do item (`vIBS`) — soma de [ibsUf] e [ibsMun].
  String? vIBS;

  /// CBS (`gCBS`).
  TributoIbsCbs? cbs;

  /// Construtor da classe `GrupoIbsCbs`.
  GrupoIbsCbs({this.vBC, this.ibsUf, this.ibsMun, this.vIBS, this.cbs});

  /// Converte a instância atual em um mapa (`Map<String, dynamic>`).
  Map<String, dynamic> toMap() {
    return {
      'vBC': vBC,
      'gIBSUF': ibsUf?.toMap(),
      'gIBSMun': ibsMun?.toMap(),
      'vIBS': vIBS,
      'gCBS': cbs?.toMap(),
    };
  }

  /// Cria uma instância de `GrupoIbsCbs` a partir do grupo `<gIBSCBS>`.
  factory GrupoIbsCbs.fromMap(Map<String, dynamic> map) {
    final ibsUf = map['gIBSUF'];
    final ibsMun = map['gIBSMun'];
    final cbs = map['gCBS'];

    return GrupoIbsCbs(
      vBC: map['vBC'],
      vIBS: map['vIBS'],
      ibsUf: ibsUf is Map<String, dynamic>
          ? TributoIbsCbs.fromMap(ibsUf, sufixo: 'IBSUF')
          : null,
      ibsMun: ibsMun is Map<String, dynamic>
          ? TributoIbsCbs.fromMap(ibsMun, sufixo: 'IBSMun')
          : null,
      cbs: cbs is Map<String, dynamic>
          ? TributoIbsCbs.fromMap(cbs, sufixo: 'CBS')
          : null,
    );
  }

  /// Converte a instância atual em uma string JSON.
  String toJson() => json.encode(toMap());

  /// Cria uma instância de `GrupoIbsCbs` a partir de uma string JSON.
  factory GrupoIbsCbs.fromJson(String source) =>
      GrupoIbsCbs.fromMap(json.decode(source));
}

/// Grupo `<IBSCBS>` de um item — a tributação pelo IBS e pela CBS introduzida
/// pela reforma tributária (NT 2025.002).
///
/// ### Grupos ainda não modelados
/// A NT continua em revisão e as fontes públicas não publicam a lista completa
/// de tags. Ficam de fora, por ora: `gTribRegular`, `gTribCompraGov`,
/// `gIBSCBSMono` (monofasia por item), `gTransfCred` e `gALCZFMCBS`. Como
/// [TributoIbsCbs] é parametrizado pelo sufixo da tag, acrescentá-los é
/// aditivo — basta um campo novo aqui ou em [GrupoIbsCbs], mais a chave
/// correspondente em `toMap`.
class IbsCbs {
  /// Código de Situação Tributária do IBS/CBS (`CST`).
  String? cst;

  /// Código de classificação tributária (`cClassTrib`).
  String? cClassTrib;

  /// Valores de IBS e CBS (`gIBSCBS`).
  GrupoIbsCbs? grupo;

  /// Construtor da classe `IbsCbs`.
  ///
  /// ### Parâmetros:
  /// - [cst]: Código de Situação Tributária.
  /// - [cClassTrib]: Código de classificação tributária.
  /// - [grupo]: Valores de IBS e CBS.
  IbsCbs({this.cst, this.cClassTrib, this.grupo});

  /// Converte a instância atual em um mapa (`Map<String, dynamic>`).
  Map<String, dynamic> toMap() {
    return {'CST': cst, 'cClassTrib': cClassTrib, 'gIBSCBS': grupo?.toMap()};
  }

  /// Cria uma instância de `IbsCbs` a partir do grupo `<IBSCBS>`.
  factory IbsCbs.fromMap(Map<String, dynamic> map) {
    final grupo = map['gIBSCBS'];
    return IbsCbs(
      cst: map['CST'],
      cClassTrib: map['cClassTrib'],
      grupo: grupo is Map<String, dynamic> ? GrupoIbsCbs.fromMap(grupo) : null,
    );
  }

  /// Converte a instância atual em uma string JSON.
  String toJson() => json.encode(toMap());

  /// Cria uma instância de `IbsCbs` a partir de uma string JSON.
  factory IbsCbs.fromJson(String source) => IbsCbs.fromMap(json.decode(source));
}
