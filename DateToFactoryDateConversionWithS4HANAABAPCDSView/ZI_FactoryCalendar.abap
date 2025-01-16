@EndUserText.label: 'Factory Calendar'
@ClientHandling.type: #CLIENT_INDEPENDENT
define table function ZI_FactoryCalendar
returns
{
  key FactoryCalendar: wfcid;
  key CalendarDate: dats;
  WeekDay: char1;
  FactoryDate: dats;
  PreviousFactoryDate: dats;  
}
implemented by method
  zcl_factory_calendar=>function;