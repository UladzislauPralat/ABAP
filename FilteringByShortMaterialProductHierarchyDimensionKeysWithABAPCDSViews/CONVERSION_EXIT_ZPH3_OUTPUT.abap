FUNCTION conversion_exit_zph3_output.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(INPUT)
*"  EXPORTING
*"     REFERENCE(OUTPUT)
*"--------------------------------------------------------------------

  output =
    SWITCH string( STRLEN( input )
                   WHEN 8 THEN input+5(3)
                   ELSE input ).

ENDFUNCTION.