import 'dart:convert';

import 'package:xml2json/xml2json.dart';

/// Conversão única de XML em `Map` usada por todos os parsers do pacote.
///
/// O XML é normalizado com a biblioteca `xml2json` no formato **Parker com
/// atributos**:
///
/// - a raiz vira a única chave do mapa retornado (ex.: `{'nfeProc': {...}}`);
/// - atributos recebem o prefixo `_` (ex.: `Id` vira `_Id`);
/// - elementos sem filhos viram `String` (string vazia quando o elemento é
///   vazio);
/// - elementos repetidos viram `List`, e um elemento único fica como `Map` ou
///   `String`, sem lista.
///
/// Os modelos (`Danfe`, `Nfse` etc.) leem os dados seguindo essa convenção.
abstract final class XmlMap {
  /// Converte [xml] em um `Map` no formato Parker com atributos.
  ///
  /// Lança exceção se o XML for inválido.
  static Map<String, dynamic> parse(String xml) {
    final transformer = Xml2Json()..parse(xml);
    return jsonDecode(transformer.toParkerWithAttrs()) as Map<String, dynamic>;
  }

  /// Retorna [valor] como `Map` quando ele for um objeto, ou `null` caso
  /// contrário (string, lista ou ausente).
  static Map<String, dynamic>? asMap(Object? valor) =>
      valor is Map<String, dynamic> ? valor : null;
}
