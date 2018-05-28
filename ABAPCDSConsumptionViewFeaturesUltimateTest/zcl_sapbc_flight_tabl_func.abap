class zcl_sapbc_flight_tabl_func definition
  public
  final
  create public .

public section.
    interfaces if_amdp_marker_hdb.
    class-methods function for table function zsapbc_flight_tabl_func.
protected section.
private section.
endclass.



class zcl_sapbc_flight_tabl_func implementation.
  method function by database function
                   for hdb language sqlscript
                   options read-only
                   using sflight.


    it_data =
      select mandt, carrid, connid, fldate,
             currency, :p_disp_currency as disp_currency,
             paymentsum,
             CONVERT_CURRENCY(amount=>paymentsum,
               "SOURCE_UNIT" =>currency,
               "SCHEMA" => 'SAPA4H',
               "CONVERSION_TYPE" => 'M',
               "TARGET_UNIT" => :p_disp_currency,
               "REFERENCE_DATE" =>fldate,
               "ERROR_HANDLING"=>'set to null',
               "CLIENT" => '000') as payment_disp_curr,
               substr( fldate, 1, 4) as flyear
    from sflight;

    return
      select mandt, carrid, connid, fldate, currency, disp_currency,
             paymentsum , payment_disp_curr,
             sum( payment_disp_curr  ) over ( partition by flyear ) as payment_disp_curr_total,
             flyear
      from :it_data;

  endmethod.
endclass.