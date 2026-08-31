import '../models/dados_danfe.dart';
import '../models/prot_nfe.dart';
import 'documento_parser.dart';

/// Base compartilhada pelos parsers de NF-e e NFC-e.
///
/// Concentra a leitura da parte do XML que é idêntica nos dois modelos —
/// `<infNFe>` e `<protNFe>` — deixando para as subclasses apenas o que é
/// exclusivo de cada uma.
abstract class BaseDanfeParser implements DocumentoParser {
  /// Lê `<infNFe>`, comum aos dois modelos.
  DadosDanfe dadosComuns(DanfeXmlContext ctx) => DadosDanfe.fromMap(ctx.infNFe);

  /// Lê `<protNFe>`, presente apenas quando o XML é um `nfeProc`.
  ProtNFe? protocolo(DanfeXmlContext ctx) =>
      ctx.protNFe != null ? ProtNFe.fromMap(ctx.protNFe!) : null;
}
