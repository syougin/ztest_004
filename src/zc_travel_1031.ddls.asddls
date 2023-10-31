@EndUserText.label: 'Projection Travel data'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@Search.searchable: true
define root view entity zc_travel_1031
  provider contract transactional_query
  as projection on zi_travel_1031
{
      @Consumption.valueHelpDefinition: [{ entity :{ name :'/dmo/i_agency_stdvh',element: 'AgencyID'},useForValidation: true }]
      @ObjectModel.text.element: [ 'AgencyName' ]
      @Search.defaultSearchElement: true
  key TravelId,

      AgencyId,

      _agency.Name             as AgencyName,

      @Consumption.valueHelpDefinition: [{ entity :{ name :'/dmo/i_Customer_stdvh',element: 'CustomerID'},useForValidation: true }]
      @ObjectModel.text.element: [ 'AgencyName' ]
      @Search.defaultSearchElement: true
      CustomerId,
      _Customer.LastName       as CustomerName,

      BeginDate,
      EndDate,
      BookingFee,
      TotalPrice,

      @Consumption.valueHelpDefinition: [{ entity :{ name :'i_currencystdvh',element: 'CustomerID'},useForValidation: true }]
      CurrencyCode,
      Memo,
      Status,
      
      _TravelStatus._text.Text as StatusText : localized,
      Lastchangedat,
      /* Associations */
      _agency,
      _Booking :redirected to composition child zc_booking_1031,
      _currency,
      _Customer,
      _TravelStatus
}
