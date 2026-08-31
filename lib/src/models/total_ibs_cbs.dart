import 'dart:convert';

/// Um dos tributos totalizados de `<IBSCBSTot>`: `<gIBSUF>`, `<gIBSMun>` ou
/// `<gCBS>`.
///
/// Como no nível do item, os três têm a mesma forma e mudam só o sufixo da tag
/// de valor (`vIBSUF`, `vIBSMun`, `vCBS`), então uma classe parametrizada
/// atende aos três. `vCredPres`/`vCredPresCondSus` só aparecem em `<gCBS>`.
class TotalTributoIbsCbs {
  /// Valor diferido (`vDif`).
  String? vDif;

  /// Valor devolvido ao contribuinte (`vDevTrib`).
  String? vDevTrib;

  /// Valor do tributo (`vIBSUF`, `vIBSMun` ou `vCBS`).
  String? valor;

  /// Crédito presumido (`vCredPres`).
  String? vCredPres;

  /// Crédito presumido em condição suspensiva (`vCredPresCondSus`).
  String? vCredPresCondSus;

  /// Construtor da classe `TotalTributoIbsCbs`.
  TotalTributoIbsCbs({
    this.vDif,
    this.vDevTrib,
    this.valor,
    this.vCredPres,
    this.vCredPresCondSus,
  });

  /// Converte a instância atual em um mapa (`Map<String, dynamic>`).
  Map<String, dynamic> toMap() {
    return {
      'vDif': vDif,
      'vDevTrib': vDevTrib,
      'valor': valor,
      'vCredPres': vCredPres,
      'vCredPresCondSus': vCredPresCondSus,
    };
  }

  /// Cria uma instância a partir de `<gIBSUF>`, `<gIBSMun>` ou `<gCBS>`.
  ///
  /// ### Parâmetros:
  /// - [map]: Conteúdo do grupo.
  /// - [sufixo]: Sufixo da tag de valor — `IBSUF`, `IBSMun` ou `CBS`.
  factory TotalTributoIbsCbs.fromMap(
    Map<String, dynamic> map, {
    required String sufixo,
  }) {
    return TotalTributoIbsCbs(
      vDif: map['vDif'],
      vDevTrib: map['vDevTrib'],
      // A segunda chave permite o round-trip a partir do mapa de [toMap].
      valor: map['v$sufixo'] ?? map['valor'],
      vCredPres: map['vCredPres'],
      vCredPresCondSus: map['vCredPresCondSus'],
    );
  }

  /// Converte a instância atual em uma string JSON.
  String toJson() => json.encode(toMap());
}

/// Grupo `<gIBS>` de `<IBSCBSTot>` — o IBS totalizado da nota.
class TotalIbs {
  /// IBS de competência estadual (`gIBSUF`).
  TotalTributoIbsCbs? uf;

  /// IBS de competência municipal (`gIBSMun`).
  TotalTributoIbsCbs? mun;

  /// Valor total do IBS (`vIBS`).
  String? vIBS;

  /// Crédito presumido (`vCredPres`).
  String? vCredPres;

  /// Crédito presumido em condição suspensiva (`vCredPresCondSus`).
  String? vCredPresCondSus;

  /// Construtor da classe `TotalIbs`.
  TotalIbs({
    this.uf,
    this.mun,
    this.vIBS,
    this.vCredPres,
    this.vCredPresCondSus,
  });

  /// Converte a instância atual em um mapa (`Map<String, dynamic>`).
  Map<String, dynamic> toMap() {
    return {
      'gIBSUF': uf?.toMap(),
      'gIBSMun': mun?.toMap(),
      'vIBS': vIBS,
      'vCredPres': vCredPres,
      'vCredPresCondSus': vCredPresCondSus,
    };
  }

  /// Cria uma instância de `TotalIbs` a partir do grupo `<gIBS>`.
  factory TotalIbs.fromMap(Map<String, dynamic> map) {
    final uf = map['gIBSUF'];
    final mun = map['gIBSMun'];

    return TotalIbs(
      vIBS: map['vIBS'],
      vCredPres: map['vCredPres'],
      vCredPresCondSus: map['vCredPresCondSus'],
      uf: uf is Map<String, dynamic>
          ? TotalTributoIbsCbs.fromMap(uf, sufixo: 'IBSUF')
          : null,
      mun: mun is Map<String, dynamic>
          ? TotalTributoIbsCbs.fromMap(mun, sufixo: 'IBSMun')
          : null,
    );
  }

  /// Converte a instância atual em uma string JSON.
  String toJson() => json.encode(toMap());

  /// Cria uma instância de `TotalIbs` a partir de uma string JSON.
  factory TotalIbs.fromJson(String source) =>
      TotalIbs.fromMap(json.decode(source));
}

