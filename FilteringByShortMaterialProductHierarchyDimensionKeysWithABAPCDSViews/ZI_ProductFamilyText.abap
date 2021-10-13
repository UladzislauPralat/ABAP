@AbapCatalog.sqlViewName: 'ZIPRODUCTFAMILYT'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.dataCategory: #TEXT
@VDM.viewType: #BASIC
@EndUserText.label: 'Product Family'
define view ZI_ProductFamilyText as select from t179 inner join t179t
                                                             on t179.prodh = t179t.prodh  
  association [0..1] to I_Language       as _Language      on $projection.Language = _Language.Language
  association [1..1] to ZI_ProductFamily as _ProductFamily on $projection.ProductFamily = _ProductFamily.ProductFamily
{
  @ObjectModel.foreignKey.association: '_ProductFamily'
  key t179t.prodh as ProductFamily,
  @Semantics.language: true
  @ObjectModel.foreignKey.association: '_Language'
  key t179t.spras as Language, 
  @Semantics.text: true
  vtext as ProductFamilyText,
  _ProductFamily,
  _Language
}
where t179.stufe = '4'
