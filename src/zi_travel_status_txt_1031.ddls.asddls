@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Travel Status Text View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #A,
    sizeCategory: #S,
    dataClass: #MASTER
}
define view entity zi_travel_status_txt_1031
  as select from /dmo/trvl_stat_t as Travel_status_t
  association [1..1] to zi_travel_status_1031 as _TravelStatus on $projection.TravelStatus = _TravelStatus.TravelStatus
{
      @ObjectModel.text.element: [ 'Text' ]
  key Travel_status_t.travel_status as TravelStatus,
      @Semantics.language: true
  key Travel_status_t.language      as Language,
      @Semantics.text: true
      Travel_status_t.text          as Text,
      _TravelStatus
}
