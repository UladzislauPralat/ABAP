@AbapCatalog.sqlViewName: 'ZFLIGHT_QUERY2'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck:#CHECK
@VDM.viewType: #CONSUMPTION
@Analytics.query: true 
@EndUserText.label: 'Flight Query'
define view zsapbc_flight_query2 with parameters
     @EndUserText.label: 'Display Currency'     
     @Consumption.defaultValue: 'CAD'
     p_display_currency : s_currcode,
     @EndUserText.label: 'Year 1'     
     @Consumption.derivation: {lookupEntity: 'ZSAPBC_CURR_YEAR_ADD_N', resultElement: 'p_year' ,
     binding: [{ targetParameter: 'p_offset', type: #CONSTANT, value: -1 }]}
     p_year_1: rscalyear,
     @EndUserText.label: 'Year 2'     
     @Consumption.derivation: {lookupEntity: 'ZSAPBC_CURR_YEAR_ADD_N', resultElement: 'p_year',
     binding: [{ targetParameter: 'p_offset', type:#CONSTANT , value: 0 }] }     
     p_year_2: rscalyear     
     as select from zsapbc_flight_cube( p_display_currency:  $parameters.p_display_currency, 
                                         p_year_1: $parameters.p_year_1,
                                         p_year_2: $parameters.p_year_2 ) {
    @AnalyticsDetails.query.axis: #ROWS
    @AnalyticsDetails.query.displayHierarchy: #ON
    @Consumption.filter: { selectionType: #HIERARCHY_NODE, multipleSelections: true, mandatory: false }   
    @AnalyticsDetails.query.hierarchyInitialLevel: 3
    region,
    @AnalyticsDetails.query.axis: #COLUMNS
    seatsocc_total_year_1,    
    @AnalyticsDetails.query.axis: #COLUMNS
    seatsmax_total_year_1,
    @AnalyticsDetails.query.axis: #COLUMNS
    @AnalyticsDetails.query.decimals: 1
    @EndUserText.label: 'Seats Occ (%) Year 1'
    @AnalyticsDetails.query.formula: 'NDIV0( NODIM( seatsocc_total_year_1 ) /
                                        NODIM( seatsmax_total_year_1 ) ) * hundred '
    1 as seats_occ_prc_year_1,    
    @AnalyticsDetails.query.axis: #COLUMNS
    seatsocc_total_year_2,    
    @AnalyticsDetails.query.axis: #COLUMNS
    seatsmax_total_year_2,        
    @AnalyticsDetails.query.axis: #COLUMNS
    @AnalyticsDetails.query.decimals: 1
    @EndUserText.label: 'Seats Occ (%) Year 2'
    @AnalyticsDetails.query.formula: 'NDIV0( NODIM( seatsocc_total_year_2 ) /
                                        NODIM( seatsmax_total_year_2 ) ) * hundred '
    1 as seats_occ_prc_year_2,
    @AnalyticsDetails.query.axis: #COLUMNS
    zsapbc_flight_cube.payment_year_1,    
    @AnalyticsDetails.query.axis: #COLUMNS
    zsapbc_flight_cube.payment_year_2,    
    @AnalyticsDetails.query.axis: #COLUMNS
    zsapbc_flight_cube.payment_disp_curr_year_1,        
    @AnalyticsDetails.query.axis: #COLUMNS
    zsapbc_flight_cube.payment_disp_curr_year_2,
    @AnalyticsDetails.query.axis: #FREE    
    connid,          
    @AnalyticsDetails.query.axis: #FREE
    @Consumption.filter: {selectionType: #SINGLE, multipleSelections: true, mandatory: false }
    carrid,
    @AnalyticsDetails.query.axis: #FREE
    fldate,
    @AnalyticsDetails.query.axis: #FREE
    flmonth,
    @AnalyticsDetails.query.axis: #FREE
    flyear,
    @AnalyticsDetails.query.axis: #FREE
    currency,
    @AnalyticsDetails.query.axis: #FREE
    disp_curr,
    @AnalyticsDetails.query.axis: #FREE
    unit
} 
 