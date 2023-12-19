CLASS zcl_inventory_aging DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

PUBLIC SECTION.
  INTERFACES if_amdp_marker_hdb.
  CLASS-METHODS FUNCTION FOR TABLE FUNCTION ZI_InventoryAgingFunc.
PROTECTED SECTION.
PRIVATE SECTION.
ENDCLASS.



CLASS zcl_inventory_aging IMPLEMENTATION.


  METHOD function BY DATABASE FUNCTION
                  FOR HDB LANGUAGE SQLSCRIPT
                  OPTIONS READ-ONLY
                  USING matdoc acdoca_m_extract finsv_curtp_ml mbew ckmlcr fmlt_curtp_ml mbewh t001k t001.

/*  Material Valuation Current */
    v_ml_acdoc_ex_ul_ddl =
      SELECT acdoca_m_extract.rclnt,
             acdoca_m_extract.rldnr,
             acdoca_m_extract.rbukrs,
             acdoca_m_extract.kalnr,
             acdoca_m_extract.matnr,
             acdoca_m_extract.bwkey,
             acdoca_m_extract.bwtar,
             acdoca_m_extract.ml_sobkz,
             acdoca_m_extract.ml_kdauf,
             acdoca_m_extract.ml_kdpos,
             acdoca_m_extract.ml_lifnr,
             acdoca_m_extract.ml_pspnr,
             SUM(acdoca_m_extract.vmsl) AS vmsl,
             SUM(acdoca_m_extract.hsl) AS hsl,
             SUM(acdoca_m_extract.ksl) AS ksl,
             SUM(acdoca_m_extract.osl) AS osl,
             SUM(acdoca_m_extract.vsl) AS vsl,
             SUM(acdoca_m_extract.hvkwrt) AS hvkwrt
      FROM acdoca_m_extract INNER JOIN finsv_curtp_ml AS mapp
                                    ON  acdoca_m_extract.rbukrs = mapp.rbukrs
                                   AND mapp.curtp               = '10'
                                   AND acdoca_m_extract.rldnr   = mapp.rldnr
                                   AND acdoca_m_extract.rclnt   = mapp.mandt
      WHERE fiscyearper = '9999999'
        AND ryear       = '9999'
        AND poper       = '999'
      GROUP BY rclnt,
               acdoca_m_extract.rldnr,
               acdoca_m_extract.rbukrs,
               kalnr,
               matnr,
               bwkey,
               bwtar,
               ml_sobkz,
               ml_kdauf,
               ml_kdpos,
               ml_lifnr,
               ml_pspnr;

    v_ml_acdoc_ex_ul_ddl =
      SELECT acdoca_m_extract.rclnt,
             acdoca_m_extract.rldnr,
             acdoca_m_extract.rbukrs,
             acdoca_m_extract.kalnr,
             acdoca_m_extract.matnr,
             acdoca_m_extract.bwkey,
             acdoca_m_extract.bwtar,
             acdoca_m_extract.ml_sobkz,
             acdoca_m_extract.ml_kdauf,
             acdoca_m_extract.ml_kdpos,
             acdoca_m_extract.ml_lifnr,
             acdoca_m_extract.ml_pspnr,
             SUM(acdoca_m_extract.vmsl) AS vmsl,
             SUM(acdoca_m_extract.hsl) AS hsl,
             SUM(acdoca_m_extract.ksl) AS ksl,
             SUM(acdoca_m_extract.osl) AS osl,
             SUM(acdoca_m_extract.vsl) AS vsl,
             SUM(acdoca_m_extract.hvkwrt) AS hvkwrt
      FROM acdoca_m_extract INNER JOIN finsv_curtp_ml AS mapp
                                    ON acdoca_m_extract.rbukrs = mapp.rbukrs
                                   AND mapp.curtp              = '10'
                                   AND acdoca_m_extract.rldnr  = mapp.rldnr
                                   AND acdoca_m_extract.rclnt  = mapp.mandt
      WHERE fiscyearper = '9999999'
        AND ryear       = '9999'
        AND poper       = '999'
      GROUP BY rclnt,
               acdoca_m_extract.rldnr,
               acdoca_m_extract.rbukrs,
               kalnr,
               matnr,
               bwkey,
               bwtar,
               ml_sobkz,
               ml_kdauf,
               ml_kdpos,
               ml_lifnr,
               ml_pspnr;

    mbv_mbew_base =
      SELECT m.mandt,
             m.matnr,
             m.bwkey,
             m.bwtar,
             kaln1,
             /*LBKUM from acdoca extract table */
             COALESCE(u.vmsl, 0) AS lbkum,
             /*SALK3 from acdoca extract table */
             COALESCE(u.hsl, 0) AS salk3,
             lvorm,
             m.vprsv,
             verpr,
             m.stprs,
             m.peinh,
             bklas,
             /*SALKV from CR table  */
             COALESCE(cr.salkv, 0) AS salkv,
             vmkum,
             vmsal,
             vmvpr,
             vmver,
             vmstp,
             vmpei,
             vmbkl,
             vmsav,
             vjkum,
             vjsal,
             vjvpr,
             vjver,
             vjstp,
             vjpei,
             vjbkl,
             vjsav,
             lfgja,
             lfmon,
             bwtty,
             stprv,
             laepr,
             zkprs,
             zkdat,
             timestamp,
             bwprs,
             bwprh,
             vjbws,
             vjbwh,
             vvjsl,
             vvjlb,
             vvmlb,
             vvsal,
             zplpr,
             zplp1,
             zplp2,
             zplp3,
             zpld1,
             zpld2,
             zpld3,
             pperz,
             pperl,
             pperv,
             kalkz,
             kalkl,
             kalkv,
             kalsc,
             xlifo,
             mypol,
             bwph1,
             bwps1,
             abwkz,
             pstat,
             m.kalnr,
             bwva1,
             bwva2,
             bwva3,
             vers1,
             vers2,
             vers3,
             hrkft,
             kosgr,
             pprdz,
             pprdl,
             pprdv,
             pdatz,
             pdatl,
             pdatv,
             ekalr,
             vplpr,
             mlmaa,
             mlast,
             lplpr,
            /*VKSAL from acdoca extract table*/
             COALESCE(u.hvkwrt, 0) AS vksal,
             hkmat,
             sperw,
             kziwl,
             wlinl,
             abciw,
             bwspa,
             lplpx,
             vplpx,
             fplpx,
             lbwst,
             vbwst,
             fbwst,
             eklas,
             qklas,
             mtuse,
             mtorg,
             ownpr,
             xbewm,
             bwpei,
             mbrue,
             oklas,
             dummy_val_incl_eew_ps
      FROM mbew as m LEFT OUTER JOIN :v_ml_acdoc_ex_ul_ddl as u
                                  ON  u.kalnr = m.kaln1
                                 AND u.rclnt = m.mandt
                                 AND u.matnr = m.matnr  /*MATNR and BWKEY are added due to performance reason*/
                                 AND u.bwkey = m.bwkey  /*see SAP note 2505119*/
                     LEFT OUTER JOIN ckmlcr AS cr
                                  ON  cr.mandt = m.mandt
                                 AND cr.kalnr = m.kaln1
                                 AND cr.bdatj = m.lfgja
                                 AND cr.poper = concat( '0', m.lfmon )
                                 AND cr.untper = '000'
                                 AND cr.curtp = '10';
    mbv_mbew_mother_segment =
      SELECT m.mandt,
             m.matnr,
             m.bwkey,
             m.bwtar,
             m.lvorm,
             CAST(SUM(vmsl) AS DEC(13,3)) AS lbkum,
             CAST(SUM(hsl) AS DEC(13,2)) AS salk3,
             m.vprsv,
             m.verpr,
             m.stprs,
             m.peinh,
             m.bklas,
             m.vmkum,
             m.vmsal,
             m.vmvpr,
             m.vmver,
             m.vmstp,
             m.vmpei,
             m.vmbkl,
             m.vmsav,
             m.vjkum,
             m.vjsal,
             m.vjvpr,
             m.vjver,
             m.vjstp,
             m.vjpei,
             m.vjbkl,
             m.vjsav,
             m.lfgja,
             m.lfmon,
             m.bwtty,
             m.stprv,
             m.laepr,
             m.zkprs,
             m.zkdat,
             m.timestamp,
             m.bwprs,
             m.bwprh,
             m.vjbws,
             m.vjbwh,
             m.vvjsl,
             m.vvjlb,
             m.vvmlb,
             m.vvsal,
             m.zplpr,
             m.zplp1,
             m.zplp2,
             m.zplp3,
             m.zpld1,
             m.zpld2,
             m.zpld3,
             m.pperz,
             m.pperl,
             m.pperv,
             m.kalkz,
             m.kalkl,
             m.kalkv,
             m.kalsc,
             m.xlifo,
             m.mypol,
             m.bwph1,
             m.bwps1,
             m.abwkz,
             m.pstat,
             m.kaln1,
             m.kalnr,
             m.bwva1,
             m.bwva2,
             m.bwva3,
             m.vers1,
             m.vers2,
             m.vers3,
             m.hrkft,
             m.kosgr,
             m.pprdz,
             m.pprdl,
             m.pprdv,
             m.pdatz,
             m.pdatl,
             m.pdatv,
             m.ekalr,
             m.vplpr,
             m.mlmaa,
             m.mlast,
             m.lplpr,
             CAST(SUM(hvkwrt) AS DEC(13,2)) AS vksal,
             m.hkmat,
             m.sperw,
             m.kziwl,
             m.wlinl,
             m.abciw,
             m.bwspa,
             m.lplpx,
             m.vplpx,
             m.fplpx,
             m.lbwst,
             m.vbwst,
             m.fbwst,
             m.eklas,
             m.qklas,
             m.mtuse,
             m.mtorg,
             m.ownpr,
             m.xbewm,
             m.bwpei,
             m.mbrue,
             m.oklas,
             m.dummy_val_incl_eew_ps,
             /*Joint Venture*/
             m.oippinv
      FROM mbew as m LEFT OUTER JOIN :v_ml_acdoc_ex_ul_ddl as u
                                  ON u.matnr  = m.matnr
                                 AND u.bwkey    = m.bwkey
                                 AND u.ml_sobkz = ''
                                 AND u.rclnt    = m.mandt
      WHERE bwtty != ''
        AND m.bwtar = '' /*Mother segment*/
      GROUP BY mandt,
               m.matnr,
               m.bwkey,
               m.bwtar,
               m.lvorm,
               m.vprsv,
               m.verpr,
               m.stprs,
               m.peinh,
               m.bklas,
               m.vmkum,
               m.vmsal,
               m.vmvpr,
               m.vmver,
               m.vmstp,
               m.vmpei,
               m.vmbkl,
               m.vmsav,
               m.vjkum,
               m.vjsal,
               m.vjvpr,
               m.vjver,
               m.vjstp,
               m.vjpei,
               m.vjbkl,
               m.vjsav,
               m.lfgja,
               m.lfmon,
               m.bwtty,
               m.stprv,
               m.laepr,
               m.zkprs,
               m.zkdat,
               m.timestamp,
               m.bwprs,
               m.bwprh,
               m.vjbws,
               m.vjbwh,
               m.vvjsl,
               m.vvjlb,
               m.vvmlb,
               m.vvsal,
               m.zplpr,
               m.zplp1,
               m.zplp2,
               m.zplp3,
               m.zpld1,
               m.zpld2,
               m.zpld3,
               m.pperz,
               m.pperl,
               m.pperv,
               m.kalkz,
               m.kalkl,
               m.kalkv,
               m.kalsc,
               m.xlifo,
               m.mypol,
               m.bwph1,
               m.bwps1,
               m.abwkz,
               m.pstat,
               m.kaln1,
               m.kalnr,
               m.bwva1,
               m.bwva2,
               m.bwva3,
               m.vers1,
               m.vers2,
               m.vers3,
               m.hrkft,
               m.kosgr,
               m.pprdz,
               m.pprdl,
               m.pprdv,
               m.pdatz,
               m.pdatl,
               m.pdatv,
               m.ekalr,
               m.vplpr,
               m.mlmaa,
               m.mlast,
               m.lplpr,
               m.hkmat,
               m.sperw,
               m.kziwl,
               m.wlinl,
               m.abciw,
               m.bwspa,
               m.lplpx,
               m.vplpx,
               m.fplpx,
               m.lbwst,
               m.vbwst,
               m.fbwst,
               m.eklas,
               m.qklas,
               m.mtuse,
               m.mtorg,
               m.ownpr,
               m.xbewm,
               m.bwpei,
               m.mbrue,
               m.oklas,
               m.dummy_val_incl_eew_ps,
               /*Joint Venture*/
              m.oippinv;

    mbv_mbew =
      SELECT b.mandt,
             b.matnr,
             b.bwkey,
             b.bwtar,
             b.lvorm,
             /*LBKUM*/
             CAST(CASE WHEN b.bwtar = '' AND b.bwtty != ''
                       THEN mother.lbkum /* Mother Segment*/
                       ELSE b.lbkum
                   END AS DEC(13,3)) AS lbkum,
             /*SALK3*/
             CAST(CASE WHEN b.bwtar = '' AND b.bwtty != ''
                       THEN mother.salk3 /* Mother Segment */
                       ELSE b.salk3
                  END as DEC(13,2)) AS salk3,
             b.vprsv,
             b.verpr,
             b.stprs,
             b.peinh,
             b.bklas,
             /*SALKV*/
             CAST(b.salkv AS DEC(13,2)) AS salkv,
             b.vmkum,
             b.vmsal,
             b.vmvpr,
             b.vmver,
             b.vmstp,
             b.vmpei,
             b.vmbkl,
             b.vmsav,
             b.vjkum,
             b.vjsal,
             b.vjvpr,
             b.vjver,
             b.vjstp,
             b.vjpei,
             b.vjbkl,
             b.vjsav,
             b.lfgja,
             b.lfmon,
             b.bwtty,
             b.stprv,
             b.laepr,
             b.zkprs,
             b.zkdat,
             b.timestamp,
             b.bwprs,
             b.bwprh,
             b.vjbws,
             b.vjbwh,
             b.vvjsl,
             b.vvjlb,
             b.vvmlb,
             b.vvsal,
             b.zplpr,
             b.zplp1,
             b.zplp2,
             b.zplp3,
             b.zpld1,
             b.zpld2,
             b.zpld3,
             b.pperz,
             b.pperl,
             b.pperv,
             b.kalkz,
             b.kalkl,
             b.kalkv,
             b.kalsc,
             b.xlifo,
             b.mypol,
             b.bwph1,
             b.bwps1,
             b.abwkz,
             b.pstat,
             b.kaln1,
             b.kalnr,
             b.bwva1,
             b.bwva2,
             b.bwva3,
             b.vers1,
             b.vers2,
             b.vers3,
             b.hrkft,
             b.kosgr,
             b.pprdz,
             b.pprdl,
             b.pprdv,
             b.pdatz,
             b.pdatl,
             b.pdatv,
             b.ekalr,
             b.vplpr,
             b.mlmaa,
             b.mlast,
             b.lplpr,
             /*VKSAL*/
             CAST( CASE WHEN b.bwtar = '' AND b.bwtty != ''
                        THEN mother.vksal /* Mother Segment*/
                        ELSE b.vksal
                   END AS  DEC(13,2)) AS vksal,
             b.hkmat,
             b.sperw,
             b.kziwl,
             b.wlinl,
             b.abciw,
             b.bwspa,
             b.lplpx,
             b.vplpx,
             b.fplpx,
             b.lbwst,
             b.vbwst,
             b.fbwst,
             b.eklas,
             b.qklas,
             b.mtuse,
             b.mtorg,
             b.ownpr,
             b.xbewm,
             b.bwpei,
             b.mbrue,
             b.oklas,
             mbew.dummy_val_incl_eew_ps,
             /*Joint venture*/
             mbew.oippinv
      FROM  mbew LEFT OUTER JOIN :mbv_mbew_base AS b
                              ON  mbew.kalnr = b.kalnr
                             AND mbew.mandt = b.mandt
                             AND mbew.matnr = b.matnr  /*MATNR and BWKEY are added due to performance reason*/
                             AND mbew.bwkey = b.bwkey  /*see SAP note 2505119*/
                 LEFT OUTER JOIN :mbv_mbew_mother_segment AS mother
                              ON  mother.matnr = b.matnr
                             AND mother.bwkey = b.bwkey
                             AND mother.mandt = b.mandt;

