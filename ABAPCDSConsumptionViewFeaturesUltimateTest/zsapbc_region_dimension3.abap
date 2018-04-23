@AbapCatalog.sqlViewName: 'ZREGION_DIM3'
@Analytics: { dataCategory: #DIMENSION, dataExtraction.enabled: true }
@ObjectModel.representativeKey: 'region'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Flight – Region Dimension' 
define view zsapbc_region_dimension3 as select from zsapbc_region3
association [1..1] to zsapbc_region_text3 as _region_text on $projection.region = _region_text.region
association[0..*] to zsapbc_region_hierarchy3 as _region_hier on
$projection.region = _region_hier.HierarchyNode
{
@ObjectModel.text.association: '_region_text'
@ObjectModel.Hierarchy.association: '_region_hier' 
key region,
@Semantics.businessDate.to: true 
key dateto,
@Semantics.businessDate.from: true
datefrom,
@EndUserText.label: 'Main Region'
main_region,
_region_text,
_region_hier
} 
 