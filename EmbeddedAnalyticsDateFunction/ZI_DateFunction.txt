@AbapCatalog.sqlViewName: 'ZIDATEFUNC'
@EndUserText.label: 'Date Function'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Analytics.dataCategory: #DIMENSION
@VDM.viewType: #BASIC
@ObjectModel.representativeKey: 'DateFunction'
define view ZI_DateFunction as select from C_GregorianCalDateFunction( P_Language: $session.system_language )
{
  @ObjectModel.text.element:'DateFunctionName'
  key DateFunction,
  @Semantics.text: true
  DateFunctionName
}
