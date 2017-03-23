@AbapCatalog.sqlViewName: 'ZREGION  '
@AccessControl.authorizationCheck:#NOT_REQUIRED 
@EndUserText.label: 'Flight - Region '
define view zsapbc_region as select distinct from zsapbc_carr {
  key region,
  case 
  when region = 'Germany' or region = 'France' or region = 'Italy' or
       region = 'UK' or region = 'Austria' or region = 'Swirzerland' then 'Europe'
  when region = 'US' or region = 'Canada' then 'North America'
  
  when region = 'South Africa' then 'Africa' 
  when region = 'Fiji' or region = 'Japan' or region = 'Singapure' then 'Asia'
  else 'Other' 
  end as main_region  
}
where region <> 'Australia'

union

select distinct from scarr {

key 'Europe' as region,
    'World' as main_region
}

union

select distinct from scarr {

key 'North America' as region,
    'World' as main_region
}

union

select distinct from scarr {

key 'Asia' as region,
    'World' as main_region
}

union

select distinct from scarr {

key 'Australia' as region,
    'World' as main_region
}

union

select distinct from scarr {

key 'Africa' as region,
    'World' as main_region
}

union

select distinct from scarr {

key 'World' as region,
    '' as main_region
}


