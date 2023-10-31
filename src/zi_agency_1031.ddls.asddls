@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Agency view - cds data model'
@Search.searchable: true
define view entity zi_agency_1031
  as select from /dmo/agency as Agency
  association [0..1] to I_Country as _country on $projection.CountryCode = _country.Country

{

  key Agency.agency_id     as AgencyId,
      @Semantics.text: true
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      Agency.name          as Name,
      Agency.street        as Street,
      Agency.postal_code   as PostalCode,
      Agency.city          as City,
      Agency.country_code  as CountryCode,
      Agency.phone_number  as PhoneNumber,
      Agency.email_address as EmailAddress,
      Agency.web_address   as WebAddress,
      _country

}
