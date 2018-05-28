@AbapCatalog.sqlViewName: 'zsflight_fact4'
@AbapCatalog.compiler.compareFilter: true
@Analytics.dataCategory: #FACT
@AccessControl.authorizationCheck:#NOT_REQUIRED
@EndUserText.label: 'Flight Fact 4'
define view zsapbc_flight_fact4 with parameters
    @Consumption.defaultValue: 'CAD' 
    p_display_currency : s_currcode 
    as select from sflight inner join zsapbc_carr as scarr 
                                   on sflight.carrid = scarr.carrid 
                           inner join zsapbc_flight_tabl_func( p_disp_currency:  $parameters.p_display_currency ) as tabl_func 
                                   on sflight.carrid = tabl_func.carrid
                                  and sflight.connid = tabl_func.connid
                                  and sflight.fldate = tabl_func.fldate  {
  key sflight.carrid,
  key sflight.connid,
  key sflight.fldate,
  scarr.region,  
  cast(substring(sflight.fldate,1,6) as abap.numc( 6 )) as flmonth, 
  cast(substring(sflight.fldate,1,4) as abap.numc( 4 )) as flyear,  
  sflight.currency,
  sflight.paymentsum as payment,
  $parameters.p_display_currency as disp_curr,
  currency_conversion( 
    amount             => sflight.paymentsum,
    source_currency    => sflight.currency,
    target_currency    => $parameters.p_display_currency,
    exchange_rate_date => sflight.fldate,
    exchange_rate_type => 'M',
    error_handling     => 'SET_TO_NULL'              // otherwise data inconsistencies cause a dump     
  ) as payment_disp_curr,
  tabl_func.payment_disp_curr_total,  
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
 