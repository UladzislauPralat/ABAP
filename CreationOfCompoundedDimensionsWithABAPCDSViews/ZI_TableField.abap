@AbapCatalog.sqlViewName: 'ZITABLFLD'
@EndUserText.label: 'Table Field' 
@Analytics.dataCategory: #DIMENSION
@VDM.viewType: #BASIC
@ObjectModel.representativeKey: 'FieldName'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view ZI_TableField as select from dd02l inner join dd03l on dd02l.tabname  = dd03l.tabname
                                                               and dd02l.as4local = dd03l.as4local
                                                               and dd02l.as4vers  = dd03l.as4vers
  association [0..*] to ZI_TableFieldText as _TableFieldText on $projection.FieldName = _TableFieldText.FieldName
                                                            and  $projection.TableName = _TableFieldText.TableName
{
  key dd03l.tabname as TableName,
  @ObjectModel.text.association: '_TableFieldText'  
  key dd03l.fieldname as FieldName,
  _TableFieldText
}   
where dd02l.tabclass = #tabclass.'TRANSP'
  and ( dd03l.comptype = #comptype.'E' or  dd03l.comptype = #comptype.' ' ) 
  and dd03l.as4local = 'A'
  and dd03l.as4vers = '0000' 
