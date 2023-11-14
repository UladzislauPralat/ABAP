@EndUserText.label: 'Inventory Aging'
define table function ZI_InventoryAgingFunc
  with parameters
    @Environment.systemField: #SYSTEM_DATE
    P_Current_Date: dats,
    @EndUserText.label: 'Aging Range 1'    
    P_Aging_Range_1: char3,
    @EndUserText.label: 'Aging Range 2'    
    P_Aging_Range_2: char3,
    @EndUserText.label: 'Aging Range 3'    
    P_Aging_Range_3: char3,    
    @EndUserText.label: 'Aging Range 4'    
    P_Aging_Range_4: char3,        
    @EndUserText.label: 'Internal Flow Elimination'    
    P_Internal_Flow_Elimination: cacsyn     
returns
{
  key mandt: abap.clnt;
  key werks: werks_d;
  key lgort: lgort_d;
  key sobkz: sobkz;
  key kunnr_sid: nsdm_kunnr;
  key lifnr: elifn;
  key kzbws: kzbws;
  key mat_kdauf: mat_kdauf;
  key mat_kdpos: mat_kdpos;  
  key matnr: matnr;
  key lbbsa_sid: nsdm_lbbsa; 
  aging_range: abap.char(1);
  budat_h_max: budat; 
  meins: meins;
  waers: waers;  
  labst: labst;
  salk3: salk3;   
}
implemented by method
  zcl_inventory_aging=>function;
