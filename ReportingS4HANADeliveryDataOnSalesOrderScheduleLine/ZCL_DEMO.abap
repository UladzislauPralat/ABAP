class ZCL_DEMO definition
  public
  final
  create public .

public section.
  INTERFACES if_amdp_marker_hdb.
  CLASS-METHODS function for table function zi_demo.
protected section.
private section.
ENDCLASS.



CLASS ZCL_DEMO IMPLEMENTATION.

  METHOD function by database function
                  for hdb language sqlscript
                  options read-only
                  using vbak vbap vbep likp lips.

    it_lips =
       SELECT lips.mandt, lips.vgbel AS vbeln, lips.vgpos AS posnr,
              SUM( CASE likp.vbtyp WHEN 'J'
                                   THEN lips.lfimg
                                   WHEN 'T'
                                   THEN lips.lfimg * -1
                   END ) AS lfimg
       FROM likp INNER JOIN lips
                         ON likp.mandt = lips.mandt
                        AND likp.vbeln = lips.vbeln
       GROUP BY lips.mandt, lips.vgbel, lips.vgpos;

    it_data_1 =
      SELECT vbak.mandt,
             vbak.vbeln,
             vbap.posnr,
             vbep.etenr,
             vbap.matnr,
             vbep.edatu,
                CASE WHEN vbak.vbtyp IN ( 'H', 'K' )
                        THEN vbep.wmeng * -1
                        ELSE vbep.wmeng END AS wmeng,
             CASE WHEN vbak.vbtyp IN ( 'H', 'K' )
                        THEN vbep.bmeng * -1
                        ELSE vbep.bmeng END AS bmeng,
             lips.lfimg AS lfimg_t
      FROM vbak INNER JOIN vbap
                        ON vbak.mandt = vbap.mandt
                       AND vbak.vbeln = vbap.vbeln
                INNER JOIN vbep
                        ON vbap.mandt = vbep.mandt
                       AND vbap.vbeln = vbep.vbeln
                       AND vbap.posnr = vbep.posnr
           LEFT OUTER JOIN :it_lips AS lips
                        ON vbap.mandt = lips.mandt
                       AND vbap.vbeln = lips.vbeln
                       AND vbap.posnr = lips.posnr;

    it_data_2 =
      SELECT mandt,
             vbeln,
             posnr,
             etenr,
             matnr,
             edatu,
             wmeng,                                                                              /* Order Qty (Sched Line) */
             bmeng,                                                                              /* Confirmed Qty (Sched Line) */
             SUM( bmeng ) OVER ( PARTITION BY mandt, vbeln, posnr ORDER BY edatu ) AS bmeng_rt,  /* Confirmed Qty (Sched Line) Running Total */
             lfimg_t                                                                             /* Delivery Qty Total */
      FROM :it_data_1;

    RETURN
      SELECT mandt,
             vbeln,
             posnr,
             etenr,
             matnr,
             wmeng,                                          /* Order Qty (Sched Line) */
             bmeng,                                          /* Confirmed Qty (Sched Line) */
             bmeng_rt,                                       /* Confirmed Qty (Sched Line) Running Total */
             CASE WHEN bmeng = 0
                  THEN 0
                  WHEN lfimg_t > bmeng_rt
                  THEN bmeng
                  WHEN lfimg_t  >= ( bmeng_rt - bmeng )
                  THEN lfimg_t -  ( bmeng_rt - bmeng )
                  ELSE 0
             END AS lfimg,                                   /* Delivered Qty */
             lfimg_t                                         /* Delivered Qty Total */
      FROM :it_data_2;


  ENDMETHOD.

ENDCLASS.