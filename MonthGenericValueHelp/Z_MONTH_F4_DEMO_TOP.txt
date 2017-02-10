*&---------------------------------------------------------------------*
*&  Include           Z_MONTH_F4_DEMO_TOP
*&---------------------------------------------------------------------*

************************************************************************
* Data Definitions                                                     *
************************************************************************
DATA: w_month TYPE rsfiscper6.

************************************************************************
* Selection Screen
************************************************************************
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 1(30) c_month FOR FIELD s_month.
SELECT-OPTIONS s_month FOR w_month NO-EXTENSION OBLIGATORY.
SELECTION-SCREEN END OF LINE.