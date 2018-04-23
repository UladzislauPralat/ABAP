@AbapCatalog.sqlViewName: 'ZREGION_HIER3'
@Analytics: { dataCategory: #HIERARCHY, dataExtraction.enabled: true }
@ObjectModel.representativeKey: 'REGION'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Flight - Region Hierarchy'
@Hierarchy.parentChild.name: 'REGION_GEO'
@Hierarchy.parentChild.label: 'Region Geography'
@Hierarchy.parentChild: 
{ recurse:          {   parent: 'ParentNode',   child:  'HierarchyNode'   } }
define view zsapbc_region_hierarchy3 as select distinct from zsapbc_region3 
 association[0..*] to zsapbc_region_dimension3 as _region_dim on $projection.HierarchyNode = _region_dim.region
{
  @ObjectModel.foreignKey.association: '_region_dim'
  key region as HierarchyNode,

@Semantics.businessDate.to: true 
key dateto,
@Semantics.businessDate.from: true
datefrom,
main_region as ParentNode,
  _region_dim
} 
 