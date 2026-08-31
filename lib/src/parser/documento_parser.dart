import '../models/danfe.dart';

/// Estrutura já normalizada do XML, comum aos dois modelos de documento.
///
/// O [DanfeParser] resolve a raiz do XML (`nfeProc` ou `NFe`) e entrega este
/// contexto ao parser do modelo correspondente, de modo que cada
/// [DocumentoParser] só precise se preocupar com o que é seu.
class DanfeXmlContext {
  /// Conteúdo de `<infNFe>` — a parte comum aos dois modelos.
  final Map<String, dynamic> infNFe;

  /// Conteúdo de `<infNFeSupl>`, quando presente (só na NFC-e).
  final Map<String, dynamic>? infNFeSupl;

  /// Conteúdo de `<protNFe>`, presente apenas em XML já autorizado (`nfeProc`).
  final Map<String, dynamic>? protNFe;

  /// Construtor de [DanfeXmlContext].
  const DanfeXmlContext({
    required this.infNFe,
    this.infNFeSupl,
    this.protNFe,
  });

  /// Modelo do documento fiscal declarado em `<ide><mod>` (`55` ou `65`).
  ///
  /// Retorna `null` quando o grupo `ide` está ausente ou não traz `mod`.
  String? get modelo {
    final mod = infNFe['ide']?['mod'];
    return mod is String ? mod : mod?.toString();
  }
}

/// Contrato de um parser de documento fiscal.
///
/// Cada implementação atende exatamente um modelo (`55`, `65`, …) e é
/// resolvida pelo [DanfeParser] a partir de `<ide><mod>`.
///
/// Para suportar um modelo novo sem alterar o pacote, implemente esta
/// interface e registre a implementação:
///
/// ```dart
/// class MeuParser implements DocumentoParser {
///   @override
///   String get modelo => '99';
///
///   @override
///   Danfe parse(DanfeXmlContext ctx) => ...;
/// }
///
/// DanfeParser.registrar(MeuParser());
/// ```
abstract interface class DocumentoParser {
  /// Modelo do documento fiscal atendido por este parser (`55`, `65`, …).
  String get modelo;

  /// Constrói o [Danfe] a partir do contexto já normalizado do XML.
  Danfe parse(DanfeXmlContext ctx);
}
