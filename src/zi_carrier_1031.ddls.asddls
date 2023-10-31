@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Carrier view'
define view entity zi_carrier_1031
  as select from /dmo/carrier as Airline
{
  key Airline.carrier_id    as AirlineID,
      @Semantics.text: true
      Airline.name          as Name,
      Airline.currency_code as CurrencyCode
}