/* Material Valuation History */
    fins_curtp_ml =
      SELECT mandt,
             rbukrs,
             curtp,
             rldnr,
             rcolumn
      FROM fmlt_curtp_ml;

    v_ml_acdoc_ex_ag_ddl =
      SELECT acdoca_m_extract.rclnt,
             acdoca_m_extract.rldnr,
             acdoca_m_extract.rbukrs,
             acdoca_m_extract.kalnr,
             acdoca_m_extract.fiscyearper,
             acdoca_m_extract.ryear,
             acdoca_m_extract.poper,
             acdoca_m_extract.matnr,
             acdoca_m_extract.bwkey,
             acdoca_m_extract.bwtar,
             acdoca_m_extract.ml_sobkz,
             acdoca_m_extract.ml_kdauf,
             acdoca_m_extract.ml_kdpos,
             acdoca_m_extract.ml_lifnr,
             acdoca_m_extract.ml_pspnr,
             SUM(acdoca_m_extract.vmsl)   AS vmsl,
             SUM(acdoca_m_extract.hsl)    AS hsl,
             SUM(acdoca_m_extract.ksl)    AS ksl,
             SUM(acdoca_m_extract.osl)    AS osl,
             SUM(acdoca_m_extract.vsl)    AS vsl,
             SUM(acdoca_m_extract.hvkwrt) AS hvkwrt
      FROM  acdoca_m_extract INNER JOIN finsv_curtp_ml AS mapp ON acdoca_m_extract.rbukrs = mapp.rbukrs
                                                              AND mapp.curtp              = '10'
                                                              AND acdoca_m_extract.rldnr  = mapp.rldnr
                                                              AND acdoca_m_extract.rclnt  = mapp.mandt
      GROUP BY rclnt,
               acdoca_m_extract.rldnr,
               acdoca_m_extract.rbukrs,
               kalnr,
               fiscyearper,
               ryear,
               poper,
               matnr,
               bwkey,
               bwtar,
               ml_sobkz,
               ml_kdauf,
               ml_kdpos,
               ml_lifnr,
               ml_pspnr;

    mbv_mbewh_base =
      SELECT mbewh.mandt,
             mbewh.matnr,
             mbewh.bwkey,
             mbewh.bwtar,
             mbewh.lfgja,
             mbewh.lfmon,
