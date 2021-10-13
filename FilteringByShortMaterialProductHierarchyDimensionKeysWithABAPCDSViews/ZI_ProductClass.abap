@AbapCatalog.sqlViewName: 'ZIPRODCLSGBU'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@VDM.viewType: #BASIC
@ObjectModel.representativeKey: 'ProductClass'
@Analytics.dataCategory: #DIMENSION
@EndUserText.label: 'Product Class'
define view ZI_ProductClass as select from t179 
  association [0..*] to ZI_ProductClassText as _Text on $projection.ProductClass = _Text.ProductClass  
{
  @ObjectModel.text.association: '_Text'
  key cast(left(t179.prodh,5) as zproductclass ) as ProductClass,  
  _Text   
}
where t179.stufe = '2'
