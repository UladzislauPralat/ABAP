@AbapCatalog.sqlViewName: 'ZREGION3'
@AccessControl.authorizationCheck:#NOT_REQUIRED 
@EndUserText.label: 'Flight - Region '
define view zsapbc_region3 as select distinct from zsapbc_carr {
  key region,
  case 
  when region = 'US' or region = 'Canada' then 'North America'
  
  when region = 'South Africa' then 'Africa' 
  when region = 'Fiji' or region = 'Japan' or region = 'Singapure' then 'Asia'
  else 'Other' 
  end as main_region,
  cast( '00010101' as abap.dats ) as datefrom,
  cast( '99991231' as abap.dats ) as dateto  
}
where region <> 'Australia' and region <> 'Germany' and region <> 'France' and region <> 'Italy' and
       region <> 'UK' and region <> 'Austria' and region <> 'Swirzerland'

union

select distinct from zsapbc_carr {
  key region,
  'Europe' as main_region,
  cast( '00010101' as abap.dats ) as datefrom,
  cast( '19931031' as abap.dats ) as dateto
}
where region = 'Germany' or region = 'France' or region = 'Italy' or
       region = 'UK' or region = 'Austria' or region = 'Swirzerland'

union

select distinct from zsapbc_carr {
  key region,
  'EU' as main_region,
  cast( '19931031' as abap.dats ) as datefrom,
  cast( '99991231' as abap.dats ) as dateto
}
where region = 'Germany' or region = 'France' or region = 'Italy' or
       region = 'UK' or region = 'Austria' or region = 'Swirzerland'

union

select distinct from scarr {

  key 'Europe' as region,
  'World' as main_region,
  cast( '00010101' as abap.dats ) as datefrom,
  cast( '19931031' as abap.dats ) as dateto
}

union

select distinct from scarr {

  key 'EU' as region,
  'World' as main_region,
  cast( '19931101' as abap.dats ) as datefrom,
  cast( '99991231' as abap.dats ) as dateto
}

union  

select distinct from scarr {

  key 'North America' as region,
  'World' as main_region,
  cast( '00010101' as abap.dats ) as datefrom,
  cast( '99991231' as abap.dats ) as dateto
}

union

select distinct from scarr {

  key 'Asia' as region,
  'World' as main_region,
  cast( '00010101' as abap.dats ) as datefrom,
  cast( '99991231' as abap.dats ) as dateto
}

union

select distinct from scarr {

  key 'Australia' as region,
  'World' as main_region,
  cast( '00010101' as abap.dats ) as datefrom,
  cast( '99991231' as abap.dats ) as dateto
}

union

select distinct from scarr {

  key 'Africa' as region,
  'World' as main_region,
  cast( '00010101' as abap.dats ) as datefrom,
  cast( '99991231' as abap.dats ) as dateto
}

union

select distinct from scarr {

  key 'World' as region,
  '' as main_region,
  cast( '00010101' as abap.dats ) as datefrom,
  cast( '99991231' as abap.dats ) as dateto  
} 
 