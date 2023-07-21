class ZCL_RSROA_VARIABLES_EXIT definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_RSROA_VARIABLES_EXIT_BADI .
protected section.
private section.

  methods GET_INVAGINGDATE
    returning
      value(RT_RANGE) type RSR_T_RANGESID .
  methods GET_INVAGINGRANGE
    importing
      !I_VNAM type RSZGLOBV-VNAM
    returning
      value(RT_RANGE) type RSR_T_RANGESID .
  methods GET_INTFLOWELIM
    returning
      value(RT_RANGE) type RSR_T_RANGESID .
  methods GET_INVAGINGRANGETEXT
    importing
      !I_VNAM type RSZGLOBV-VNAM
      !I_T_VAR_RANGE type RRS0_T_VAR_RANGE
    returning
      value(RT_RANGE) type RSR_T_RANGESID .
  methods CHECK
    importing
      !I_T_VAR_RANGE type RRS0_T_VAR_RANGE
    returning
      value(RT_RANGE) type RSR_T_RANGESID
    raising
      CX_RS_ERROR .
  methods CHECK_INVAGINGINTFLOWELIM
    importing
      !I_T_VAR_RANGE type RRS0_T_VAR_RANGE
    returning
      value(RT_RANGE) type RSR_T_RANGESID
    raising
      CX_RS_ERROR .
  methods CHECK_INVAGINGRANGE
    importing
      !I_T_VAR_RANGE type RRS0_T_VAR_RANGE
    returning
      value(RT_RANGE) type RSR_T_RANGESID
    raising
      CX_RS_ERROR .
ENDCLASS.



CLASS ZCL_RSROA_VARIABLES_EXIT IMPLEMENTATION.


METHOD check.

  TRY.
    IF line_exists( i_t_var_range[ vnam = 'INVAGINGINTFLOWELIM' ] ).
      check_invagingintflowelim( i_t_var_range ).
    ELSEIF line_exists( i_t_var_range[ vnam = 'INVAGINGRANGE1' ] )
        OR line_exists( i_t_var_range[ vnam = 'INVAGINGRANGE2' ] )
        OR line_exists( i_t_var_range[ vnam = 'INVAGINGRANGE3' ] )
        OR line_exists( i_t_var_range[ vnam = 'INVAGINGRANGE4' ] ).
      check_invagingrange( i_t_var_range ).
    ENDIF.
  CATCH cx_rs_error.
    RAISE EXCEPTION TYPE cx_rs_error.
  ENDTRY.
  rt_range = VALUE #( ).

ENDMETHOD.


METHOD check_invagingintflowelim.

  TRY.
    DATA(w_intflowelim) = CONV cacsyn( i_t_var_range[ vnam = 'INVAGINGINTFLOWELIM' ]-low ).
    IF w_intflowelim <> 'Y' AND w_intflowelim <> 'N'.
      DATA(w_msgv1) = |{ w_intflowelim } is not valid Internal Flow Elimination|.
      CALL FUNCTION 'RRMS_MESSAGE_HANDLING'
           EXPORTING
                i_class  = 'OO'
                i_type   = 'E'
                i_number = '000'
                i_msgv1  = w_msgv1.
      RAISE EXCEPTION TYPE cx_rs_error.
    ENDIF.
  CATCH cx_sy_itab_line_not_found.
  ENDTRY.

ENDMETHOD.


METHOD check_invagingrange.
DATA: w_msgv1 TYPE string.

  TRY.
    DO 5 TIMES.
      DATA(w_test) = i_t_var_range[ vnam = |INVAGINGRANGE{ CONV i( sy-index ) }| ]-low.
      IF NOT matches( val = i_t_var_range[ vnam = |INVAGINGRANGE{ CONV i( sy-index ) }| ]-low regex = '^\d+$').
        w_msgv1 = |Invalid Aging Range { CONV i( sy-index ) }|.
        CALL FUNCTION 'RRMS_MESSAGE_HANDLING'
             EXPORTING
                  i_class  = 'OO'
                  i_type   = 'E'
                  i_number = '000'
                  i_msgv1  = w_msgv1.
        RAISE EXCEPTION TYPE cx_rs_error.
      ELSEIF CONV i( i_t_var_range[ vnam = |INVAGINGRANGE{ CONV i( sy-index ) }| ]-low ) = 0.
        w_msgv1 = |Aging Range { CONV i( sy-index ) } should be greater then 0|.
        CALL FUNCTION 'RRMS_MESSAGE_HANDLING'
             EXPORTING
                  i_class  = 'OO'
                  i_type   = 'E'
                  i_number = '000'
                  i_msgv1  = w_msgv1.
        RAISE EXCEPTION TYPE cx_rs_error.
      ELSEIF ( sy-index > 1 ).
        IF CONV i( i_t_var_range[ vnam = |INVAGINGRANGE{ CONV i( sy-index ) }| ]-low ) <=
           CONV i( i_t_var_range[ vnam = |INVAGINGRANGE{ CONV i( sy-index - 1 ) }| ]-low ).
          w_msgv1 = |Aging Range { CONV i( sy-index ) } should be greater then Aging Range { CONV i( sy-index - 1 ) }|.
          CALL FUNCTION 'RRMS_MESSAGE_HANDLING'
               EXPORTING
                    i_class  = 'OO'
                    i_type   = 'E'
                    i_number = '000'
                    i_msgv1  = w_msgv1.
          RAISE EXCEPTION TYPE cx_rs_error.
        ENDIF.
      ENDIF.
    ENDDO.
  CATCH cx_sy_itab_line_not_found.
  ENDTRY.

