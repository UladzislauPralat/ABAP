@AbapCatalog.sqlViewName: 'ZFLIGHT_QUERY5'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck:#CHECK
@VDM.viewType: #CONSUMPTION
@Analytics.query: true 
@EndUserText.label: 'Flight Query'
define view zsapbc_flight_query5 with parameters
  @EndUserText.label: 'Display Currency'     
  @Consumption.defaultValue: 'CAD'
  p_display_currency : s_currcode    
  as select from zsapbc_flight_cube5( p_display_currency:  $parameters.p_display_currency ) {
  @AnalyticsDetails.query.axis: #ROWS
  @AnalyticsDetails.query.displayHierarchy: #ON
  @Consumption.filter: { selectionType: #HIERARCHY_NODE, multipleSelections: true, mandatory: false }   
  @AnalyticsDetails.query.hierarchyInitialLevel: 3
  @AnalyticsDetails.query.variableSequence: 1    
  region,
  @AnalyticsDetails.query.axis: #FREE    
  connid,          
  @AnalyticsDetails.query.axis: #FREE
  @Consumption.filter: {selectionType: #RANGE, multipleSelections: true, mandatory: false }
  @AnalyticsDetails.query.variableSequence: 2      
  carrid,
  @AnalyticsDetails.query.axis: #FREE
  fldate,
  @AnalyticsDetails.query.axis: #FREE
  flmonth,
  @AnalyticsDetails.query.axis: #FREE
  @Consumption.filter: {selectionType: #RANGE, multipleSelections: true, mandatory: false }
  @AnalyticsDetails.query.variableSequence: 3    
  flyear,
  @AnalyticsDetails.query.axis: #FREE
  currency,
  @AnalyticsDetails.query.axis: #FREE
  disp_curr,
  @AnalyticsDetails.query.axis: #FREE
  unit,    
  @AnalyticsDetails.query.axis: #COLUMNS
  seatsocc_total,    
  @AnalyticsDetails.query.axis: #COLUMNS
  seatsmax_total,
  @AnalyticsDetails.query.axis: #COLUMNS
  @AnalyticsDetails.query.decimals: 1
  @EndUserText.label: 'Seats Occ (%)'
  @AnalyticsDetails.query.formula: 'NDIV0( NODIM( seatsocc_total ) /
                                           NODIM( seatsmax_total ) ) * hundred '
  1 as seats_occ_prc,
  @EndUserText.label: 'Low Occupied Flight Count'
  @AnalyticsDetails: {
    exceptionAggregationSteps: [{
      exceptionAggregationBehavior: #SUM,
      exceptionAggregationElements: ['carrid', 'connid','fldate' ] }]
  }  
  @AnalyticsDetails.query.axis: #COLUMNS  
  @AnalyticsDetails.query.formula: 'case when $projection.seats_occ_prc < 96 then 1 else 0 end'
  0 as flight_cnt_low_occ,
  
  @EndUserText.label: 'High Occupied Flight Count'    
  @AnalyticsDetails: {
    exceptionAggregationSteps: [{
      exceptionAggregationBehavior: #SUM,
      exceptionAggregationElements: ['carrid', 'connid','fldate' ] }]
  }  
  @AnalyticsDetails.query.axis: #COLUMNS  
  @AnalyticsDetails.query.formula: 'case when $projection.seats_occ_prc >= 96 then 1 else 0 end'
  0 as flight_cnt_high_occ,
  @EndUserText.label: 'Flight Count'    
  @AnalyticsDetails: {
    exceptionAggregationSteps: [{
      exceptionAggregationBehavior: #COUNT,
      exceptionAggregationElements: ['carrid', 'connid','fldate' ] }]
  }  
  0 as flight_cnt,
  @AnalyticsDetails.query.hidden: true      
  @AnalyticsDetails.query.axis: #COLUMNS
  payment,    
  @AnalyticsDetails.query.hidden: true  
  @AnalyticsDetails.query.axis: #COLUMNS
  payment_disp_curr        
}
