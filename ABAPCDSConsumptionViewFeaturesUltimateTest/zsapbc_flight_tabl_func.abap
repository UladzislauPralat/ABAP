@EndUserText.label: 'Flight Table Function'
define table function zsapbc_flight_tabl_func
with parameters
 p_disp_currency : s_currcode
returns
{
  mandt : abap.clnt;
  carrid: s_carr_id;
  connid: s_conn_id;
  fldate: s_date;
  @Semantics.currencyCode: true  
  currency: s_currcode;
  @Semantics.currencyCode: true  
  disp_currency: s_currcode;  
  @Semantics.amount.currencyCode: 'currency'    
  paymentsum: s_sum;
  @Semantics.amount.currencyCode: 'disp_currency'  
  payment_disp_curr: s_sum;
  @Semantics.amount.currencyCode: 'disp_currency'   
  payment_disp_curr_total: s_sum;
  flyear: abap.char(4);

}
implemented by method
  zcl_sapbc_flight_tabl_func=>function;