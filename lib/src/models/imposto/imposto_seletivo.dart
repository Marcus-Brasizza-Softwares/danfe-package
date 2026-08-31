import 'dart:convert';

/// Grupo `<IS>` de um item — o Imposto Seletivo criado pela reforma
/// tributária (NT 2025.002).
class ImpostoSeletivo {
  /// Código de Situação Tributária do IS (`CSTIS`).
  String? cstIs;

  /// Código de classificação tributária do IS (`cClassTribIS`).
  String? cClassTribIs;

  /// Base de cálculo do IS (`vBCIS`).
  String? vBCIS;

  /// Alíquota do IS em percentual (`pIS`).
  String? pIS;

  /// Alíquota específica por unidade de medida (`pISEspec`).
  String? pISEspec;

  /// Unidade de medida tributável (`uTrib`).
  String? uTrib;

  /// Quantidade tributável (`qTrib`).
  String? qTrib;

  /// Valor do Imposto Seletivo (`vIS`).
  String? vIS;

  /// Construtor da classe `ImpostoSeletivo`.
  ImpostoSeletivo({
    this.cstIs,
    this.cClassTribIs,
    this.vBCIS,
    this.pIS,
    this.pISEspec,
    this.uTrib,
    this.qTrib,
    this.vIS,
  });

  /// Converte a instância atual em um mapa (`Map<String, dynamic>`).
  Map<String, dynamic> toMap() {
    return {
      'CSTIS': cstIs,
      'cClassTribIS': cClassTribIs,
      'vBCIS': vBCIS,
      'pIS': pIS,
      'pISEspec': pISEspec,
      'uTrib': uTrib,
      'qTrib': qTrib,
      'vIS': vIS,
    };
  }

  /// Cria uma instância de `ImpostoSeletivo` a partir do grupo `<IS>`.
  ///
  /// ### Exemplo:
  /// ```dart
  /// final is_ = ImpostoSeletivo.fromMap({'CSTIS': '200', 'vIS': '0.01'});
  /// print(is_.vIS); // 0.01
  /// ```
  factory ImpostoSeletivo.fromMap(Map<String, dynamic> map) {
    return ImpostoSeletivo(
      cstIs: map['CSTIS'],
      cClassTribIs: map['cClassTribIS'],
      vBCIS: map['vBCIS'],
      pIS: map['pIS'],
      pISEspec: map['pISEspec'],
      uTrib: map['uTrib'],
      qTrib: map['qTrib'],
      vIS: map['vIS'],
    );
  }

  /// Converte a instância atual em uma string JSON.
  String toJson() => json.encode(toMap());

  /// Cria uma instância de `ImpostoSeletivo` a partir de uma string JSON.
  factory ImpostoSeletivo.fromJson(String source) =>
      ImpostoSeletivo.fromMap(json.decode(source));
}
