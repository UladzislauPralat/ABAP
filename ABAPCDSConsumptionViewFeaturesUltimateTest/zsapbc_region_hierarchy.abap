@AbapCatalog.sqlViewName: 'ZREGION_HIER'
@Analytics: { dataCategory: #HIERARCHY, dataExtraction.enabled: true }
@ObjectModel.representativeKey: 'REGION'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Flight - Region Dimension'
@Hierarchy.parentChild.name: 'REGION_GEO'
@Hierarchy.parentChild.label: 'Region Geography'
@Hierarchy.parentChild: 
{ recurse:          {   parent: 'ParentNode',   child:  'HierarchyNode'   } }
define view zsapbc_region_hierarchy as select distinct from zsapbc_region 
 association[0..1] to zsapbc_region_dimension as _region_dim on $projection.HierarchyNode = _region_dim.region
{
  @ObjectModel.foreignKey.association: '_region_dim'
  key region as HierarchyNode,
  main_region as ParentNode,
  _region_dim
}
