import 'package:danfe/danfe.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../danfe_controller.dart';
import '../exemplos/xml_exemplos.dart';

class DanfeScreen extends StatefulWidget {
  const DanfeScreen({super.key});

  @override
  State<DanfeScreen> createState() => _DanfeScreenState();
}

class _DanfeScreenState extends State<DanfeScreen> {
  final controller = DanfeController();
  Danfe? _dadosDanfe;
  final TextEditingController _xmlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _xmlController.text = xmlNfceReforma;
  }

  /// Carrega um XML de exemplo no campo e já o processa.
  void _carregarExemplo(String xml) {
    setState(() {
      _xmlController.text = xml;
      _dadosDanfe = controller.parseXml(xml);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DANFE / NFC-E'),
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Cole o XML do DANFE',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _xmlController,
                      maxLines: 8,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        hintText: 'Cole aqui o XML da nota fiscal...',
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => _carregarExemplo(xmlNfceReforma),
                            child: const Text('NFC-e c/ IBS-CBS'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => _carregarExemplo(xmlNfce),
                            child: const Text('NFC-e (65)'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => _carregarExemplo(xmlNfe),
                            child: const Text('NF-e (55)'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            _dadosDanfe = controller.parseXml(
                              _xmlController.text,
                            );
                          });
                        },
                        icon: const Icon(Icons.receipt_long),
                        label: const Text('Processar Nota'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_dadosDanfe != null) ...[
              const SizedBox(height: 16),
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ações',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () => _showPreviewDialog(context),
                            icon: const Icon(Icons.visibility),
                            label: const Text('Visualizar'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () => _showImagePreview(context),
                            icon: const Icon(Icons.image),
                            label: const Text('Preview Imagem'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple,
                              foregroundColor: Colors.white,
                            ),
                          ),
                          kIsWasm || kIsWeb
                              ? const SizedBox()
                              : ElevatedButton.icon(
                                  onPressed: () async {
                                    final profile =
                                        await CapabilityProfile.load();
                                    await controller.printDefault(
                                      danfe: _dadosDanfe,
                                      paper: PaperSize.mm80,
                                      profile: profile,
                                    );
                                  },
                                  icon: const Icon(Icons.print),
                                  label: const Text('Imprimir'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Informações da Nota',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      dadosNota(_dadosDanfe),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showPreviewDialog(BuildContext context) {
    final imageDanfe = ImageDanfe.fromDanfe(
      danfe: _dadosDanfe!,
      paperSize: DanfePaperSize.mm80,
      customFont: 'RobotoMonoRegular',
    );

    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600, maxHeight: 800),
          child: Column(
            children: [
              AppBar(
                title: const Text('Pré-visualização'),
                automaticallyImplyLeading: false,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: imageDanfe.toWidget(margin: 8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showImagePreview(BuildContext context) async {
    final imageDanfe = ImageDanfe.fromDanfe(
      danfe: _dadosDanfe!,
      paperSize: DanfePaperSize.mm80,
      customFont: 'RobotoMonoRegular',
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Card(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Gerando imagem...'),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      final imageBytes = await imageDanfe.toImage(
        context,
        fixedRatio: 2.0,
      );

      final imageParts = await imageDanfe.toEscPosPrinter(
        context,
        maxHeight: 2000,
        maxWidth: 576,
        margin: 0,
        fixedRatio: 1.0,
      );

      if (context.mounted) {
        Navigator.pop(context);

        showDialog(
          context: context,
          builder: (context) => Dialog(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 600, maxHeight: 800),
              child: Column(
                children: [
                  AppBar(
                    title: const Text('Preview - Imagem'),
                    automaticallyImplyLeading: false,
                    actions: [
                      kIsWeb || kIsWeb
                          ? const SizedBox()
                          : IconButton(
                              icon: const Icon(Icons.print),
                              onPressed: () async {
                                controller.printImagePos(
                                  images: imageParts,
                                  paper: PaperSize.mm80,
                                  profile: await CapabilityProfile.load(),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Função de impressão de imagem',
                                    ),
                                  ),
                                );
                              },
                            ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  Expanded(
                    child: InteractiveViewer(
                      minScale: 0.5,
                      maxScale: 4.0,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Image.memory(
                            imageBytes,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao gerar imagem: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget dadosNota(Danfe? nota) {
    return Container(
      color: Colors.grey.shade300,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text('Nota ${nota?.descricao ?? ''}'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Nome fantasia:  ',
                      style: TextStyle(color: Colors.black, fontSize: 10),
                    ),
                    TextSpan(
                      text: nota?.dados?.emit?.xFant ?? '',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'CNPJ:  ',
                      style: TextStyle(color: Colors.black, fontSize: 10),
                    ),
                    TextSpan(
                      text: nota?.dados?.emit?.cnpj ?? '',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Chave da nota:  ',
                      style: TextStyle(color: Colors.black, fontSize: 10),
                    ),
                    TextSpan(
                      text: nota?.dados?.chaveNota ?? '',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Número da nota:  ',
                      style: TextStyle(color: Colors.black, fontSize: 10),
                    ),
                    TextSpan(
                      text: nota?.dados?.ide?.nNF ?? '',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Center(child: Text('Produtos')),
            ListView.separated(
              shrinkWrap: true,
              separatorBuilder: (_, __) => const Divider(),
              itemCount: nota?.dados?.det?.length ?? 0,
              itemBuilder: (_, index) {
                final Det? prod = nota?.dados?.det?[index];
                return ListTile(
                  leading: Text(prod?.prod?.qCom ?? ''),
                  title: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: prod?.prod?.xProd ?? '',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          ),
                        ),
                        TextSpan(
                          text: ' (${prod?.prod?.vProd ?? ''}) ',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  subtitle: (prod?.prod?.vDesc != null)
                      ? Text('Desconto: ${prod?.prod?.vDesc ?? ''}')
                      : const SizedBox(),
                  trailing: Text(prod?.prod?.vUnCom ?? ''),
                );
              },
            ),
            const Center(child: Text('Dados de pagamento')),
            ListView.separated(
              shrinkWrap: true,
              separatorBuilder: (_, __) => const Divider(),
              itemCount: nota?.dados?.pgto?.formas?.length ?? 0,
              itemBuilder: (_, index) {
                final MP? pgto = nota?.dados?.pgto?.formas?[index];
                return ListTile(
                  leading: Text(pgto?.tPag ?? ''),
                  title: Text(pgto?.vPag ?? ''),
                );
              },
            ),
            Visibility(
              visible:
                  (nota?.dados?.total?.desconto != '0.00' &&
                  nota?.dados?.total?.desconto != null),
              child: RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Desconto na conta: ',
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    ),
                    TextSpan(
                      text: nota?.dados?.total?.desconto,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible:
                  (nota?.dados?.pgto?.vTroco != '0.00' &&
                  nota?.dados?.pgto?.vTroco != null),
              child: RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Troco: ',
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    ),
                    TextSpan(
                      text: nota?.dados?.pgto?.vTroco ?? '',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: 'Total da conta: ',
                    style: TextStyle(color: Colors.black, fontSize: 12),
                  ),
                  TextSpan(
                    text: nota?.dados?.total?.valorTotal,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