--           LBKUM from acdoca extract table
             SUM(CASE WHEN ext.vmsl IS NULL THEN 0
                      ELSE ext.vmsl
                 END) AS lbkum,
--           SALK3 from acdoca extract table
             SUM(CASE WHEN ext.hsl IS NULL THEN 0
                      ELSE ext.hsl
                 END ) AS salk3,
             mbewh.vprsv,
             mbewh.verpr,
             mbewh.stprs,
             mbewh.peinh,
             mbewh.bklas,
--           BWTTY from mbew
             mbew.bwtty,
--           SALKV from CR table
             COALESCE(cr.salkv, 0) AS salkv,
--           VKSAL from acdoca extract table
             SUM(CASE WHEN ext.hvkwrt IS NULL THEN 0
                 ELSE ext.hvkwrt
                 END ) AS vksal
--               MBEW for BWTTY (Split valuation)
      FROM mbewh LEFT OUTER JOIN mbew ON mbew.matnr = mbewh.matnr
                                     AND mbew.bwkey = mbewh.bwkey
                                     AND mbew.bwtar = mbewh.bwtar
                                     AND mbew.mandt = mbewh.mandt
--               Extract for LBKUM, SALK3, VKSAL
                 LEFT OUTER JOIN :v_ml_acdoc_ex_ag_ddl AS ext ON  ext.kalnr   = mbew.kaln1
                                                             AND mbewh.mandt = ext.rclnt
                                                             AND mbewh.matnr = ext.matnr  --MATNR and BWKEY are added due to performance reason,
                                                             AND mbewh.bwkey = ext.bwkey  --see SAP note 2505119
                                                             AND (ext.fiscyearper > CONCAT(mbewh.lfgja, CONCAT('0', mbewh.lfmon) ) )
