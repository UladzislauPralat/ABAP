@EndUserText.label: 'Demo'
define table function zi_demo
returns
{
  mandt: abap.clnt;
  vbeln: vbeln_va;
  posnr: posnr_va;
  etenr: etenr;
  matnr: matnr;
  wmeng: wmeng;
  bmeng: bmeng;
  bmeng_rt: bmeng;
  lfimg: lfimg;
  lfimg_t: lfimg;
}
implemented by method
  zcl_demo=>function; 