*&---------------------------------------------------------------------*
*&  Include           Z_RDA_DAEMON_APPL
*&---------------------------------------------------------------------*

*---------------------------------------------------------------------*
*       CLASS lcl_daemon  DEFINITION
*---------------------------------------------------------------------*
CLASS lcl_daemon DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS:
      f4,
      check.
    METHODS:
      constructor             IMPORTING iv_daemon    TYPE rscrt_demonid
                              RAISING zcx_exception,
      set                     IMPORTING iv_daemon    TYPE rscrt_demonid
                              RAISING zcx_exception,
      start                   RAISING zcx_exception,
      stop                    RAISING zcx_exception,
      monitor                 RAISING zcx_exception,
      get_job_status          RETURNING VALUE(rv_job_status)
                                                     TYPE btcstatus,
      get_status              RETURNING VALUE(rv_status)
                                                     TYPE icon_d
                              RAISING zcx_exception.
    DATA:
      _daemon                 TYPE rscrt_demonid READ-ONLY,
      _daemon_descr           TYPE rscrt_demon_descr READ-ONLY,
      _jobname                TYPE btcjob READ-ONLY,
      _jobcount               TYPE btcjobcnt READ-ONLY.
    CONSTANTS:
      c_job_running           TYPE btcstatus  VALUE 'R',
      c_job_finished          TYPE btcstatus  VALUE 'F',
      c_started               TYPE icon_d     VALUE icon_activate,
      c_stopped               TYPE icon_d     VALUE icon_deactivate,
      c_failed                TYPE icon_d     VALUE icon_failure.

ENDCLASS.


*---------------------------------------------------------------------*
*       CLASS lcl_daemon  IMPLEMENTATION
*---------------------------------------------------------------------*
CLASS lcl_daemon IMPLEMENTATION.

*---------------------------------------------------------------------*
* f4
*---------------------------------------------------------------------*
  METHOD f4.
  TYPES: t_field TYPE TABLE OF help_value.
  TYPES: BEGIN OF s_deamon,
           daemon      TYPE rscrt_rdaobject,
           description TYPE rscrt_demon_descr,
         END OF s_deamon,
         t_deamon TYPE TABLE OF s_deamon.
  TYPES: BEGIN OF value,
           value(40) TYPE c,
         END OF value,
         t_value TYPE TABLE OF value.
  DATA: wa_field TYPE LINE OF t_field,
        wt_field TYPE t_field.
  DATA: wa_value TYPE value,
        wt_value TYPE t_value.
  DATA: w_daemon TYPE rscrt_demonid.
  DATA: wa_daemon TYPE s_deamon,
        wt_daemon TYPE t_deamon.

    SELECT DISTINCT demon description
    INTO TABLE wt_daemon
    FROM rscrt_rda_demon
    WHERE demon <> '00'.
*
    LOOP AT wt_daemon INTO wa_daemon.
      APPEND: wa_daemon-daemon      TO wt_value,
              wa_daemon-description TO wt_value.
    ENDLOOP.
*
    CLEAR wt_field[].
    wa_field-tabname    = 'RSLDPCRTCP'.
    wa_field-fieldname  = 'DEMONID'.
    wa_field-selectflag = 'X'.
    APPEND wa_field TO wt_field.
    CLEAR: wa_field.
    wa_field-tabname    = 'RSCRT_RDA_DEMON'.
    wa_field-fieldname  = 'DESCRIPTION'.
    APPEND wa_field TO wt_field.
    CLEAR: wa_field.
    wa_field-tabname    = 'RSLDPCRTCP'.
    wa_field-fieldname  = 'DEMONID'.
    CALL FUNCTION 'HELP_VALUES_GET_WITH_TABLE'
         EXPORTING
              tabname      = wa_field-tabname
              fieldname    = wa_field-fieldname
         IMPORTING
              select_value = w_daemon
         TABLES
              fields       = wt_field
              valuetab     = wt_value
         EXCEPTIONS
              OTHERS       = 99.
    IF sy-subrc EQ 0.
      p_daemon = w_daemon.
    ENDIF.

  ENDMETHOD.

