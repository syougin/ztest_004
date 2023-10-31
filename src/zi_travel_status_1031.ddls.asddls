@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Travel Status Value Help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
 serviceQuality: #A,
 sizeCategory: #S,
 dataClass: #MASTER
 }
 @ObjectModel.resultSet.sizeCategory: #XS
define view entity zi_travel_status_1031 as select from /dmo/trvl_stat as travel_status
association [0..*] to zi_travel_status_txt_1031  as _text on $projection.TravelStatus = _text.TravelStatus
{
        @UI.textArrangement: #TEXT_ONLY
        @UI.lineItem: [{ importance: #HIGH }]
        @ObjectModel.text.association: '_text'
        key travel_status.travel_status as TravelStatus,
        _text
}
