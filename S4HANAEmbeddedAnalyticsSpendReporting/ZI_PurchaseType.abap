@AbapCatalog.sqlViewName: 'ZI_PURTP'
@EndUserText.label: 'Purchase Type'
@Analytics.dataCategory: #DIMENSION
@VDM.viewType: #BASIC
@ObjectModel.representativeKey: 'PurchaseType'
define view ZI_PurchaseType as select from tadir
{
  @ObjectModel.text.element: 'PurchaseTypeText'
  key 'I' as PurchaseType,
  @Semantics.text
  cast('Indirect' as abap.char( 8 )) as PurchaseTypeText
}
where obj_name = 'ZI_PURCHASETYPE'
  and object = 'DDLS'
  
union all

select from tadir
{
  @ObjectModel.text.element: 'PurchaseTypeText'
  key 'D' as PurchaseType,
  @Semantics.text
  cast('Direct' as abap.char( 8 )) as PurchaseTypeText
}
where obj_name = 'ZI_PURCHASETYPE'
  and object = 'DDLS'
