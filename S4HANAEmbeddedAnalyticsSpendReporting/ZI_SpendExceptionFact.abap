@AbapCatalog.sqlViewName: 'ZISPENDEXCF'
@AccessControl.authorizationCheck: #CHECK
@VDM.viewType: #BASIC
@Analytics.dataCategory: #FACT
@EndUserText.label: 'Spend Exception'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_SpendExceptionFact 
as select from ZI_ReceivablesPayablesItem as I_ReceivablesPayablesItem inner join ZI_SpendExceptionJournalEntry1 as SpendException
                                                                               on I_ReceivablesPayablesItem.CompanyCode        = SpendException.CompanyCode
                                                                              and I_ReceivablesPayablesItem.AccountingDocument = SpendException.AccountingDocument
                                                                              and I_ReceivablesPayablesItem.FiscalYear         = SpendException.FiscalYear
                                                                  left outer join I_CalendarDate
                                                                               on I_ReceivablesPayablesItem.PostingDate = I_CalendarDate.CalendarDate               
{
  key I_ReceivablesPayablesItem.CompanyCode,
  key I_ReceivablesPayablesItem.AccountingDocument,
  key I_ReceivablesPayablesItem.FiscalYear,
  key I_ReceivablesPayablesItem.AccountingDocumentItem,
  key I_ReceivablesPayablesItem.Creditor as Supplier,
  I_ReceivablesPayablesItem.AccountingDocumentType,
  I_ReceivablesPayablesItem.PostingKey,
  I_ReceivablesPayablesItem.LineItemID,
  I_ReceivablesPayablesItem.ClearingAccountingDocument,
  I_ReceivablesPayablesItem.ClearingDocFiscalYear,
  I_ReceivablesPayablesItem.ClearingItem,
  I_ReceivablesPayablesItem.GLAccount,   
  I_ReceivablesPayablesItem.ControllingArea,
  I_ReceivablesPayablesItem.CostCenter,  
  I_ReceivablesPayablesItem.Reference3IDByBusinessPartner,
  I_ReceivablesPayablesItem.PaymentTerms,
  I_ReceivablesPayablesItem.PostingDate,
  @Semantics.calendar.yearMonth: true
  I_CalendarDate.YearMonth as PostingMonth,
  I_ReceivablesPayablesItem.CompanyCodeCurrency,
  I_ReceivablesPayablesItem.TransactionCurrency,
  @EndUserText.label: 'Group Currency'    
  I_ReceivablesPayablesItem.AdditionalCurrency1 as GroupCurrency,
  I_ReceivablesPayablesItem.AmountInCompanyCodeCurrency,
  I_ReceivablesPayablesItem.AmountInTransactionCurrency,
  @EndUserText.label: 'Amount in Group Currency'  
  I_ReceivablesPayablesItem.AmountInAdditionalCurrency1 as AmountInGroupCurrency
}
where I_ReceivablesPayablesItem.AccountingDocumentCategory = ''
  and I_ReceivablesPayablesItem.FinancialAccountType = 'K'
  and ( I_ReceivablesPayablesItem.PostingKey = '21' or
        I_ReceivablesPayablesItem.PostingKey = '22' or
        I_ReceivablesPayablesItem.PostingKey = '24' or
        I_ReceivablesPayablesItem.PostingKey = '31' or
        I_ReceivablesPayablesItem.PostingKey = '32' or
        I_ReceivablesPayablesItem.PostingKey = '34' )
  and I_ReceivablesPayablesItem.SpecialGLCode = '' 
