@AbapCatalog.sqlViewName: 'ZIEXCAGGRC'
@EndUserText.label: 'Exception Aggregation'
@Analytics.dataCategory: #CUBE
@VDM.viewType: #COMPOSITE
define view ZI_ExceptionAggregationCube 
  as select from vbak inner join vbap
                              on vbak.vbeln = vbap.vbeln 
  association [0..1] to I_SalesOrganization   as _SalesOrganization    on $projection.SalesOrganization = _SalesOrganization.SalesOrganization
  association [0..1] to I_DistributionChannel as _DistributionChannel  on $projection.DistributionChannel = _DistributionChannel.DistributionChannel
  association [0..1] to I_Division            as _Division             on $projection.Division = _Division.Division
  association [0..1] to I_Customer            as _SoldToParty          on $projection.SoldToParty = _SoldToParty.Customer
  association [0..1] to I_Material            as _Material             on $projection.Material = _Material.Material  
{
  vbak.vbeln as SalesDocument,
  vbap.posnr as SalesDocumentItem,
  @ObjectModel.foreignKey.association: '_SalesOrganization'
  vbak.vkorg as SalesOrganization,
  @ObjectModel.foreignKey.association: '_DistributionChannel'  
  vbak.vtweg as DistributionChannel,
  @ObjectModel.foreignKey.association: '_Division'  
  vbak.spart as Division,
  @ObjectModel.foreignKey.association: '_SoldToParty' 
  vbak.kunnr as SoldToParty,
  @ObjectModel.foreignKey.association: '_Material'  
  vbap.matnr as Material,
  _SalesOrganization,
  _DistributionChannel,
  _Division,
  _SoldToParty,
  _Material
}

