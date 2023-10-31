@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Conneciton view'
define view entity zi_connection_1031
  as select from /dmo/connection as Connection
{
  key Connection.carrier_id      as AirlineId,
  key Connection.connection_id   as ConnectionId,
      Connection.airport_from_id as AirportFromId,
      Connection.airport_to_id   as AirportToId,
      Connection.departure_time  as DepartureTime,
      Connection.arrival_time    as ArrivalTime,

      @Semantics.quantity.unitOfMeasure: 'DistanceUnit'
      Connection.distance        as Distance,
      Connection.distance_unit   as DistanceUnit
}
