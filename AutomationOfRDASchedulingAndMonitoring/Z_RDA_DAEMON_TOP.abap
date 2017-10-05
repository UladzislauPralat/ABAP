*&---------------------------------------------------------------------*
*&  Include           Z_RDA_DAEMON_START_TOP
*&---------------------------------------------------------------------*

************************************************************************
* Types
************************************************************************
TYPE-POOLS: abap,
            icon.

************************************************************************
* Selection Screen
************************************************************************
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 1(7) c_daemon FOR FIELD p_daemon.
SELECTION-SCREEN POSITION 35.
PARAMETERS: p_daemon TYPE rscrt_demonid OBLIGATORY.
SELECTION-SCREEN END OF LINE.