/// Grupo `<gMono>` de `<IBSCBSTot>` — totais da tributação monofásica.
class TotalMonofasico {
  /// Valor do IBS monofásico (`vIBSMono`).
  String? vIBSMono;

  /// Valor da CBS monofásica (`vCBSMono`).
  String? vCBSMono;

  /// Valor do IBS monofásico sujeito a retenção (`vIBSMonoReten`).
  String? vIBSMonoReten;

  /// Valor da CBS monofásica sujeita a retenção (`vCBSMonoReten`).
  String? vCBSMonoReten;

  /// Valor do IBS monofásico retido anteriormente (`vIBSMonoRet`).
  String? vIBSMonoRet;

  /// Valor da CBS monofásica retida anteriormente (`vCBSMonoRet`).
  String? vCBSMonoRet;

  /// Construtor da classe `TotalMonofasico`.
  TotalMonofasico({
    this.vIBSMono,
    this.vCBSMono,
    this.vIBSMonoReten,
    this.vCBSMonoReten,
    this.vIBSMonoRet,
    this.vCBSMonoRet,
  });

  /// Converte a instância atual em um mapa (`Map<String, dynamic>`).
  Map<String, dynamic> toMap() {
    return {
      'vIBSMono': vIBSMono,
      'vCBSMono': vCBSMono,
      'vIBSMonoReten': vIBSMonoReten,
      'vCBSMonoReten': vCBSMonoReten,
      'vIBSMonoRet': vIBSMonoRet,
      'vCBSMonoRet': vCBSMonoRet,
    };
  }

  /// Cria uma instância de `TotalMonofasico` a partir do grupo `<gMono>`.
  factory TotalMonofasico.fromMap(Map<String, dynamic> map) {
    return TotalMonofasico(
      vIBSMono: map['vIBSMono'],
      vCBSMono: map['vCBSMono'],
      vIBSMonoReten: map['vIBSMonoReten'],
      vCBSMonoReten: map['vCBSMonoReten'],
      vIBSMonoRet: map['vIBSMonoRet'],
      vCBSMonoRet: map['vCBSMonoRet'],
    );
  }

  /// Converte a instância atual em uma string JSON.
  String toJson() => json.encode(toMap());

  /// Cria uma instância de `TotalMonofasico` a partir de uma string JSON.
  factory TotalMonofasico.fromJson(String source) =>
      TotalMonofasico.fromMap(json.decode(source));
}

/// Grupo `<IBSCBSTot>` — os totais de IBS e CBS da nota.
class TotalIbsCbs {
  /// Base de cálculo do IBS/CBS (`vBCIBSCBS`).
  String? vBCIBSCBS;

  /// Totais do IBS (`gIBS`).
  TotalIbs? ibs;

  /// Totais da CBS (`gCBS`).
  TotalTributoIbsCbs? cbs;

  /// Totais da tributação monofásica (`gMono`).
  TotalMonofasico? mono;

  /// Construtor da classe `TotalIbsCbs`.
  ///
  /// ### Parâmetros:
  /// - [vBCIBSCBS]: Base de cálculo do IBS/CBS.
  /// - [ibs]: Totais do IBS.
  /// - [cbs]: Totais da CBS.
  /// - [mono]: Totais da tributação monofásica.
  TotalIbsCbs({this.vBCIBSCBS, this.ibs, this.cbs, this.mono});

  /// Converte a instância atual em um mapa (`Map<String, dynamic>`).
  Map<String, dynamic> toMap() {
    return {
      'vBCIBSCBS': vBCIBSCBS,
      'gIBS': ibs?.toMap(),
      'gCBS': cbs?.toMap(),
      'gMono': mono?.toMap(),
    };
  }

  /// Cria uma instância de `TotalIbsCbs` a partir do grupo `<IBSCBSTot>`.
  factory TotalIbsCbs.fromMap(Map<String, dynamic> map) {
    final ibs = map['gIBS'];
    final cbs = map['gCBS'];
    final mono = map['gMono'];

    return TotalIbsCbs(
      vBCIBSCBS: map['vBCIBSCBS'],
      ibs: ibs is Map<String, dynamic> ? TotalIbs.fromMap(ibs) : null,
      cbs: cbs is Map<String, dynamic>
          ? TotalTributoIbsCbs.fromMap(cbs, sufixo: 'CBS')
          : null,
      mono: mono is Map<String, dynamic> ? TotalMonofasico.fromMap(mono) : null,
    );
  }

  /// Converte a instância atual em uma string JSON.
  String toJson() => json.encode(toMap());

  /// Cria uma instância de `TotalIbsCbs` a partir de uma string JSON.
  factory TotalIbsCbs.fromJson(String source) =>
      TotalIbsCbs.fromMap(json.decode(source));
}
