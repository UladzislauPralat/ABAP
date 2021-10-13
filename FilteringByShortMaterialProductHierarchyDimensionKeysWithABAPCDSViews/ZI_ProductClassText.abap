
@AbapCatalog.sqlViewName: 'ZIPRDCLASS'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.dataCategory: #TEXT
@VDM.viewType: #BASIC
@EndUserText.label: 'Product Subclass'
define view ZI_ProductClassText as select from t179 inner join t179t
                                                            on t179.prodh = t179t.prodh  
  association [0..1] to I_Language      as _Language     on $projection.Language     = _Language.Language
  association [1..1] to ZI_ProductClass as _ProductClass on $projection.ProductClass = _ProductClass.ProductClass
{
  @ObjectModel.foreignKey.association: '_ProductClass'
  key t179t.prodh as ProductClass,
  @Semantics.language: true
  @ObjectModel.foreignKey.association: '_Language'
  key t179t.spras as Language, 
  @Semantics.text: true
  vtext as ProductClassText,
  _ProductClass,
  _Language
}
where t179.stufe = '2'


