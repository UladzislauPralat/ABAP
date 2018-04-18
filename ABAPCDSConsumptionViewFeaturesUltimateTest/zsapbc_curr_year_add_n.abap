@AbapCatalog.sqlViewName 'ZCURR_YR_ADD_N'
@AbapCatalog.compiler.compareFilter true
@AccessControl.authorizationCheck #CHECK
@EndUserText.label 'Current Year Plus Offset'
define view zsapbc_curr_year_add_n with parameters
  p_offset  abap.int2
as select from zsapbc_curr_date {
  ( cast(cast(substring(system_date,1,4) as abap.numc(4)) as abap.int2) + p_offset )  as p_year
} 
 