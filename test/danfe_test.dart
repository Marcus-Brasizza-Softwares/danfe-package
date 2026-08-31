import 'package:danfe/danfe.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fixtures/xml_samples.dart';

void main() {
  mainReforma();

  group('DanfeParser — seleção de parser por modelo', () {
    test('modelo 65 produz um DanfeNFCe', () {
      final danfe = DanfeParser.readFromString(xmlNfce);

      expect(danfe, isA<DanfeNFCe>());
      expect(danfe!.tipo, TipoDocumento.NFCe);
      expect(danfe.modelo, '65');
      expect(danfe.descricao, 'NFC-E');
    });

    test('modelo 55 produz um DanfeNFe', () {
      final danfe = DanfeParser.readFromString(xmlNfe);

      expect(danfe, isA<DanfeNFe>());
      expect(danfe!.tipo, TipoDocumento.NFe);
      expect(danfe.modelo, '55');
      expect(danfe.descricao, 'NFe');
    });

    test('XML de SAT (CFe) não é mais suportado e retorna null', () {
      expect(DanfeParser.readFromString(xmlCfeSat), isNull);
    });

    test('XML sem raiz reconhecida retorna null', () {
      expect(
        DanfeParser.readFromString('<?xml version="1.0"?><outraCoisa/>'),
        isNull,
      );
    });

    test('modelo não registrado retorna null em vez de adivinhar', () {
      final xmlModelo99 = xmlNfce.replaceFirst(
        '<mod>65</mod>',
        '<mod>99</mod>',
      );

      expect(DanfeParser.readFromString(xmlModelo99), isNull);
    });

    test('modelos suportados são 55 e 65', () {
      expect(DanfeParser.modelosSuportados, containsAll(['55', '65']));
    });
  });

  group('DanfeNFCe — campos exclusivos do modelo 65', () {
    late DanfeNFCe danfe;

    setUp(() {
      danfe = DanfeParser.readFromString(xmlNfce) as DanfeNFCe;
    });

    test('QR Code vem de infNFeSupl', () {
      expect(danfe.qrcodePrinter, isNotNull);
      expect(danfe.qrcodePrinter, contains('qrcode?p='));
      expect(danfe.infNFeSupl?.qrCode, danfe.qrcodePrinter);
      expect(danfe.infNFeSupl?.urlChave, isNotNull);
    });

    test('chave de acesso tem 44 dígitos e não conserva o prefixo NFe', () {
      expect(danfe.dados?.chaveNota, hasLength(44));
      expect(danfe.dados?.chaveNota, isNot(contains('NFe')));
      expect(
        danfe.dados?.chaveNota,
        '35250612345678000190650010000012341100001234',
      );
    });

    test('protocolo de autorização é lido de protNFe', () {
      expect(danfe.protNFe?.infProt?.nProt, '135250000123456');
      expect(danfe.protNFe?.infProt?.cStat, '100');
    });
  });

  group('DanfeNFe — campos exclusivos do modelo 55', () {
    late DanfeNFe danfe;

    setUp(() {
      danfe = DanfeParser.readFromString(xmlNfe) as DanfeNFe;
    });

    test('transportadora é lida de transp', () {
      expect(danfe.transp?.modFrete, '0');
      expect(danfe.transp?.transporta?.xNome, 'TRANSPORTES RAPIDOS LTDA');
      expect(danfe.transp?.transporta?.uf, 'SP');
      expect(danfe.transp?.vol?.qVol, '10');
    });

    test('fatura e duplicatas são lidas de cobr', () {
      expect(danfe.cobr?.fat?.nFat, '5678');
      expect(danfe.cobr?.fat?.vLiq, '2150.00');
      expect(danfe.cobr?.dup, hasLength(2));
      expect(danfe.cobr?.dup?.first.nDup, '001');
      expect(danfe.cobr?.dup?.last.vDup, '1075.00');
    });

    test('dhSaiEnt é preenchido', () {
      expect(danfe.dados?.ide?.dhSaiEnt, '2026-08-21T16:00:00-03:00');
    });
  });

  group('Campos comuns aos dois modelos', () {
    test('dataEmissao é formatada a partir de dhEmi', () {
      final danfe = DanfeParser.readFromString(xmlNfce);

      expect(danfe?.dados?.ide?.dhEmi, '2026-08-20T10:15:30-03:00');
      expect(danfe?.dados?.ide?.dataEmissao, '2026-08-20 10:15:30');
    });

    test('emitente e destinatário', () {
      final danfe = DanfeParser.readFromString(xmlNfce);

      expect(danfe?.dados?.emit?.cnpj, '12345678000190');
      expect(danfe?.dados?.emit?.xFant, 'MERCADO MODELO');
      expect(danfe?.dados?.emit?.enderEmit?.uF, 'SP');
      expect(danfe?.dados?.dest?.cpf, '12345678909');
    });

    test('totais vêm de ICMSTot', () {
      final total = DanfeParser.readFromString(xmlNfce)?.dados?.total;

      expect(total?.valorTotal, '52.80');
      expect(total?.valorPago, '50.00');
      expect(total?.desconto, '2.80');
      expect(total?.valorIcms, '9.00');
      expect(total?.valorPis, '0.86');
      expect(total?.valorCofins, '3.96');
      expect(total?.valorTotalTributos, '6.30');
    });

    test('vST é lido com o case correto da tag', () {
      final total = DanfeParser.readFromString(xmlNfe)?.dados?.total;

      // O XML traz <vST>0.00</vST>; antes a leitura usava 'vSt' e nunca casava.
      expect(total?.valorSt, '0.00');
      expect(total?.valorFrete, '150.00');
    });

    test('formas de pagamento vêm de detPag com tPag traduzido', () {
      final pgto = DanfeParser.readFromString(xmlNfce)?.dados?.pgto;

      expect(pgto?.formas, hasLength(1));
      expect(pgto?.formas?.first.tPag, 'PIX');
      expect(pgto?.formas?.first.vPag, '50.00');
    });

    test('itens e o grupo imposto de cada um', () {
      final det = DanfeParser.readFromString(xmlNfce)?.dados?.det;

      expect(det, hasLength(2));
      expect(det?.first.sNItem, '1');
      expect(det?.first.prod?.xProd, 'CAFE TORRADO 500G');
      expect(det?.first.prod?.vUnCom, '18.9000');
      expect(det?.first.imposto?.vTotTrib, '4.53');
      expect(det?.last.imposto?.vTotTrib, '1.77');
    });

    test('nota com um único item ainda produce uma lista', () {
      final det = DanfeParser.readFromString(xmlNfe)?.dados?.det;

      expect(det, hasLength(1));
      expect(det?.first.prod?.xProd, 'CAIXA DE CAFE 12X500G');
    });

    test('informações adicionais', () {
      final danfe = DanfeParser.readFromString(xmlNfce);

      expect(danfe?.dados?.infAdic?.infCpl, contains('Simples Nacional'));
    });
  });

  group('Serialização', () {
    test('Total faz round-trip por JSON sem perder campos', () {
      final total = DanfeParser.readFromString(xmlNfe)!.dados!.total!;
      final rehidratado = Total.fromJson(total.toJson());

      expect(rehidratado.toMap(), total.toMap());
      expect(rehidratado.valorSeguro, total.valorSeguro);
      expect(rehidratado.valorBaseCalculo, total.valorBaseCalculo);
      expect(rehidratado.valorTotalTributos, total.valorTotalTributos);
    });

    test('toMap da NFC-e carrega o QR Code e o modelo', () {
      final mapa = DanfeParser.readFromString(xmlNfce)!.toMap();

      expect(mapa['tipo'], 'NFCe');
      expect(mapa['modelo'], '65');
      expect(mapa['qrcodePrinter'], isNotNull);
    });

    test('toMap da NF-e carrega transporte e cobrança', () {
      final mapa = DanfeParser.readFromString(xmlNfe)!.toMap();

      expect(mapa['tipo'], 'NFe');
      expect(mapa['modelo'], '55');
      expect(mapa['transp'], isNotNull);
      expect(mapa['cobr'], isNotNull);
      expect(mapa.containsKey('qrcodePrinter'), isFalse);
    });
  });

  group('DanfeParser.registrar — ponto de extensão', () {
    tearDown(() {
      DanfeParser.removerRegistro('99');
    });

    test('permite atender a um modelo novo sem alterar o pacote', () {
      DanfeParser.registrar(_ParserFalso());

      final xmlModelo99 = xmlNfce.replaceFirst(
        '<mod>65</mod>',
        '<mod>99</mod>',
      );
      final danfe = DanfeParser.readFromString(xmlModelo99);

      expect(danfe, isA<DanfeNFe>());
      expect(danfe?.dados?.emit?.xFant, 'MERCADO MODELO');
    });
  });
}

