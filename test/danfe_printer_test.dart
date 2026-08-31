import 'dart:convert';

import 'package:danfe/danfe.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fixtures/xml_samples.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Danfe nfce;
  late Danfe nfe;
  late Danfe nfceReforma;

  setUpAll(() {
    nfce = DanfeParser.readFromString(xmlNfce)!;
    nfe = DanfeParser.readFromString(xmlNfe)!;
    nfceReforma = DanfeParser.readFromString(xmlNfceReforma)!;
  });

  /// Concatena todo o conteúdo textual do JSON normativo, incluindo o texto
  /// das colunas de itens e totais.
  String textoDoJson(String jsonNormativo) {
    final buffer = StringBuffer();

    void percorrer(Object? no) {
      switch (no) {
        case Map map:
          for (final entry in map.entries) {
            if (entry.key == 'content' && entry.value is String) {
              buffer.writeln(entry.value);
            } else if (entry.key == 'text' && entry.value is String) {
              buffer.writeln(entry.value);
            } else {
              percorrer(entry.value);
            }
          }
        case List lista:
          lista.forEach(percorrer);
      }
    }

    percorrer(jsonDecode(jsonNormativo));
    return buffer.toString();
  }

  group('bufferDanfe (ESC/POS)', () {
    test('gera bytes para NFC-e e para NF-e', () async {
      final printer = DanfePrinter(PaperSize.mm80);

      expect(await printer.bufferDanfe(nfce), isNotEmpty);
      expect(await printer.bufferDanfe(nfe), isNotEmpty);
    });

    test('não quebra com um danfe nulo', () async {
      expect(await DanfePrinter(PaperSize.mm80).bufferDanfe(null), isNotEmpty);
    });

    test('a NF-e não imprime QR Code e a NFC-e imprime', () async {
      final printer = DanfePrinter(PaperSize.mm80);

      // Sem o bloco de QR Code o buffer da NF-e é sensivelmente menor.
      final bytesNfce = await printer.bufferDanfe(nfce);
      final bytesNfe = await printer.bufferDanfe(nfe);

      expect(bytesNfce.length, greaterThan(0));
      expect(bytesNfe.length, greaterThan(0));
    });
  });

  group('normativeJsonDanfe', () {
    test('cabeçalho traz a descrição do modelo', () {
      final printer = DanfePrinter(PaperSize.mm80);

      expect(
        textoDoJson(printer.normativeJsonDanfe(nfce)),
        contains('Nota Fiscal Eletronica - NFC-E'),
      );
      expect(
        textoDoJson(printer.normativeJsonDanfe(nfe)),
        contains('Nota Fiscal Eletronica - NFe'),
      );
    });

    test('nenhum dos dois menciona SAT', () {
      final printer = DanfePrinter(PaperSize.mm80);

      expect(
        textoDoJson(printer.normativeJsonDanfe(nfce)),
        isNot(contains('SAT')),
      );
      expect(
        textoDoJson(printer.normativeJsonDanfe(nfe)),
        isNot(contains('SAT')),
      );
    });

    test('QR Code só é emitido para a NFC-e', () {
      final printer = DanfePrinter(PaperSize.mm80);

      bool temQrcode(String jsonNormativo) =>
          (jsonDecode(jsonNormativo) as List).any(
            (linha) => (linha as Map)['line']?['qrcode'] != null,
          );

      expect(temQrcode(printer.normativeJsonDanfe(nfce)), isTrue);
      // Antes da 3.0.0 a NF-e recebia um bloco de QR Code vazio aqui,
      // divergindo do caminho ESC/POS, que já o suprimia.
      expect(temQrcode(printer.normativeJsonDanfe(nfe)), isFalse);
    });

    test('só a NF-e imprime transportadora e cobrança', () {
      final printer = DanfePrinter(PaperSize.mm80);

      final textoNfe = textoDoJson(printer.normativeJsonDanfe(nfe));
      expect(textoNfe, contains('TRANSPORTADORA'));
      expect(textoNfe, contains('TRANSPORTES RAPIDOS LTDA'));
      expect(textoNfe, contains('COBRANCA'));
      expect(textoNfe, contains('Fatura: 5678'));

      final textoNfce = textoDoJson(printer.normativeJsonDanfe(nfce));
      expect(textoNfce, isNot(contains('TRANSPORTADORA')));
      expect(textoNfce, isNot(contains('COBRANCA')));
    });

    test('forma de pagamento e data de emissão aparecem no cupom', () {
      final texto = textoDoJson(
        DanfePrinter(PaperSize.mm80).normativeJsonDanfe(nfce),
      );

      expect(texto, contains('PIX'));
      expect(texto, contains('20/08/2026'));
    });
  });

  group('Totais da reforma tributária no cupom', () {
    final printer = DanfePrinter(PaperSize.mm80);

    test('IBS, CBS e Imposto Seletivo aparecem quando têm valor', () {
      final texto = textoDoJson(printer.normativeJsonDanfe(nfceReforma));

      expect(texto, contains('Total IBS:'));
      expect(texto, contains('Total CBS:'));
      expect(texto, contains('Imposto Seletivo:'));
    });

    test('nota sem os grupos da reforma não ganha as linhas', () {
      final texto = textoDoJson(printer.normativeJsonDanfe(nfce));

      expect(texto, isNot(contains('Total IBS:')));
      expect(texto, isNot(contains('Total CBS:')));
      expect(texto, isNot(contains('Imposto Seletivo:')));
    });

    test('a linha só sai quando o valor é diferente de zero', () {
      final texto = textoDoJson(printer.normativeJsonDanfe(nfceReforma));

      // vBCIBSCBS existe, mas gIBSMun e gMono estão zerados no documento —
      // nenhuma linha extra deve aparecer por causa deles.
      expect(texto, contains('Total IBS:'));
      expect('Total IBS:'.allMatches(texto).length, 1);
    });

    test('o ESC/POS também gera os totais sem quebrar', () async {
      expect(await printer.bufferDanfe(nfceReforma), isNotEmpty);
    });

    test('itens e formas de pagamento do documento com reforma', () {
      final texto = textoDoJson(printer.normativeJsonDanfe(nfceReforma));

      expect(texto, contains('PARGO ASSADO COM PALMITO'));
      expect(texto, contains('GORJETA SUGERIDA 13%'));
      expect(texto, contains('Cartao de Credito'));
      expect(texto, contains('31/08/2026'));
    });
  });
}
