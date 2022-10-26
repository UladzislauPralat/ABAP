@AbapCatalog.sqlViewName: 'ZSPENDC'
@AccessControl.authorizationCheck: #CHECK
@VDM.viewType: #COMPOSITE
@Analytics.dataCategory: #CUBE
@EndUserText.label: 'Spend'
define view ZI_SpendCube 
  as select from ZI_SpendFact as Spend   
    association [0..1] to I_CompanyCode                  as _CompanyCode                 on $projection.CompanyCode = _CompanyCode.CompanyCode
    association [1..1] to I_JournalEntry                 as _JournalEntry                on $projection.CompanyCode        = _JournalEntry.CompanyCode                             // 8000006493 / ED1K913105
                                                                                        and $projection.FiscalYear         = _JournalEntry.FiscalYear                              // 8000006493 / ED1K913105
                                                                                        and $projection.AccountingDocument = _JournalEntry.AccountingDocument                      // 8000006493 / ED1K913105
    association [0..1] to I_FiscalYearForCompanyCode     as _FiscalYear                  on $projection.FiscalYear               = _FiscalYear.FiscalYear                          // 8000006493 / ED1K913105
                                                                                        and $projection.CompanyCode              = _FiscalYear.CompanyCode                         // 8000006493 / ED1K913105    
    association [0..1] to I_Supplier                     as _Supplier                    on $projection.Supplier = _Supplier.Supplier
    association [0..1] to I_SupplierAccountGroup         as _SupplierAccountGroup        on $projection.supplieraccountgroup = _SupplierAccountGroup.SupplierAccountGroup
    association [0..1] to I_AccountingDocumentType       as _AccountingDocumentType      on $projection.AccountingDocumentType = _AccountingDocumentType.AccountingDocumentType    
    association [0..1] to I_PostingKey                   as _PostingKey                  on $projection.PostingKey = _PostingKey.PostingKey       
    association [0..1] to I_GLAccount                    as _GLAccount                   on $projection.GLAccount   = _GLAccount.GLAccount
                                                                                        and $projection.CompanyCode = _GLAccount.CompanyCode 
    association [0..1] to I_ControllingArea              as _ControllingArea             on $projection.ControllingArea = _ControllingArea.ControllingArea
    association [0..*] to I_CostCenter                   as _CostCenter                  on $projection.CostCenter      = _CostCenter.CostCenter
                                                                                        and $projection.ControllingArea = _CostCenter.ControllingArea
    association [1..1] to I_PurchasingDocumentCategory   as _PurchasingDocumentCategory  on $projection.PurchasingDocumentCategory = _PurchasingDocumentCategory.PurchasingDocumentCategory
    association [0..1] to I_PurchasingDocumentType       as _PurchasingDocumentType      on $projection.PurchasingDocumentCategory = _PurchasingDocumentType.PurchasingDocumentCategory
                                                                                        and $projection.PurchasingDocumentType     = _PurchasingDocumentType.PurchasingDocumentType
    association [0..1] to I_PurchasingOrganization       as _PurchasingOrganization      on $projection.PurchasingOrganization = _PurchasingOrganization.PurchasingOrganization
    association [0..1] to I_Plant                        as _Plant                       on $projection.Plant = _Plant.Plant
    association [0..1] to I_Material                     as _Material                    on $projection.Material = _Material.Material
    association [0..1] to I_MaterialGroup                as _MaterialGroup               on $projection.MaterialGroup = _MaterialGroup.MaterialGroup
    association [1..1] to I_PurchasingDocumentCategory   as _PurchaseRequisitionCategory on $projection.PurchaseRequisitionCategory = _PurchaseRequisitionCategory.PurchasingDocumentCategory    
    association [0..1] to I_PurchasingDocumentType       as _PurchaseRequisitionType     on $projection.PurchaseRequisitionCategory = _PurchaseRequisitionType.PurchasingDocumentCategory
                                                                                        and $projection.PurchaseRequisitionType     = _PurchaseRequisitionType.PurchasingDocumentType
    association [0..1] to I_PaymentTerms                 as _PaymentTerms                on $projection.PaymentTerms = _PaymentTerms.PaymentTerms                                                                                       
    association [0..1] to I_ReferenceDocumentType        as _ReferenceDocumentType       on $projection.ReferenceDocumentType = _ReferenceDocumentType.ReferenceDocumentType
    association [0..1] to ZI_PurchaseProcess             as _PurchaseProcess             on $projection.PurchaseProcess = _PurchaseProcess.PurchaseProcess    
    association [0..1] to ZI_PurchaseType                as _PurchaseType                on $projection.PurchaseType = _PurchaseType.PurchaseType
    association [0..1] to ZI_PurchaseProcessDocumentType as _PurchaseProcessDocumentType on $projection.PurchaseProcessDocumentType = _PurchaseProcessDocumentType.PurchaseProcessDocumentType
    association [0..1] to I_Country                      as _Country                     on $projection.Country = _Country.Country
    association [0..1] to I_Currency                     as _CompanyCodeCurrency         on $projection.CompanyCodeCurrency = _CompanyCodeCurrency.Currency
    association [0..1] to I_Currency                     as _TransactionCurrency         on $projection.TransactionCurrency = _TransactionCurrency.Currency
    association [0..1] to I_Currency                     as _GroupCurrency               on $projection.GroupCurrency = _GroupCurrency.Currency
{
  @ObjectModel.foreignKey.association: '_CompanyCode'
  key CompanyCode,
  @ObjectModel.foreignKey.association: '_JournalEntry'    
  key AccountingDocument,
  @ObjectModel.foreignKey.association: '_FiscalYear'      
  key FiscalYear,
  key AccountingDocumentItem,
  @ObjectModel.foreignKey.association: '_Supplier'  
  key Supplier,
  @ObjectModel.foreignKey.association: '_SupplierAccountGroup'
  _Supplier.SupplierAccountGroup,
  @ObjectModel.foreignKey.association: '_AccountingDocumentType'  
  AccountingDocumentType,
  @ObjectModel.foreignKey.association: '_PostingKey'  
  PostingKey,
  ClearingAccountingDocument,
  ClearingDocFiscalYear,
  ClearingItem,
  LineItemID,
  @ObjectModel.foreignKey.association: '_GLAccount'  
  GLAccount,
  @ObjectModel.foreignKey.association: '_ControllingArea'  
  ControllingArea,
  @ObjectModel.foreignKey.association: '_CostCenter'  
  CostCenter,
  PurchasingDocument,
  PurchasingDocumentItem,  
  WBSElement,
  OrderID,
  PurchasingDocumentCreationDate,
  @ObjectModel.foreignKey.association: '_PurchasingDocumentCategory'  
  PurchasingDocumentCategory,
  @ObjectModel.foreignKey.association: '_PurchasingDocumentType'  
  PurchasingDocumentType,
  @ObjectModel.foreignKey.association: '_PurchasingOrganization'  
  PurchasingOrganization, 
  PurchasingDocumentItemText,
  @ObjectModel.foreignKey.association: '_Plant'  
  Plant,
  @ObjectModel.foreignKey.association: '_Material'  
  Material,  
  @ObjectModel.foreignKey.association: '_MaterialGroup'  
  MaterialGroup,
  PurchaseRequisition, 
  PurchaseRequisitionItem,
  PurReqCreationDate,
  PurReqCreatedByUser,
  RequisitionerName,
  @ObjectModel.foreignKey.association: '_PurchaseRequisitionCategory'
  PurchaseRequisitionCategory,
  @ObjectModel.foreignKey.association: '_PurchaseRequisitionType'
  PurchaseRequisitionType,
  @ObjectModel.foreignKey.association: '_PaymentTerms'
  PaymentTerms,
  PostingDate,
  @EndUserText.label: 'Posting Month'     
  PostingMonth,
  ReferenceDocument,
  ExchangeRate,
  @ObjectModel.foreignKey.association: '_ReferenceDocumentType'  
  ReferenceDocumentType,
  @ObjectModel.foreignKey.association: '_PurchaseProcess'  
  PurchaseProcess,
  @ObjectModel.foreignKey.association: '_PurchaseType'  
  PurchaseType,
  @ObjectModel.foreignKey.association: '_PurchaseProcessDocumentType'  
  PurchaseProcessDocumentType,
  DocumentDate,
  EnteredOn,
  @ObjectModel.foreignKey.association: '_Country'  
  Country,
  @ObjectModel.foreignKey.association: '_CompanyCodeCurrency'
  @Semantics.currencyCode: true  
  CompanyCodeCurrency,
  @ObjectModel.foreignKey.association: '_TransactionCurrency'  
  @Semantics.currencyCode: true  
  TransactionCurrency,
  @Semantics.currencyCode: true
  @ObjectModel.foreignKey.association: '_GroupCurrency'  
  GroupCurrency,  
  @DefaultAggregation: #SUM       
  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'  
  AmountInCompanyCodeCurrency,
  @DefaultAggregation: #SUM  
  @Semantics.amount.currencyCode: 'TransactionCurrency'  
  AmountInTransactionCurrency,
  @DefaultAggregation: #SUM
  @Semantics.amount.currencyCode: 'GroupCurrency'  
  AmountInGroupCurrency,
  _CompanyCode,
  _JournalEntry,      
  _FiscalYear,         
  _Supplier,
  _SupplierAccountGroup,
  _AccountingDocumentType,
  _PostingKey,
  _GLAccount,
  _ControllingArea,
  _CostCenter,
  _PurchasingDocumentCategory,
  _PurchasingDocumentType,  
  _PurchasingOrganization,
  _Plant,
  _Material,  
  _MaterialGroup,
  _PurchaseRequisitionCategory,
  _PurchaseRequisitionType,
  _PaymentTerms,
  _ReferenceDocumentType,
  _PurchaseProcess,
  _PurchaseType,
  _PurchaseProcessDocumentType,
  _Country,
  _CompanyCodeCurrency,
  _TransactionCurrency,
  _GroupCurrency    
}
