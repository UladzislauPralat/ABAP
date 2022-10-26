@VDM.viewType: #BASIC
@VDM.private: true
@AbapCatalog.sqlViewName: 'ZISPENDEXCJE2'
define view ZI_SpendExceptionJournalEntry2
  as select distinct from ZI_ReceivablesPayablesItem as I_ReceivablesPayablesItem
{
  I_ReceivablesPayablesItem.CompanyCode,
  I_ReceivablesPayablesItem.AccountingDocument,
  I_ReceivablesPayablesItem.FiscalYear
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
