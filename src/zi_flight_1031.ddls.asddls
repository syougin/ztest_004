@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Flight View'
define view entity zi_flight_1031
  as select from /dmo/flight as Flight
{
  key Flight.carrier_id     as CarrierId,
  key Flight.connection_id  as ConnectionId,
  key Flight.flight_date    as FlightDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      Flight.price          as Price,
      Flight.currency_code  as CurrencyCode,
      Flight.plane_type_id  as PlaneTypeId,
      Flight.seats_max      as SeatsMax,
      Flight.seats_occupied as SeatsOccupied
}
