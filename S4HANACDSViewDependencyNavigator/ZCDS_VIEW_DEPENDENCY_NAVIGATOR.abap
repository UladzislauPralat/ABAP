REPORT zcds_view_dependency_navigator.

**********************************************************************
* Selection Screen
**********************************************************************
SELECTION-SCREEN BEGIN OF BLOCK cds WITH FRAME TITLE c_cds.
  SELECTION-SCREEN BEGIN OF LINE.
    SELECTION-SCREEN COMMENT 1(31) c_name FOR FIELD p_name.
    PARAMETERS p_name TYPE c LENGTH 40 LOWER CASE.
  SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK cds.

SELECTION-SCREEN BEGIN OF BLOCK direction WITH FRAME TITLE c_dir.
  SELECTION-SCREEN BEGIN OF LINE.
    SELECTION-SCREEN COMMENT 1(31) c_up FOR FIELD p_up.
    PARAMETERS: p_up RADIOBUTTON GROUP dir DEFAULT 'X'.
  SELECTION-SCREEN END OF LINE.
  SELECTION-SCREEN BEGIN OF LINE.
    SELECTION-SCREEN COMMENT 1(31) c_down FOR FIELD p_down.
    PARAMETERS: p_down RADIOBUTTON GROUP dir.
  SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK direction.


************************************************************************
INITIALIZATION.
************************************************************************
c_dir = 'Navigation Direction'.
c_up = 'Up'.
c_down = 'Down'.
c_cds = 'Table / CDS view'.
c_name = 'Name'.
sy-title = 'CDS View Dependency Navigator'.


************************************************************************
* CLASS lcx_exception DEFINITION
************************************************************************
CLASS lcx_exception DEFINITION
  INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    DATA text TYPE string.
    METHODS constructor
      IMPORTING
        !text TYPE string.
ENDCLASS.

************************************************************************
* CLASS lcx_exception IMPLEMENTATION
************************************************************************
CLASS lcx_exception IMPLEMENTATION.

  METHOD constructor.
    super->constructor( ).
    me->text = text.
  ENDMETHOD.

ENDCLASS.

************************************************************************
* CLASS lcl_ddic_helper DEFINITION
************************************************************************
CLASS lcl_ddic_helper DEFINITION.
  PUBLIC SECTION.
    TYPES: BEGIN OF ty_field_meta,
             fieldname    TYPE fieldname,
             is_key       TYPE abap_bool,
             datatype     TYPE dynptype,
             length       TYPE i,
             decimals     TYPE i,
             data_element TYPE rollname,
             domain       TYPE domname,
             label_short  TYPE string,
           END OF ty_field_meta.
    TYPES tt_field_meta TYPE STANDARD TABLE OF ty_field_meta WITH EMPTY KEY.
    CLASS-METHODS get_field_metadata
      IMPORTING
        iv_tabname     TYPE tabname
      RETURNING
        VALUE(rt_meta) TYPE tt_field_meta.
ENDCLASS.

************************************************************************
* CLASS lcl_ddic_helper IMPLEMENTATION
************************************************************************
CLASS lcl_ddic_helper IMPLEMENTATION.

  METHOD get_field_metadata.
  DATA(lv_tabname) = iv_tabname.
  TRANSLATE lv_tabname TO UPPER CASE.

  DATA(lo_structdescr) =
    CAST cl_abap_structdescr( cl_abap_typedescr=>describe_by_name( lv_tabname ) ).
  DATA(lt_components) = lo_structdescr->get_components( ).

    LOOP AT lt_components INTO DATA(ls_comp).
      DATA(ls_meta) = VALUE ty_field_meta( fieldname = ls_comp-name ).
      IF ls_comp-type->kind = cl_abap_typedescr=>kind_elem.
        DATA(lo_elem) = CAST cl_abap_elemdescr( ls_comp-type ).
        DATA(ls_ddic) = lo_elem->get_ddic_field( ).
        ls_meta-data_element = ls_ddic-rollname.
        ls_meta-domain       = ls_ddic-domname.
        ls_meta-datatype     = ls_ddic-datatype.
        ls_meta-length       = ls_ddic-leng.
        ls_meta-decimals     = ls_ddic-decimals.
