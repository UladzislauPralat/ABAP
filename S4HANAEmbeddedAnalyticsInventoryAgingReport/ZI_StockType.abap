@AbapCatalog.sqlViewName: 'ZISTOCKTYPE'
@VDM.viewType: #BASIC
@Analytics.dataCategory: #DIMENSION
@ObjectModel.representativeKey: 'StockType'
@EndUserText.label: 'Stock Type'
define view ZI_StockType 
  as select from dd07t 
{
  @EndUserText.label: 'Stock Type'
  @ObjectModel.text.element: ['StockTypeDescription']  
  key cast(domvalue_l as nsdm_lbbsa) as StockType,
  @Semantics.text: true
  @EndUserText.label: 'Stock Type Description'  
 ddtext as StockTypeDescription     
}
where domname = 'NSDM_LBBSA'
  and ddlanguage = 'E'