*---------------------------------------------------------------------*
* check
*---------------------------------------------------------------------*
  METHOD check.
  DATA: w_daemon TYPE rscrt_rdaobject.
  DATA: w_message TYPE string.

    SELECT demon
    INTO w_daemon
    FROM rscrt_rda_demon UP TO 1 ROWS
    WHERE demon = p_daemon.
    ENDSELECT.
    IF sy-subrc <> 0.
      CONCATENATE 'Daemon#' p_daemon INTO w_message.
      CONCATENATE w_message 'does not exist'
        INTO w_message SEPARATED BY SPACE.
      MESSAGE w_message TYPE 'E'.
    ENDIF.

  ENDMETHOD.

*---------------------------------------------------------------------*
* constructor
*---------------------------------------------------------------------*
  METHOD constructor.
  DATA: exception TYPE REF TO zcx_exception.

    TRY.
      set( iv_daemon ).
      CATCH zcx_exception INTO exception.
        MESSAGE exception->text TYPE 'E'.
    ENDTRY.

  ENDMETHOD.

*---------------------------------------------------------------------*
* set
*---------------------------------------------------------------------*
  METHOD set.
  DATA: w_demon TYPE rscrt_rdaobject.
  DATA: w_message TYPE string.

    SELECT demon description jobname jobcount
    INTO (w_demon, _daemon_descr, _jobname, _jobcount)
    FROM rscrt_rda_demon UP TO 1 ROWS
    WHERE demon = iv_daemon.
    ENDSELECT.
    CASE sy-subrc.
    WHEN 0.
      _daemon = w_demon.
    WHEN OTHERS.
      CONCATENATE 'Daemon#' iv_daemon INTO w_message.
      CONCATENATE w_message 'does not exist'
        INTO w_message SEPARATED BY SPACE.
      RAISE EXCEPTION TYPE zcx_exception
        EXPORTING text = w_message.
    ENDCASE.

  ENDMETHOD.

*---------------------------------------------------------------------*
* start
*---------------------------------------------------------------------*
  METHOD start.
  DATA: w_message TYPE string.
* DATA: ws_line TYPE rscrt_demon_monitor.                    "(-)
  DATA: ws_monitor TYPE rscrt_rda_s_monitor.                 "(+)
  DATA: w_refresh TYPE rs_bool.
  DATA: exception TYPE REF TO zcx_exception.

*   Check if daemon already started
    CASE get_status( ).
    WHEN c_started.
      CONCATENATE _daemon_descr 'daemon is already started'
        INTO w_message SEPARATED BY SPACE.
      RAISE EXCEPTION TYPE zcx_exception
        EXPORTING text = w_message.
    WHEN c_failed.
      CONCATENATE _daemon_descr 'daemon failed'
        INTO w_message SEPARATED BY SPACE.
      RAISE EXCEPTION TYPE zcx_exception
        EXPORTING text = w_message.
    ENDCASE.
*   Start daemon
*   ws_line-demonid = _daemon.                               "(-)
    ws_monitor-demonid = _daemon.                            "(+)
    PERFORM start_demon_with_all_ipaks IN PROGRAM rscrt_rda_monitor
*     USING ws_line CHANGING w_refresh.                      "(-)
      USING ws_monitor CHANGING w_refresh.                   "(+)

*   Check if daemon started successfully
    IF get_status( ) = c_failed.
      CONCATENATE 'Failed to start' _daemon_descr 'daemon'
        INTO w_message SEPARATED BY SPACE.
      RAISE EXCEPTION TYPE zcx_exception
        EXPORTING text = w_message.
    ENDIF.

  ENDMETHOD.

*---------------------------------------------------------------------*
* stop
*---------------------------------------------------------------------*
  METHOD stop.
  DATA: w_message TYPE string.
* DATA: ws_line TYPE rscrt_demon_monitor.                    "(-)
  DATA: ws_monitor TYPE rscrt_rda_s_monitor.                 "(+)
  DATA: w_refresh TYPE rs_bool.

