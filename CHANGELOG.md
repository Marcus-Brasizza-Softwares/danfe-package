
## 3.1.1

### NFSe — mesmo pipeline de parsing do DANFE
* `NfseParser` deixa de ter um conversor XML → Map próprio e passa a usar o
  mesmo pipeline do `DanfeParser` (`xml2json`, formato Parker com atributos).
  A API pública não muda.
* `InfDPS.id` agora vem do atributo `_Id`, mesma convenção dos modelos de
  NF-e/NFC-e.
* `NfseParser.extractBasicInfo`: `cnpjPrestador` passa a vir de `prest/CNPJ`.
  Antes era o primeiro `<CNPJ>` encontrado em `infDPS` — com prestador pessoa
  física, isso devolvia o CNPJ do tomador.
* A dependência direta `xml` foi removida.

## 3.1.0

Suporte aos grupos da reforma tributária (NT 2025.002) e ao restante do
leiaute 4.00 que ainda era descartado. Tudo aditivo sobre a 3.0.0.

### Reforma tributária — IBS, CBS e Imposto Seletivo
* **Por item** (`Det.imposto`): novos `IbsCbs` (grupo `IBSCBS`, com `CST`,
  `cClassTrib` e `gIBSCBS`) e `ImpostoSeletivo` (grupo `IS`).
  `gIBSUF`, `gIBSMun` e `gCBS` compartilham a classe `TributoIbsCbs`,
  parametrizada pelo sufixo da tag — inclui alíquota, `gRed`
  (`ReducaoAliquota`), valor, diferimento, devolução e crédito presumido.
* **Nos totais** (`Total`): `ibsCbs` (grupo `IBSCBSTot`, com `TotalIbs`,
  `TotalTributoIbsCbs` e `TotalMonofasico`), `valorIs` (`ISTot/vIS`) e
  `valorTotalNota` (`vNFTot`).
* **`Det.vItem`** — Grupo VB, filho direto de `<det>`. Não confundir com o
  `Prod.vItem` do SAT removido na 3.0.0, que ficava em `det/prod/vItem`.
* Os totais de IBS, CBS e Imposto Seletivo passam a ser impressos no rodapé do
  cupom, nos dois renderizadores, quando têm valor.
* Ficam de fora, documentados como ponto de extensão em `IbsCbs`:
  `gTribRegular`, `gTribCompraGov`, `gIBSCBSMono`, `gTransfCred` e
  `gALCZFMCBS`.

### Regime antigo por item
Durante a transição os dois regimes convivem na mesma nota, então o grupo
`<imposto>` passa a ser lido por inteiro:

* `Icms`, `Pis` e `Cofins` achatam a variante do CST: `grupo` guarda o nome do
  filho no XML (`ICMS00`, `ICMS40`, `ICMSSN102`, `PISAliq`, `PISNT`…) e os
  demais campos são a união dos valores possíveis. `CST` e `CSOSN` caem no
  mesmo campo `cst`.

### Demais campos do leiaute 4.00
* `Ide`: `natOp`, `tpNF`, `idDest`, `finNFe`, `indFinal`, `indPres`,
  `indIntermed`, `verProc`.
* `Emit.crt` (`CRT`).
* `Prod`: `cEAN`, `cEANTrib`, `cest`, `indEscala`, `cBenef`, `uTrib`, `qTrib`,
  `vUnTrib`, `indTot`, `nItemPed`.
* `Total`: `valorFcp`, `valorFcpSt`, `valorFcpStRetido`,
  `valorImpostoImportacao`, `valorIpiDevolvido`.
* `CardPagamento` (grupo `card`) volta e agora é de fato preenchida, via
  `MP.card` — na 3.0.0 foi removida por ser código morto, mas o dado existe nos
  documentos reais.
* Nova `InfRespTec` (grupo `infRespTec`), em `DadosDanfe.infRespTec`.

### Correções
* `InfAdic.obsFisco` passa de `ObsFisco?` para `List<ObsFisco>?`. O grupo é
  repetível no leiaute e, com mais de uma ocorrência, o parsing quebrava.
  **Quebra de tipo** num campo quase sempre nulo.
* Novo `DanfeUtils.temValor`, usado para decidir se uma linha de total é
  impressa. Substitui a comparação com a string `'0.00'`, que não cobria
  `'0'`, `'0.0000'` nem vazio.

## 3.0.0

**Versão com quebras de compatibilidade.** O SAT (CFe) deixou de ser emitido e
seu suporte foi removido; o parser passou a separar NF-e e NFC-e por modelo.

### Removido — SAT (CFe)
* `TipoDocumento.CFe`, `Danfe.fromMapSat`, `Danfe.extractQrCode` e `Danfe.findTypeByMap`.
  Um XML `<CFe>` agora retorna `null` em `DanfeParser.readFromString`.
