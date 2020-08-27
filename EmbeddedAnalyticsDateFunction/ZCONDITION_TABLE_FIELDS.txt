REPORT zcondition_table_fields.
PARAMETERS: p_vkorg TYPE abap_bool DEFAULT abap_true,
            p_vtweg TYPE abap_bool DEFAULT abap_true,
            p_kunnr TYPE abap_bool DEFAULT abap_true,
            p_matnr TYPE abap_bool DEFAULT abap_true.
SELECT DISTINCT konh~kotabnr
INTO TABLE @DATA(wt_kotabnr_tmp)
FROM konh INNER JOIN t681 ON konh~kotabnr = t681~kotabnr
                         AND t681~kvewe = 'A'
                         AND t681~kappl = 'V'
ORDER BY konh~kotabnr.

DATA: wt_kotabnr LIKE wt_kotabnr_tmp.

LOOP AT wt_kotabnr_tmp ASSIGNING FIELD-SYMBOL(<s_kotabnr>).
  DATA(struct_def) = CAST cl_abap_structdescr( cl_abap_tabledescr=>describe_by_name( |A{ <s_kotabnr>-kotabnr }| ) ).
  DATA(wt_component) = struct_def->get_components( ).
  IF ( LINE_EXISTS( wt_component[ name = 'VKORG' ] ) AND p_vkorg = abap_true ) OR
     ( LINE_EXISTS( wt_component[ name = 'VTWEG' ] ) AND p_vtweg = abap_true ) OR
     ( LINE_EXISTS( wt_component[ name = 'KUNNR' ] ) AND p_kunnr = abap_true ) OR
     ( LINE_EXISTS( wt_component[ name = 'MATNR' ] ) AND p_matnr = abap_true ).
    APPEND <s_kotabnr> TO wt_kotabnr.
  ENDIF.
ENDLOOP.
SORT wt_kotabnr.


 cl_salv_table=>factory(
        IMPORTING
          r_salv_table = DATA(alv)
        CHANGING
          t_table      = wt_kotabnr ).
 alv->display( ).