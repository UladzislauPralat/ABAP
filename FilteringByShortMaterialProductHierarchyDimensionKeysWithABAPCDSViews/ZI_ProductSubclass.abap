@AbapCatalog.sqlViewName: 'ZIPRODSUBCLASS'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@VDM.viewType: #BASIC
@ObjectModel.representativeKey: 'ProductSubclass'
@Analytics.dataCategory: #DIMENSION
@EndUserText.label: 'Product Subclass'
define view ZI_ProductSubclass as select from t179 
  association [0..*] to ZI_ProductSubclassText as _Text on $projection.ProductSubclass = _Text.ProductSubclass  
{
  @ObjectModel.text.association: '_Text'
  key cast(left(t179.prodh,8) as zproductsubclass ) as ProductSubclass,  
  _Text   
}
where t179.stufe = '3'
