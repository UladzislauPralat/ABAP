@AbapCatalog.sqlViewName: 'zsflight_fact'
@AbapCatalog.compiler.compareFilter: true
@Analytics.dataCategory: #FACT
@AccessControl.authorizationCheck:#NOT_REQUIRED
@EndUserText.label: 'Flight Fact'
define view zsapbc_flight_fact with parameters
    @Consumption.defaultValue: 'CAD' 
    p_display_currency : s_currcode 
    as select from sflight inner join zsapbc_carr as scarr 
                                   on sflight.carrid = scarr.carrid {
  key sflight.carrid,
  key sflight.connid,
  key sflight.fldate,
  scarr.region,  
  cast(substring(sflight.fldate,1,6) as abap.numc( 6 )) as flmonth, 
  cast(substring(sflight.fldate,1,4) as abap.numc( 4 )) as flyear,  
  sflight.currency,
  sflight.paymentsum as payment,
  'CAD' as disp_curr,
  currency_conversion( 
    amount             => sflight.paymentsum,
    source_currency    => sflight.currency,
    target_currency    => $parameters.p_display_currency,
    exchange_rate_date => sflight.fldate,
    exchange_rate_type => 'M',
    error_handling     => 'SET_TO_NULL'              // otherwise data inconsistencies cause a dump     
  ) as payment_disp_curr,
  cast('EA' as abap.unit(3) ) as unit,
  sflight.seatsmax,
  sflight.seatsmax_b,
  sflight.seatsmax_f,
  seatsmax + seatsmax_b + seatsmax_f as seatsmax_total,
  sflight.seatsocc,
  sflight.seatsocc_b,
  sflight.seatsocc_f,
  seatsocc + seatsocc_b + seatsocc_f as seatsocc_total    
}