*   Check if daemon already stopped or failed
    CASE get_status( ).
    WHEN c_stopped.
      CONCATENATE _daemon_descr 'daemon is already stopped'
        INTO w_message SEPARATED BY SPACE.
      RAISE EXCEPTION TYPE zcx_exception
        EXPORTING text = w_message.
    WHEN c_failed.
      CONCATENATE _daemon_descr 'daemon is already stopped'
        INTO w_message SEPARATED BY SPACE.
      RAISE EXCEPTION TYPE zcx_exception
        EXPORTING text = w_message.
    ENDCASE.
*   Trigger Daemon stop
*   ws_line-demonid = _daemon.                               "(-)
    ws_monitor-demonid = _daemon.                            "(+)
    PERFORM demon_stop IN PROGRAM rscrt_rda_monitor
*     USING ws_line CHANGING w_refresh.                      "(-)
      USING ws_monitor CHANGING w_refresh.                   "(+)

*   Wait till job finishes
    WHILE get_job_status( ) = c_job_running.
       WAIT UP TO 5 SECONDS.
    ENDWHILE.

  ENDMETHOD.

*---------------------------------------------------------------------*
* monitor
*---------------------------------------------------------------------*
  METHOD monitor.
  DATA: wa_monitor_data TYPE rscrt_demon_monitor,
        wt_monitor_data TYPE rscrt_demon_monitor_t.
  DATA: w_message TYPE string.

*   Check if daemon is stopped
    CASE get_status( ).
    WHEN c_stopped.
      CONCATENATE _daemon_descr 'daemon is stopped'
        INTO w_message SEPARATED BY SPACE.
    WHEN c_failed.
      CONCATENATE _daemon_descr 'daemon failed'
        INTO w_message SEPARATED BY SPACE.
    WHEN c_started.
*     Check DTPs and InfoPackages
      CALL FUNCTION 'RSCRT_RDA_GET_MONITOR_DATA'
           IMPORTING
              e_t_data = wt_monitor_data.
      READ TABLE wt_monitor_data INTO wa_monitor_data
      WITH KEY demonid = _daemon status = icon_red_light.
      CASE sy-subrc.
      WHEN 0.
        CONCATENATE _daemon_descr 'daemon is running, but some'
          'InfoPackage(s) and/or DTP(s) failed'
          INTO w_message SEPARATED BY SPACE.
      WHEN OTHERS.
        READ TABLE wt_monitor_data INTO wa_monitor_data
        WITH KEY demonid = _daemon status = icon_light_out.
        CASE sy-subrc.
        WHEN 0.
          CONCATENATE _daemon_descr 'daemon is running, but some'
            'InfoPackage(s) and/or DTP(s) are not running'
            INTO w_message SEPARATED BY SPACE.
        WHEN OTHERS.
          EXIT.
        ENDCASE.
      ENDCASE.
    ENDCASE.
    RAISE EXCEPTION TYPE zcx_exception
       EXPORTING text = w_message.
  ENDMETHOD.

*---------------------------------------------------------------------*
* get_job_status
*---------------------------------------------------------------------*
  METHOD get_job_status.
  DATA: w_jobname  TYPE btcjob,
        w_jobcount TYPE btcjobcnt.

    CALL FUNCTION 'BP_JOB_CHECKSTATE'
         EXPORTING
              dialog   = 'N'
              jobcount = _jobcount
              jobname  = _jobname
         IMPORTING
                actual_status = rv_job_status.

  ENDMETHOD.

*---------------------------------------------------------------------*
* get_status
*---------------------------------------------------------------------*
  METHOD get_status.
  DATA: wa_monitor_data TYPE rscrt_demon_monitor,
        wt_monitor_data TYPE rscrt_demon_monitor_t.

    CALL FUNCTION 'RSCRT_RDA_GET_MONITOR_DATA'
         IMPORTING
              e_t_data = wt_monitor_data.
    READ TABLE wt_monitor_data INTO wa_monitor_data
      WITH KEY demonid = _daemon.
    IF sy-subrc = 0.
      rv_status = wa_monitor_data-demon_running.
    ENDIF.

  ENDMETHOD.

ENDCLASS.