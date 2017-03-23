@AbapCatalog.sqlViewName: 'ZCARR_TEXT'
@Analytics: {dataCategory:  #TEXT, dataExtraction.enabled: true}
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Flight - Carrier Text'
define view zsapbc_carr_text as select from scarr {
  key carrid,
  @Semantics.text: true
  carrname as CarrierName    
}