/// Parser de teste que atende a um modelo fictício.
class _ParserFalso implements DocumentoParser {
  @override
  String get modelo => '99';

  @override
  Danfe parse(DanfeXmlContext ctx) =>
      DanfeNFe(dados: DadosDanfe.fromMap(ctx.infNFe));
}

/// Testes dos grupos introduzidos pela reforma tributária (NT 2025.002).
void mainReforma() {
  group('Reforma — IBS/CBS e IS por item', () {
    late Danfe danfe;
    late Det item1;
    late Det gorjeta;

    setUp(() {
      danfe = DanfeParser.readFromString(xmlNfceReforma)!;
      item1 = danfe.dados!.det![0];
      gorjeta = danfe.dados!.det![2];
    });

    test('IBSCBS do item traz CST, classificação e base', () {
      final ibsCbs = item1.imposto!.ibsCbs!;

      expect(ibsCbs.cst, '200');
      expect(ibsCbs.cClassTrib, '200047');
      expect(ibsCbs.grupo?.vBC, '85.00');
      expect(ibsCbs.grupo?.vIBS, '0.05');
    });

    test('IBS estadual traz alíquota, redução e valor', () {
      final ibsUf = item1.imposto!.ibsCbs!.grupo!.ibsUf!;

      expect(ibsUf.aliquota, '0.1000');
      expect(ibsUf.reducao?.pRedAliq, '40.0000');
      expect(ibsUf.reducao?.pAliqEfet, '0.0600');
      expect(ibsUf.valor, '0.05');
    });

    test('IBS municipal e CBS usam o mesmo modelo, com sufixo próprio', () {
      final grupo = item1.imposto!.ibsCbs!.grupo!;

      expect(grupo.ibsMun?.aliquota, '0.00');
      expect(grupo.ibsMun?.valor, '0.00');
      expect(grupo.cbs?.aliquota, '0.9000');
      expect(grupo.cbs?.reducao?.pAliqEfet, '0.5400');
      expect(grupo.cbs?.valor, '0.46');
    });

    test('Imposto Seletivo do item', () {
      final impostoSeletivo = item1.imposto!.impostoSeletivo!;

      expect(impostoSeletivo.cstIs, '200');
      expect(impostoSeletivo.cClassTribIs, '200047');
      expect(impostoSeletivo.vBCIS, '85.00');
      expect(impostoSeletivo.qTrib, '1.0000');
      expect(impostoSeletivo.vIS, '0.01');
    });

    test('item isento não traz IBS/CBS nem IS, e não quebra o parsing', () {
      expect(gorjeta.prod?.xProd, 'GORJETA SUGERIDA 13%');
      expect(gorjeta.imposto?.ibsCbs, isNull);
      expect(gorjeta.imposto?.impostoSeletivo, isNull);
      expect(gorjeta.imposto?.icms?.grupo, 'ICMS40');
      expect(gorjeta.imposto?.pis?.grupo, 'PISNT');
      expect(gorjeta.imposto?.cofins?.grupo, 'COFINSNT');
    });

    test('vItem é lido de det, não de det/prod', () {
      expect(item1.vItem, '85.00');
      expect(gorjeta.vItem, '49.40');
    });
  });

  group('Reforma — ICMS/PIS/COFINS achatados por variante', () {
    late Det item1;
    late Det gorjeta;

    setUp(() {
      final danfe = DanfeParser.readFromString(xmlNfceReforma)!;
      item1 = danfe.dados!.det![0];
      gorjeta = danfe.dados!.det![2];
    });

    test('ICMS00 preenche os campos da variante', () {
      final icms = item1.imposto!.icms!;

      expect(icms.grupo, 'ICMS00');
      expect(icms.orig, '0');
      expect(icms.cst, '00');
      expect(icms.modBC, '3');
      expect(icms.vBC, '85.00');
      expect(icms.pICMS, '4.0000');
      expect(icms.vICMS, '3.40');
    });

    test('ICMS40 traz só o que a variante tem', () {
      final icms = gorjeta.imposto!.icms!;

      expect(icms.grupo, 'ICMS40');
      expect(icms.cst, '40');
      expect(icms.vICMS, isNull);
    });

    test('PIS e COFINS achatam alíquota e valor pelo sufixo da tag', () {
      final pis = item1.imposto!.pis!;
      final cofins = item1.imposto!.cofins!;

      expect(pis.grupo, 'PISAliq');
      expect(pis.cst, '01');
      expect(pis.aliquota, '1.6500');
      expect(pis.valor, '1.40');

      expect(cofins.grupo, 'COFINSAliq');
      expect(cofins.aliquota, '7.6000');
      expect(cofins.valor, '6.46');
    });

    test('CSOSN do Simples entra no mesmo campo cst', () {
      // A fixture sem reforma usa ICMSSN102, que traz CSOSN em vez de CST.
      final icms = DanfeParser.readFromString(
        xmlNfce,
      )!.dados!.det![0].imposto!.icms!;

      expect(icms.grupo, 'ICMSSN102');
      expect(icms.cst, '102');
    });
  });

  group('Reforma — totais', () {
    late Total total;

    setUp(() {
      total = DanfeParser.readFromString(xmlNfceReforma)!.dados!.total!;
    });

    test('IBSCBSTot com IBS estadual, municipal e CBS', () {
      final ibsCbs = total.ibsCbs!;

      expect(ibsCbs.vBCIBSCBS, '177.00');
      expect(ibsCbs.ibs?.vIBS, '0.11');
      expect(ibsCbs.ibs?.uf?.valor, '0.11');
      expect(ibsCbs.ibs?.uf?.vDif, '0.00');
      expect(ibsCbs.ibs?.mun?.valor, '0.00');
      expect(ibsCbs.cbs?.valor, '0.96');
      expect(ibsCbs.cbs?.vCredPres, '0.00');
    });

    test('gMono é lido mesmo zerado', () {
      expect(total.ibsCbs?.mono?.vIBSMono, '0.00');
      expect(total.ibsCbs?.mono?.vCBSMonoRet, '0.00');
    });

    test('ISTot e vNFTot', () {
      expect(total.valorIs, '0.02');
      expect(total.valorTotalNota, '226.40');
    });

    test('campos de ICMSTot que faltavam', () {
      expect(total.valorFcp, '0.00');
      expect(total.valorFcpSt, '0.00');
      expect(total.valorFcpStRetido, '0.00');
      expect(total.valorImpostoImportacao, '0.00');
      expect(total.valorIpiDevolvido, '0.00');
    });

    test('ICMSTot sem vTotTrib cai no padrão, sem quebrar', () {
      // O documento real não traz <vTotTrib> dentro de <ICMSTot>.
      expect(total.valorTotalTributos, '0.00');
    });

    test('nota sem grupos da reforma deixa os campos novos vazios', () {
      final semReforma = DanfeParser.readFromString(xmlNfce)!.dados!.total!;

      expect(semReforma.ibsCbs, isNull);
      expect(semReforma.valorIs, '0.00');
      expect(semReforma.valorTotalNota, isNull);
    });
  });

  group('Reforma — demais campos do documento real', () {
    late Danfe danfe;

    setUp(() {
      danfe = DanfeParser.readFromString(xmlNfceReforma)!;
    });

    test('ide operacional', () {
      final ide = danfe.dados!.ide!;

      expect(ide.natOp, '5102');
      expect(ide.tpNF, '1');
      expect(ide.idDest, '1');
      expect(ide.finNFe, '1');
      expect(ide.indFinal, '1');
      expect(ide.indPres, '1');
      expect(ide.indIntermed, '0');
      expect(ide.verProc, '3.0.0');
    });

    test('CRT do emitente', () {
      expect(danfe.dados?.emit?.crt, '3');
    });

    test('grupo prod completo', () {
      final prod = danfe.dados!.det![0].prod!;

      expect(prod.cEAN, 'SEM GTIN');
      expect(prod.cEANTrib, 'SEM GTIN');
      expect(prod.cest, '0000000');
      expect(prod.indEscala, 'S');
      expect(prod.uTrib, 'UN');
      expect(prod.qTrib, '1.0000');
      expect(prod.vUnTrib, '85.0000000000');
      expect(prod.indTot, '1');
      expect(prod.nItemPed, '1');
      expect(danfe.dados!.det![2].prod?.cBenef, 'SP019090');
    });

    test('card da forma de pagamento', () {
      final card = danfe.dados!.pgto!.formas!.first.card!;

      expect(card.tpIntegra, '2');
      expect(card.tBand, '02');
      expect(card.cAut, '362667');
    });

    test('responsável técnico', () {
      final respTec = danfe.dados!.infRespTec!;

      expect(respTec.cnpj, '15120049000155');
      expect(respTec.xContato, 'SUPORTE MODELO');
      expect(respTec.email, 'suporte@exemplo.com.br');
    });

    test('NFC-e sem grupo dest não quebra', () {
      expect(danfe.dados?.dest, isNull);
    });
  });

  group('Reforma — round-trip por JSON', () {
    test('Total preserva os grupos novos', () {
      final total = DanfeParser.readFromString(xmlNfceReforma)!.dados!.total!;
      final rehidratado = Total.fromJson(total.toJson());

      expect(rehidratado.toMap(), total.toMap());
      expect(rehidratado.ibsCbs?.ibs?.uf?.valor, '0.11');
      expect(rehidratado.ibsCbs?.cbs?.valor, '0.96');
      expect(rehidratado.valorIs, '0.02');
      expect(rehidratado.valorTotalNota, '226.40');
    });

    test('Imposto do item preserva IBS/CBS, IS e o regime antigo', () {
      final imposto = DanfeParser.readFromString(
        xmlNfceReforma,
      )!.dados!.det![0].imposto!;
      final rehidratado = Imposto.fromJson(imposto.toJson());

      expect(rehidratado.toMap(), imposto.toMap());
      expect(rehidratado.ibsCbs?.grupo?.ibsUf?.valor, '0.05');
      expect(rehidratado.ibsCbs?.grupo?.ibsUf?.reducao?.pAliqEfet, '0.0600');
      expect(rehidratado.ibsCbs?.grupo?.cbs?.aliquota, '0.9000');
      expect(rehidratado.impostoSeletivo?.vIS, '0.01');
      expect(rehidratado.icms?.grupo, 'ICMS00');
      expect(rehidratado.pis?.valor, '1.40');
    });
  });
}
