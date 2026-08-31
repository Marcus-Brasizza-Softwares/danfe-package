import 'dart:convert';

import 'package:xml2json/xml2json.dart';

import 'src/models/danfe.dart';
import 'src/parser/documento_parser.dart';
import 'src/parser/nfce_parser.dart';
import 'src/parser/nfe_parser.dart';

/// A classe `DanfeParser` converte o XML de um documento fiscal eletrônico em
/// um objeto [Danfe].
///
/// O XML é normalizado com a biblioteca `xml2json` (formato Parker) e, em
/// seguida, entregue ao [DocumentoParser] correspondente ao modelo declarado
/// em `<ide><mod>`:
///
/// | Modelo | Parser        | Resultado   |
/// |--------|---------------|-------------|
/// | `55`   | `NfeParser`   | `DanfeNFe`  |
/// | `65`   | `NfceParser`  | `DanfeNFCe` |
///
/// Modelos não registrados retornam `null` — o parser não tenta adivinhar.
///
/// > O SAT (`CFe`, modelo 59) deixou de ser emitido e não é mais suportado
/// > desde a versão 3.0.0: um XML `<CFe>` retorna `null`.
///
/// A classe é implementada com um construtor privado para garantir que não
/// possa ser instanciada, sendo usada apenas para acesso aos métodos estáticos.
class DanfeParser {
  /// Construtor privado para impedir a instanciação da classe.
  DanfeParser._();

  /// Parsers registrados, indexados pelo modelo do documento fiscal.
  static final Map<String, DocumentoParser> _parsers = {
    '55': NfeParser(),
    '65': NfceParser(),
  };

  /// Registra (ou substitui) o parser de um modelo de documento fiscal.
  ///
  /// É o ponto de extensão do pacote: permite atender a um modelo novo — ou
  /// trocar o comportamento de um existente — sem alterar [readFromString].
  ///
  /// ```dart
  /// DanfeParser.registrar(MeuParserCustomizado());
  /// ```
  static void registrar(DocumentoParser parser) {
    _parsers[parser.modelo] = parser;
  }

  /// Remove o parser registrado para [modelo].
  ///
  /// Retorna o parser removido, ou `null` se não havia nenhum registrado.
  static DocumentoParser? removerRegistro(String modelo) =>
      _parsers.remove(modelo);

  /// Modelos de documento fiscal atualmente suportados.
  static Iterable<String> get modelosSuportados => _parsers.keys;

  /// Converte um XML de documento fiscal em um objeto [Danfe].
  ///
  /// ### Parâmetros:
  /// - [xml]: Uma `String` contendo o documento XML que será processado.
  ///
  /// ### Retorno:
  /// - [DanfeNFe] para o modelo `55`, [DanfeNFCe] para o modelo `65`.
  /// - `null` se o XML não tiver uma raiz reconhecida (`nfeProc`/`NFe`) ou se
  ///   o modelo declarado não tiver parser registrado.
  ///
  /// ### Erros:
  /// - Pode lançar exceções de parsing XML ou de decodificação JSON se o XML
  ///   fornecido for inválido ou malformado.
  static Danfe? readFromString(String xml) {
    final ctx = _contextoFromXml(xml);
    if (ctx == null) {
      return null;
    }

    final modelo = ctx.modelo;
    if (modelo == null) {
      return null;
    }

    return _parsers[modelo]?.parse(ctx);
  }

  /// Normaliza o XML e localiza `infNFe`, `infNFeSupl` e `protNFe`.
  ///
  /// Aceita as duas raízes possíveis: `<nfeProc>` (nota autorizada, com
  /// protocolo) e `<NFe>` (nota avulsa).
  static DanfeXmlContext? _contextoFromXml(String xml) {
    final transformer = Xml2Json();
    transformer.parse(xml);

    // O formato Parker com atributos prefixa atributos XML com `_`
    // (ex.: `Id` vira `_Id`), convenção usada por todos os modelos.
    final Map<String, dynamic> raiz = jsonDecode(
      transformer.toParkerWithAttrs(),
    );

    final nfeProc = raiz['nfeProc'];
    final Map<String, dynamic>? envelope = nfeProc is Map<String, dynamic>
        ? nfeProc
        : raiz.containsKey('NFe')
        ? raiz
        : null;

    if (envelope == null) {
      return null;
    }

    final nfe = envelope['NFe'];
    final Map<String, dynamic> conteudo = nfe is Map<String, dynamic>
        ? nfe
        : envelope;

    final infNFe = conteudo['infNFe'];
    if (infNFe is! Map<String, dynamic>) {
      return null;
    }

    final infNFeSupl = conteudo['infNFeSupl'];
    final protNFe = envelope['protNFe'];

    return DanfeXmlContext(
      infNFe: infNFe,
      infNFeSupl: infNFeSupl is Map<String, dynamic> ? infNFeSupl : null,
      protNFe: protNFe is Map<String, dynamic> ? protNFe : null,
    );
  }
}
