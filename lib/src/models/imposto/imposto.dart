import 'dart:convert';

import 'contribuicao.dart';
import 'ibs_cbs.dart';
import 'icms.dart';
import 'imposto_seletivo.dart';

/// Grupo `<imposto>` de um item da nota (`<det><imposto>`).
///
/// Durante a transição da reforma tributária os dois regimes convivem no mesmo
/// item: o antigo ([icms], [pis], [cofins]) e o novo ([ibsCbs],
/// [impostoSeletivo]). Todos são opcionais — um item isento pode trazer só
/// `ICMS40`/`PISNT`, sem grupo `IBSCBS`.
class Imposto {
  /// Valor aproximado total de tributos do item (`vTotTrib`).
  String? vTotTrib;

  /// Grupo `<ICMS>`, com a variante do CST achatada.
  Icms? icms;

  /// Grupo `<PIS>`.
  Pis? pis;

  /// Grupo `<COFINS>`.
  Cofins? cofins;

  /// Grupo `<IS>` — Imposto Seletivo.
  ImpostoSeletivo? impostoSeletivo;

  /// Grupo `<IBSCBS>` — IBS e CBS.
  IbsCbs? ibsCbs;

  /// Construtor da classe `Imposto`.
  ///
  /// ### Parâmetros:
  /// - [vTotTrib]: Valor aproximado total de tributos do item.
  /// - [icms]: Grupo `<ICMS>`.
  /// - [pis]: Grupo `<PIS>`.
  /// - [cofins]: Grupo `<COFINS>`.
  /// - [impostoSeletivo]: Grupo `<IS>`.
  /// - [ibsCbs]: Grupo `<IBSCBS>`.
  Imposto({
    this.vTotTrib,
    this.icms,
    this.pis,
    this.cofins,
    this.impostoSeletivo,
    this.ibsCbs,
  });

  /// Converte a instância atual em um mapa (`Map<String, dynamic>`).
  Map<String, dynamic> toMap() {
    return {
      'vTotTrib': vTotTrib,
      'ICMS': icms?.toMap(),
      'PIS': pis?.toMap(),
      'COFINS': cofins?.toMap(),
      'IS': impostoSeletivo?.toMap(),
      'IBSCBS': ibsCbs?.toMap(),
    };
  }

  /// Cria uma instância de `Imposto` a partir do grupo `<imposto>` do item.
  ///
  /// O `xml2json` no formato Parker devolve string vazia — e não `null` — para
  /// elementos vazios, por isso cada grupo é validado com
  /// `is Map<String, dynamic>` em vez de `!= null`.
  factory Imposto.fromMap(Map<String, dynamic> map) {
    final icms = map['ICMS'];
    final pis = map['PIS'];
    final cofins = map['COFINS'];
    final impostoSeletivo = map['IS'];
    final ibsCbs = map['IBSCBS'];

    return Imposto(
      vTotTrib: map['vTotTrib'],
      icms: icms is Map<String, dynamic> ? Icms.fromMap(icms) : null,
      pis: pis is Map<String, dynamic> ? Pis.fromMap(pis) : null,
      cofins: cofins is Map<String, dynamic> ? Cofins.fromMap(cofins) : null,
      impostoSeletivo: impostoSeletivo is Map<String, dynamic>
          ? ImpostoSeletivo.fromMap(impostoSeletivo)
          : null,
      ibsCbs: ibsCbs is Map<String, dynamic> ? IbsCbs.fromMap(ibsCbs) : null,
    );
  }

  /// Converte a instância atual em uma string JSON.
  String toJson() => json.encode(toMap());

  /// Cria uma instância de `Imposto` a partir de uma string JSON.
  factory Imposto.fromJson(String source) =>
      Imposto.fromMap(json.decode(source));
}
