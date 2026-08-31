import '../models/danfe.dart';
import '../models/inf_supl.dart';
import 'base_danfe_parser.dart';
import 'documento_parser.dart';

/// Parser do **modelo 65 — Nota Fiscal de Consumidor Eletrônica (NFC-e)**.
///
/// Além da parte comum, lê `<infNFeSupl>`, de onde saem o QR Code e a URL de
/// consulta impressos no cupom. Deliberadamente **não** lê `<transp>`/`<cobr>`:
/// a NFC-e é venda presencial à vista.
class NfceParser extends BaseDanfeParser {
  @override
  String get modelo => '65';

  @override
  Danfe parse(DanfeXmlContext ctx) {
    final supl = ctx.infNFeSupl;

    return DanfeNFCe(
      dados: dadosComuns(ctx),
      protNFe: protocolo(ctx),
      infNFeSupl: supl != null ? InfNFeSupl.fromMap(supl) : null,
      qrcodePrinter: supl?['qrCode'],
    );
  }
}
