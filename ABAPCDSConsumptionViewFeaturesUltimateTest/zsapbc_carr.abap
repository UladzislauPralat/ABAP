@AbapCatalog.sqlViewName: 'ZCARR'
@AccessControl.authorizationCheck:#NOT_REQUIRED 
@EndUserText.label: 'Airline'
define view zsapbc_carr as select from scarr
{
  carrid,   
  url,
  currcode,
  cast(case 
  when carrid = 'LH' or carrid = 'AB' then 'Germany'
  when carrid = 'AA' or carrid = 'CO' or carrid = 'DL' or 
       carrid = 'NW' or carrid = 'WA' then 'US'
  when carrid = 'AC' then 'Canada'  
  when carrid = 'AF' then 'France'  
  when carrid = 'AZ' then 'Italy'
  when carrid = 'BA' then 'UK'
  when carrid = 'FJ' then 'Fiji'
  when carrid = 'NG' then 'Austria'
  when carrid = 'JL' then 'Japan'
  when carrid = 'QF' then 'Australia'
  when carrid = 'SA' then 'South Africa'
  when carrid = 'SQ' then 'Singapure'
  when carrid = 'SR' then 'Swirzerland'  
  when carrid = 'UA' then 'US'
  else 'Other'
  end as abap.char( 13 ))  as region    
}