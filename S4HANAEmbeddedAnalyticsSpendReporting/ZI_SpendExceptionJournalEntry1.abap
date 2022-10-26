@VDM.viewType: #BASIC
@VDM.private: true
@AbapCatalog.sqlViewName: 'ZISPENDEXCJE1'
define view ZI_SpendExceptionJournalEntry1
  as select from ZI_SpendExceptionJournalEntry2 as SpendException left outer join ZI_SpendJournalEntry1 as Spend 
                                                                               on SpendException.CompanyCode = Spend.CompanyCode
                                                                              and SpendException.AccountingDocument = Spend.AccountingDocument
                                                                              and SpendException.FiscalYear = Spend.FiscalYear      
{
  SpendException.CompanyCode,
  SpendException.AccountingDocument,
  SpendException.FiscalYear
}
where Spend.CompanyCode is null
  and Spend.AccountingDocument is null
  and Spend.FiscalYear is null
