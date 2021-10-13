@AbapCatalog.sqlViewName: 'ZIPRODSUBCLASST'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.dataCategory: #TEXT
@VDM.viewType: #BASIC
@EndUserText.label: 'Product Subclass'
define view ZI_ProductSubclassText as select from t179 inner join t179t
                                                               on t179.prodh = t179t.prodh  
  association [0..1] to I_Language         as _Language        on $projection.Language = _Language.Language
  association [1..1] to ZI_ProductSubclass as _ProductSubclass on $projection.ProductSubclass = _ProductSubclass.ProductSubclass
{
  @ObjectModel.foreignKey.association: '_ProductSubclass'
  key t179t.prodh as ProductSubclass,
  @Semantics.language: true
  @ObjectModel.foreignKey.association: '_Language'
  key t179t.spras as Language, 
  @Semantics.text: true
  vtext as ProductSubclassText,
  _ProductSubclass,
  _Language
}
where t179.stufe = '3'
