@AbapCatalog.sqlViewName: 'ZIPRODCATEGT'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.dataCategory: #TEXT
@VDM.viewType: #BASIC
@EndUserText.label: 'Product Category'
define view ZI_ProductCategoryText as select from t179 inner join t179t
                                                               on t179.prodh = t179t.prodh  
  association [0..1] to I_Language         as _Language        on $projection.Language        = _Language.Language
  association [1..1] to ZI_ProductCategory as _ProductCategory on $projection.ProductCategory = _ProductCategory.ProductCategory
{
  @ObjectModel.foreignKey.association: '_ProductCategory'
  key t179t.prodh as ProductCategory,
  @Semantics.language: true
  @ObjectModel.foreignKey.association: '_Language'
  key t179t.spras as Language, 
  @Semantics.text: true
  vtext as ProductCategoryText,
  _ProductCategory,
  _Language
}
where t179.stufe = '1'