--              CR for SALKV
                 LEFT OUTER JOIN ckmlcr AS cr ON cr.mandt = mbew.mandt
                                             AND cr.kalnr = mbew.kaln1
                                             AND cr.bdatj = mbewh.lfgja
                                             AND cr.poper = CONCAT('0', mbewh.lfmon)
                                             AND cr.untper = '000'
                                             AND cr.curtp = '10'
      GROUP BY mbewh.mandt,
               mbewh.matnr,
               mbewh.bwkey,
               mbewh.bwtar,
               mbewh.lfgja,
               mbewh.lfmon,
               mbewh.vprsv,
               mbewh.verpr,
               mbewh.stprs,
               mbewh.peinh,
               mbewh.bklas,
               mbew.bwtty,
               cr.salkv;

    mbv_mbewh_mother_segment =
      SELECT mh.mandt,
             mh.matnr,
             mh.bwkey,
             mh.bwtar,
             mh.lfgja,
             mh.lfmon,
             CAST(SUM(vmsl) AS DEC(13,3)) AS lbkum,
             CAST(SUM(hsl) AS DEC(13,2)) AS salk3,
             mh.vprsv,
             mh.verpr,
             mh.stprs,
             mh.peinh,
             mh.bklas,
             CAST(SUM(hvkwrt) AS DEC(13,2)) AS vksal
      FROM mbewh mh LEFT OUTER JOIN mbew m ON  m.matnr = mh.matnr
                                          AND m.bwkey = mh.bwkey
                                          AND m.bwtar = mh.bwtar
                                          AND m.mandt = mh.mandt
                    LEFT OUTER JOIN :v_ml_acdoc_ex_ag_ddl AS ext ON ext.rclnt = mh.mandt
                                                                AND ext.matnr    = mh.matnr
                                                                AND ext.bwkey    = mh.bwkey
                                                                AND ext.ml_sobkz = ''
                                                                AND (ext.fiscyearper > concat(mh.lfgja, CONCAT('0', mh.lfmon)))
      WHERE bwtty != ''
        AND mh.bwtar = ''
      GROUP BY mh.mandt,
               mh.matnr,
               mh.bwkey,
               mh.bwtar,
               mh.lfgja,
               mh.lfmon,
               mh.vprsv,
               mh.verpr,
               mh.stprs,
               mh.peinh,
               mh.bklas;

    mbv_mbewh =
      SELECT base.mandt,
             base.matnr,
             base.bwkey,
             base.bwtar,
             base.lfgja,
             base.lfmon,