* Campos que só o CFe preenchia: `Ide.nserieSAT`, `Ide.signAC`,
  `Ide.assinaturaQRCODE`, `Ide.numeroCaixa`, `Ide.dEmi`, `Ide.hEmi`,
  `Total.valorLei12741`, `Prod.indRegra`, `Prod.vItem`, `Prod.vRatDesc`,
  `Emit.cRegTrib`, `Emit.indRatISSQN`, `DadosDanfe.sVersaoDadosEnt` e
  `DadosDanfe.sVersaoSB`.
* `DetPag` e `CardPagamento`: eram código morto — nunca chegavam a ser
  instanciados, já que `Pgto` funilava os dois formatos por `MP`.
* Quem ainda precisa emitir SAT deve fixar a versão `2.x`.

### Separação NF-e (55) × NFC-e (65)
* `Danfe` virou uma classe `sealed` com duas subclasses: `DanfeNFe` (modelo 55,
  com `transp` e `cobr`) e `DanfeNFCe` (modelo 65, com `infNFeSupl` e
  `qrcodePrinter`). Um `switch` sobre `Danfe` é exaustivo em tempo de compilação.
* `transp` e `cobr` saíram de `DadosDanfe` e passaram para `DanfeNFe`.
* O parsing foi dividido em `NfeParser` e `NfceParser`, resolvidos por
  `<ide><mod>` através de um registry. Novo ponto de extensão:
  `DanfeParser.registrar(DocumentoParser)` permite atender a um modelo novo sem
  alterar o pacote.
* Modelo desconhecido agora retorna `null`. Antes, qualquer `mod` diferente de
  `'55'` — inclusive ausente ou inválido — era silenciosamente tratado como NFC-e.

### Reforma tributária (IBS/CBS)
* Novo `Det.imposto` (classe `Imposto`), que lê o grupo `<imposto>` de cada item
  — antes o nó era descartado por inteiro. É o ponto de extensão documentado
  para os grupos IBS/CBS da NT 2025.002.

### Correções
* `Total.toMap()` serializava 11 dos 17 campos, então `toJson()` perdia dados e
  `Total.fromJson(total.toJson())` não fazia round-trip. Agora serializa todos.
* `Total.valorSt` lia a tag `vSt`, mas o schema define `vST` — o valor era
  sempre `'0.00'`.
* A data de emissão era convertida para UTC: uma nota emitida às 10:15 (-03:00)
  era impressa como 13:15. Agora o horário declarado no XML é preservado.
* `normativeJsonDanfe` emitia um bloco de QR Code vazio para NF-e, ao contrário
  de `bufferDanfe`, que já o suprimia.
* `bufferDanfe` estourava quando `pgto.formas` vinha nulo.
* `bufferDanfe(null)` estourava em `DanfeUtils.formatDate`/`formatNumber`/
  `formatMoneyMilhar`, que lançavam `FormatException` para string vazia.
  Os formatadores agora devolvem vazio/zero, como o `?? ''` das impressoras
  já pressupunha.
* `ObsFisco.sXCampo` lia `sXCampo`, mas atributos chegam prefixados com `_`
  (`_xCampo`) — o campo nunca era preenchido.
* Removido um `print` de depuração em `Cobr.fromMap`.

### Renomeações
* `Total.valotTotalTributos` → `Total.valorTotalTributos` (corrige o erro de digitação).
* `Total.valorTotalIcms` e `Total.valorIcms` eram o mesmo dado (`ICMSTot/vICMS`);
  restou `valorIcms`.
* `MP.cMP`/`MP.vMP` → `MP.tPag`/`MP.vPag`, acompanhando o vocabulário da NF-e.
* `IDanfePrinter.normativeJsonDanfe` passou a declarar o parâmetro `customFont`,
  que a implementação já aceitava.

