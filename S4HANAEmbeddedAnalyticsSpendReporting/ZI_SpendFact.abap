@AbapCatalog.sqlViewName: 'ZISPENDF'
@AccessControl.authorizationCheck: #CHECK
@VDM.viewType: #BASIC
@Analytics.dataCategory: #FACT
@EndUserText.label: 'Spend'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_SpendFact 
as select from ZI_ReceivablesPayablesItem as I_ReceivablesPayablesItem_2 inner join ZI_SpendJournalEntry1 as Spend
                                                                                 on I_ReceivablesPayablesItem_2.CompanyCode        = Spend.CompanyCode
                                                                                and I_ReceivablesPayablesItem_2.AccountingDocument = Spend.AccountingDocument
                                                                                and I_ReceivablesPayablesItem_2.FiscalYear         = Spend.FiscalYear
                                                                         inner join ZI_ReceivablesPayablesItem as I_ReceivablesPayablesItem_1
                                                                                 on I_ReceivablesPayablesItem_2.CompanyCode        = I_ReceivablesPayablesItem_1.CompanyCode
                                                                                and I_ReceivablesPayablesItem_2.AccountingDocument = I_ReceivablesPayablesItem_1.AccountingDocument
                                                                                and I_ReceivablesPayablesItem_2.FiscalYear         = I_ReceivablesPayablesItem_1.FiscalYear                                                                                                 
                                                                         inner join bkpf
                                                                                 on I_ReceivablesPayablesItem_1.CompanyCode = bkpf.bukrs
                                                                                and I_ReceivablesPayablesItem_1.AccountingDocument = bkpf.belnr
                                                                                and I_ReceivablesPayablesItem_1.FiscalYear = bkpf.gjahr
                                                                    left outer join I_PurchasingDocument
                                                                                 on I_ReceivablesPayablesItem_1.PurchasingDocument = I_PurchasingDocument.PurchasingDocument
                                                                    left outer join I_PurchasingDocumentItem
                                                                                 on I_ReceivablesPayablesItem_1.PurchasingDocument     = I_PurchasingDocumentItem.PurchasingDocument
                                                                                and I_ReceivablesPayablesItem_1.PurchasingDocumentItem = I_PurchasingDocumentItem.PurchasingDocumentItem
                                                                    left outer join I_Purchaserequisitionitem
                                                                                 on I_PurchasingDocumentItem.PurchaseRequisition     = I_Purchaserequisitionitem.PurchaseRequisition
                                                                                and I_PurchasingDocumentItem.PurchaseRequisitionItem = I_Purchaserequisitionitem.PurchaseRequisitionItem                                                                                                                                                                                                            
                                                                    left outer join ZI_Reference3IDByBusPartner
                                                                                 on I_ReceivablesPayablesItem_1.Reference3IDByBusinessPartner = ZI_Reference3IDByBusPartner.Reference3IDByBusinessPartner       
                                                                    left outer join I_CalendarDate
                                                                                 on I_ReceivablesPayablesItem_1.PostingDate = I_CalendarDate.CalendarDate
                                                                    left outer join mara
                                                                                 on I_PurchasingDocumentItem.Material = mara.matnr
                                                                    left outer join marc
                                                                                 on I_PurchasingDocumentItem.Material = marc.matnr
                                                                                and I_PurchasingDocumentItem.Plant   = marc.werks
{
  key I_ReceivablesPayablesItem_1.CompanyCode,
  key I_ReceivablesPayablesItem_1.AccountingDocument,
  key I_ReceivablesPayablesItem_1.FiscalYear,
  key I_ReceivablesPayablesItem_1.AccountingDocumentItem,
  key I_ReceivablesPayablesItem_2.Creditor as Supplier,
  I_ReceivablesPayablesItem_1.AccountingDocumentType,
  I_ReceivablesPayablesItem_2.PostingKey,
  I_ReceivablesPayablesItem_1.LineItemID,
  I_ReceivablesPayablesItem_1.ClearingAccountingDocument,
  I_ReceivablesPayablesItem_1.ClearingDocFiscalYear,
  I_ReceivablesPayablesItem_1.ClearingItem,
  cast(coalesce(ZI_Reference3IDByBusPartner.GLAccount,I_ReceivablesPayablesItem_1.GLAccount) as fis_racct ) as GLAccount,   
  I_ReceivablesPayablesItem_1.ControllingArea,
  cast(coalesce(ZI_Reference3IDByBusPartner.CostCenter, I_ReceivablesPayablesItem_1.CostCenter) as fis_kostl ) as CostCenter,  
  I_ReceivablesPayablesItem_1.PurchasingDocument,
  I_ReceivablesPayablesItem_1.PurchasingDocumentItem,
  I_ReceivablesPayablesItem_1.WBSElement,
  I_ReceivablesPayablesItem_1.OrderID,
  @EndUserText.label: 'PO Created On'  
  I_PurchasingDocument.CreationDate as PurchasingDocumentCreationDate,
  I_PurchasingDocument.PurchasingDocumentCategory,
  I_PurchasingDocument.PurchasingDocumentType,
  I_PurchasingDocument.PurchasingOrganization, 
  cast( coalesce( I_PurchasingDocumentItem.PurchasingDocumentItemText,I_ReceivablesPayablesItem_1.DocumentItemText) as txz01 ) as PurchasingDocumentItemText, 
  I_PurchasingDocumentItem.Plant,
  I_PurchasingDocumentItem.Material,
  I_PurchasingDocumentItem.MaterialGroup,
  I_PurchasingDocumentItem.PurchaseRequisition, 
  I_PurchasingDocumentItem.PurchaseRequisitionItem,
  @EndUserText.label: 'Pur. Req. Created On'  
  I_Purchaserequisitionitem.CreationDate as PurReqCreationDate,
  @EndUserText.label: 'Pur. Req. Created By'  
  I_Purchaserequisitionitem.CreatedByUser as PurReqCreatedByUser,
  I_Purchaserequisitionitem.RequisitionerName,
  @EndUserText.label: 'Pur. Req. Category'  
  I_Purchaserequisitionitem.PurchasingDocumentCategory as PurchaseRequisitionCategory,  
  @EndUserText.label: 'Pur. Req. Type'  
  I_Purchaserequisitionitem.PurchaseRequisitionType,
  I_ReceivablesPayablesItem_1.Reference3IDByBusinessPartner,
  I_ReceivablesPayablesItem_2.PaymentTerms,
  I_ReceivablesPayablesItem_1.PostingDate,
  @Semantics.calendar.yearMonth: true
  I_CalendarDate.YearMonth as PostingMonth,
  bkpf.xblnr as ReferenceDocument,
  @EndUserText.label: 'Exchange Rate'  
  cast( bkpf.kursf as abap.char( 12 )) as ExchangeRate,
  I_ReceivablesPayablesItem_1.ReferenceDocumentType,
  @EndUserText.label: 'Pur. Process'  
  case when I_ReceivablesPayablesItem_1.PurchasingDocument <> ''
       then 'P'
       else 'N'       
  end as PurchaseProcess,    
  @EndUserText.label: 'Pur. Type'  
  case I_ReceivablesPayablesItem_1.Material
  when '' then 'I'
  else 'D'
  end as PurchaseType,
  @EndUserText.label: 'Pur. Proc. Doc. Type'  
  case when I_PurchasingDocumentItem.PurchasingDocument <> '' 
        and I_PurchasingDocumentItem.PurchaseRequisition <> ''
       then '1'
       when I_PurchasingDocumentItem.PurchasingDocument <> '' 
        and I_PurchasingDocumentItem.PurchaseRequisition = ''
       then '2'
       else '3'
  end as PurchaseProcessDocumentType,      
  bkpf.bldat as DocumentDate,
  bkpf.cpudt as EnteredOn,
  cast(marc.herkl as land1_gp preserving type ) as Country, 
  I_ReceivablesPayablesItem_1.CompanyCodeCurrency,
  I_ReceivablesPayablesItem_1.TransactionCurrency,
  @EndUserText.label: 'Group Currency'    
  I_ReceivablesPayablesItem_1.AdditionalCurrency1 as GroupCurrency,
  I_ReceivablesPayablesItem_1.AmountInCompanyCodeCurrency,
  I_ReceivablesPayablesItem_1.AmountInTransactionCurrency,
  @EndUserText.label: 'Amount in Group Currency'  
  I_ReceivablesPayablesItem_1.AmountInAdditionalCurrency1 as AmountInGroupCurrency
}
where I_ReceivablesPayablesItem_2.AccountingDocumentCategory = ''
  and I_ReceivablesPayablesItem_2.FinancialAccountType = 'K'
  and ( I_ReceivablesPayablesItem_2.PostingKey = '21' or
        I_ReceivablesPayablesItem_2.PostingKey = '22' or
        I_ReceivablesPayablesItem_2.PostingKey = '24' or
        I_ReceivablesPayablesItem_2.PostingKey = '31' or
        I_ReceivablesPayablesItem_2.PostingKey = '32' or
        I_ReceivablesPayablesItem_2.PostingKey = '34' )
  and I_ReceivablesPayablesItem_2.SpecialGLCode = ''
  and not ( I_ReceivablesPayablesItem_1.AccountingDocumentCategory = ''
        and I_ReceivablesPayablesItem_1.FinancialAccountType = 'K'
        and ( I_ReceivablesPayablesItem_1.PostingKey = '21' or
              I_ReceivablesPayablesItem_1.PostingKey = '22' or
              I_ReceivablesPayablesItem_1.PostingKey = '24' or
              I_ReceivablesPayablesItem_1.PostingKey = '31' or
              I_ReceivablesPayablesItem_1.PostingKey = '32' or
              I_ReceivablesPayablesItem_1.PostingKey = '34' )
        and I_ReceivablesPayablesItem_1.SpecialGLCode = '' )  
