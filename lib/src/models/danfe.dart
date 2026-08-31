import 'dart:convert';

import 'cobr.dart';
import 'dados_danfe.dart';
import 'inf_supl.dart';
import 'prot_nfe.dart';
import 'transp.dart';

/// Enum que representa os modelos de documento fiscal suportados.
///
/// O SAT (`CFe`, modelo 59) deixou de ser emitido e não é mais suportado
/// desde a versão 3.0.0.
enum TipoDocumento {
  /// Nota Fiscal Eletrônica — modelo 55.
  NFe,

  /// Nota Fiscal de Consumidor Eletrônica — modelo 65.
  NFCe,
}

/// Extensão para facilitar a conversão entre `TipoDocumento` e `String`.
extension TipoDocumentoExtension on TipoDocumento {
  /// Obtém o valor em string correspondente ao tipo de documento.
  String get value {
    switch (this) {
      case TipoDocumento.NFe:
        return 'NFe';
      case TipoDocumento.NFCe:
        return 'NFCe';
    }
  }

  /// Modelo do documento fiscal (`55` ou `65`).
  String get modelo {
    switch (this) {
      case TipoDocumento.NFe:
        return '55';
      case TipoDocumento.NFCe:
        return '65';
    }
  }

  /// Converte uma string em uma enumeração `TipoDocumento`.
  static TipoDocumento fromString(String value) {
    switch (value) {
      case 'NFe':
        return TipoDocumento.NFe;
      case 'NFCe':
        return TipoDocumento.NFCe;
      default:
        throw ArgumentError('Tipo de documento desconhecido: $value');
    }
  }
}

/// A classe `Danfe` representa os dados estruturados de um DANFE
/// (Documento Auxiliar da Nota Fiscal Eletrônica).
///
/// É uma classe `sealed`: existe exatamente uma subclasse por modelo de
/// documento fiscal — [DanfeNFe] (modelo 55) e [DanfeNFCe] (modelo 65).
/// Isso faz com que um `switch` sobre um `Danfe` seja exaustivo em tempo de
/// compilação, e mantém em cada subclasse apenas os campos que aquele modelo
/// de fato possui.
///
/// ### Exemplo:
/// ```dart
/// final danfe = DanfeParser.readFromString(xml);
/// switch (danfe) {
///   case DanfeNFCe d:
///     print(d.qrcodePrinter); // QR Code só existe na NFC-e
///   case DanfeNFe d:
///     print(d.transp?.transporta?.xNome); // transporte só na NF-e
///   case null:
///     print('XML não reconhecido');
/// }
/// ```
///
/// Instâncias não são criadas diretamente a partir do XML: use
/// `DanfeParser.readFromString`.
sealed class Danfe {
  /// Dados principais do DANFE.
  /// Instância da classe [DadosDanfe], que centraliza as informações do documento fiscal.
  DadosDanfe? dados;

  /// Protocolo de autorização da Nota Fiscal.
  /// Presente apenas quando o XML é um `nfeProc` (nota já autorizada).
  ProtNFe? protNFe;

  Danfe({this.dados, this.protNFe});

  /// Modelo do documento fiscal: `55` (NF-e) ou `65` (NFC-e).
  String get modelo;

  /// Tipo do documento fiscal.
  TipoDocumento get tipo;

  /// Descrição usada no cabeçalho impresso (ex.: `NFe`, `NFC-E`).
  String get descricao;

  /// Converte a instância atual em um mapa (`Map<String, dynamic>`).
  Map<String, dynamic> toMap() {
    return {
      'dados': dados?.toMap(),
      'tipo': tipo.value,
      'modelo': modelo,
      'protNFe': protNFe?.toMap(),
    };
  }

  /// Converte a instância atual em uma string JSON.
  String toJson() => json.encode(toMap());

  /// Método utilitário para obter um valor de forma segura de um mapa.
  static T? safeGet<T>(Map<String, dynamic> map, String key) {
    return map.containsKey(key) && map[key] != null ? map[key] as T : null;
  }
}

/// DANFE do modelo **55 — Nota Fiscal Eletrônica (NF-e)**.
///
/// Diferente da NFC-e, não possui QR Code (`infNFeSupl`), e é o modelo que
/// carrega os grupos de transporte (`transp`) e cobrança (`cobr`).
final class DanfeNFe extends Danfe {
  /// Informações sobre o transporte dos itens (`<transp>`).
  Transp? transp;

  /// Informações sobre a cobrança da nota — fatura e duplicatas (`<cobr>`).
  Cobr? cobr;

  DanfeNFe({super.dados, super.protNFe, this.transp, this.cobr});

  @override
  String get modelo => '55';

  @override
  TipoDocumento get tipo => TipoDocumento.NFe;

  @override
  String get descricao => 'NFe';

  @override
  Map<String, dynamic> toMap() {
    return {...super.toMap(), 'transp': transp?.toMap(), 'cobr': cobr?.toMap()};
  }
}

/// DANFE do modelo **65 — Nota Fiscal de Consumidor Eletrônica (NFC-e)**.
///
/// Sempre acompanha o grupo `infNFeSupl`, de onde saem o QR Code e a URL de
/// consulta impressos no cupom.
final class DanfeNFCe extends Danfe {
  /// Informações suplementares da Nota Fiscal (QR Code e URL de consulta).
  InfNFeSupl? infNFeSupl;

  /// QR Code preparado para impressão.
  String? qrcodePrinter;

  DanfeNFCe({
    super.dados,
    super.protNFe,
    this.infNFeSupl,
    this.qrcodePrinter,
  });

  @override
  String get modelo => '65';

  @override
  TipoDocumento get tipo => TipoDocumento.NFCe;

  @override
  String get descricao => 'NFC-E';

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'infNFeSupl': infNFeSupl?.toMap(),
      'qrcodePrinter': qrcodePrinter,
    };
  }
}
