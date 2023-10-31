@EndUserText.label: 'Projection Booking View'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@Search.searchable: true
define view entity zc_booking_1031
  as projection on zi_booking_1031
{
      @Search.defaultSearchElement: true
  key TravelId,

      @Search.defaultSearchElement: true
  key BookingId,

      BookingDate,

      @Consumption.valueHelpDefinition: [{entity: {name: '/DMO/I_Customer_StdVH', element: 'CustomerID' }, useForValidation: true}]
      @Search.defaultSearchElement: true
      @ObjectModel.text.element: ['CustomerName']
      CustomerId,

      _Customer.LastName as CustomerName,

      @ObjectModel.text.element: ['CarrierName']
      @Consumption.valueHelpDefinition: [
          { entity: {name: '/DMO/I_Flight_StdVH', element: 'AirlineID'},
            additionalBinding: [ { localElement: 'FlightDate',   element: 'FlightDate',   usage: #RESULT},
                                 { localElement: 'ConnectionID', element: 'ConnectionID', usage: #RESULT},
                                 { localElement: 'FlightPrice',  element: 'Price',        usage: #RESULT},
                                 { localElement: 'CurrencyCode', element: 'CurrencyCode', usage: #RESULT } ],
            useForValidation: true }
        ]
      AirlineId,

      _Carrier.Name      as CarrierName,

      @Consumption.valueHelpDefinition: [
      { entity: {name: '/DMO/I_Flight_StdVH', element: 'ConnectionID'},
        additionalBinding: [ { localElement: 'FlightDate',   element: 'FlightDate',   usage: #RESULT},
                             { localElement: 'AirlineID',    element: 'AirlineID',    usage: #FILTER_AND_RESULT},
                             { localElement: 'FlightPrice',  element: 'Price',        usage: #RESULT},
                             { localElement: 'CurrencyCode', element: 'CurrencyCode', usage: #RESULT } ],
        useForValidation: true }
      ]
      ConnectionId,

      @Consumption.valueHelpDefinition: [
      { entity: {name: '/DMO/I_Flight_StdVH', element: 'FlightDate'},
       additionalBinding: [ { localElement: 'AirlineID',    element: 'AirlineID',    usage: #FILTER_AND_RESULT},
                            { localElement: 'ConnectionID', element: 'ConnectionID', usage: #FILTER_AND_RESULT},
                            { localElement: 'FlightPrice',  element: 'Price',        usage: #RESULT},
                            { localElement: 'CurrencyCode', element: 'CurrencyCode', usage: #RESULT } ],
       useForValidation: true }
      ]
      FlightDate,

      @Consumption.valueHelpDefinition: [
         { entity: {name: '/DMO/I_Flight_StdVH', element: 'Price'},
           additionalBinding: [ { localElement: 'FlightDate',   element: 'FlightDate',   usage: #FILTER_AND_RESULT},
                                { localElement: 'AirlineID',    element: 'AirlineID',    usage: #FILTER_AND_RESULT},
                                { localElement: 'ConnectionID', element: 'ConnectionID', usage: #FILTER_AND_RESULT},
                                { localElement: 'CurrencyCode', element: 'CurrencyCode', usage: #RESULT } ],
           useForValidation: true }
       ]
      FlightPrice,

      @Consumption.valueHelpDefinition: [{entity: {name: 'I_CurrencyStdVH', element: 'Currency' }, useForValidation: true }]
      CurrencyCode,
      /* Associations */
      _Carrier,
      _Connection,
      _Customer,
      _Travel : redirected to parent zc_travel_1031
}