--           LBKUM
             CAST(CASE WHEN base.bwtar = '' AND base.bwtty != '' THEN mother.lbkum -- Mother Segment
                  ELSE base.lbkum
                  END AS DEC(13,3)) AS lbkum,
--           SALK3
             CAST(CASE WHEN base.bwtar = '' AND base.bwtty != '' THEN mother.salk3 -- Mother Segment
                  ELSE base.salk3
                  END AS DEC(13,2)) AS salk3,
            base.vprsv,
            base.verpr,
            base.stprs,
            base.peinh,
            base.bklas,
--          SALKV
            CAST(base.salkv AS DEC(13,2)) AS salkv,
--          VKSAL
            CAST(CASE WHEN base.bwtar = '' AND bwtty != '' THEN mother.vksal -- Mother Segment
                 ELSE base.vksal
                 END AS DEC(13,2)) AS vksal
           FROM :mbv_mbewh_base AS base LEFT OUTER JOIN :mbv_mbewh_mother_segment AS mother ON mother.matnr = base.matnr
                                                                                           AND mother.bwkey = base.bwkey
                                                                                           AND mother.lfgja = base.lfgja
                                                                                           AND mother.lfmon = base.lfmon
                                                                                           AND mother.mandt = base.mandt;

/*  Material Valuation */
    mbew =
      SELECT mandt, matnr, bwkey, bwtar, salk3, lbkum, date_from, date_to
      FROM ( SELECT mandt, matnr, bwkey, bwtar, salk3, lbkum,
             CASE WHEN date_from = CAST('00010101' AS DATE) OR date_from = CAST('99991231' AS date ) THEN date_from ELSE ADD_DAYS(date_from,1) END AS date_from, date_to
             FROM ( SELECT mandt, matnr, bwkey, bwtar, salk3, lbkum,
                   LAG(date_to,1,CAST('00010101' AS DATE)) OVER ( PARTITION BY mandt, bwkey, matnr ORDER BY date_to ASC) AS date_from, date_to
                   FROM ( SELECT mandt, matnr, bwkey, bwtar, salk3, lbkum, CAST('99991231' AS DATE ) AS date_to
                          FROM :mbv_mbew AS mbew
                          UNION ALL
                          SELECT mandt, matnr, bwkey, bwtar, salk3, lbkum, ADD_DAYS(ADD_MONTHS(CAST(CONCAT(CONCAT(lfgja,lfmon),'01') AS DATE),1),-1) AS date_to
                          FROM :mbv_mbewh AS mbewh ) ) )
      WHERE date_from <= :P_Current_Date
        AND date_to >= :P_Current_Date;

