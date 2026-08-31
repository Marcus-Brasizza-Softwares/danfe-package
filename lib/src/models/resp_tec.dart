import 'dart:convert';

/// Grupo `<infRespTec>` — responsável técnico pela emissão do documento.
class InfRespTec {
  /// CNPJ da empresa responsável técnica pelo sistema emissor (`CNPJ`).
  String? cnpj;

  /// Nome da pessoa de contato (`xContato`).
  String? xContato;

  /// E-mail da pessoa de contato (`email`).
  String? email;

  /// Telefone da pessoa de contato (`fone`).
  String? fone;

  /// Construtor da classe `InfRespTec`.
  ///
  /// ### Parâmetros:
  /// - [cnpj]: CNPJ do responsável técnico.
  /// - [xContato]: Nome da pessoa de contato.
  /// - [email]: E-mail de contato.
  /// - [fone]: Telefone de contato.
  InfRespTec({this.cnpj, this.xContato, this.email, this.fone});

  /// Converte a instância atual em um mapa (`Map<String, dynamic>`).
  Map<String, dynamic> toMap() {
    return {'cnpj': cnpj, 'xContato': xContato, 'email': email, 'fone': fone};
  }

  /// Cria uma instância de `InfRespTec` a partir do grupo `<infRespTec>`.
  factory InfRespTec.fromMap(Map<String, dynamic> map) {
    return InfRespTec(
      cnpj: map['CNPJ'] ?? map['cnpj'],
      xContato: map['xContato'],
      email: map['email'],
      fone: map['fone'],
    );
  }

  /// Converte a instância atual em uma string JSON.
  String toJson() => json.encode(toMap());

  /// Cria uma instância de `InfRespTec` a partir de uma string JSON.
  factory InfRespTec.fromJson(String source) =>
      InfRespTec.fromMap(json.decode(source));
}
