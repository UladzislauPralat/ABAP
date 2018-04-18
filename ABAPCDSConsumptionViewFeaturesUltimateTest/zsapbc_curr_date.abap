@AbapCatalog.sqlViewName: 'ZCURR_DATE'
define view zsapbc_curr_date as select from tadir
{
  $session.system_date as system_date
}
where obj_name = 'ZSAPBC_CURR_DATE'
  and object   = 'DDLS' 