@AbapCatalog.sqlViewName: 'ZI_PURP'
@EndUserText.label: 'Purchase Process'
@Analytics.dataCategory: #DIMENSION
@VDM.viewType: #BASIC
@ObjectModel.representativeKey: 'PurchaseType'
define view ZI_PurchaseProcess as select from tadir
{
  @ObjectModel.text.element: 'PurchaseProcessText'
  key 'P' as PurchaseProcess,
  @Semantics.text
  cast('PO' as abap.char( 8 )) as PurchaseProcessText
}
where obj_name = 'ZI_PURCHASEPROCESS'
  and object = 'DDLS'
  
union all

select from tadir
{
  @ObjectModel.text.element: 'PurchaseProcessText'
  key 'N' as PurchaseProcess,
  @Semantics.text
  cast('Non PO' as abap.char( 8 )) as PurchaseProcessText
}
where obj_name = 'ZI_PURCHASEPROCESS'
  and object = 'DDLS'