/*  Inventory */
    inventory_flow =
      SELECT matdoc.mandt,
             inventory_flow.werks, inventory_flow.lgort, inventory_flow.sobkz, inventory_flow.kunnr_sid, inventory_flow.lifnr, inventory_flow.kzbws, inventory_flow.mat_kdauf, inventory_flow.mat_kdpos,
             matdoc.matnr, matdoc.lbbsa_sid, matdoc.budat, matdoc.shkzg, matdoc.meins, matdoc.menge
      FROM ( SELECT mandt, mblnr, mjahr,
             werks,
             CAST(CASE WHEN P_Internal_Flow_Elimination = 'Y' THEN '' ELSE lgort END AS NVARCHAR( 4 )) AS lgort,
             sobkz,
             CAST(CASE WHEN sobkz = 'W' THEN kunnr_sid ELSE '' END AS NVARCHAR( 10 )) AS kunnr_sid,
             CAST(CASE WHEN sobkz IN ( 'O', 'K' ) THEN lifnr     ELSE '' END AS NVARCHAR( 10 )) AS lifnr,
             CAST(CASE WHEN sobkz IN ( 'E', 'T' ) THEN kzbws     ELSE '' END AS NVARCHAR( 1 )) AS kzbws,
             CAST(CASE WHEN sobkz IN ( 'E', 'T' ) THEN mat_kdauf ELSE '' END AS NVARCHAR( 10 )) AS mat_kdauf,
             CAST(CASE WHEN sobkz IN ( 'E', 'T' ) THEN mat_kdpos ELSE '' END AS NVARCHAR( 6 )) AS mat_kdpos,
             matnr, lbbsa_sid, SUM( CASE WHEN shkzg = 'S' THEN menge WHEN shkzg = 'H' THEN menge * -1 END ) AS menge
             FROM matdoc
             WHERE budat <= P_Current_Date
             GROUP BY mandt, mblnr, mjahr,
                      werks,
                      CAST(CASE WHEN P_Internal_Flow_Elimination = 'Y' THEN '' ELSE lgort END AS NVARCHAR( 4 )),
                      sobkz,
                      CAST(CASE WHEN sobkz = 'W'           THEN kunnr_sid ELSE '' END AS NVARCHAR( 10 )),
                      CAST(CASE WHEN sobkz IN ( 'O', 'K' ) THEN lifnr     ELSE '' END AS NVARCHAR( 10 )),
                      CAST(CASE WHEN sobkz IN ( 'E', 'T' ) THEN kzbws     ELSE '' END AS NVARCHAR( 1 )),
                      CAST(CASE WHEN sobkz IN ( 'E', 'T' ) THEN mat_kdauf ELSE '' END AS NVARCHAR( 10 )),
                      CAST(CASE WHEN sobkz IN ( 'E', 'T' ) THEN mat_kdpos ELSE '' END AS NVARCHAR( 6 )),
                      matnr, lbbsa_sid
             HAVING SUM( CASE WHEN shkzg = 'S' THEN menge WHEN shkzg = 'H' THEN menge * -1 END ) <> 0  ) AS inventory_flow
             INNER JOIN matdoc
                     ON inventory_flow.mandt = matdoc.mandt
                    AND inventory_flow.mblnr = matdoc.mblnr
                    AND inventory_flow.mjahr = matdoc.mjahr
                    AND inventory_flow.werks = matdoc.werks
                    AND inventory_flow.lgort = CAST(CASE WHEN P_Internal_Flow_Elimination = 'Y' THEN '' ELSE matdoc.lgort END AS NVARCHAR( 4 ))
                    AND inventory_flow.sobkz = matdoc.sobkz
                    AND inventory_flow.kunnr_sid = CAST(CASE WHEN matdoc.sobkz = 'W' THEN matdoc.kunnr_sid ELSE '' END AS NVARCHAR( 10 ))
                    AND inventory_flow.lifnr     = CAST(CASE WHEN matdoc.sobkz IN ( 'O', 'K' ) THEN matdoc.lifnr     ELSE '' END AS NVARCHAR( 10 ))
                    AND inventory_flow.kzbws     = CAST(CASE WHEN matdoc.sobkz IN ( 'E', 'T' ) THEN matdoc.kzbws     ELSE '' END AS NVARCHAR( 1 ))
                    AND inventory_flow.mat_kdauf = CAST(CASE WHEN matdoc.sobkz IN ( 'E', 'T' ) THEN matdoc.mat_kdauf ELSE '' END AS NVARCHAR( 10 ))
                    AND inventory_flow.mat_kdpos = CAST(CASE WHEN matdoc.sobkz IN ( 'E', 'T' ) THEN matdoc.mat_kdpos ELSE '' END AS NVARCHAR( 6 ))
                    AND inventory_flow.matnr = matdoc.matnr
                    AND inventory_flow.lbbsa_sid = matdoc.lbbsa_sid;

    inventory_inflow =
      SELECT mandt, werks,
             lgort, sobkz, kunnr_sid, lifnr, kzbws, mat_kdauf, mat_kdpos,
             matnr, lbbsa_sid, budat, meins,
             menge AS menge_inflow,
             SUM( menge ) OVER ( PARTITION BY mandt, werks,
                                              lgort, sobkz, kunnr_sid, lifnr, kzbws, mat_kdauf, mat_kdpos,
                                              matnr, lbbsa_sid ORDER BY budat ASC) AS menge_inflow_rt
      FROM (
             SELECT mandt, werks,
                    lgort, sobkz, kunnr_sid, lifnr, kzbws, mat_kdauf, mat_kdpos,
                    matnr, lbbsa_sid, budat, meins, SUM( menge ) AS menge
             FROM :inventory_flow
             WHERE shkzg = 'S'
             GROUP BY mandt, werks,
                      lgort, sobkz, kunnr_sid, lifnr, kzbws, mat_kdauf, mat_kdpos,
                      matnr, lbbsa_sid, budat, meins
           );

    inventory_outflow =
       SELECT mandt, werks,
              lgort, sobkz, kunnr_sid, lifnr, kzbws, mat_kdauf, mat_kdpos,
              matnr, lbbsa_sid, MAX(budat) AS budat_h_max, SUM( menge ) AS menge_outflow_t
       FROM :inventory_flow
       WHERE shkzg = 'H'
       GROUP BY mandt, werks,
                lgort, sobkz, kunnr_sid, lifnr, kzbws, mat_kdauf, mat_kdpos,
                matnr, lbbsa_sid;

    inventory =
      SELECT inflow.mandt, inflow.werks,
             inflow.lgort, inflow.sobkz, inflow.kunnr_sid, inflow.lifnr, inflow.kzbws, inflow.mat_kdauf, inflow.mat_kdpos,
             inflow.matnr, inflow.lbbsa_sid, inflow.budat, inflow.meins,
             DAYS_BETWEEN(inflow.budat, P_Current_Date ) AS aging,
             outflow.budat_h_max,
             CASE WHEN DAYS_BETWEEN(inflow.budat, P_Current_Date ) BETWEEN 0 AND TO_INTEGER(P_Aging_Range_1) THEN '1'
                  WHEN DAYS_BETWEEN(inflow.budat, P_Current_Date ) BETWEEN TO_INTEGER(P_Aging_Range_1) + 1 AND TO_INTEGER(P_Aging_Range_2) THEN '2'
                  WHEN DAYS_BETWEEN(inflow.budat, P_Current_Date ) BETWEEN TO_INTEGER(P_Aging_Range_2) + 1 AND TO_INTEGER(P_Aging_Range_3) THEN '3'
                  WHEN DAYS_BETWEEN(inflow.budat, P_Current_Date ) BETWEEN TO_INTEGER(P_Aging_Range_3) + 1 AND TO_INTEGER(P_Aging_Range_4) THEN '4'
                  ELSE '5'
             END AS aging_range,
             CASE WHEN ( inflow.menge_inflow_rt - inflow.menge_inflow ) < menge_outflow_t THEN inflow.menge_inflow_rt - outflow.menge_outflow_t ELSE inflow.menge_inflow END AS menge,
             inflow.menge_inflow, inflow.menge_inflow_rt, outflow.menge_outflow_t
      FROM :inventory_inflow as inflow LEFT OUTER JOIN :inventory_outflow AS outflow
                                                    ON inflow.mandt     = outflow.mandt
                                                   AND inflow.werks     = outflow.werks
                                                   AND inflow.lgort     = outflow.lgort
                                                   AND inflow.sobkz     = outflow.sobkz
                                                   AND inflow.kunnr_sid = outflow.kunnr_sid
                                                   AND inflow.lifnr     = outflow.lifnr
                                                   AND inflow.kzbws     = outflow.kzbws
                                                   AND inflow.mat_kdauf = outflow.mat_kdauf
                                                   AND inflow.mat_kdpos = outflow.mat_kdpos
                                                   AND inflow.matnr     = outflow.matnr
                                                   AND inflow.lbbsa_sid = outflow.lbbsa_sid
      WHERE inflow.menge_inflow_rt > outflow.menge_outflow_t
         OR outflow.menge_outflow_t IS NULL;

    RETURN
      SELECT inventory.mandt, inventory.werks,
             inventory.lgort, inventory.sobkz, inventory.kunnr_sid, inventory.lifnr, inventory.kzbws, inventory.mat_kdauf, inventory.mat_kdpos,
             inventory.matnr, inventory.lbbsa_sid, :P_Current_Date AS date, inventory.aging_range, inventory.budat_h_max, inventory.meins, t001.waers, inventory.menge AS labst,
             CASE WHEN mbew.lbkum = 0 THEN 0 ELSE ( mbew.salk3 / mbew.lbkum ) * inventory.menge END AS salk3
      FROM ( SELECT inventory.mandt, inventory.werks,
             inventory.lgort, inventory.sobkz, inventory.kunnr_sid, inventory.lifnr, inventory.kzbws, inventory.mat_kdauf, inventory.mat_kdpos, inventory.lbbsa_sid,
             inventory.matnr, inventory.aging_range, inventory.budat_h_max, inventory.meins, SUM( menge ) AS menge
             FROM :inventory AS inventory
             GROUP BY inventory.mandt, inventory.werks,
                      inventory.lgort, inventory.sobkz, inventory.kunnr_sid, inventory.lifnr, inventory.kzbws, inventory.mat_kdauf, inventory.mat_kdpos, inventory.lbbsa_sid,
                      inventory.matnr, inventory.meins, inventory.aging_range, inventory.budat_h_max ) inventory
             LEFT OUTER JOIN :mbew mbew
                          ON inventory.mandt = mbew.mandt
                         AND inventory.werks = mbew.bwkey
                         AND inventory.matnr = mbew.matnr
                         AND mbew.bwtar = ''
                  INNER JOIN t001k
                          ON mbew.mandt = t001k.mandt
                         AND mbew.bwkey = t001k.bwkey
                  INNER JOIN t001
                          ON t001k.mandt = t001.mandt
                         AND t001k.bukrs = t001.bukrs;

  ENDMETHOD.

ENDCLASS.