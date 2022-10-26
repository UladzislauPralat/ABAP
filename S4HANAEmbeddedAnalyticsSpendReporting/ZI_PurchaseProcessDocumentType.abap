@AbapCatalog.sqlViewName: 'ZI_PURPDT'
@EndUserText.label: 'Purchase Process Document Type'
@Analytics.dataCategory: #DIMENSION
@VDM.viewType: #BASIC
@ObjectModel.representativeKey: 'PurchaseProcessDocumentType'
define view ZI_PurchaseProcessDocumentType as select from tadir
{
  @ObjectModel.text.element: 'PurProcessDocTypeText'
  key '1' as PurchaseProcessDocumentType,
  @Semantics.text
  cast('PO & PR' as abap.char( 8 )) as PurProcessDocTypeText
}
where obj_name = 'ZI_PURCHASEPROCESSDOCUMENTTYPE'
  and object = 'DDLS'
  
union all

select from tadir
{
  @ObjectModel.text.element: 'PurProcessDocTypeText'
  key '2' as PurchaseProcessDocumentType,
  @Semantics.text
  cast('PO' as abap.char( 8 )) as PurProcessDocTypeText
}
where obj_name = 'ZI_PURCHASEPROCESSDOCUMENTTYPE'
  and object = 'DDLS'
  
union all

select from tadir
{
  @ObjectModel.text.element: 'PurProcessDocTypeText'
  key '3' as PurchaseProcessDocumentType,
  @Semantics.text
  cast('No PO' as abap.char( 8 )) as PurProcessDocTypeText
}
where obj_name = 'ZI_PURCHASEPROCESSDOCUMENTTYPE'
  and object = 'DDLS'  
