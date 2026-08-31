import '../models/cobr.dart';
import '../models/danfe.dart';
import '../models/transp.dart';
import 'base_danfe_parser.dart';
import 'documento_parser.dart';

/// Parser do **modelo 55 — Nota Fiscal Eletrônica (NF-e)**.
///
/// Além da parte comum, lê os grupos de transporte (`<transp>`) e cobrança
/// (`<cobr>`). Deliberadamente **não** lê `<infNFeSupl>`: a NF-e não possui
/// QR Code.
class NfeParser extends BaseDanfeParser {
  @override
  String get modelo => '55';

  @override
  Danfe parse(DanfeXmlContext ctx) {
    final transp = ctx.infNFe['transp'];
    final cobr = ctx.infNFe['cobr'];

    return DanfeNFe(
      dados: dadosComuns(ctx),
      protNFe: protocolo(ctx),
      transp: transp is Map<String, dynamic> ? Transp.fromMap(transp) : null,
      cobr: cobr is Map<String, dynamic> ? Cobr.fromMap(cobr) : null,
    );
  }
}
