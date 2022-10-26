class ZCL_REFERENCE3IDBYBUSPARTNER definition
  public
  final
  create public .

public section.
  INTERFACES if_amdp_marker_hdb.
  CLASS-METHODS function for table function ZI_Reference3IDByBusPartner.
protected section.
private section.
ENDCLASS.



CLASS ZCL_REFERENCE3IDBYBUSPARTNER IMPLEMENTATION.


  METHOD function by database function
                  for hdb language sqlscript
                  options read-only
                  using bseg bkpf.
     it_data_1 =
       SELECT DISTINCT bseg_1.mandt,
                       bseg_1.xref3,
                       bseg_1.matnr
       FROM bseg AS bseg_1 INNER JOIN bseg AS bseg_2
                                   ON bseg_1.mandt = bseg_2.mandt
                                  AND bseg_1.bukrs = bseg_2.bukrs
                                  AND bseg_1.belnr = bseg_2.belnr
                                  AND bseg_1.gjahr = bseg_2.gjahr
                           INNER JOIN bkpf
                                   ON bseg_1.mandt = bkpf.mandt
                                  AND bseg_1.bukrs = bkpf.bukrs
                                  AND bseg_1.belnr = bkpf.belnr
                                  AND bseg_1.gjahr = bkpf.gjahr
       WHERE bseg_2.h_bstat = ''
         AND bseg_2.koart = 'K'
         AND bseg_2.bschl in ( '21','22','24','31','32','34' )
         AND bseg_1.koart <> 'K'
         AND bseg_1.xref3 <> '';

     it_data_2 =
       SELECT DISTINCT bseg_1.mandt,
                       bseg_1.xref3
       FROM :it_data_1 INNER JOIN bseg AS bseg_1
                               ON :it_data_1.mandt = bseg_1.mandt
                              AND :it_data_1.xref3 = bseg_1.xref3
                       INNER JOIN bseg AS bseg_2
                               ON bseg_1.mandt = bseg_2.mandt
                              AND bseg_1.bukrs = bseg_2.bukrs
                              AND bseg_1.belnr = bseg_2.belnr
                              AND bseg_1.gjahr = bseg_2.gjahr
                              AND bseg_1.ebeln = bseg_2.ebeln
                              AND bseg_1.ebelp = bseg_2.ebelp
                              AND bseg_1.matnr = bseg_2.matnr
       WHERE bseg_1.buzid = 'W'
         AND bseg_2.buzid = 'M'
       GROUP BY bseg_1.mandt, bseg_1.xref3
       HAVING SUM( CASE bseg_2.shkzg
                   WHEN 'H' THEN bseg_2.dmbtr * -1
                   WHEN 'S' THEN bseg_2.dmbtr
                   ELSE bseg_2.dmbtr
                   END ) <> 0;

     it_data_3 =
       SELECT DISTINCT bseg_1.mandt,
                       bseg_1.xref3,
                       bseg_2.bukrs,
                       bseg_2.hkont,
                       bseg_2.kokrs,
                       bseg_2.kostl,
                       RANK ( ) OVER ( PARTITION BY bseg_1.mandt, bseg_1.xref3 ORDER BY bseg_2.h_budat DESC, bseg_2.belnr DESC, bseg_2.buzei DESC ) AS Rank
       FROM :it_data_2 INNER JOIN bseg AS bseg_1
                               ON :it_data_2.mandt = bseg_1.mandt
                              AND :it_data_2.xref3 = bseg_1.xref3
                       INNER JOIN bseg AS bseg_2
                               ON bseg_1.mandt = bseg_2.mandt
                              AND bseg_1.bukrs = bseg_2.bukrs
                              AND bseg_1.belnr = bseg_2.belnr
                              AND bseg_1.gjahr = bseg_2.gjahr
                              AND bseg_1.ebeln = bseg_2.ebeln
                              AND bseg_1.ebelp = bseg_2.ebelp
                              AND bseg_1.matnr = bseg_2.matnr
       WHERE bseg_1.buzid = 'W'
         AND bseg_2.buzid = 'M';

    RETURN
      SELECT mandt,
             xref3 AS Reference3IDByBusinessPartner,
             bukrs AS CompanyCode,
             hkont AS GLAccount,
             kokrs AS ControllingArea,
             kostl AS CostCenter
      FROM :it_data_3
      WHERE Rank = 1;

  ENDMETHOD.
ENDCLASS.