@AbapCatalog.sqlViewName: 'ZIINVAGINGC'
@AccessControl.authorizationCheck: #CHECK
@VDM.viewType: #COMPOSITE
@Analytics.dataCategory: #CUBE
@EndUserText.label: 'Inventory Aging'
define view ZI_InventoryAgingCube
  with parameters
    @EndUserText.label: 'Date'     
    @Environment.systemField: #SYSTEM_DATE
    P_Current_Date: dats,
    @EndUserText.label: 'Aging Range 1'    
    P_Aging_Range_1: char3,
    @EndUserText.label: 'Aging Range 2'    
    P_Aging_Range_2: char3,
    @EndUserText.label: 'Aging Range 3'    
    P_Aging_Range_3: char3,    
    @EndUserText.label: 'Aging Range 4'    
    P_Aging_Range_4: char3,        
    @EndUserText.label: 'Internal Flow Elimination'
    P_Internal_Flow_Elimination: cacsyn  
  as select from ZI_InventoryAgingFunc(P_Current_Date:              $parameters.P_Current_Date,
                                       P_Aging_Range_1:             $parameters.P_Aging_Range_1,
                                       P_Aging_Range_2:             $parameters.P_Aging_Range_2,
                                       P_Aging_Range_3:             $parameters.P_Aging_Range_3,
                                       P_Aging_Range_4:             $parameters.P_Aging_Range_4,                             
                                       P_Internal_Flow_Elimination: $parameters.P_Internal_Flow_Elimination)
  association [0..1] to I_Plant                     as _Plant                      on $projection.Plant                     = _Plant.Plant
  association [0..1] to I_StorageLocation           as _StorageLocation            on $projection.Plant                     = _StorageLocation.Plant
                                                                                  and $projection.StorageLocation           = _StorageLocation.StorageLocation
  association [0..1] to I_InventorySpecialStockType as _InventorySpecialStockType  on $projection.InventorySpecialStockType = _InventorySpecialStockType.InventorySpecialStockType
  association [0..1] to I_Customer                  as _Customer                   on $projection.CustomerStockIdentifier   = _Customer.Customer  
  association [0..1] to ZI_StockType                as _StockType                  on $projection.StockType                 = _StockType.StockType
  association [0..1] to I_Material                  as _Material                   on $projection.Material                  = _Material.Material
  association [0..1] to ZI_AgingRange               as _AgingRange                 on $projection.AgingRange                = _AgingRange.AgingRange
  association [0..1] to I_UnitOfMeasure             as _UnitOfMeasure              on $projection.UnitOfMeasure             = _UnitOfMeasure.UnitOfMeasure
  association [0..1] to I_Currency                  as _Currency                   on $projection.Currency                  = _Currency.Currency                                                   
{
  @ObjectModel.foreignKey.association: '_Plant'
  key werks as Plant,
  @ObjectModel.foreignKey.association: '_StorageLocation'  
  key lgort as StorageLocation,
  @ObjectModel.foreignKey.association: '_InventorySpecialStockType'  
  key sobkz as InventorySpecialStockType,
  @ObjectModel.foreignKey.association: '_Customer'
  @EndUserText.label: 'Customer Stock Identifier'
  key kunnr_sid as CustomerStockIdentifier,
  @ObjectModel.foreignKey.association: '_StockType'  
  @EndUserText.label: 'Stock Type'
  key lbbsa_sid as StockType,  
  @ObjectModel.foreignKey.association: '_Material'
  key matnr as Material,
  @ObjectModel.foreignKey.association: '_AgingRange'
  @EndUserText.label: 'Aging'  
  aging_range as AgingRange,
  @EndUserText.label: 'Last Consumption Date'
  budat_h_max as LastConsumptionDate,  
  @ObjectModel.foreignKey.association: '_UnitOfMeasure'
  @Semantics.unitOfMeasure: true  
  meins as UnitOfMeasure,
  @Semantics.currencyCode: true
  @ObjectModel.foreignKey.association: '_Currency'    
  waers as Currency,
  @Semantics.quantity.unitOfMeasure: 'UnitOfMeasure'
  @DefaultAggregation: #SUM        
  labst as StockQuantity,
  @Semantics.amount.currencyCode: 'Currency'
  @DefaultAggregation: #SUM    
  salk3 as StockValue,
  _Plant,
  _StorageLocation,
  _InventorySpecialStockType,  
  _Customer,
  _StockType,
  _Material,
  _AgingRange,  
  _UnitOfMeasure,
  _Currency    
}