## 2.0.2
* Melhoria na fonte customizável
* Separação do core de geração do JSON para uma classe separada
* Para saber como utlizar as fontes: [pubspec.yaml](https://github.com/brasizza/danfe-package/blob/master/example/pubspec.yaml)

## 2.0.1
* Melhorando a impressão padrao da danfe printer,melhorando a fonte padrao
## 2.0.0
* Agora é possível parsear NFSE no modelo nacional
* Inclusao de um novo modelo de impressao onde pode te retornar uma imagem e/ou um widget para preview em tela, assim pode mandar a impressão direto via imagem para qualquer dispositivo

## 1.0.3
* Inclusão da tag de totais de tributos incidentes na impressao da danfe

## 1.0.2
* Melhoria na diferenciação entre NFE/NFC-E , com a inclusão da impressão do frete, inibição do QRCODE e identificação correta entre NFE/NFC-E no cabeçalho!

## 1.0.1
* Atualizando (NFE) para notas que o TRANSPORTA está vazio e tambem quando a nota nao contém duplicata!

## 1.0.0
* Atualizado para a última versão do flutter/dart (foi necessário subir o intl pra 0.20)
* Atualizado o exemplo pra kts (ultimo gradle do flutter novo)


## 0.1.0
* Melhorias na impressao, aumento do qrcode, removendo acentos de onde fui achando
* Melhorias na impressao, aumento do qrcode, inserindo mais dados importantes do emitente no cabeçalho da impressao

## 0.0.29
* change: As versoes mais novas do escpos_utils trocou o size de Size para size, quebrando alguns sistemas. atualizei o meu package para o ultimo escpos_utils, portanto no seu codigo pode haver algum problema do Size do qrcode, somente mudar para size minusculo


## 0.0.28
* fix: Duplicatas podem ser uma lista, alterado para receber uma lista de DUP  mesmo com somente uma duplicata

## 0.0.27
* Improve: Duplicatas podem ser uma lista, alterado para receber uma lista de DUP
## 0.0.26
* Improve: A pedidos no git, foi mapeado outros campos no ICMSTOT no model de totais

## 0.0.25
## 0.0.24
* Improve: Incrementando o nó transporte e cobrança nos dados de danfe no parses e na impresao!
* Melhoria na documentacao do componente para melhor visualizaçao na IDE
## 0.0.23
* Improve: Arrumando o calculo de desconto/acrescimo no SAT Tks to [@alessandro-amos](https://github.com/alessandro-amos)
## 0.0.22
## 0.0.21
* Improve: Preparando a danfe para um futuro package de json normativo que estou desenvolvendo.


## 0.0.20
* Improve: Imprimir os dados do consumidor quando for CNPJ Tks pelo xml de teste Tks to [@smorigo](https://github.com/smorigo)

## 0.0.19
* Improve: Diminuir o qrcode da danfe que estava muito grande!

## 0.0.18
* Improve: Melhoria de recebimento do protocolo quando é NFC-E da danfe Tks to [@EduardoDadalt](https://github.com/EduardoDadalt)
* Melhoria de impressão, agora estamos colocando o número do documento, serie e os numeros de procoloco quando é NFC-e e a data!
- Sem breakchanges


## 0.0.17
* Change:  Foi necessário fazer o fork do esc_pos_printer para atualizar dependencias e colocar no meu repositório **esc_pos_printer_plus**

## 0.0.16
* Improve:  Foi necessário tirar o valor unitário quando a impressão for a de 58mm por conta da colunagem.



## 0.0.15
* Improve: Corrigindo o calculo de desconto da danfe Tks to [@murilorissos](https://github.com/murilorissos)


## 0.0.14
* Improve: Comportando múltiplas formas de pagamento Tks to [@f-junior](https://github.com/f-junior)


## 0.0.13
* Improve: Incluindo a possibilidade de parsear um xml sem protocolo [@Hudson82011](https://github.com/Hudson82011)

## 0.0.12
* Improve: Novas formas de Pagamento de acordo com a NT 2020 Tks to [@f-junior](https://github.com/f-junior)

## 0.0.11
* Fix do pubspec pra levar o dart pro 4.0.0

## 0.0.10
* Atualização do **intl interno** de   *^0.17.0* para *^0.18.1*

## 0.0.9
* Criação do campo **vCFeLei12741** como *valorLei12741*

## 0.0.8
* Separação do *vDesc* e do *vRatDesc* em duas propriedades diferentes para facilitar o uso

## 0.0.7
* O nó DEST as vezes o sistema entendia NULL, as vezes Vazio, corrigido para sempre ser nulo


## 0.0.6
* Alteração de conversão de double pra string feita errada


## 0.0.5
* Inclusão da mensagem do fisco no final da nota
* A data na emissão agora é a data da nota e não mais a data atual

## 0.0.4
* Melhoria no modelo parão de impressão da danfe, colocando mais detalhado os descontos, acréscimos, troco e as formas de pagamento
* Retirado também do modelo os espaços que consumia muita bobina
* Melhoria no modo de criar seu próprio modelo de impressão. Você agora pode implementar a interface ***IDanfePrinter*** 
* Inclusão de uma propriedade para mostrar ou esconder o R$ nos valores.
* Externalização de uma classe DanfeUtils com metodos de ajuda como conversão de valores
* No exemplo, o custom printer tem exatamente o layout que uso na classe interna do package


## 0.0.3
* Melhoria no exemplo dentro do REAME
* Refatoração nas classes de modelos, colocando uma em cada pasta para facilitar futura manutenção
* Agora no exemplo o customPrinter extende a DanfePrinter para utilizar os metodos de lá

## 0.0.2
* Identação do README


## 0.0.1
* Início do projeto com as funcionalidades básicas de parsear o xml em um objeto e preparar o buffer para impressao.
