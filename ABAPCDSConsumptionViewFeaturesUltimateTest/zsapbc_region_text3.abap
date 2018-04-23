@AbapCatalog.sqlViewName: 'ZREGION_TEXT3'
@Analytics: {dataCategory:  #TEXT, dataExtraction.enabled: true}
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Flight - Region Text'
define view zsapbc_region_text3 as select from zsapbc_region3 {

  key region,
  @Semantics: {language: true }
  'E' as lang,     
  @Semantics.text: true
  case 
  when region = 'EU' then 'European Union'
  else region 
  end as region_text    
} 
 
 union
 
 select from zsapbc_region3 {

  key region,
  @Semantics: {language: true }
  'D' as lang,     
  @Semantics.text: true
  case 
  when region = 'EU' then 'Europäische Union'
  when region = 'World' then 'Welt'
  when region = 'US' then 'Vereinigte Staaten'
  when region = 'Canada' then 'Kanada' 
  when region = 'Fiji' then 'Fidschi'  
  when region = 'South Africa' then 'Südafrika'         
  when region = 'Singapure' then 'Singapur'
  when region = 'France' then 'Frankreich'
  when region = 'Italy' then 'Italien'    
  when region = 'UK' then 'Vereinigtes Königreich'
  when region = 'UK' then 'Vereinigtes Königreich'                       
  when region = 'Germany' then 'Deutschland'
  when region = 'Austria' then 'Österreich'       
  when region = 'Swirzerland' then 'Schweiz'        
  when region = 'Europe' then 'Europa'      
  when region = 'North America' then 'Nordamerika'     
  when region = 'Asia' then 'Asien'  
  when region = 'Australia' then 'Australien'
  when region = 'Africa' then 'Afrika'
  else region end as region_text    
} 
 