/// XMLs de exemplo usados nos testes e na aplicação de exemplo.
///
/// São documentos fictícios em ambiente de homologação (`tpAmb` = 2), com
/// CNPJ/CPF e chaves de acesso inventados.
library;

/// NFC-e (modelo 65) autorizada — traz `infNFeSupl` com QR Code e `protNFe`.
const String xmlNfce = r'''<?xml version="1.0" encoding="UTF-8"?>
<nfeProc versao="4.00">
  <NFe>
    <infNFe versao="4.00" Id="NFe35250612345678000190650010000012341100001234">
      <ide>
        <cUF>35</cUF>
        <cNF>10000123</cNF>
        <natOp>VENDA AO CONSUMIDOR</natOp>
        <mod>65</mod>
        <serie>1</serie>
        <nNF>1234</nNF>
        <dhEmi>2026-08-20T10:15:30-03:00</dhEmi>
        <tpNF>1</tpNF>
        <idDest>1</idDest>
        <cMunFG>3550308</cMunFG>
        <tpImp>4</tpImp>
        <tpEmis>1</tpEmis>
        <cDV>4</cDV>
        <tpAmb>2</tpAmb>
        <finNFe>1</finNFe>
        <indFinal>1</indFinal>
        <indPres>1</indPres>
      </ide>
      <emit>
        <CNPJ>12345678000190</CNPJ>
        <xNome>MERCADO MODELO LTDA</xNome>
        <xFant>MERCADO MODELO</xFant>
        <enderEmit>
          <xLgr>RUA DAS FLORES</xLgr>
          <nro>1000</nro>
          <xBairro>CENTRO</xBairro>
          <cMun>3550308</cMun>
          <xMun>SAO PAULO</xMun>
          <UF>SP</UF>
          <CEP>01001000</CEP>
          <fone>1133334444</fone>
        </enderEmit>
        <IE>111222333444</IE>
        <CRT>3</CRT>
      </emit>
      <dest>
        <CPF>12345678909</CPF>
        <xNome>CONSUMIDOR DE TESTE</xNome>
      </dest>
      <det nItem="1">
        <prod>
          <cProd>001</cProd>
          <xProd>CAFE TORRADO 500G</xProd>
          <NCM>09012100</NCM>
          <CFOP>5102</CFOP>
          <uCom>UN</uCom>
          <qCom>2.0000</qCom>
          <vUnCom>18.9000</vUnCom>
          <vProd>37.80</vProd>
          <vDesc>1.80</vDesc>
          <indTot>1</indTot>
        </prod>
        <imposto>
          <vTotTrib>4.53</vTotTrib>
          <ICMS>
            <ICMSSN102>
              <orig>0</orig>
              <CSOSN>102</CSOSN>
            </ICMSSN102>
          </ICMS>
        </imposto>
      </det>
      <det nItem="2">
        <prod>
          <cProd>002</cProd>
          <xProd>ACUCAR REFINADO 1KG</xProd>
          <NCM>17019900</NCM>
          <CFOP>5102</CFOP>
          <uCom>UN</uCom>
          <qCom>3.0000</qCom>
          <vUnCom>5.0000</vUnCom>
          <vProd>15.00</vProd>
          <vDesc>1.00</vDesc>
          <indTot>1</indTot>
        </prod>
        <imposto>
          <vTotTrib>1.77</vTotTrib>
          <ICMS>
            <ICMSSN102>
              <orig>0</orig>
              <CSOSN>102</CSOSN>
            </ICMSSN102>
          </ICMS>
        </imposto>
      </det>
      <total>
        <ICMSTot>
          <vBC>50.00</vBC>
          <vICMS>9.00</vICMS>
          <vICMSDeson>0.00</vICMSDeson>
          <vBCST>0.00</vBCST>
          <vST>0.00</vST>
          <vProd>52.80</vProd>
          <vFrete>0.00</vFrete>
          <vSeg>0.00</vSeg>
          <vDesc>2.80</vDesc>
          <vIPI>0.00</vIPI>
          <vPIS>0.86</vPIS>
          <vCOFINS>3.96</vCOFINS>
          <vOutro>0.00</vOutro>
          <vNF>50.00</vNF>
          <vTotTrib>6.30</vTotTrib>
        </ICMSTot>
      </total>
      <transp>
        <modFrete>9</modFrete>
      </transp>
      <pag>
        <detPag>
          <tPag>17</tPag>
          <vPag>50.00</vPag>
        </detPag>
      </pag>
      <infAdic>
        <infCpl>Documento emitido por ME ou EPP optante pelo Simples Nacional.</infCpl>
      </infAdic>
    </infNFe>
    <infNFeSupl>
      <qrCode>https://www.homologacao.nfce.fazenda.sp.gov.br/qrcode?p=35250612345678000190650010000012341100001234|2|2|1|A1B2C3</qrCode>
      <urlChave>https://www.homologacao.nfce.fazenda.sp.gov.br/consulta</urlChave>
    </infNFeSupl>
  </NFe>
  <protNFe versao="4.00">
    <infProt>
      <tpAmb>2</tpAmb>
      <verAplic>SP_NFCE_PL_009</verAplic>
      <chNFe>35250612345678000190650010000012341100001234</chNFe>
      <dhRecbto>2026-08-20T10:15:35-03:00</dhRecbto>
      <nProt>135250000123456</nProt>
      <digVal>YWJjMTIz</digVal>
      <cStat>100</cStat>
      <xMotivo>Autorizado o uso da NF-e</xMotivo>
    </infProt>
  </protNFe>
</nfeProc>''';

