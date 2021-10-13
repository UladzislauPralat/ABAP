FUNCTION conversion_exit_zph4_output.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(INPUT)
*"  EXPORTING
*"     REFERENCE(OUTPUT)
*"--------------------------------------------------------------------

  output =
    SWITCH string( STRLEN( input )
                   WHEN 13 THEN input+8(5)
                   ELSE input ).

ENDFUNCTION.