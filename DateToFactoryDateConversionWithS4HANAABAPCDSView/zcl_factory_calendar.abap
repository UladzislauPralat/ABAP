CLASS zcl_factory_calendar DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb.
    CLASS-METHODS function FOR TABLE FUNCTION ZI_FactoryCalendar.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_factory_calendar IMPLEMENTATION.

  METHOD function BY DATABASE FUNCTION
                  FOR HDB LANGUAGE SQLSCRIPT
                  OPTIONS READ-ONLY
                  USING tfacs scal_tt_year scal_tt_date.

--  Kind of unpivot month fields
    tfacs0 =
      SELECT ident, jahr, '01' AS calendarmonth, mon01 AS mon
      FROM tfacs INNER JOIN scal_tt_year AS year
                         ON tfacs.jahr = year.calendaryear
      UNION ALL
      SELECT ident, jahr, '02' AS calendarmonth, mon02 AS mon
      FROM tfacs INNER JOIN scal_tt_year AS year
                         ON tfacs.jahr = year.calendaryear
      UNION ALL
      SELECT ident, jahr, '03' AS calendarmonth, mon03 AS mon
      FROM tfacs INNER JOIN scal_tt_year AS year
                         ON tfacs.jahr = year.calendaryear
      UNION ALL
      SELECT ident, jahr, '04' AS calendarmonth, mon04 AS mon
      FROM tfacs INNER JOIN scal_tt_year AS year
                         ON tfacs.jahr = year.calendaryear
      UNION ALL
      SELECT ident, jahr, '05' AS calendarmonth, mon05 AS mon
      FROM tfacs INNER JOIN scal_tt_year AS year
                         ON tfacs.jahr = year.calendaryear
      UNION ALL
      SELECT ident, jahr, '06' AS calendarmonth, mon06 AS mon
      FROM tfacs INNER JOIN scal_tt_year AS year
                         ON tfacs.jahr = year.calendaryear
      UNION ALL
      SELECT ident, jahr, '07' AS calendarmonth, mon07 AS mon
      FROM tfacs INNER JOIN scal_tt_year AS year
                         ON tfacs.jahr = year.calendaryear
      UNION ALL
      SELECT ident, jahr, '08' AS calendarmonth, mon08 AS mon
      FROM tfacs INNER JOIN scal_tt_year AS year
                         ON tfacs.jahr = year.calendaryear
      UNION ALL
      SELECT ident, jahr, '09' AS calendarmonth, mon09 AS mon
      FROM tfacs INNER JOIN scal_tt_year AS year
                         ON tfacs.jahr = year.calendaryear
      UNION ALL
      SELECT ident, jahr, '10' AS calendarmonth, mon10 AS mon
      FROM tfacs INNER JOIN scal_tt_year AS year
                         ON tfacs.jahr = year.calendaryear
      UNION ALL
      SELECT ident, jahr, '11' AS calendarmonth, mon11 AS mon
      FROM tfacs INNER JOIN scal_tt_year AS year
                         ON tfacs.jahr = year.calendaryear
      UNION ALL
      SELECT ident, jahr, '12' AS calendarmonth, mon12 AS mon
      FROM tfacs INNER JOIN scal_tt_year AS year
                         ON tfacs.jahr = year.calendaryear;

--  Kind of unnest individual dates
    tfacs1 = SELECT ident, date.calendardate, substring(tfacs0.mon, date.calendarday, 1 ) AS weekday
             FROM :tfacs0 AS tfacs0 INNER JOIN scal_tt_date AS date
                                            ON tfacs0.jahr = date.calendaryear
                                           AND tfacs0.calendarmonth = date.calendarmonth;

--  Find previous and next factory dates when weekend / holiday starts
    tfacs2 =
      SELECT ident,
             calendardate,
             weekday,
             CASE WHEN LAG(weekday) OVER (PARTITION BY ident ORDER BY calendardate ASC) <> weekday
                  THEN LAG(calendardate) OVER (PARTITION BY ident ORDER BY calendardate ASC)
                  ELSE NULL
             END AS fac_dat_prev,
             CASE WHEN LEAD(weekday) OVER (PARTITION BY ident ORDER BY calendardate ASC) <> weekday
                  THEN LEAD(calendardate) OVER (PARTITION BY ident ORDER BY calendardate ASC)
                  ELSE NULL
             END AS fac_dat_next
      FROM :tfacs1;

--  Fill previous and next factory dates for all other dates
    tfacs3 =
      SELECT ident,
             calendardate,
             weekday,
             CASE WHEN weekday = '0'
                  THEN MIN(fac_dat_next) OVER ( PARTITION BY ident ORDER BY calendardate ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING )
                  ELSE calendardate
             END AS fac_dat_next,
             CASE WHEN weekday = '0'
                  THEN MAX(fac_dat_prev) OVER ( PARTITION BY ident ORDER BY calendardate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW )
                  ELSE calendardate
             END AS fac_dat_prev
      FROM :tfacs2;

    RETURN
      SELECT ident AS FactoryCalendar,
             calendardate AS CalendarDate,
             CASE WHEN weekday = '0' THEN ' '
                  WHEN weekday = '1' THEN 'X'
             END AS weekday,
             fac_dat_next AS FactoryDate,
             fac_dat_prev AS PreviousFactoryDate
      FROM :tfacs3;

  ENDMETHOD.

ENDCLASS.