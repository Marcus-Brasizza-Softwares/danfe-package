import 'dart:convert';

/// A classe `Ide` representa as informações de identificação (IDE) de um documento fiscal.
///
/// ### Funcionalidades:
/// - Suporte à conversão para mapas (`Map<String, dynamic>`) e JSON.
/// - Permite inicialização a partir de mapas e strings JSON.
/// - Processamento e formatação de data e hora da emissão do documento.
class Ide {
  /// Código da UF do emitente.
  String? cUF;

  /// Código numérico da nota.
  String? cNF;

  /// Modelo do documento fiscal (`55` para NF-e, `65` para NFC-e).
  String? mod;

  /// Natureza da operação (`natOp`).
  String? natOp;

  /// Tipo da operação: 0 = entrada, 1 = saída (`tpNF`).
  String? tpNF;

  /// Local de destino da operação (`idDest`).
  String? idDest;

  /// Finalidade de emissão da NF-e (`finNFe`).
  String? finNFe;

  /// Indica operação com consumidor final (`indFinal`).
  String? indFinal;

  /// Indicador de presença do comprador (`indPres`).
  String? indPres;

  /// Indicador de intermediador/marketplace (`indIntermed`).
  String? indIntermed;

  /// Versão do aplicativo emissor (`verProc`).
  String? verProc;

  /// Série do documento fiscal.
  String? serie;

  /// Dígito verificador do código da chave de acesso.
  String? cDV;

  /// Tipo de ambiente (1 = Produção, 2 = Homologação).
  String? tpAmb;

  /// CNPJ do emitente.
  String? cNPJ;

  /// Número da nota fiscal.
  String? nNF;

  /// Data e hora de emissão no formato UTC.
  String? dhEmi;

  /// Data e hora de emissão formatada (AAAA-MM-DD HH:MM:SS).
  String? dataEmissao;

  /// Data e hora de saída/entrada.
  ///
  /// Exclusivo do modelo 55 (NF-e); a NFC-e não possui este campo.
  String? dhSaiEnt;

  /// Construtor da classe `Ide`.
  ///
  /// ### Parâmetros:
  /// - [cUF]: Código da UF.
  /// - [cNF]: Código numérico da nota.
  /// - [mod]: Modelo do documento fiscal.
  /// - [natOp]: Natureza da operação.
  /// - [tpNF]: Tipo da operação.
  /// - [idDest]: Local de destino da operação.
  /// - [finNFe]: Finalidade de emissão.
  /// - [indFinal]: Operação com consumidor final.
  /// - [indPres]: Indicador de presença do comprador.
  /// - [indIntermed]: Indicador de intermediador.
  /// - [verProc]: Versão do aplicativo emissor.
  /// - [serie]: Série do documento fiscal.
  /// - [cDV]: Dígito verificador.
  /// - [tpAmb]: Tipo de ambiente.
  /// - [cNPJ]: CNPJ do emitente.
  /// - [nNF]: Número da nota fiscal.
  /// - [dhEmi]: Data e hora de emissão (UTC).
  /// - [dataEmissao]: Data e hora formatadas.
  /// - [dhSaiEnt]: Data e hora de saída/entrada (somente NF-e).
  Ide({
    this.cUF,
    this.cNF,
    this.mod,
    this.natOp,
    this.tpNF,
    this.idDest,
    this.finNFe,
    this.indFinal,
    this.indPres,
    this.indIntermed,
    this.verProc,
    this.serie,
    this.cDV,
    this.tpAmb,
    this.cNPJ,
    this.nNF,
    this.dhEmi,
    this.dataEmissao,
    this.dhSaiEnt,
  });

