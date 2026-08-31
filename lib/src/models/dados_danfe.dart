import 'dart:convert';

import 'dest.dart';
import 'det.dart';
import 'emit.dart';
import 'ide.dart';
import 'inf_adic.dart';
import 'pgto.dart';
import 'resp_tec.dart';
import 'total.dart';

/// A classe `DadosDanfe` representa o conteúdo de `<infNFe>` — a parte do
/// documento fiscal que é idêntica entre NF-e (modelo 55) e NFC-e (modelo 65).
///
/// O que é exclusivo de cada modelo não fica aqui, e sim nas subclasses de
/// `Danfe`: `transp`/`cobr` em `DanfeNFe`, `infNFeSupl`/QR Code em `DanfeNFCe`.
class DadosDanfe {
  /// Identificação da nota fiscal.
  /// Instância da classe [Ide], que contém informações como UF, série e data de emissão.
  Ide? ide;

  /// Dados do emitente da nota.
  /// Instância da classe [Emit], que contém informações como CNPJ, nome e endereço do emitente.
  Emit? emit;

  /// Dados do destinatário da nota.
  /// Instância da classe [Dest], que contém informações como CPF/CNPJ e nome do destinatário.
  Dest? dest;

  /// Lista de itens (detalhes) presentes na nota.
  /// Cada item é representado por uma instância da classe [Det].
  List<Det>? det;

  /// Totais calculados da nota fiscal.
  /// Representados por uma instância da classe [Total].
  Total? total;

  /// Informações sobre os pagamentos realizados.
  /// Instância da classe [Pgto], que detalha as formas de pagamento e valores envolvidos.
  Pgto? pgto;

  /// Informações adicionais presentes no DANFE.
  /// Instância da classe [InfAdic], contendo observações fiscais e complementares.
  InfAdic? infAdic;

  /// Chave de acesso da nota fiscal (44 dígitos, sem o prefixo `NFe`).
  String? chaveNota;

  /// Versão do layout do documento.
  String? sVersao;

  /// Responsável técnico pela emissão (`infRespTec`).
  InfRespTec? infRespTec;

  /// Construtor da classe `DadosDanfe`.
  ///
  /// ### Parâmetros:
  /// - [ide]: Informações de identificação da nota.
  /// - [emit]: Informações do emitente.
  /// - [dest]: Informações do destinatário.
  /// - [det]: Lista de itens (detalhes) da nota.
  /// - [total]: Informações dos totais da nota.
  /// - [pgto]: Informações sobre os pagamentos.
  /// - [infAdic]: Informações adicionais.
  /// - [chaveNota]: Chave de acesso da nota fiscal.
  /// - [sVersao]: Versão do layout.
  /// - [infRespTec]: Responsável técnico pela emissão.
  DadosDanfe({
    this.ide,
    this.emit,
    this.dest,
    this.det,
    this.total,
    this.pgto,
    this.infAdic,
    this.chaveNota,
    this.sVersao,
    this.infRespTec,
  });

  /// Converte a instância atual em um mapa (`Map<String, dynamic>`).
  Map<String, dynamic> toMap() {
    return {
      'ide': ide?.toMap(),
      'emit': emit?.toMap(),
      'dest': dest?.toMap(),
      'det': det?.map((x) => x.toMap()).toList(),
      'total': total?.toMap(),
      'pgto': pgto?.toMap(),
      'infAdic': infAdic?.toMap(),
      'chaveNota': chaveNota,
      'sVersao': sVersao,
      'infRespTec': infRespTec?.toMap(),
    };
  }

  /// Cria uma instância de `DadosDanfe` a partir do mapa de `<infNFe>`.
  ///
  /// O `xml2json` no formato Parker colapsa listas de um único elemento em um
  /// mapa, daí o tratamento defensivo em `det`.
  factory DadosDanfe.fromMap(Map<String, dynamic> map) {
    final detRaw = map['det'];
    final List<Det>? det = detRaw is List
        ? List<Det>.from(detRaw.map((x) => Det.fromMap(x)))
        : detRaw != null
        ? [Det.fromMap(detRaw)]
        : null;

    return DadosDanfe(
      ide: map['ide'] != null ? Ide.fromMap(map['ide']) : null,
      emit: map['emit'] != null ? Emit.fromMap(map['emit']) : null,
      dest: (map['dest'] != null && map['dest'] != '')
          ? Dest.fromMap(map['dest'])
          : null,
      det: det,
      total: map['total'] != null ? Total.fromMap(map['total']) : null,
      pgto: (map['pag'] ?? map['pgto']) != null
          ? Pgto.fromMap(map['pag'] ?? map['pgto'])
          : null,
      infAdic: map['infAdic'] != null ? InfAdic.fromMap(map['infAdic']) : null,
      chaveNota: _extrairChave(map),
      sVersao: map['_versao'] ?? map['sVersao'],
      infRespTec: map['infRespTec'] is Map<String, dynamic>
          ? InfRespTec.fromMap(map['infRespTec'])
          : null,
    );
  }

  /// Extrai a chave de acesso do atributo `Id` de `<infNFe>`, removendo o
  /// prefixo `NFe`. Cai em `chaveNota` para permitir o round-trip via [fromJson].
  static String? _extrairChave(Map<String, dynamic> map) {
    final id = map['_Id'] ?? map['chaveNota'];
    return id is String ? id.replaceAll('NFe', '') : null;
  }

  /// Converte a instância atual em uma string JSON.
  String toJson() => json.encode(toMap());

  /// Cria uma instância de `DadosDanfe` a partir de uma string JSON.
  factory DadosDanfe.fromJson(String source) =>
      DadosDanfe.fromMap(json.decode(source));
}
