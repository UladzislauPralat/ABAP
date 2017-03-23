@AbapCatalog.sqlViewName: 'ZREGION_DIM'
@Analytics: { dataCategory: #DIMENSION, dataExtraction.enabled: true }
@ObjectModel.representativeKey: 'REGION'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Flight - Region Dimension'
define view zsapbc_region_dimension as select from zsapbc_region 
association[0..*] to zsapbc_region_hierarchy as _region_hier on  $projection.region    = _region_hier.HierarchyNode
{
  @ObjectModel.Hierarchy.association: '_region_hier'  
  key region,
   @EndUserText.label: 'Main Region'
  main_region,
  _region_hier
}