*
        SELECT SINGLE 'X'
        FROM dd03l
        INTO @ls_meta-is_key
        WHERE tabname  = @iv_tabname
          AND fieldname = @ls_comp-name
          AND keyflag  = 'X'
          AND as4local = 'A'.
*
        SELECT SINGLE scrtext_l
        FROM dd04t
        INTO @ls_meta-label_short
        WHERE rollname = @ls_ddic-rollname
          AND ddlanguage = 'E'
          AND as4local = 'A'
          AND as4vers = '0000'.
        IF sy-subrc <> 0.
          SELECT SINGLE ddtext
          FROM dd03t
          INTO @ls_meta-label_short
          WHERE tabname = @iv_tabname
            AND fieldname = @ls_comp-name
            AND ddlanguage = 'E'
            AND as4local = 'A'.
        ENDIF.
*
        APPEND ls_meta TO rt_meta.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

************************************************************************
* CLASS lcl_application DEFINITION
************************************************************************
CLASS lcl_application DEFINITION CREATE PRIVATE.
  PUBLIC SECTION.
    TYPES:
      BEGIN OF s_dependency,
        ddlname        TYPE ddlname,
        ddlsource_link TYPE ddlname,
        ddlsource      TYPE ddddlsource,
        ddltext        TYPE ddtext,
        ddltype        TYPE val_text,
        viewtype       TYPE ddtext,
        category       TYPE ddtext,
        query          TYPE ddtext,
        lifecycle      TYPE ddtext,
        successor      TYPE ddtext,
      END OF s_dependency,
      t_dependency TYPE STANDARD TABLE OF s_dependency WITH EMPTY KEY,
      BEGIN OF s_navigation,
        ddlname  TYPE ddlname,
        depth    TYPE i,
        dependency TYPE t_dependency,
      END OF s_navigation,
      t_navigation TYPE STANDARD TABLE OF s_navigation WITH EMPTY KEY.
    CONSTANTS:
      c_up TYPE string VALUE 'up',
      c_down TYPE string VALUE 'down'.
    CLASS-METHODS:
      get_application IMPORTING i_up TYPE abap_bool
                      RETURNING VALUE(rv_application) TYPE REF TO lcl_application,
      check_name
        IMPORTING i_name TYPE text40
        RAISING   lcx_exception,
      get_fieldcat
        RETURNING VALUE(rt_fieldcat) TYPE slis_t_fieldcat_alv.
    METHODS:
      constructor
        IMPORTING i_up TYPE abap_bool,
      navigate
        IMPORTING i_name TYPE ddlname
        RAISING lcx_exception,
      get_dependency
        RETURNING VALUE(rt_dependency) TYPE t_dependency,
      get_ddl_source
         IMPORTING i_name TYPE ddlname
         RETURNING VALUE(r_source) TYPE string
         RAISING lcx_exception,
      get_ddl_path
         IMPORTING i_name TYPE ddlname
         RETURNING VALUE(r_path) TYPE string.

  PRIVATE SECTION.
    CLASS-DATA application TYPE REF TO lcl_application.
    DATA:
      direction TYPE string,
      navigation TYPE t_navigation.
    METHODS:
      adjust_navigation
        IMPORTING i_name TYPE ddlname,
      get_ddl_attributes
        CHANGING c_dependency TYPE s_dependency,
      get_dependency_up
        IMPORTING i_name TYPE ddlname
        RETURNING VALUE(rt_dependency) TYPE t_dependency
        RAISING lcx_exception,
      get_dependency_down
        IMPORTING i_name TYPE ddlname
        RETURNING VALUE(rt_dependency) TYPE t_dependency
        RAISING lcx_exception.

ENDCLASS.

