@EndUserText.label: 'Reference key 3'
define table function ZI_Reference3IDByBusPartner
returns
{
  mandt: abap.clnt;
  Reference3IDByBusinessPartner: xref3;
  CompanyCode: bukrs;
  GLAccount: fis_racct;
  ControllingArea: kokrs;
  CostCenter: kostl;
}
implemented by method
  zcl_reference3idbybuspartner=>function; 