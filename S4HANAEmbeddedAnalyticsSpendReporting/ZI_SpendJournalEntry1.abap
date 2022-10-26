@VDM.viewType: #BASIC
@VDM.private: true
@AbapCatalog.sqlViewName: 'ZISPENDJE1'
define view ZI_SpendJournalEntry1
  as select from ZI_ReceivablesPayablesItem as I_ReceivablesPayablesItem inner join ZI_SpendJournalEntry2 as SpendJournalEntry 
                                                                                 on I_ReceivablesPayablesItem.CompanyCode = SpendJournalEntry.CompanyCode
                                                                                and I_ReceivablesPayablesItem.AccountingDocument = SpendJournalEntry.AccountingDocument
                                                                                and I_ReceivablesPayablesItem.FiscalYear = SpendJournalEntry.FiscalYear   
{
  I_ReceivablesPayablesItem.CompanyCode,
  I_ReceivablesPayablesItem.AccountingDocument,
  I_ReceivablesPayablesItem.FiscalYear
}
where I_ReceivablesPayablesItem.FinancialAccountType = 'K'
group by I_ReceivablesPayablesItem.CompanyCode,
         I_ReceivablesPayablesItem.AccountingDocument,
         I_ReceivablesPayablesItem.FiscalYear
having count( * ) = 1      
