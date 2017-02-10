*&---------------------------------------------------------------------*
*&  Include           Z_MONTH_F4_DEMO_APPL
*&---------------------------------------------------------------------*

*---------------------------------------------------------------------*
*       CLASS lcl_application  DEFINITION
*---------------------------------------------------------------------*
CLASS lcl_application DEFINITION CREATE PRIVATE.
  PUBLIC SECTION.
    CLASS-DATA:
      application TYPE REF TO lcl_application.
    CLASS-METHODS:
      main.
  PRIVATE SECTION.
    TYPES:
      t_month     TYPE RANGE OF rsfiscper6.
    DATA:
      _t_data     TYPE TABLE OF sflight.
    METHODS:
      constructor IMPORTING it_month      TYPE t_month,
      display_data.
ENDCLASS.

*---------------------------------------------------------------------*
*       CLASS lcl_application  IMPLEMENTATION
*---------------------------------------------------------------------*
CLASS lcl_application IMPLEMENTATION.

*---------------------------------------------------------------------*
* main
*---------------------------------------------------------------------*
  METHOD main.

    DATA(application) = NEW lcl_application( it_month   = s_month[] ).
    application->display_data( ).

  ENDMETHOD.

*---------------------------------------------------------------------*
* constructor
*---------------------------------------------------------------------*
  METHOD constructor.

    TRY.
      DATA(w_date_from) = CONV d( |{ it_month[ 1 ]-low }| && '01' ).
      CASE it_month[ 1 ]-option.
      WHEN 'EQ'.
        DATA(w_date_to) = w_date_from.
        WHILE w_date_to+4(2) = it_month[ 1 ]-low+4(2).
          w_date_to = w_date_to + 1.
        ENDWHILE.
        w_date_to = w_date_to - 1.
      WHEN 'BT'.
        w_date_to  = CONV d( |{ it_month[ 1 ]-high }| && '01' ).
        WHILE w_date_to+4(2) = it_month[ 1 ]-high+4(2).
          w_date_to = w_date_to + 1.
        ENDWHILE.
        w_date_to = w_date_to - 1.
      ENDCASE.
*
      SELECT *
      INTO TABLE _t_data
      FROM sflight
      WHERE fldate BETWEEN w_date_from AND w_date_to
      ORDER BY fldate.
    CATCH cx_sy_itab_line_not_found INTO DATA(itab_line_not_found).
    ENDTRY.

  ENDMETHOD.

*---------------------------------------------------------------------*
* display_data
*---------------------------------------------------------------------*
  METHOD display_data.

    cl_salv_table=>factory(
      IMPORTING r_salv_table = DATA(alv)
      CHANGING  t_table      = _t_data ).
    alv->display( ).

  ENDMETHOD.

ENDCLASS.