*&---------------------------------------------------------------------*
*&  Include  Z_MONTH_F4
*&---------------------------------------------------------------------*

*---------------------------------------------------------------------*
*       CLASS lcl_month  DEFINITION
*---------------------------------------------------------------------*
CLASS lcl_month DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS:
      f4.
ENDCLASS.

*---------------------------------------------------------------------*
*       CLASS lcl_month  IMPLEMENTATION
*---------------------------------------------------------------------*
CLASS lcl_month IMPLEMENTATION.
*---------------------------------------------------------------------*
* f4
*---------------------------------------------------------------------*
  METHOD f4.
  DATA: WA_DYNPFIELDS TYPE DYNPREAD,
        MF_DYNPFIELDS TYPE TABLE OF DYNPREAD.
  DATA: MF_RETURNCODE   LIKE SY-SUBRC,
        MF_MONAT        TYPE ISELLIST-MONTH,
        MF_HLP_REPID    LIKE SY-REPID.
  FIELD-SYMBOLS: <MF_FELD> TYPE ANY.

* Wert von Dynpro lesen
  GET CURSOR FIELD WA_DYNPFIELDS-FIELDNAME.
  APPEND WA_DYNPFIELDS TO MF_DYNPFIELDS.
  MF_HLP_REPID = SY-REPID.
  DO 2 TIMES.
    CALL FUNCTION 'DYNP_VALUES_READ'
         EXPORTING
              DYNAME               = MF_HLP_REPID
              DYNUMB               = SY-DYNNR
         TABLES
              DYNPFIELDS           = MF_DYNPFIELDS
         EXCEPTIONS
              INVALID_ABAPWORKAREA = 01
              INVALID_DYNPROFIELD  = 02
              INVALID_DYNPRONAME   = 03
              INVALID_DYNPRONUMMER = 04
              INVALID_REQUEST      = 05
              NO_FIELDDESCRIPTION  = 06
              UNDEFIND_ERROR       = 07.
    IF SY-SUBRC = 3.
*     Aktuelles Dynpro ist Wertemengenbild
      MF_HLP_REPID = 'SAPLALDB'.
    ELSE.
      READ TABLE MF_DYNPFIELDS INTO WA_DYNPFIELDS INDEX 1.
*     Unterstriche durch Blanks ersetzen
      TRANSLATE WA_DYNPFIELDS-FIELDVALUE USING '_ '.
      EXIT.
    ENDIF.
  ENDDO.
  IF SY-SUBRC = 0.
*   Konvertierung ins interne Format
    CALL FUNCTION 'CONVERSION_EXIT_PERI6_INPUT'
         EXPORTING
              INPUT  = WA_DYNPFIELDS-FIELDVALUE
         IMPORTING
              OUTPUT = MF_MONAT
         EXCEPTIONS
              ERROR_MESSAGE = 1.
    IF MF_MONAT IS INITIAL.
*     Monat ist initial => Vorschlagswert aus akt. Datum ableiten
      MF_MONAT = SY-DATLO(6).
    ENDIF.
    CALL FUNCTION 'POPUP_TO_SELECT_MONTH'
         EXPORTING
              ACTUAL_MONTH               = MF_MONAT
         IMPORTING
              SELECTED_MONTH             = MF_MONAT
              RETURN_CODE                = MF_RETURNCODE
         EXCEPTIONS
              FACTORY_CALENDAR_NOT_FOUND = 01
              HOLIDAY_CALENDAR_NOT_FOUND = 02
              MONTH_NOT_FOUND            = 03.
    IF SY-SUBRC = 0 AND MF_RETURNCODE = 0.
      CALL FUNCTION 'CONVERSION_EXIT_PERI6_OUTPUT'
           EXPORTING
                INPUT  =  MF_MONAT
           IMPORTING
                OUTPUT =  WA_DYNPFIELDS-FIELDVALUE.
      COLLECT WA_DYNPFIELDS INTO MF_DYNPFIELDS.
      CALL FUNCTION 'DYNP_VALUES_UPDATE'
           EXPORTING
                DYNAME               = MF_HLP_REPID
                DYNUMB               = SY-DYNNR
         TABLES
                DYNPFIELDS           = MF_DYNPFIELDS
           EXCEPTIONS
                INVALID_ABAPWORKAREA = 01
                INVALID_DYNPROFIELD  = 02
                INVALID_DYNPRONAME   = 03
                INVALID_DYNPRONUMMER = 04
                INVALID_REQUEST      = 05
                NO_FIELDDESCRIPTION  = 06
                UNDEFIND_ERROR       = 07.           "<<== note 148804
    ENDIF.
  ENDIF.

  ENDMETHOD.
ENDCLASS.