/// NF-e (modelo 55) autorizada — traz `transp` e `cobr`, e nenhum QR Code.
const String xmlNfe = r'''<?xml version="1.0" encoding="UTF-8"?>
<nfeProc versao="4.00">
  <NFe>
    <infNFe versao="4.00" Id="NFe35250612345678000190550010000056781100005678">
      <ide>
        <cUF>35</cUF>
        <cNF>10000567</cNF>
        <natOp>VENDA DE MERCADORIA</natOp>
        <mod>55</mod>
        <serie>1</serie>
        <nNF>5678</nNF>
        <dhEmi>2026-08-21T14:30:00-03:00</dhEmi>
        <dhSaiEnt>2026-08-21T16:00:00-03:00</dhSaiEnt>
        <tpNF>1</tpNF>
        <idDest>1</idDest>
        <cMunFG>3550308</cMunFG>
        <tpImp>1</tpImp>
        <tpEmis>1</tpEmis>
        <cDV>8</cDV>
        <tpAmb>2</tpAmb>
        <finNFe>1</finNFe>
        <indFinal>0</indFinal>
        <indPres>0</indPres>
      </ide>
      <emit>
        <CNPJ>12345678000190</CNPJ>
        <xNome>DISTRIBUIDORA MODELO LTDA</xNome>
        <xFant>DISTRIBUIDORA MODELO</xFant>
        <enderEmit>
          <xLgr>AVENIDA INDUSTRIAL</xLgr>
          <nro>2500</nro>
          <xBairro>DISTRITO INDUSTRIAL</xBairro>
          <cMun>3550308</cMun>
          <xMun>SAO PAULO</xMun>
          <UF>SP</UF>
          <CEP>04001000</CEP>
        </enderEmit>
        <IE>555666777888</IE>
        <CRT>3</CRT>
      </emit>
      <dest>
        <CNPJ>98765432000110</CNPJ>
        <xNome>COMERCIO VAREJISTA MODELO LTDA</xNome>
      </dest>
      <det nItem="1">
        <prod>
          <cProd>100</cProd>
          <xProd>CAIXA DE CAFE 12X500G</xProd>
          <NCM>09012100</NCM>
          <CFOP>5102</CFOP>
          <uCom>CX</uCom>
          <qCom>10.0000</qCom>
          <vUnCom>200.0000</vUnCom>
          <vProd>2000.00</vProd>
          <indTot>1</indTot>
        </prod>
        <imposto>
          <vTotTrib>240.00</vTotTrib>
          <ICMS>
            <ICMS00>
              <orig>0</orig>
              <CST>00</CST>
              <vBC>2000.00</vBC>
              <pICMS>18.00</pICMS>
              <vICMS>360.00</vICMS>
            </ICMS00>
          </ICMS>
        </imposto>
      </det>
      <total>
        <ICMSTot>
          <vBC>2000.00</vBC>
          <vICMS>360.00</vICMS>
          <vICMSDeson>0.00</vICMSDeson>
          <vBCST>0.00</vBCST>
          <vST>0.00</vST>
          <vProd>2000.00</vProd>
          <vFrete>150.00</vFrete>
          <vSeg>0.00</vSeg>
          <vDesc>0.00</vDesc>
          <vIPI>0.00</vIPI>
          <vPIS>33.00</vPIS>
          <vCOFINS>152.00</vCOFINS>
          <vOutro>0.00</vOutro>
          <vNF>2150.00</vNF>
          <vTotTrib>240.00</vTotTrib>
        </ICMSTot>
      </total>
      <transp>
        <modFrete>0</modFrete>
        <transporta>
          <CNPJ>11222333000144</CNPJ>
          <xNome>TRANSPORTES RAPIDOS LTDA</xNome>
          <IE>999888777666</IE>
          <xEnder>RUA DOS CAMINHOES 45</xEnder>
          <xMun>GUARULHOS</xMun>
          <UF>SP</UF>
        </transporta>
        <vol>
          <qVol>10</qVol>
          <esp>CAIXA</esp>
          <marca>MODELO</marca>
          <pesoL>120.000</pesoL>
          <pesoB>125.000</pesoB>
        </vol>
      </transp>
      <cobr>
        <fat>
          <nFat>5678</nFat>
          <vOrig>2150.00</vOrig>
          <vDesc>0.00</vDesc>
          <vLiq>2150.00</vLiq>
        </fat>
        <dup>
          <nDup>001</nDup>
          <dVenc>2026-09-20</dVenc>
          <vDup>1075.00</vDup>
        </dup>
        <dup>
          <nDup>002</nDup>
          <dVenc>2026-10-20</dVenc>
          <vDup>1075.00</vDup>
        </dup>
      </cobr>
      <pag>
        <detPag>
          <tPag>15</tPag>
          <vPag>2150.00</vPag>
        </detPag>
      </pag>
      <infAdic>
        <infCpl>Venda com frete por conta do emitente.</infCpl>
      </infAdic>
    </infNFe>
  </NFe>
  <protNFe versao="4.00">
    <infProt>
      <tpAmb>2</tpAmb>
      <verAplic>SP_NFE_PL_009</verAplic>
      <chNFe>35250612345678000190550010000056781100005678</chNFe>
      <dhRecbto>2026-08-21T14:30:12-03:00</dhRecbto>
      <nProt>135250000567890</nProt>
      <digVal>ZGVmNDU2</digVal>
      <cStat>100</cStat>
      <xMotivo>Autorizado o uso da NF-e</xMotivo>
    </infProt>
  </protNFe>
</nfeProc>''';

