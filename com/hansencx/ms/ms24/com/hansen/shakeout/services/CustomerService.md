# CustomerService.java
## Methods
### Static
#### createShakeoutCustomerAndPremise(String publishFlagState, LocalDate extRefEffectiveFromDate):GeneratorDTO
This method is used to create data for each chain.
##### Examples
```java
GeneratorDTO generatorDTO = 
        CustomerService.createShakeoutCustomerAndPremise("YES", LocalDate.of(2012, 1, 1));
```