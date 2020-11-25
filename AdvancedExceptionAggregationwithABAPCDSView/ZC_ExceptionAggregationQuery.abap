@AbapCatalog.sqlViewName: 'ZCEXCAGGRQ'
@EndUserText.label: 'Exception Aggregation'
@VDM.viewType: #CONSUMPTION
@Analytics.query: true
define view ZC_ExceptionAggregationQuery 
  as select from ZI_ExceptionAggregationCube
{
  @AnalyticsDetails.query.axis: #FREE
  SalesDocument,
  @AnalyticsDetails.query.axis: #FREE  
  SalesDocumentItem,
  @AnalyticsDetails.query.axis: #FREE  
  SalesOrganization,
  @AnalyticsDetails.query.axis: #FREE  
  DistributionChannel,
  @AnalyticsDetails.query.axis: #FREE  
  Division,
  @AnalyticsDetails.query.axis: #FREE  
  SoldToParty,
  @AnalyticsDetails.query.axis: #FREE  
  Material,
  @AnalyticsDetails.query.axis: #COLUMNS  
  @EndUserText.label: 'Sales Document Item Count'    
  @AnalyticsDetails: {
    exceptionAggregationSteps: [
        { exceptionAggregationBehavior: #COUNT  ,
          exceptionAggregationElements: ['SalesDocument','SalesDocumentItem']  }
    ]
  }
  @AnalyticsDetails.query.formula: '1' 0 as SalesDocumentItemCount,
  @AnalyticsDetails.query.axis: #COLUMNS
  @EndUserText.label: 'Sales Document Count'    
  @AnalyticsDetails: {
    exceptionAggregationSteps: [
        { exceptionAggregationBehavior: #COUNT,
          exceptionAggregationElements: ['SalesDocument']  }
    ]
  }
  @AnalyticsDetails.query.formula: '1' 0 as SalesDocumentCount,
  @AnalyticsDetails.query.axis: #COLUMNS
  @AnalyticsDetails.query.decimals: 0
  @EndUserText.label: 'Sales Document Avg by Sales Org'    
  @AnalyticsDetails: {
    exceptionAggregationSteps: [
        { exceptionAggregationBehavior: #COUNT,
          exceptionAggregationElements: ['SalesDocument']  },
        { exceptionAggregationBehavior: #AVG,
          exceptionAggregationElements: ['SalesOrganization']  }                    
    ]
  }
  @AnalyticsDetails.query.formula: '1' 0 as SalesDocumentAvgBySalesOrg  
}
