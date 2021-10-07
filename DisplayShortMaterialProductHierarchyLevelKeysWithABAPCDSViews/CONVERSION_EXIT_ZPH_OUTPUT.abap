FUNCTION conversion_exit_zph_output.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(INPUT)
*"  EXPORTING
*"     REFERENCE(OUTPUT)
*"--------------------------------------------------------------------

  output = COND char18( WHEN matches( val = input regex = '^.{13,13}$' )
                        THEN input+8(5)
                        WHEN matches( val = input regex = '^.{8,8}$' )
                        THEN input+5(3)
                        WHEN matches( val = input regex = '^.{5,5}$' )
                        THEN input+2(3)
                        WHEN matches( val = input regex = '^.{2,2}$' )
                        THEN input+0(2)
                        ELSE input ).

ENDFUNCTION.