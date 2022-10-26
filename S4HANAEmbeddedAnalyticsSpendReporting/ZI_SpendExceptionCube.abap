@AbapCatalog.sqlViewName: 'ZSPENDEXCC'
@AccessControl.authorizationCheck: #CHECK
@VDM.viewType: #COMPOSITE
@Analytics.dataCategory: #CUBE
@EndUserText.label: 'Spend'
define view ZI_SpendExceptionCube 
  as select from ZI_SpendExceptionFact  
    association [0..1] to I_CompanyCode                  as _CompanyCode                 on $projection.CompanyCode = _CompanyCode.CompanyCode
    association [1..1] to I_JournalEntry                 as _JournalEntry                on $projection.CompanyCode        = _JournalEntry.CompanyCode                             
                                                                                        and $projection.FiscalYear         = _JournalEntry.FiscalYear                              
                                                                                        and $projection.AccountingDocument = _JournalEntry.AccountingDocument                      
    association [0..1] to I_FiscalYearForCompanyCode     as _FiscalYear                  on $projection.FiscalYear               = _FiscalYear.FiscalYear                          
                                                                                        and $projection.CompanyCode              = _FiscalYear.CompanyCode                             
    association [0..1] to I_Supplier                     as _Supplier                    on $projection.Supplier = _Supplier.Supplier
    association [0..1] to I_AccountingDocumentType       as _AccountingDocumentType      on $projection.AccountingDocumentType = _AccountingDocumentType.AccountingDocumentType    
    association [0..1] to I_PostingKey                   as _PostingKey                  on $projection.PostingKey = _PostingKey.PostingKey       
    association [0..1] to I_GLAccount                    as _GLAccount                   on $projection.GLAccount   = _GLAccount.GLAccount
                                                                                        and $projection.CompanyCode = _GLAccount.CompanyCode 
    association [0..1] to I_ControllingArea              as _ControllingArea             on $projection.ControllingArea = _ControllingArea.ControllingArea
    association [0..*] to I_CostCenter                   as _CostCenter                  on $projection.CostCenter      = _CostCenter.CostCenter
                                                                                        and $projection.ControllingArea = _CostCenter.ControllingArea
    association [0..1] to I_PaymentTerms                 as _PaymentTerms                on $projection.PaymentTerms = _PaymentTerms.PaymentTerms                                                                                        
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
  @ObjectModel.foreignKey.association: '_PaymentTerms'
  PaymentTerms,
  PostingDate,
  @EndUserText.label: 'Posting Month'       
  PostingMonth,
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
  _AccountingDocumentType,
  _PostingKey,
  _GLAccount,
  _ControllingArea,
  _CostCenter,
  _PaymentTerms,
  _CompanyCodeCurrency,
  _TransactionCurrency,
  _GroupCurrency    
}
