@AbapCatalog.sqlViewName: 'ZITABLNM'
@EndUserText.label: 'Table Name'
@Analytics.dataCategory: #DIMENSION
@VDM.viewType: #BASIC
@ObjectModel.representativeKey: 'TableName'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view ZI_TableName as select from dd02l
  association [0..*] to ZI_TableNameText as _TableNameText on $projection.TableName = _TableNameText.TableName  
{
  @ObjectModel.text.association: '_TableNameText'      
  key tabname as TableName,
  _TableNameText  
}
where ( tabclass = #tabclass.'TRANSP' or tabclass = #tabclass.'INTTAB' )
  and as4local = 'A'
  and as4vers = '0000' 
