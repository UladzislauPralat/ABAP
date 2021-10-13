FUNCTION conversion_exit_zph2_output.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(INPUT)
*"  EXPORTING
*"     REFERENCE(OUTPUT)
*"----------------------------------------------------------------------

  output =
    SWITCH string( STRLEN( input )
                   WHEN 5 THEN input+2(3)
                   ELSE input ).

ENDFUNCTION.