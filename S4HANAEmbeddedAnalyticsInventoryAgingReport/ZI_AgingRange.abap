@AbapCatalog.sqlViewName: 'ZIAGINGRANGE'
@VDM.viewType: #BASIC
@ObjectModel.representativeKey: 'AgingRange'
@Analytics.dataCategory: #DIMENSION
@EndUserText.label: 'Aging Range'
define view ZI_AgingRange 
  as select from tadir 
{
  @EndUserText.label: 'Aging Range'
  @ObjectModel.text.element: ['AgingRangeDescription']  
  key cast('1' as abap.char(1)) as AgingRange,
  @Semantics.text: true
  @EndUserText.label: 'Aging Range Description'  
  cast('Range 1' as text10) as AgingRangeDescription     
    
}
where obj_name = 'ZI_AGINGRANGE'
  and object = 'DDLS' 

union all

select from tadir 
{
  @EndUserText.label: 'Aging Range'
  @ObjectModel.text.element: ['AgingRangeDescription']  
  key cast('2' as abap.char(1)) as AgingRange,
  @Semantics.text: true
  @EndUserText.label: 'Aging Range Description'  
  cast('Range 2' as text10) as AgingRangeDescription     
    
}
where obj_name = 'ZI_AGINGRANGE'
  and object = 'DDLS'
  
union all

select from tadir 
{
  @EndUserText.label: 'Aging Range'
  @ObjectModel.text.element: ['AgingRangeDescription']  
  key cast('3' as abap.char(1)) as AgingRange,
  @Semantics.text: true
  @EndUserText.label: 'Aging Range Description'  
  cast('Range 3' as text10) as AgingRangeDescription     
    
}
where obj_name = 'ZI_AGINGRANGE'
  and object = 'DDLS'  

union all

select from tadir 
{
  @EndUserText.label: 'Aging Range'
  @ObjectModel.text.element: ['AgingRangeDescription']  
  key cast('4' as abap.char(1)) as AgingRange,
  @Semantics.text: true
  @EndUserText.label: 'Aging Range Description'  
  cast('Range 4' as text10) as AgingRangeDescription     
    
}
where obj_name = 'ZI_AGINGRANGE'
  and object = 'DDLS'  
  
union all

select from tadir 
{
  @EndUserText.label: 'Aging Range'
  @ObjectModel.text.element: ['AgingRangeDescription']  
  key cast('5' as abap.char(1)) as AgingRange,
  @Semantics.text: true
  @EndUserText.label: 'Aging Range Description'  
  cast('Range 5' as text10) as AgingRangeDescription     
    
}
where obj_name = 'ZI_AGINGRANGE'
  and object = 'DDLS'    