ENDMETHOD.


METHOD get_intflowelim.

  rt_range = VALUE #( ( sign = 'I'
                        opt  = 'EQ'
                        low  = 'Y' ) ).

ENDMETHOD.


METHOD get_invagingdate.

  rt_range = VALUE #( ( sign = 'I'
                        opt  = 'EQ'
                        low  = sy-datum ) ).

ENDMETHOD.


METHOD get_invagingrange.

  rt_range = VALUE #( ( sign = 'I'
                        opt  = 'EQ'
                        low  = SWITCH #( i_vnam+13(1)
                                         WHEN '1' THEN '180'
                                         WHEN '2' THEN '360'
                                         WHEN '3' THEN '540'
                                         WHEN '4' THEN '720' ) ) ).

ENDMETHOD.


METHOD get_invagingrangetext.

  TRY.
    rt_range =
      SWITCH #( i_vnam
                WHEN 'INVAGINGRANGETEXT1'
                THEN VALUE #( ( sign = 'I'
                                opt  = 'EQ'
                                low  = |0..{ CONV i( i_t_var_range[ vnam = 'INVAGINGRANGE1' ]-low ) }| ) )
                WHEN 'INVAGINGRANGETEXT2'
                THEN VALUE #( ( sign = 'I'
                                opt  = 'EQ'
                                low  = |{ CONV i( i_t_var_range[ vnam = 'INVAGINGRANGE1' ]-low ) + 1 }..{ CONV i( i_t_var_range[ vnam = 'INVAGINGRANGE2' ]-low ) }| ) )
                WHEN 'INVAGINGRANGETEXT3'
                THEN VALUE #( ( sign = 'I'
                                opt  = 'EQ'
                                low  = |{ CONV i( i_t_var_range[ vnam = 'INVAGINGRANGE2' ]-low ) + 1 }..{ CONV i( i_t_var_range[ vnam = 'INVAGINGRANGE3' ]-low ) }| ) )
                WHEN 'INVAGINGRANGETEXT4'
                THEN VALUE #( ( sign = 'I'
                                opt  = 'EQ'
                                low  = |{ CONV i( i_t_var_range[ vnam = 'INVAGINGRANGE3' ]-low ) + 1 }..{ CONV i( i_t_var_range[ vnam = 'INVAGINGRANGE4' ]-low ) }| ) )
                WHEN 'INVAGINGRANGETEXT5'
                THEN VALUE #( ( sign = 'I'
                                opt  = 'EQ'
                                low  = |{ CONV i( i_t_var_range[ vnam = 'INVAGINGRANGE4' ]-low ) + 1 }..| ) ) ).
  CATCH cx_sy_itab_line_not_found.
  ENDTRY.

ENDMETHOD.


METHOD if_rsroa_variables_exit_badi~process.

  TRY.
  c_t_range =
    COND #( WHEN NOT c_t_range[] IS INITIAL
            THEN c_t_range
            WHEN i_step = 1
            THEN COND #( WHEN i_vnam = 'INVAGINGDATE'
                         THEN get_invagingdate( )
                         WHEN matches( val = i_vnam regex = '^INVAGINGRANGE[0-6]$' )
                         THEN get_invagingrange( i_vnam = i_vnam )
                         WHEN i_vnam = 'INVAGINGINTFLOWELIM'
                         THEN get_intflowelim( ) )
            WHEN i_step = 2
            THEN COND #( WHEN matches( val = i_vnam regex = '^INVAGINGRANGETEXT[0-5]$' )
                         THEN get_invagingrangetext( i_vnam        = i_vnam
                                                     i_t_var_range = i_t_var_range ) )
            WHEN i_step = 3
            THEN check( i_t_var_range ) ).
  CATCH cx_rs_error.
    RAISE EXCEPTION TYPE cx_rs_error.
  ENDTRY.

ENDMETHOD.
ENDCLASS.