@AbapCatalog.sqlViewName: 'ZIFLDNM'
@EndUserText.label: 'Table Field'
@Analytics.dataCategory: #DIMENSION
@VDM.viewType: #BASIC
@ObjectModel.representativeKey: 'FieldName'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view ZI_FieldName as select from dd02l inner join dd03l on dd02l.tabname  = dd03l.tabname
                                                              and dd02l.as4local = dd03l.as4local
                                                              and dd02l.as4vers  = dd03l.as4vers
  association [0..*] to ZI_FieldNameText as _FieldNameText  on $projection.TableName = _FieldNameText.TableName
                                                           and $projection.FieldName = _FieldNameText.FieldName
  association [0..1] to ZI_TableName as _TableName  on $projection.TableName = _TableName.TableName                                                           
{
  @ObjectModel.foreignKey.association: '_TableName'
  key dd03l.tabname as TableName,
  @ObjectModel.text.association: '_FieldNameText'  
  key dd03l.fieldname as FieldName,

   _FieldNameText,
   _TableName
}   
where ( tabclass = #tabclass.'TRANSP' or tabclass = #tabclass.'INTTAB' )
  and ( dd03l.comptype = #comptype.'E' or  dd03l.comptype = #comptype.' ' ) 
  and dd03l.as4local = 'A'
  and dd03l.as4vers = '0000' 

union
  
select from dd02l inner join dd03l on dd02l.tabname  = dd03l.tabname
                                  and dd02l.as4local = dd03l.as4local
                                  and dd02l.as4vers  = dd03l.as4vers
  association [0..*] to ZI_FieldNameText as _FieldNameText  on $projection.TableName = _FieldNameText.TableName
                                                           and $projection.FieldName = _FieldNameText.FieldName
  association [0..1] to ZI_TableName as _TableName  on $projection.TableName = _TableName.TableName
    
{
  @ObjectModel.foreignKey.association: '_TableName'
  key dd03l.tabname as TableName,
  @ObjectModel.text.association: '_FieldNameText'  
  key cast('KEY' as fieldname) as FieldName,

   _FieldNameText,
   _TableName
}   
where ( tabclass = #tabclass.'TRANSP' or tabclass = #tabclass.'INTTAB' )
  and ( dd03l.comptype = #comptype.'E' or  dd03l.comptype = #comptype.' ' ) 
  and dd03l.as4local = 'A'
  and dd03l.as4vers = '0000'    
