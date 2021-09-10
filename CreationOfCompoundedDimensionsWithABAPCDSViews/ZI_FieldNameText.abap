@AbapCatalog.sqlViewName: 'ZIFLDNMTXT'
@ObjectModel.dataCategory: #TEXT
@VDM.viewType: #BASIC
@ObjectModel.representativeKey: 'FieldName'
@EndUserText.label: 'Table Field'
define view ZI_FieldNameText as select from dd02l inner join dd03l  on dd02l.tabname  = dd03l.tabname
                                                                   and dd02l.as4local = dd03l.as4local
                                                                   and dd02l.as4vers  = dd03l.as4vers
                                                  inner join dd04t  on dd03l.rollname = dd04t.rollname
                                                                   and dd03l.as4local = dd04t.as4local
                                                                   and dd03l.as4vers  = dd04t.as4vers      
{
  key dd03l.tabname as TableName,
  key dd03l.fieldname as FieldName,
  @Semantics.language: true
  key dd04t.ddlanguage as Language,
  @Semantics.text: true
  cast(dd04t.scrtext_l as as4text) as FieldDescription    
}
where ( tabclass = #tabclass.'TRANSP' or tabclass = #tabclass.'INTTAB' )
  and ( dd03l.comptype = #comptype.'E' or  dd03l.comptype = #comptype.' ' )
  and dd03l.as4local = 'A'
  and dd03l.as4vers = '0000'
  
union

select from dd02l inner join dd02t  on dd02l.tabname  = dd02t.tabname
                                   and dd02l.as4local = dd02t.as4local
                                   and dd02l.as4vers  = dd02t.as4vers                                                         
{
  key dd02l.tabname as TableName, 
  key cast('KEY' as fieldname) as FieldName,  
  @Semantics.language: true
  key dd02t.ddlanguage as Language,
  @Semantics.text: true
//cast(ddtext as scrtext_l) as FieldDescription
  ddtext as FieldDescription    
}
where ( tabclass = #tabclass.'TRANSP' or tabclass = #tabclass.'INTTAB' )
  and dd02l.as4local = 'A'
  and dd02l.as4vers = '0000'
  

