@AbapCatalog.sqlViewName: 'ZCARR_DIM'
@Analytics: {dataCategory: #DIMENSION, dataExtraction.enabled: true} 
@ObjectModel.representativeKey: 'CARRID'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Flight - Carrier Dimension'
define view zsapbc_carr_dimension as select from zsapbc_carr as scarr
 association [1..1] to zsapbc_carr_text as _carr on $projection.carrid = scarr.carrid
 {
 @ObjectModel.text.association: '_carr' 
  key carrid,
  url,
  currcode,
  @EndUserText.label: 'Region'
  region,
  _carr
}
