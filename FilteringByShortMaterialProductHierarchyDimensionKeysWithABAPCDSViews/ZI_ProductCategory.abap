@AbapCatalog.sqlViewName: 'ZIPRODCATEG'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@VDM.viewType: #BASIC
@ObjectModel.representativeKey: 'ProductClass'
@Analytics.dataCategory: #DIMENSION
@EndUserText.label: 'Product Category'
define view ZI_ProductCategory as select from t179 
  association [0..*] to ZI_ProductCategoryText as _Text on $projection.ProductCategory = _Text.ProductCategory  
{
  @ObjectModel.text.association: '_Text'
  key cast(left(t179.prodh,8) as zproductcategory ) as ProductCategory,  

  _Text   
}
where t179.stufe = '1'
