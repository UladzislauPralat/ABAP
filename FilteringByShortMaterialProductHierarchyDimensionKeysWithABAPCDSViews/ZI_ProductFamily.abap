@AbapCatalog.sqlViewName: 'ZIPRODUCTFAMILY'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@VDM.viewType: #BASIC
@ObjectModel.representativeKey: 'ProductFamily'
@Analytics.dataCategory: #DIMENSION
@EndUserText.label: 'Product Family'
define view ZI_ProductFamily 
  as select from t179 
    association [0..*] to ZI_ProductFamilyText as _Text on $projection.ProductFamily = _Text.ProductFamily  
{
  @ObjectModel.text.association: '_Text'
  key cast(left(t179.prodh,13) as zproductfamily ) as ProductFamily,
  _Text   
}
where t179.stufe = '4'