************************************************************************
* CLASS lcl_application IMPLEMENTATION
************************************************************************
CLASS lcl_application IMPLEMENTATION.

  METHOD get_application.

    IF application IS INITIAL.
      CREATE OBJECT application EXPORTING i_up = i_up.
    ENDIF.
    rv_application = application.

  ENDMETHOD.

  METHOD constructor.

    direction = COND string( WHEN p_up = abap_true THEN c_up
                             WHEN p_up = abap_false THEN c_down ).
  ENDMETHOD.

  METHOD navigate.
  DATA: wt_dependency TYPE t_dependency.
  DATA: exception TYPE REF TO lcx_exception.

    TRY.
      IF direction = c_up .
        wt_dependency = get_dependency_up( i_name ).
      ELSEIF direction = lcl_application=>c_down.
        wt_dependency = get_dependency_down( i_name ).
      ENDIF.
      SORT wt_dependency BY ddlname ASCENDING.
      APPEND VALUE #( ddlname    = i_name
                      depth      = lines( navigation ) + 1
                      dependency = wt_dependency ) TO navigation.
     CATCH lcx_exception INTO exception.
       RAISE EXCEPTION TYPE lcx_exception
             EXPORTING
                 text = exception->text.
   ENDTRY.

  ENDMETHOD.

  METHOD get_dependency.

    rt_dependency = navigation[ depth = LINES( navigation ) ]-dependency.

  ENDMETHOD.

  METHOD get_ddl_source.

    adjust_navigation( i_name ).
    IF navigation[ depth = lines( navigation ) ]-dependency[ ddlname = i_name ]-ddltype = 'DDIC-table'.
      RAISE EXCEPTION TYPE lcx_exception
        EXPORTING text = 'No CDS view source code for DDIC-table'.
    ENDIF.
    r_source = navigation[ depth = lines( navigation ) ]-dependency[ ddlname = i_name ]-ddlsource.


  ENDMETHOD.

  METHOD get_ddl_path.

    adjust_navigation( i_name ).
    r_path = COND string( WHEN direction = c_down THEN i_name ELSE space ).
    DO lines( navigation ) TIMES.
      r_path = COND string( WHEN direction = c_up
                            THEN |{ r_path } { COND string( WHEN r_path <> space THEN '→' ) } { navigation[ depth = sy-index ]-ddlname }|
                            WHEN direction = c_down
                            THEN |{ r_path } ← { navigation[ depth = lines( navigation ) - sy-index + 1 ]-ddlname }| ).
    ENDDO.
    r_path = COND string( WHEN direction = c_up THEN |{ r_path } → { i_name }| ELSE r_path ).

  ENDMETHOD.

  METHOD adjust_navigation.

    WHILE NOT line_exists( navigation[ depth = lines( navigation ) ]-dependency[ ddlname = i_name ] )
      AND navigation[] IS NOT INITIAL.
      DELETE navigation WHERE depth = lines( navigation ).
    ENDWHILE.

  ENDMETHOD.

  METHOD get_ddl_attributes.
  DATA(w_ddlsource) = c_dependency-ddlsource.

    REPLACE ALL OCCURRENCES OF PCRE '(--|//).*\R' IN w_ddlsource WITH ''.
