REPORT z_rda_daemon_stop.

INCLUDE z_rda_daemon_top.
INCLUDE z_rda_daemon_appl.


************************************************************************
INITIALIZATION.
************************************************************************
c_daemon = 'Daemon'.

************************************************************************
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_daemon.
************************************************************************
CALL METHOD lcl_daemon=>f4.

************************************************************************
AT SELECTION-SCREEN ON p_daemon.
************************************************************************
CALL METHOD lcl_daemon=>check.

************************************************************************
START-OF-SELECTION.
************************************************************************
DATA: exception TYPE REF TO zcx_exception.
DATA: daemon TYPE REF TO lcl_daemon.

  TRY.
    CREATE OBJECT daemon EXPORTING iv_daemon = p_daemon.
    daemon->stop( ).
    CATCH zcx_exception INTO exception.
      MESSAGE exception->text TYPE 'E'.
      EXIT.
  ENDTRY.