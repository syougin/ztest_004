@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking view'
define view entity zi_booking_1031
  as select from /dmo/booking as Booking
  association        to parent zi_travel_1031 as _Travel     on  $projection.TravelId = _Travel.TravelId
  association [0..1] to zi_customer_1031      as _Customer   on  $projection.CustomerId = _Customer.CustomerId
  association [0..1] to zi_carrier_1031       as _Carrier    on  $projection.AirlineId = _Carrier.AirlineID
  association [0..1] to zi_connection_1031    as _Connection on  $projection.AirlineId    = _Connection.AirlineId
                                                             and $projection.ConnectionId = _Connection.ConnectionId



{
  key Booking.travel_id     as TravelId,
  key Booking.booking_id    as BookingId,
      Booking.booking_date  as BookingDate,
      Booking.customer_id   as CustomerId,
      Booking.carrier_id    as AirlineId,
      Booking.connection_id as ConnectionId,
      Booking.flight_date   as FlightDate,
      Booking.flight_price  as FlightPrice,
      Booking.currency_code as CurrencyCode,

      _Travel,
      _Customer,
      _Carrier,
      _Connection
}