*
    FIND PCRE 'define\s+view(?:\s+entity)?\s+([A-Za-z][A-Za-z0-9_]*)'
      IN w_ddlsource
      IGNORING CASE
      SUBMATCHES c_dependency-ddlname.
    c_dependency-ddlsource_link = c_dependency-ddlname.

    FIND PCRE '@VDM\.viewType:\s+\#([A-Z]+)'
      IN w_ddlsource
      IGNORING CASE
      SUBMATCHES c_dependency-viewtype.
    IF sy-subrc <> 0.
      FIND PCRE '@VDM\s*:\s*{[^}]*viewType\s*:\s*\#([A-Z_]+)'
        IN w_ddlsource
        IGNORING CASE
        SUBMATCHES c_dependency-viewtype.
    ENDIF.

    FIND PCRE '@Analytics\.dataCategory:\s*\#([A-Z]+)'
      IN w_ddlsource
      IGNORING CASE
      SUBMATCHES c_dependency-category.
    IF sy-subrc <> 0.
      FIND PCRE '@Analytics\s*:\s*{[^}]*dataCategory\s*:\s*\#([A-Z_]+)'
       IN w_ddlsource
       IGNORING CASE
       SUBMATCHES c_dependency-category.
    ENDIF.

    FIND PCRE '@Analytics\.query:\s*(true|false)'
      IN w_ddlsource
      IGNORING CASE
      SUBMATCHES c_dependency-query.
    IF sy-subrc <> 0.
      FIND PCRE '@Analytics\s*:\s*{[^}]*query\s*:\s*(true|false)'
       IN w_ddlsource
       IGNORING CASE
       SUBMATCHES c_dependency-query.
    ENDIF.

    FIND PCRE '(?s)@VDM\s*:\s*{.*?lifecycle\s*:\s*{.*?status\s*:\s*\#(\w+).*?define\s'           " structured structured
      IN w_ddlsource
      IGNORING CASE
      SUBMATCHES c_dependency-lifecycle.
    IF sy-subrc <> 0.
      FIND PCRE '(?s)@VDM\.lifecycle\.status\s*:\s*\#([A-Z_]+).*?define\s'                       " flattened flattened
        IN w_ddlsource
        IGNORING CASE
        SUBMATCHES c_dependency-lifecycle.
      IF sy-subrc <> 0.
        FIND PCRE '(?s)@VDM\s*:\s*{.*?lifecycle\.status\s*:\s*\#([A-Z_]+).*?define\s'            " structured flattened
          IN w_ddlsource
          IGNORING CASE
          SUBMATCHES c_dependency-lifecycle.
        IF sy-subrc <> 0.
          FIND PCRE '(?s)@VDM\.lifecycle\s*:\s*{.*?status\s*:\s*\#(\w+).*?define\s'              " flattened structured
            IN w_ddlsource
            IGNORING CASE
            SUBMATCHES c_dependency-lifecycle.
        ENDIF.
      ENDIF.
    ENDIF.

    FIND PCRE '(?s)@VDM\s*:\s*{.*?lifecycle\s*:\s*{.*?successor\s*:\s*''([^'']+)''.*?define\s'   " structured structured
      IN w_ddlsource
      IGNORING CASE
      SUBMATCHES c_dependency-successor.
    IF sy-subrc <> 0.
      FIND PCRE '(?s)@VDM\.lifecycle\.successor\s*:\s*''([^'']+)''.*?define\s'                   " flattened flattened
       IN w_ddlsource
       IGNORING CASE
       SUBMATCHES c_dependency-successor.
      IF sy-subrc <> 0.
        FIND PCRE '(?s)@VDM\s*:\s*{.*?lifecycle\.successor\s*:\s*''([^'']+)''.*?define\s'        " structured flattened
          IN w_ddlsource
          IGNORING CASE
          SUBMATCHES c_dependency-successor.
        IF sy-subrc <> 0.
          FIND PCRE '(?s)@VDM\.lifecycle\s*:\s*{.*?successor\s*:\s*''([^'']+)''.*?define\s'      " flattened structured
            IN w_ddlsource
            IGNORING CASE
            SUBMATCHES c_dependency-successor.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.

  METHOD get_dependency_up.

    adjust_navigation( i_name ).

    DATA(w_where) = |%{ i_name }%|.
    SELECT ddddlsrc~ddlname,
           ddddlsrc~ddlname AS ddlsource_link,
           ddddlsrc~source,
           ddddlsrct~ddtext AS ddltext,
           dd07t~ddtext AS ddltype,
           ' ' AS viewtype,
           ' ' AS category,
           ' ' AS query
      FROM ddddlsrc LEFT OUTER JOIN ddddlsrct
                                 ON ddddlsrc~ddlname = ddddlsrct~ddlname
                                AND ddddlsrct~ddlanguage = 'E'
                                AND ddddlsrct~as4local = 'A'
                    LEFT OUTER JOIN dd07t
                                 ON ddddlsrc~source_type = dd07t~domvalue_l
                                AND dd07t~domname = 'DDDDLSRCTYPE'
                                AND dd07t~ddlanguage = 'E'
                                AND dd07t~as4local = 'A'
                                AND dd07t~as4vers = '000'
      INTO TABLE @rt_dependency
      WHERE ( source LIKE @w_where ).

    LOOP AT rt_dependency ASSIGNING FIELD-SYMBOL(<dependency>).
      REPLACE ALL OCCURRENCES OF PCRE '(--|//).*\R' IN <dependency>-ddlsource WITH ''.
      REPLACE ALL OCCURRENCES OF PCRE '/\*\+\[internal][\s\S]*?\*/' IN <dependency>-ddlsource WITH ''.
      REPLACE ALL OCCURRENCES OF PCRE '/\*+[\s\S]*?[\s\S]*?\*/' IN <dependency>-ddlsource WITH ''.
      FIND PCRE |(?:from\|join)\\s+({ i_name })(?:\\s\|\\()|
        IN <dependency>-ddlsource
        IGNORING CASE.
      IF sy-subrc <> 0.
        DELETE rt_dependency INDEX sy-tabix.
      ENDIF.
    ENDLOOP.

    LOOP AT rt_dependency ASSIGNING <dependency>.
      get_ddl_attributes( CHANGING c_dependency = <dependency> ).
      REPLACE ALL OCCURRENCES OF PCRE '(?<=\})\s*$' IN <dependency>-ddlsource WITH ''.
    ENDLOOP.

    IF rt_dependency[] IS INITIAL.
      RAISE EXCEPTION TYPE lcx_exception EXPORTING text = 'No more dependencies'.
    ENDIF.

  ENDMETHOD.

  METHOD get_dependency_down.

    adjust_navigation( i_name ).

    SELECT SINGLE 'X'
    FROM dd02l
    WHERE tabname = upper( @i_name )
    INTO @DATA(w_table_exists).
    IF sy-subrc = 0.
      RAISE EXCEPTION TYPE lcx_exception EXPORTING text = 'No more dependencies'.
    ENDIF.

    SELECT SINGLE source
    FROM ddddlsrc
    WHERE ddlname = upper( @i_name )
    INTO @DATA(w_source).
    IF sy-subrc = 0.
      REPLACE ALL OCCURRENCES OF PCRE '(--|//).*\R' IN w_source WITH ''.
      REPLACE ALL OCCURRENCES OF PCRE '/\*+[\s\S]*?[\s\S]*?\*/' IN w_source WITH ''.
      FIND ALL OCCURRENCES OF PCRE '(?:from|join)\s+([a-z0-9_/]+)' IN w_source
      IGNORING CASE
      RESULTS DATA(wt_match_result).
      rt_dependency =
        VALUE lcl_application=>t_dependency(
          FOR result   IN wt_match_result
            FOR submatch IN result-submatches
              ( ddlname        = w_source+submatch-offset(submatch-length)
                ddlsource_link = w_source+submatch-offset(submatch-length)
                ddltype        = 'DDIC-table'  ) ).

      SORT rt_dependency BY ddlname.
      DELETE ADJACENT DUPLICATES FROM rt_dependency COMPARING ddlname.
      LOOP AT rt_dependency ASSIGNING FIELD-SYMBOL(<dependency>).
        SELECT SINGLE ddddlsrc~source,
                      ddddlsrct~ddtext AS ddltext,
                      dd07t~ddtext AS ddltype
        FROM ddddlsrc LEFT OUTER JOIN ddddlsrct
                                   ON ddddlsrc~ddlname      = ddddlsrct~ddlname
                                  AND ddddlsrct~ddlanguage = 'E'
                                  AND ddddlsrct~as4local   = 'A'
                      LEFT OUTER JOIN dd07t
                                   ON ddddlsrc~source_type = dd07t~domvalue_l
                                  AND dd07t~domname = 'DDDDLSRCTYPE'
                                  AND dd07t~ddlanguage = 'E'
                                  AND dd07t~as4local = 'A'
                                  AND dd07t~as4vers = '000'
        WHERE ddddlsrc~ddlname = upper( @<dependency>-ddlname )
        INTO ( @<dependency>-ddlsource, @<dependency>-ddltext, @<dependency>-ddltype ).
        CASE sy-subrc.
          WHEN 0.
            get_ddl_attributes( CHANGING c_dependency = <dependency> ).
            REPLACE ALL OCCURRENCES OF PCRE '(?<=\})\s*$' IN <dependency>-ddlsource WITH ''.
          WHEN OTHERS.
            SELECT SINGLE ddtext
            FROM dd02t
            WHERE tabname = upper( @<dependency>-ddlname )
              AND ddlanguage = 'E'
              AND as4local = 'A'
              AND as4vers = '000'
            INTO (@<dependency>-ddltext).
        ENDCASE.
      ENDLOOP.

      IF rt_dependency[] IS INITIAL.
        RAISE EXCEPTION TYPE lcx_exception EXPORTING text = 'No more dependencies'.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD check_name.

    IF i_name = ''.
      RAISE EXCEPTION TYPE lcx_exception
        EXPORTING
          text = 'Table / CDS view name is empty'.
    ELSE.
      SELECT SINGLE 'X'
      FROM dd02l
      WHERE tabname = upper( @i_name )
      INTO @DATA(w_table_exists).
      IF sy-subrc <> 0.
        SELECT SINGLE 'X'
        FROM ddddlsrc
        WHERE ddlname = upper( @i_name )
        INTO @DATA(w_cds_view_exists).
        IF sy-subrc <> 0.
          RAISE EXCEPTION TYPE lcx_exception
            EXPORTING
              text = |{ i_name } is not a valid table or CDS view name|.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.

  METHOD get_fieldcat.
  DATA: wa_fieldcat TYPE slis_fieldcat_alv.

  " Field catalog
    CLEAR wa_fieldcat.
    wa_fieldcat-fieldname = 'DDLNAME'.
    wa_fieldcat-seltext_m = 'Name'.
    wa_fieldcat-edit = ' '. " Not editable
    wa_fieldcat-outputlen = 40.
    APPEND wa_fieldcat TO rt_fieldcat.

    CLEAR wa_fieldcat.
    wa_fieldcat-fieldname = 'DDLTEXT'.
    wa_fieldcat-seltext_m = 'Description'.
    wa_fieldcat-edit = ' '. " Not editable
    APPEND wa_fieldcat TO rt_fieldcat.

    CLEAR wa_fieldcat.
    wa_fieldcat-fieldname = 'DDLTYPE'.
    wa_fieldcat-seltext_m = 'Source Type'.
    wa_fieldcat-edit = ' '. " Not editable
    APPEND wa_fieldcat TO rt_fieldcat.

    CLEAR wa_fieldcat.
    wa_fieldcat-fieldname = 'VIEWTYPE'.
    wa_fieldcat-seltext_m = 'VDM View Type'.
    wa_fieldcat-edit = ' '. " Not editable
    APPEND wa_fieldcat TO rt_fieldcat.

    CLEAR wa_fieldcat.
    wa_fieldcat-fieldname = 'CATEGORY'.
    wa_fieldcat-seltext_m = 'Data Category'.
    wa_fieldcat-edit = ' '. " Not editable
    APPEND wa_fieldcat TO rt_fieldcat.

    CLEAR wa_fieldcat.
    wa_fieldcat-fieldname = 'QUERY'.
    wa_fieldcat-seltext_m = 'Analytical Query'.
    wa_fieldcat-edit = ' '. " Not editable
    APPEND wa_fieldcat TO rt_fieldcat.

    CLEAR wa_fieldcat.
    wa_fieldcat-fieldname = 'LIFECYCLE'.
    wa_fieldcat-seltext_m = 'Lifecycle Status'.
    wa_fieldcat-edit = ' '. " Not editable
    APPEND wa_fieldcat TO rt_fieldcat.

    CLEAR wa_fieldcat.
    wa_fieldcat-fieldname = 'SUCCESSOR'.
    wa_fieldcat-seltext_m = 'Successor'.
    wa_fieldcat-edit = ' '. " Not editable
    APPEND wa_fieldcat TO rt_fieldcat.

    CLEAR wa_fieldcat.
    wa_fieldcat-fieldname = 'DDLSOURCE'.
    wa_fieldcat-seltext_m = 'Source'.
    wa_fieldcat-no_out    = abap_true. " Hide SOURCE column
    wa_fieldcat-outputlen = 10.
    APPEND wa_fieldcat TO rt_fieldcat.

    CLEAR wa_fieldcat.
    wa_fieldcat-fieldname = 'DDLSOURCE_LINK'.
    wa_fieldcat-seltext_m = 'Source Code'.
    wa_fieldcat-edit      = ' '. " Not editable
    APPEND wa_fieldcat TO rt_fieldcat.

  ENDMETHOD.

ENDCLASS.


************************************************************************
* Data Definition
************************************************************************
DATA: exception TYPE REF TO lcx_exception.
DATA: application TYPE REF TO lcl_application.

************************************************************************
AT SELECTION-SCREEN ON p_name.
************************************************************************
  TRY.
    lcl_application=>check_name( p_name ).
  CATCH lcx_exception INTO exception.
    MESSAGE exception->text TYPE 'E'.
  ENDTRY.


************************************************************************
START-OF-SELECTION.
************************************************************************
  application = lcl_application=>get_application( p_up ).
  TRY.
    application->navigate( p_name ).
    PERFORM display_alv.
  CATCH lcx_exception INTO exception.
    MESSAGE exception->text TYPE 'I'.
  ENDTRY.

************************************************************************
* Display ALV
************************************************************************
FORM display_alv.

  DATA(wt_fieldcat) = lcl_application=>get_fieldcat( ).
  DATA(wa_layout) = VALUE slis_layout_alv( colwidth_optimize = abap_true ).
  DATA(wt_dependency) = application->get_dependency( ).

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
       EXPORTING
            i_callback_program      = sy-repid
            i_callback_user_command = 'USER_COMMAND'
            it_fieldcat             = wt_fieldcat[]
            is_layout               = wa_layout
            i_save                  = 'A'
       TABLES
            t_outtab                = wt_dependency
       EXCEPTIONS
            OTHERS                  = 1.

ENDFORM.

************************************************************************
* User command for ALV
************************************************************************
FORM user_command USING p_ucomm LIKE sy-ucomm
                        p_rs_selfield TYPE slis_selfield.
  DATA: wt_dependency TYPE lcl_application=>t_dependency.
  CASE p_ucomm.
  WHEN '&IC1'.
    CASE p_rs_selfield-fieldname.
    WHEN 'DDLSOURCE_LINK'.
      DATA(w_path) = application->get_ddl_path( CONV ddlname( p_rs_selfield-value ) ).
      TRY.
        DATA(w_source) = application->get_ddl_source( CONV ddlname( p_rs_selfield-value ) ).
        cl_demo_output=>display( data = w_source
                                  name = w_path ).
        CATCH lcx_exception INTO exception.
          cl_demo_output=>display( data = lcl_ddic_helper=>get_field_metadata( CONV tabname( p_rs_selfield-value ) )
                                   name = w_path ).
      ENDTRY.
    WHEN 'DDLNAME'.
      TRY.
        application->navigate( CONV ddlname( p_rs_selfield-value ) ).
        PERFORM display_alv.
      CATCH lcx_exception INTO exception.
        MESSAGE exception->text TYPE 'I'.
      ENDTRY.
    ENDCASE.
  ENDCASE.

ENDFORM.