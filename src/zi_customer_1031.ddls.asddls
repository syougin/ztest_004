@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Customer data'
@Search.searchable: true
define view entity zi_customer_1031
  as select from /dmo/customer as Customer
  association [0..1] to I_Country as _Country on $projection.CountryCode = _Country.Country
{
  key Customer.customer_id   as CustomerId,
      Customer.first_name    as FirstName,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Semantics.text: true
      Customer.last_name     as LastName,
      Customer.title         as Title,
      Customer.street        as Street,
      Customer.postal_code   as PostalCode,
      Customer.city          as City,
      Customer.country_code  as CountryCode,
      Customer.phone_number  as PhoneNumber,
      Customer.email_address as EmailAddress,
      _Country
}
