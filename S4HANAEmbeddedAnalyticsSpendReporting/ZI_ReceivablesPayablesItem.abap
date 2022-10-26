@AbapCatalog.sqlViewName: 'ZIFIRECPAYITEM'
@VDM.viewType: #BASIC
@EndUserText.label: 'Receivables Payables Item'
define view ZI_ReceivablesPayablesItem 
  as select from bseg
{  
  key bukrs                                 as CompanyCode,
  key cast( belnr as farp_belnr_d )         as AccountingDocument,
  key gjahr                                 as FiscalYear,
  key cast( buzei as farp_buzei   )         as AccountingDocumentItem,
      cast( augdt as farp_augdt )           as ClearingDate,
      cast( augcp as fis_augcp  )           as ClearingCreationDate,
      cast( augbl as farp_augbl )           as ClearingAccountingDocument,
      cast( bschl as farp_bschl )           as PostingKey,
      buzid                                 as LineItemID,
      cast( koart as farp_koart )           as FinancialAccountType,
      cast( umskz as fac_umskz )            as SpecialGLCode,
      cast( umsks as farp_umsks )           as SpecialGLTransactionType,
      zumsk                                 as TargetSpecialGLCode,
      cast( shkzg as fis_shkzg )            as DebitCreditCode,
      cast( gsber as fis_rbusa )            as BusinessArea,
      cast( pargb as fis_pargb )            as PartnerBusinessArea,
      cast( mwskz as farp_mwskz )           as TaxCode,
      cast( qsskz as fac_qsskz )            as WithholdingTaxCode,
      cast( case shkzg  when 'H' then cast(-dmbtr as abap.curr( 23,2))
                        when 'S' then cast( dmbtr as abap.curr( 23,2))
                        else cast( dmbtr as abap.curr( 23,2))
            end as fis_hsl )                as AmountInCompanyCodeCurrency,
      cast( case shkzg when 'H' then cast(-wrbtr as abap.curr( 23,2))
                       when 'S' then cast( wrbtr as abap.curr( 23,2))
                       else cast( wrbtr as abap.curr( 23,2))
            end as fis_wsl )                as AmountInTransactionCurrency,
      cast( case shkzg when 'H' then cast(-pswbt as abap.curr( 23,2))
                       when 'S' then cast( pswbt as abap.curr( 23,2))
                       else cast( pswbt as abap.curr( 23,2))
            end as fis_tsl )                as AmountInBalanceTransacCrcy,
      cast( pswsl as farp_pswsl )           as BalanceTransactionCurrency,
      cast( case shkzg when 'H' then cast(-mwsts as abap.curr( 23,2))
                       when 'S' then cast( mwsts as abap.curr( 23,2))
                       else cast( mwsts as abap.curr( 23,2))
            end as fis_mwsts )              as TaxAmountInCoCodeCrcy,
      cast( case shkzg when 'H' then cast(-wmwst as abap.curr( 23,2))
                       when 'S' then  cast( wmwst as abap.curr( 23,2))
                       else cast( wmwst as abap.curr( 23,2))
            end as wmwst_shl )              as TaxAmount,
      cast( case shkzg when 'H' then cast(-fwbas as abap.curr( 23,2))
                       when 'S' then cast( fwbas as abap.curr( 23,2))
                       else cast( fwbas as abap.curr( 23,2))
            end as fwbas_shl )              as TaxBaseAmountInTransCrcy,
      cast( case shkzg when 'H' then cast(-hwbas as abap.curr( 23,2))
                       when 'S' then cast( hwbas as abap.curr( 23,2))
                       else cast( hwbas as abap.curr( 23,2))
            end as hwbas_shl )              as TaxBaseAmountInCoCodeCrcy,
      mwart                                 as TaxType,
      txgrp                                 as TaxItemGroup,
      ktosl                                 as TransactionTypeDetermination,
      cast( case shkzg when 'H' then cast(-qsshb as abap.curr( 23,2))
                       when 'S' then cast( qsshb as abap.curr( 23,2))
                       else cast( qsshb as abap.curr( 23,2))
            end as fis_qsshb )              as WithholdingTaxBaseAmount,
      cast( case shkzg when 'H' then cast(-bdiff as abap.curr( 23,2))
                       when 'S' then cast( bdiff as abap.curr( 23,2))
                       else cast( bdiff as abap.curr( 23,2))
            end as fis_bdiff )              as ValuationDiffAmtInCoCodeCrcy,
      cast( case shkzg when 'H' then cast(-bdif2 as abap.curr( 23,2))
                       when 'S' then cast( bdif2 as abap.curr( 23,2))
                      else cast( bdif2 as abap.curr( 23,2))
            end as fis_bdif2 )              as ValuationDiffAmtInAddlCrcy1,
      valut                                 as ValueDate,
      cast( zuonr as fis_zuonr )            as AssignmentReference,
      cast( sgtxt as farp_sgtxt )           as DocumentItemText,
      vbund                                 as PartnerCompany,
      cast( bewar as fis_rmvct )            as FinancialTransactionType,
      altkt                                 as CorporateGroupAccount,
      fdlev                                 as PlanningLevel,
      cast( case shkzg when 'H' then cast(-fdwbt as abap.curr( 23,2))
                       when 'S' then cast( fdwbt as abap.curr( 23,2))
                       else cast( fdwbt as abap.curr( 23,2))
            end as fis_fdwbt )              as PlannedAmtInTransactionCrcy,
      kokrs                                 as ControllingArea,
      kostl                                 as CostCenter,
      projn                                 as WBSElementInternalID,
      aufnr                                 as OrderID,
      vbeln                                 as BillingDocument,
      vbel2                                 as SalesDocument,
      posn2                                 as SalesDocumentItem,
      eten2                                 as ScheduleLine,
      cast( anln1 as fis_anln1 )            as MasterFixedAsset,
      cast( anln2 as fis_anln2 )            as FixedAsset,
      cast( anbwa as fac_anbwa )            as AssetTransactionType,
      pernr                                 as Employee,
      cast( xumsw as farp_xumsw )           as IsSalesRelated,
      xkres                                 as LineItemDisplayIsEnabled,
      xopvw                                 as IsOpenItemManaged,
      xcpdd                                 as AddressAndBankIsSetManually,
      xauto                                 as IsAutomaticallyCreated,
      xzahl                                 as IsUsedInPaymentTransaction,
      cast( hkont as fis_racct  )           as GLAccount,
      cast( kunnr as fis_kunnr  )           as Debtor,
      cast( lifnr as fis_lifnr  )           as Creditor,
      cast( filkd as farp_filkd )           as Branch,
      xbilk                                 as IsBalanceSheetAccount,
      gvtyp                                 as ProfitLossAccountType,
      cast( hzuon as fins_hzuon )           as SpecialGLAccountAssignment,
      zfbdt                                 as DueCalculationBaseDate,
      cast( zterm as farp_dzterm )          as PaymentTerms,
      cast( zbd1t as farp_dzbd1t )          as CashDiscount1Days,
      cast( zbd2t as farp_dzbd2t )          as CashDiscount2Days,
      cast( zbd3t as farp_dzbd3t )          as NetPaymentDays,
      zbd1p                                 as CashDiscount1Percent,
      zbd2p                                 as CashDiscount2Percent,
      cast( case shkzg when 'H' then cast(-skfbt as abap.curr( 23,2))
                       when 'S' then cast( skfbt as abap.curr( 23,2))
                       else cast( skfbt as abap.curr( 23,2))
            end as fis_skfbt )              as CashDiscountBaseAmount,
      cast( case shkzg when 'H' then cast(-sknto as abap.curr( 23,2))
                       when 'S' then cast( sknto as abap.curr( 23,2))
                       else cast( sknto as abap.curr( 23,2))
            end as fis_sknto )              as CashDiscountAmtInCoCodeCrcy,
      cast( case shkzg when 'H' then cast(-wskto as abap.curr( 23,2))
                       when 'S' then cast( wskto as abap.curr( 23,2))
                       else cast( wskto as abap.curr( 23,2))
            end as fis_wskto )              as CashDiscountAmount,
      cast( zlsch as farp_schzw_bseg )      as PaymentMethod,
      cast( zlspr as farp_dzlspr )          as PaymentBlockingReason,
      cast( zbfix as farp_dzbfix )          as FixedCashDiscount,
      hbkid                                 as HouseBank,
      mwsk1                                 as TaxDistributionCode1,
      mwsk2                                 as TaxDistributionCode2,
      mwsk3                                 as TaxDistributionCode3,
      cast( rebzg as farp_rebzg )           as InvoiceReference,
      cast( rebzj as fins_rebzj )           as InvoiceReferenceFiscalYear,
      cast( rebzz as fins_rebzz )           as InvoiceItemReference,
      cast( rebzt as farp_rebzt )           as FollowOnDocumentType,
      landl                                 as SupplyingCountry,
      cast( samnr as farp_samnr )           as InvoiceList,
      abper                                 as SettlementFiscalYearPeriod,
      cast( wverw as farp_wverw )           as BillOfExchangeUsage,
      cast( mschl as farp_mschl )           as DunningKey,
      cast( mansp as farp_mansp  )          as DunningBlockingReason, 
      cast( madat as farp_madat )           as LastDunningDate, 
      cast( manst as farp_mahns_d )         as DunningLevel,
      cast( maber as farp_maber )           as DunningArea,
      cast( case shkzg when 'H' then cast(-qbshb as abap.curr( 23,2))
                       when 'S' then cast( qbshb as abap.curr( 23,2))
                       else cast( qbshb as abap.curr( 23,2))
            end as fis_qbshb )              as WithholdingTaxAmount,
      cast( case shkzg when 'H' then cast(-qsfbt as abap.curr( 23,2))
                       when 'S' then cast( qsfbt as abap.curr( 23,2))
                       else cast( qsfbt as abap.curr( 23,2))
            end as fis_qsfbt )              as WithholdingTaxExemptionAmt,
      matnr                                 as Material,
      werks                                 as Plant,
      menge                                 as Quantity,
      meins                                 as BaseUnit,
      erfmg                                 as QuantityInEntryUnit,
      erfme                                 as EntryUnit,
      bpmng                                 as PurchaseOrderQty,
      bprme                                 as PurchaseOrderPriceUnit,
      cast( ebeln as farp_ebeln )           as PurchasingDocument,
      cast( ebelp as farp_ebelp )           as PurchasingDocumentItem,
      zekkn                                 as AccountAssignmentNumber,
      elikz                                 as IsCompletelyDelivered,
      vprsv                                 as MaterialPriceControl,
      peinh                                 as MaterialPriceUnitQty,
      bwkey                                 as ValuationArea,
      bwtar                                 as InventoryValuationType,
      cast( case shkzg when 'H' then cast(-rewrt as abap.curr( 23,2))
                       when 'S' then cast( rewrt as abap.curr( 23,2))
                       else cast( rewrt as abap.curr( 23,2))
            end as fis_reewr )              as InvoiceAmtInCoCodeCrcy,
      cast( case shkzg when 'H' then cast(-rewwr as abap.curr( 23,2))
                       when 'S' then cast( rewwr as abap.curr( 23,2))
                       else cast( rewwr as abap.curr( 23,2))
            end as fis_refwr )              as InvoiceAmountInFrgnCurrency,
      cast( stceg as farp_stceg )           as VATRegistration,
      egbld                                 as DelivOfGoodsDestCountry,
      eglld                                 as DelivOfGoodsOriginCountry,
      cast( rstgr as farp_rstgr )           as PaymentDifferenceReason,
      prctr                                 as ProfitCenter,
      vname                                 as JointVenture,
      recid                                 as JointVentureCostRecoveryCode,
      egrup                                 as JointVentureEquityGroup,
      vertt                                 as TreasuryContractType,
      vertn                                 as AssetContract,
      cast( vbewa as farp_sbewart  )        as CashFlowType,
      cast( txjcd as farp_txjcd )           as TaxJurisdiction,
      cast( imkey as farp_imkey )           as RealEstateObject,
      dabrz                                 as SettlementReferenceDate,
      fipos                                 as CommitmentItem,
      kstrg                                 as CostObject,
      nplnr                                 as ProjectNetwork,
      projk                                 as WBSElement,
      paobjnr                               as ProfitabilitySegment,
      etype                                 as JointVentureEquityType,
      xegdr                                 as IsEUTriangularDeal,
      hrkft                                 as CostOriginGroup,
      cast( case shkzg when 'H' then cast(-dmbe2 as abap.curr( 23,2))
                       when 'S' then cast( dmbe2 as abap.curr( 23,2))
                       else cast( dmbe2 as abap.curr( 23,2))
            end  as dmbe2_farp  )           as AmountInAdditionalCurrency1,
      cast( case shkzg when 'H' then cast(-dmbe3 as abap.curr( 23,2))
                       when 'S' then cast( dmbe3 as abap.curr( 23,2))
                       else cast( dmbe3 as abap.curr( 23,2))
            end   as dmbe3_farp )           as AmountInAdditionalCurrency2,
      cast( case shkzg when 'H' then cast(-bdif3 as abap.curr( 23,2))
                       when 'S' then cast( bdif3 as abap.curr( 23,2))
                       else cast( bdif3 as abap.curr( 23,2))
            end as fis_bdif3 )              as ValuationDiffAmtInAddlCrcy2,
      cast( xragl as farp_xragl )           as ClearingIsReversed,
      cast( uzawe as farp_uzawe )           as PaymentMethodSupplement,
      cast( lokkt as fis_altkt_skb1 )       as AlternativeGLAccount,
      cast( fistl as farp_fistl )           as FundsCenter,
      geber                                 as Fund,
      pprct                                 as PartnerProfitCenter,
      cast( xref1 as farp_xref1 )           as Reference1IDByBusinessPartner,
      cast( xref2 as farp_xref2 )           as Reference2IDByBusinessPartner,
      cast( rfzei as farp_rfzei_cc )        as PaymentCardItem,
      cast( ccbtc as farp_ccbtc )           as PaymentCardPaymentSettlement,
      kkber                                 as CreditControlArea,
      xref3                                 as Reference3IDByBusinessPartner,
      cast( dtws1 as farp_dtat16 )          as DataExchangeInstruction1,
      cast( dtws2 as farp_dtat17 )          as DataExchangeInstruction2,
      cast( dtws3 as farp_dtat18 )          as DataExchangeInstruction3,
      cast( dtws4 as farp_dtat19 )          as DataExchangeInstruction4,
      grirg                                 as Region,
      cast( xpypr as farp_xpypr )           as HasPaymentOrder,
      cast( kidno as farp_kidno )           as PaymentReference,
      cast( case shkzg when 'H' then cast(-absbt as abap.curr( 23,2))
                       when 'S' then cast( absbt as abap.curr( 23,2))
                       else cast( absbt as abap.curr( 23,2))
            end as absbt_farp )             as HedgedAmount,
      txdat                                 as TaxDeterminationDate,
      agzei                                 as ClearingItem,
      cast( pycur as farp_pycur )           as PaymentCurrency,
      cast( case shkzg when 'H' then cast(-pyamt as abap.curr( 23,2))
                       when 'S' then cast( pyamt as abap.curr( 23,2))
                       else cast( pyamt as abap.curr( 23,2))
            end as fis_pyamt )              as AmountInPaymentCurrency,
      cast( bupla as farp_bupla )           as BusinessPlace,
      secco                                 as TaxSection,
      lstar                                 as CostCtrActivityType,
      cast( cession_kz as farp_cession_kz ) as AccountsReceivableIsPledged,
      prznr                                 as BusinessProcess,
      grant_nbr                             as GrantID,
      fkber_long                            as FunctionalArea,
      gmvkz                                 as CustomerIsInExecution,
      auggj                                 as ClearingDocFiscalYear,
      segment                               as Segment,
      psegment                              as PartnerSegment,
      pfkber                                as PartnerFunctionalArea,
      hktid                                 as HouseBankAccount,
      kstar                                 as CostElement,
      cast( awtyp as fis_awtyp )            as ReferenceDocumentType,
      awkey                                 as OriginalReferenceDocument,
      awsys                                 as ReferenceDocumentLogicalSystem,
      h_monat                               as FiscalPeriod,
      cast( h_bstat as farp_bstat_d )       as AccountingDocumentCategory,
      h_budat                               as PostingDate,
      h_bldat                               as DocumentDate,
      h_waers                               as TransactionCurrency,
      cast( h_blart as farp_blart)          as AccountingDocumentType,
      cast( h_hwaer as fis_hwaer )          as CompanyCodeCurrency,
      cast( h_hwae2 as fis_hwae2 )          as AdditionalCurrency1,
      cast( h_hwae3 as fis_hwae3 )          as AdditionalCurrency2,
      cast( netdt as farp_netdt )           as NetDueDate,
      cast( sk1dt as farp_sk1dt )           as CashDiscount1DueDate,
      sk2dt                                 as CashDiscount2DueDate,
      gkont                                 as OffsettingAccount,
      gkart                                 as OffsettingAccountType,
      pgeber                                as PartnerFund,
      pgrant_nbr                            as PartnerGrant,
      budget_pd                             as BudgetPeriod,
      pbudget_pd                            as PartnerBudgetPeriod,
      bvtyp                                 as BPBankAccountInternalID 
}
