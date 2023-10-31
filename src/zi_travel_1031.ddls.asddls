@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Travel  view cds data model'
define root view entity zi_travel_1031
  as select from /dmo/travel as Travel
  composition [0..*] of zi_booking_1031       as _Booking
  association [0..1] to zi_agency_1031        as _agency       on $projection.AgencyId = _agency.AgencyId
  association [0..1] to zi_customer_1031      as _Customer     on $projection.CustomerId = _Customer.CustomerId
  association [0..1] to I_Currency            as _currency     on $projection.CurrencyCode = _currency.Currency
  association [0..1] to zi_travel_status_1031 as _TravelStatus on $projection.Status = _TravelStatus.TravelStatus
{
  key Travel.travel_id     as TravelId,

      Travel.agency_id     as AgencyId,

      Travel.customer_id   as CustomerId,

      Travel.begin_date    as BeginDate,

      Travel.end_date      as EndDate,

      @Semantics.amount.currencyCode: 'CurrencyCode'
      Travel.booking_fee   as BookingFee,

      @Semantics.amount.currencyCode: 'CurrencyCode'
      Travel.total_price   as TotalPrice,

      Travel.currency_code as CurrencyCode,

      Travel.description   as Memo,

      Travel.status        as Status,

      Travel.lastchangedat as Lastchangedat,
      _agency,
      _Booking,
      _Customer,
      _currency,
      _TravelStatus

}
