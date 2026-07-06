public with sharing class CurrencyConversionService {
    
    public class ConversionResponse{
        public String result;
        public Decimal conversion_result;
    }

    public class CurrencyConvertRequest {
        @InvocableVariable(required=true description='Pass the Source Currency Code given by the User')
        public String convertFrom;
        
        @InvocableVariable(required=true description='Pass the Target Currency Code given by the User')
        public String convertTo;
        
        @InvocableVariable(required=true description='Pass the Amount given by the User')
        public Decimal amount;
    }

    public class CurrencyConvertResponse{
        @InvocableVariable(description='Total Conversion Rate')
        public Decimal totalConversionRate;
    }

    @InvocableMethod(callout=true label='Convert Currency' description='Convert a given amount from one currency to another currency')
    public static List<CurrencyConvertResponse> getConversionResult(List<CurrencyConvertRequest> requests){
        String endpoint = 'https://v6.exchangerate-api.com/v6/5fc62098fa8c25d4fce3e5c7/pair/' 
        + requests[0].convertFrom + '/' + requests[0].convertTo + '/' + requests[0].amount;
        
        CurrencyConvertResponse returnResponse = new CurrencyConvertResponse();

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('GET');

        try {
            HttpResponse response = http.send(request);
            
            if(response.getStatusCode() == 200){
                ConversionResponse res = (ConversionResponse) JSON.deserialize(response.getBody(), ConversionResponse.class);
                if(res != null && res.conversion_result != null){
                    returnResponse.totalConversionRate = res.conversion_result;
                }
            }
            
        } catch (Exception e) {
            System.debug('Error: ' + e.getMessage());
            throw new AuraHandledException('Error: ' + e.getMessage());
        }
        
        return new List<CurrencyConvertResponse>{ returnResponse };
    }
}