  /// Converte a instância atual em um mapa (`Map<String, dynamic>`).
  ///
  /// ### Retorno:
  /// - Um mapa contendo os valores das propriedades de `Ide`.
  ///
  /// ### Exemplo:
  /// ```dart
  /// Ide ide = Ide(cUF: '35', cNF: '12345');
  /// Map<String, dynamic> mapa = ide.toMap();
  /// print(mapa); // Saída: {cUF: 35, cNF: 12345, ...}
  /// ```
  Map<String, dynamic> toMap() {
    return {
      'cUF': cUF,
      'cNF': cNF,
      'mod': mod,
      'natOp': natOp,
      'tpNF': tpNF,
      'idDest': idDest,
      'finNFe': finNFe,
      'indFinal': indFinal,
      'indPres': indPres,
      'indIntermed': indIntermed,
      'verProc': verProc,
      'serie': serie,
      'cDV': cDV,
      'nNF': nNF,
      'dhEmi': dhEmi,
      'dataEmissao': dataEmissao,
      'tpAmb': tpAmb,
      'cNPJ': cNPJ,
      'dhSaiEnt': dhSaiEnt,
    };
  }

  /// Cria uma instância de `Ide` a partir de um mapa (`Map<String, dynamic>`).
  ///
  /// ### Parâmetros:
  /// - [map]: Um mapa contendo as chaves e valores correspondentes às propriedades de `Ide`.
  ///
  /// ### Retorno:
  /// - Uma instância de `Ide` populada com os valores fornecidos no mapa.
  ///
  /// ### Exemplo:
  /// ```dart
  /// Map<String, dynamic> mapa = {'cUF': '35', 'cNF': '12345'};
  /// Ide ide = Ide.fromMap(mapa);
  /// print(ide.cUF); // Saída: 35
  /// ```
  factory Ide.fromMap(Map<String, dynamic> map) {
    return Ide(
      cUF: map['cUF'],
      cNF: map['cNF'],
      mod: map['mod'],
      natOp: map['natOp'],
      tpNF: map['tpNF'],
      idDest: map['idDest'],
      finNFe: map['finNFe'],
      indFinal: map['indFinal'],
      indPres: map['indPres'],
      indIntermed: map['indIntermed'],
      verProc: map['verProc'],
      serie: map['serie'],
      cDV: map['cDV'],
      tpAmb: map['tpAmb'],
      cNPJ: map['CNPJ'],
      nNF: map['nNF'],
      dhEmi: map['dhEmi'],
      dataEmissao: _formatarDataEmissao(map['dhEmi']),
      dhSaiEnt: map['dhSaiEnt'],
    );
  }

  /// Padrão da parte local de `dhEmi` (`AAAA-MM-DDThh:mm:ss`), ignorando o
  /// fuso declarado no fim da string.
  static final RegExp _dataHoraLocal = RegExp(
    r'^(\d{4}-\d{2}-\d{2})T(\d{2}:\d{2}:\d{2})',
  );

  /// Formata `dhEmi` (ISO 8601) para `AAAA-MM-DD HH:MM:SS`.
  ///
  /// Preserva o horário exatamente como declarado no XML. Usar
  /// `DateTime.parse` converteria para UTC e faria uma nota emitida às
  /// 10:15 (-03:00) ser impressa como 13:15.
  ///
  /// Retorna `null` se a data estiver ausente ou fora do formato esperado.
  static String? _formatarDataEmissao(String? dhEmi) {
    if (dhEmi == null) {
      return null;
    }
    final match = _dataHoraLocal.firstMatch(dhEmi);
    return match == null ? null : '${match[1]} ${match[2]}';
  }

  /// Converte a instância atual em uma string JSON.
  ///
  /// ### Retorno:
  /// - Uma string JSON contendo os dados de `Ide`.
  String toJson() => json.encode(toMap());

  /// Cria uma instância de `Ide` a partir de uma string JSON.
  ///
  /// ### Parâmetros:
  /// - [source]: Uma string JSON contendo os dados para a classe.
  ///
  /// ### Retorno:
  /// - Uma instância de `Ide` populada com os valores fornecidos na string JSON.
  factory Ide.fromJson(String source) => Ide.fromMap(json.decode(source));
}
