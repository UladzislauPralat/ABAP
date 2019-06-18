@AbapCatalog.sqlViewName: 'ZSFLIGHT_CUBE5'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@Analytics.dataCategory: #CUBE
@VDM.viewType: #COMPOSITE
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Flights'
define view zsapbc_flight_cube5 with parameters
  p_display_currency : s_currcode    
  as select from zsapbc_flight_fact( p_display_currency:  $parameters.p_display_currency ) as flight
    association [1..1] to zsapbc_carr_dimension as _carr on  $projection.carrid  = flight.carrid
    association [1..1] to zsapbc_region_dimension as _region on  $projection.region  = flight.region
      {
  @ObjectModel.foreignKey.association: '_carr'
  key flight.carrid,
  key flight.connid,
  @EndUserText.label: 'Date'  
  key flight.fldate,
  @EndUserText.label: 'Region'
  @ObjectModel.foreignKey.association: '_region'
  flight.region,
  _carr,  
  _region,
  @Semantics.calendar.yearMonth: true
  @EndUserText.label: 'Month'  
  flight.flmonth,
  @Semantics.calendar.year: true
  @EndUserText.label: 'Year'
  flight.flyear,
  @Semantics.currencyCode: true
  @EndUserText.label: 'Booking Currency'     
  flight.currency,
  @Semantics.amount.currencyCode: 'Currency'
  @DefaultAggregation: #SUM
  @EndUserText.label: 'Booking (bc)'
  flight.payment,
  @EndUserText.label: 'Display Currency'  
  cast('CAD' as abap.cuky( 5 )) as disp_curr,
  @Semantics.amount.currencyCode: 'disp_curr'
  @EndUserText.label: 'Booking (dc)'
  @DefaultAggregation: #SUM
  flight.payment_disp_curr,
  @Semantics.unitOfMeasure: true  
  @EndUserText.label: 'UOM'  
  flight.unit,
  @Semantics.unitOfMeasure: true
  @EndUserText.label: '%'  
  cast( '%' as abap.unit( 3 ) ) as unit_percent,  
  @Semantics.quantity.unitOfMeasure: 'unit'
  @DefaultAggregation: #SUM
  @EndUserText.label: 'Seats Max Econ.'  
  flight.seatsmax,
  @Semantics.quantity.unitOfMeasure: 'unit'
  @DefaultAggregation: #SUM  
  @EndUserText.label: 'Seats Max Bus.'  
  flight.seatsmax_b,
  @Semantics.quantity.unitOfMeasure: 'unit'
  @DefaultAggregation: #SUM
  @EndUserText.label: 'Seats Max 1st'
  flight.seatsmax_f,
  @Semantics.quantity.unitOfMeasure: 'unit'
  @DefaultAggregation: #SUM  
  @EndUserText.label: 'Seats Max Total'
  seatsmax_total,
  @Semantics.quantity.unitOfMeasure: 'unit'
  @DefaultAggregation: #SUM  
  @EndUserText.label: 'Seats Occ Econ.'
  flight.seatsocc,
  @Semantics.quantity.unitOfMeasure: 'unit'
  @DefaultAggregation: #SUM  
  @EndUserText.label: 'Seats Occ Bus.'  
  flight.seatsocc_b,
  @Semantics.quantity.unitOfMeasure: 'unit'
  @DefaultAggregation: #SUM
  @EndUserText.label: 'Seats Occ 1st'  
  flight.seatsocc_f,
  @Semantics.quantity.unitOfMeasure: 'unit'
  @DefaultAggregation: #SUM  
  @EndUserText.label: 'Seats Occ Total'
  seatsocc_total,
  @Semantics.quantity.unitOfMeasure: 'unit_percent'
  @DefaultAggregation: #MAX
  @EndUserText.label: '100%'
  100 as hundred  
 }
