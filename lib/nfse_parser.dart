import 'src/core/xml_map.dart';
import 'src/models/nfse/nfse.dart';

/// A classe `NfseParser` converte o XML de uma NFSe (Nota Fiscal de Serviços
/// Eletrônica) Nacional em um objeto [Nfse].
///
/// O XML é normalizado por `XmlMap` (`xml2json`, formato Parker com
/// atributos) — o mesmo pipeline do `DanfeParser` — e o `Map` resultante é
/// entregue a [Nfse.fromMap].
///
/// A classe é implementada com um construtor privado para garantir que não
/// possa ser instanciada, sendo usada apenas para acesso aos métodos estáticos.
class NfseParser {
  /// Construtor privado para impedir a instanciação da classe.
  NfseParser._();

  /// Converte um XML de NFSe Nacional em um objeto [Nfse].
  ///
  /// Aceita o grupo `<NFSe>` aninhado no envelope ou como a própria raiz. Os
  /// dados de `infNFSe` (número, emitente, valores calculados) são mesclados
  /// com os do `DPS` (que traz `infDPS`).
  ///
  /// ### Parâmetros:
  /// - [xml]: Uma `String` contendo o documento XML que será processado.
  ///
  /// ### Retorno:
  /// - Um objeto [Nfse] se o XML for válido e for uma NFSe Nacional.
  /// - `null` se o XML não for uma NFSe Nacional ou for malformado.
  ///
  /// ### Exemplo:
  /// ```dart
  /// final nfse = NfseParser.readFromString(xmlString);
  /// if (nfse != null) {
  ///   print('NFSe número: ${nfse.infDPS?.nDPS}');
  /// }
  /// ```
  static Nfse? readFromString(String xml) {
    try {
      final envelope = _envelopeNacional(xml);
      if (envelope == null) {
        return null;
      }

      final nfse = XmlMap.asMap(envelope['NFSe']) ?? envelope;
      final infNFSe = XmlMap.asMap(nfse['infNFSe']);
      final dps =
          XmlMap.asMap(infNFSe?['DPS']) ?? XmlMap.asMap(envelope['DPS']);

      return Nfse.fromMap({...?infNFSe, ...?dps});
    } catch (_) {
      return null;
    }
  }

  /// Verifica se um XML é uma NFSe Nacional.
  ///
  /// ### Parâmetros:
  /// - [xml]: Uma `String` contendo o documento XML.
  ///
  /// ### Retorno:
  /// - `true` se for NFSe Nacional.
  /// - `false` caso contrário, inclusive para XML malformado.
  ///
  /// ### Exemplo:
  /// ```dart
  /// if (NfseParser.isNfseNacional(xmlString)) {
  ///   print('É uma NFSe Nacional');
  /// }
  /// ```
  static bool isNfseNacional(String xml) {
    try {
      return _envelopeNacional(xml) != null;
    } catch (_) {
      return false;
    }
  }

  /// Extrai informações resumidas da NFSe.
  ///
  /// ### Parâmetros:
  /// - [xmlString]: String contendo o XML da NFSe.
  ///
  /// ### Retorno:
  /// - Um `Map<String, String?>` com informações básicas da NFSe, ou um mapa
  ///   vazio se o XML não for uma NFSe Nacional válida.
  ///
  /// ### Exemplo:
  /// ```dart
  /// final info = NfseParser.extractBasicInfo(xmlString);
  /// print('Número: ${info['numero']}');
  /// print('Valor: ${info['valorServico']}');
  /// ```
  static Map<String, String?> extractBasicInfo(String xmlString) {
    final infDPS = readFromString(xmlString)?.infDPS;
    if (infDPS == null) {
      return {};
    }

    return {
      'numero': infDPS.nDPS,
      'serie': infDPS.serie,
      'dataEmissao': infDPS.dhEmi,
      'dataCompetencia': infDPS.dCompet,
      'cnpjPrestador': infDPS.prest?.cnpj,
      'valorServico': infDPS.valores?.vServPrest?.vServ,
      'descricaoServico': infDPS.serv?.cServ?.xDescServ,
    };
  }

  /// Normaliza o XML e retorna o conteúdo da raiz, ou `null` se não for uma
  /// NFSe Nacional.
  ///
  /// A identificação é feita pelo campo `versaoAplicativo` do envelope, que
  /// deve conter "Nacional" (ex.: `SefinNacional_1.5.0`, sem diferenciar
  /// maiúsculas de minúsculas).
  ///
  /// Lança exceção se o XML for malformado.
  static Map<String, dynamic>? _envelopeNacional(String xml) {
    // O nome da raiz do envelope é livre (ex.: `<root>`), por isso pega o
    // conteúdo do único elemento raiz em vez de procurar por nome.
    final envelope = XmlMap.asMap(XmlMap.parse(xml).values.firstOrNull);
    final versao = envelope?['versaoAplicativo'];

    if (versao is! String || !versao.toLowerCase().contains('nacional')) {
      return null;
    }

    return envelope;
  }
}