/// XML de SAT (CFe) — mantido para garantir que o parser passou a rejeitá-lo.
const String xmlCfeSat = r'''<?xml version="1.0"?>
<CFe>
  <infCFe Id="CFe35161261099008000141599000026310003024947916" versao="0.07">
    <ide>
      <cUF>35</cUF>
      <mod>59</mod>
      <nserieSAT>900002631</nserieSAT>
      <nCFe>000302</nCFe>
      <dEmi>20161220</dEmi>
      <hEmi>095111</hEmi>
    </ide>
  </infCFe>
</CFe>''';

/// NFC-e (modelo 65) **com os grupos da reforma tributária** — IBS/CBS por
/// item, Imposto Seletivo, `ISTot`, `IBSCBSTot` e `vNFTot`.
///
/// A estrutura reproduz literalmente a de uma NFC-e de produção emitida sob a
/// NT 2025.002; os dados do emitente e do documento são fictícios.
///
/// Casos cobertos de propósito:
/// - itens 1 e 2 tributados, com `ICMS00`/`PISAliq`/`COFINSAliq` **e** os
///   grupos novos `IS`/`IBSCBS`;
/// - item 3 (gorjeta) isento, com `ICMS40`/`PISNT`/`COFINSNT` e **sem**
///   `IBSCBS` nem `IS`;
/// - `ICMSTot` **sem** `vTotTrib`, como no documento real;
/// - sem grupo `<dest>` (consumidor não identificado);
/// - `detPag/card` e `infRespTec` presentes.
const String xmlNfceReforma = r'''<?xml version="1.0" encoding="UTF-8"?>
<nfeProc versao="4.00">
  <NFe>
    <infNFe Id="NFe35250612345678000190650020000455641813356065" versao="4.00">
      <ide>
        <cUF>35</cUF>
        <cNF>81335606</cNF>
        <natOp>5102</natOp>
        <mod>65</mod>
        <serie>2</serie>
        <nNF>45564</nNF>
        <dhEmi>2026-08-31T15:20:07-03:00</dhEmi>
        <tpNF>1</tpNF>
        <idDest>1</idDest>
        <cMunFG>3550308</cMunFG>
        <tpImp>4</tpImp>
        <tpEmis>1</tpEmis>
        <cDV>5</cDV>
        <tpAmb>2</tpAmb>
        <finNFe>1</finNFe>
        <indFinal>1</indFinal>
        <indPres>1</indPres>
        <indIntermed>0</indIntermed>
        <procEmi>0</procEmi>
        <verProc>3.0.0</verProc>
      </ide>
      <emit>
        <CNPJ>12345678000190</CNPJ>
        <xNome>RESTAURANTE MODELO LTDA</xNome>
        <xFant>RESTAURANTE MODELO</xFant>
        <enderEmit>
          <xLgr>AVENIDA DAS NACOES</xLgr>
          <nro>1089</nro>
          <xCpl>LOJA 27</xCpl>
          <xBairro>JARDIM DAS ACACIAS</xBairro>
          <cMun>3550308</cMun>
          <xMun>SAO PAULO</xMun>
          <UF>SP</UF>
          <CEP>04707900</CEP>
          <cPais>1058</cPais>
          <xPais>Brasil</xPais>
          <fone>1130833390</fone>
        </enderEmit>
        <IE>136357610110</IE>
        <IM>73678295</IM>
        <CRT>3</CRT>
      </emit>
      <det nItem="1">
        <prod>
          <cProd>10003487</cProd>
          <cEAN>SEM GTIN</cEAN>
          <xProd>PARGO ASSADO COM PALMITO</xProd>
          <NCM>21069090</NCM>
          <CEST>0000000</CEST>
          <indEscala>S</indEscala>
          <CFOP>5102</CFOP>
          <uCom>UN</uCom>
          <qCom>1.0000</qCom>
          <vUnCom>85.0000000000</vUnCom>
          <vProd>85.00</vProd>
          <cEANTrib>SEM GTIN</cEANTrib>
          <uTrib>UN</uTrib>
          <qTrib>1.0000</qTrib>
          <vUnTrib>85.0000000000</vUnTrib>
          <indTot>1</indTot>
          <nItemPed>1</nItemPed>
        </prod>
        <imposto>
          <vTotTrib>0.00</vTotTrib>
          <ICMS>
            <ICMS00>
              <orig>0</orig>
              <CST>00</CST>
              <modBC>3</modBC>
              <vBC>85.00</vBC>
              <pICMS>4.0000</pICMS>
              <vICMS>3.40</vICMS>
            </ICMS00>
          </ICMS>
          <PIS>
            <PISAliq>
              <CST>01</CST>
              <vBC>85.00</vBC>
              <pPIS>1.6500</pPIS>
              <vPIS>1.40</vPIS>
            </PISAliq>
          </PIS>
          <COFINS>
            <COFINSAliq>
              <CST>01</CST>
              <vBC>85.00</vBC>
              <pCOFINS>7.6000</pCOFINS>
              <vCOFINS>6.46</vCOFINS>
            </COFINSAliq>
          </COFINS>
          <IS>
            <CSTIS>200</CSTIS>
            <cClassTribIS>200047</cClassTribIS>
            <vBCIS>85.00</vBCIS>
            <pIS>0.0000</pIS>
            <uTrib>UN</uTrib>
            <qTrib>1.0000</qTrib>
            <vIS>0.01</vIS>
          </IS>
          <IBSCBS>
            <CST>200</CST>
            <cClassTrib>200047</cClassTrib>
            <gIBSCBS>
              <vBC>85.00</vBC>
              <gIBSUF>
                <pIBSUF>0.1000</pIBSUF>
                <gRed>
                  <pRedAliq>40.0000</pRedAliq>
                  <pAliqEfet>0.0600</pAliqEfet>
                </gRed>
                <vIBSUF>0.05</vIBSUF>
              </gIBSUF>
              <gIBSMun>
                <pIBSMun>0.00</pIBSMun>
                <gRed>
                  <pRedAliq>40.0000</pRedAliq>
                  <pAliqEfet>0.0000</pAliqEfet>
                </gRed>
                <vIBSMun>0.00</vIBSMun>
              </gIBSMun>
              <vIBS>0.05</vIBS>
              <gCBS>
                <pCBS>0.9000</pCBS>
                <gRed>
                  <pRedAliq>40.0000</pRedAliq>
                  <pAliqEfet>0.5400</pAliqEfet>
                </gRed>
                <vCBS>0.46</vCBS>
              </gCBS>
            </gIBSCBS>
          </IBSCBS>
        </imposto>
        <vItem>85.00</vItem>
      </det>
      <det nItem="2">
        <prod>
          <cProd>12000075</cProd>
          <cEAN>SEM GTIN</cEAN>
          <xProd>VINHO PINOT GRIGIO</xProd>
          <NCM>22042100</NCM>
          <CEST>0000000</CEST>
          <indEscala>S</indEscala>
          <CFOP>5102</CFOP>
          <uCom>UN</uCom>
          <qCom>2.0000</qCom>
          <vUnCom>46.0000000000</vUnCom>
          <vProd>92.00</vProd>
          <cEANTrib>SEM GTIN</cEANTrib>
          <uTrib>UN</uTrib>
          <qTrib>2.0000</qTrib>
          <vUnTrib>46.0000000000</vUnTrib>
          <indTot>1</indTot>
          <nItemPed>2</nItemPed>
        </prod>
        <imposto>
          <vTotTrib>0.00</vTotTrib>
          <ICMS>
            <ICMS00>
              <orig>0</orig>
              <CST>00</CST>
              <modBC>3</modBC>
              <vBC>92.00</vBC>
              <pICMS>4.0000</pICMS>
              <vICMS>3.68</vICMS>
            </ICMS00>
          </ICMS>
          <PIS>
            <PISAliq>
              <CST>01</CST>
              <vBC>92.00</vBC>
              <pPIS>1.6500</pPIS>
              <vPIS>1.52</vPIS>
            </PISAliq>
          </PIS>
          <COFINS>
            <COFINSAliq>
              <CST>01</CST>
              <vBC>92.00</vBC>
              <pCOFINS>7.6000</pCOFINS>
              <vCOFINS>6.99</vCOFINS>
            </COFINSAliq>
          </COFINS>
          <IS>
            <CSTIS>200</CSTIS>
            <cClassTribIS>200047</cClassTribIS>
            <vBCIS>92.00</vBCIS>
            <pIS>0.0000</pIS>
            <uTrib>UN</uTrib>
            <qTrib>2.0000</qTrib>
            <vIS>0.01</vIS>
          </IS>
          <IBSCBS>
            <CST>200</CST>
            <cClassTrib>200047</cClassTrib>
            <gIBSCBS>
              <vBC>92.00</vBC>
              <gIBSUF>
                <pIBSUF>0.1000</pIBSUF>
                <gRed>
                  <pRedAliq>40.0000</pRedAliq>
                  <pAliqEfet>0.0600</pAliqEfet>
                </gRed>
                <vIBSUF>0.06</vIBSUF>
              </gIBSUF>
              <gIBSMun>
                <pIBSMun>0.00</pIBSMun>
                <gRed>
                  <pRedAliq>40.0000</pRedAliq>
                  <pAliqEfet>0.0000</pAliqEfet>
                </gRed>
                <vIBSMun>0.00</vIBSMun>
              </gIBSMun>
              <vIBS>0.06</vIBS>
              <gCBS>
                <pCBS>0.9000</pCBS>
                <gRed>
                  <pRedAliq>40.0000</pRedAliq>
                  <pAliqEfet>0.5400</pAliqEfet>
                </gRed>
                <vCBS>0.50</vCBS>
              </gCBS>
            </gIBSCBS>
          </IBSCBS>
        </imposto>
        <vItem>92.00</vItem>
      </det>
      <det nItem="3">
        <prod>
          <cProd>14000009</cProd>
          <cEAN>SEM GTIN</cEAN>
          <xProd>GORJETA SUGERIDA 13%</xProd>
          <NCM>00000000</NCM>
          <CEST>0000000</CEST>
          <indEscala>S</indEscala>
          <cBenef>SP019090</cBenef>
          <CFOP>5949</CFOP>
          <uCom>UN</uCom>
          <qCom>1.0000</qCom>
          <vUnCom>49.4000000000</vUnCom>
          <vProd>49.40</vProd>
          <cEANTrib>SEM GTIN</cEANTrib>
          <uTrib>UN</uTrib>
          <qTrib>1.0000</qTrib>
          <vUnTrib>49.4000000000</vUnTrib>
          <indTot>1</indTot>
          <nItemPed>3</nItemPed>
        </prod>
        <imposto>
          <vTotTrib>0.00</vTotTrib>
          <ICMS>
            <ICMS40>
              <orig>0</orig>
              <CST>40</CST>
            </ICMS40>
          </ICMS>
          <PIS>
            <PISNT>
              <CST>08</CST>
            </PISNT>
          </PIS>
          <COFINS>
            <COFINSNT>
              <CST>08</CST>
            </COFINSNT>
          </COFINS>
        </imposto>
        <vItem>49.40</vItem>
      </det>
      <total>
        <ICMSTot>
          <vBC>177.00</vBC>
          <vICMS>7.08</vICMS>
          <vICMSDeson>0.00</vICMSDeson>
          <vFCP>0.00</vFCP>
          <vBCST>0.00</vBCST>
          <vST>0.00</vST>
          <vFCPST>0.00</vFCPST>
          <vFCPSTRet>0.00</vFCPSTRet>
          <vProd>226.40</vProd>
          <vFrete>0.00</vFrete>
          <vSeg>0.00</vSeg>
          <vDesc>0.00</vDesc>
          <vII>0.00</vII>
          <vIPI>0.00</vIPI>
          <vIPIDevol>0.00</vIPIDevol>
          <vPIS>2.92</vPIS>
          <vCOFINS>13.45</vCOFINS>
          <vOutro>0.00</vOutro>
          <vNF>226.40</vNF>
        </ICMSTot>
        <ISTot>
          <vIS>0.02</vIS>
        </ISTot>
        <IBSCBSTot>
          <vBCIBSCBS>177.00</vBCIBSCBS>
          <gIBS>
            <gIBSUF>
              <vDif>0.00</vDif>
              <vDevTrib>0.00</vDevTrib>
              <vIBSUF>0.11</vIBSUF>
            </gIBSUF>
            <gIBSMun>
              <vDif>0.00</vDif>
              <vDevTrib>0.00</vDevTrib>
              <vIBSMun>0.00</vIBSMun>
            </gIBSMun>
            <vIBS>0.11</vIBS>
            <vCredPres>0.00</vCredPres>
            <vCredPresCondSus>0.00</vCredPresCondSus>
          </gIBS>
          <gCBS>
            <vDif>0.00</vDif>
            <vDevTrib>0.00</vDevTrib>
            <vCBS>0.96</vCBS>
            <vCredPres>0.00</vCredPres>
            <vCredPresCondSus>0.00</vCredPresCondSus>
          </gCBS>
          <gMono>
            <vIBSMono>0.00</vIBSMono>
            <vCBSMono>0.00</vCBSMono>
            <vIBSMonoReten>0.00</vIBSMonoReten>
            <vCBSMonoReten>0.00</vCBSMonoReten>
            <vIBSMonoRet>0.00</vIBSMonoRet>
            <vCBSMonoRet>0.00</vCBSMonoRet>
          </gMono>
        </IBSCBSTot>
        <vNFTot>226.40</vNFTot>
      </total>
      <transp>
        <modFrete>9</modFrete>
      </transp>
      <pag>
        <detPag>
          <tPag>03</tPag>
          <vPag>226.40</vPag>
          <card>
            <tpIntegra>2</tpIntegra>
            <tBand>02</tBand>
            <cAut>362667</cAut>
          </card>
        </detPag>
      </pag>
      <infAdic>
        <infCpl>Tributos: Nacional R 0,00 Estadual R 0,00 Municipal R 0,00</infCpl>
      </infAdic>
      <infRespTec>
        <CNPJ>15120049000155</CNPJ>
        <xContato>SUPORTE MODELO</xContato>
        <email>suporte@exemplo.com.br</email>
        <fone>1138928272</fone>
      </infRespTec>
    </infNFe>
    <infNFeSupl>
      <qrCode>https://www.homologacao.nfce.fazenda.sp.gov.br/qrcode?p=35250612345678000190650020000455641813356065|2|2|1|4EA4ECCB14CEB2E541C7F373739662C56E36EC21</qrCode>
      <urlChave>https://www.homologacao.nfce.fazenda.sp.gov.br/consulta</urlChave>
    </infNFeSupl>
  </NFe>
  <protNFe versao="4.00">
    <infProt>
      <tpAmb>2</tpAmb>
      <verAplic>SP_NFCE_PL_009_V400</verAplic>
      <chNFe>35250612345678000190650020000455641813356065</chNFe>
      <dhRecbto>2026-08-31T15:20:08-03:00</dhRecbto>
      <nProt>135265951505296</nProt>
      <cStat>100</cStat>
      <xMotivo>Autorizado o uso da NF-e</xMotivo>
    </infProt>
  </protNFe>
</nfeProc>''';
