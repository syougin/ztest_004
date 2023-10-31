@EndUserText.label: 'Projection Booking View'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@Search.searchable: true
define view entity zc_booking_1031
  as projection on zi_booking_1031
{
      
  key TravelId,

      
  key BookingId,

      BookingDate,

      
      
      @ObjectModel.text.element: ['CustomerName']
      CustomerId,

      _Customer.LastName as CustomerName,

      @ObjectModel.text.element: ['CarrierName']
      
      AirlineId,

      _Carrier.Name      as CarrierName,

      
      ConnectionId,

      
      FlightDate,

      
      FlightPrice,

      
      CurrencyCode,
      /* Associations */
      _Carrier,
      _Connection,
      _Customer,
      _Travel : redirected to parent zc_travel_1031
}
