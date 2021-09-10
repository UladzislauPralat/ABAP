@AbapCatalog.sqlViewName: 'ZITABLNMT'
@ObjectModel.dataCategory: #TEXT
@VDM.viewType: #BASIC
@ObjectModel.representativeKey: 'TableName'
@EndUserText.label: 'Table Name'
define view ZI_TableNameText as select from dd02l inner join dd02t
                                                          on dd02l.tabname  = dd02t.tabname
                                                         and dd02l.as4local = dd02t.as4local
                                                         and dd02l.as4vers  = dd02t.as4vers                                                         
{
  key dd02l.tabname as TableName, 
  @Semantics.language: true
  key dd02t.ddlanguage as Language,
  @Semantics.text: true
  ddtext    
}
where ( tabclass = #tabclass.'TRANSP' or tabclass = #tabclass.'INTTAB' )
  and dd02l.as4local = 'A'
  and dd02l.as4vers = '0000'
