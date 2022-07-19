# Shakeout
## Step and steps chain
- Chain 1-5
- Chain 6-7
- Chain 8-9
- Chain 10
- Chain 11-12
- Chain 13-19
- Chain 20
- Chain ..
- Chain 31

Chain 1 -> 5
Chan 11 -> 12
Step 13 -> 15
Step 16 -> 18

Essential Energy LNSP role
-> outbound

Inbound from NEMMCO

CR1000 New customer
CR2000 Site 

Greenfield

2001 premise data

```mermaid
sequenceDiagram
participant Service
participant Transaction
participant TransactionGenerator
participant Printer
participant FileGenerator
participant AseXMLTransactionTransformer
participant HashMap
participant StringBuilder
participant XMLUtil
Service->>Transaction: setDto(GeneratorDTO): void
Service->>Transaction: generate(): void
Transaction->>TransactionGenerator: generate(GeneratorDTO, String transType): String
TransactionGenerator->>Printer: print(GeneratorDTO, PrintWriter): void
Printer->>FileGenerator: generate(): void
FileGenerator->>FileGenerator: writeOutput(Date, String transRef): void
FileGenerator->>FileGenerator: getXslt(String transType): String // get .xslt file name
FileGenerator->>HashMap: ctor(): HashMap // build data for raw xml generation
FileGenerator->>AseXMLTransactionTransformer: setFields(HashMap): void
FileGenerator->>AseXMLTransactionTransformer: setXslt(String): void
FileGenerator->>AseXMLTransactionTransformer: getTransaction(): String // append more data to map and build asexml
AseXMLTransactionTransformer->>AseXMLTransactionTransformer: findXsltFile(xslt): InputStream // load .xslt
AseXMLTransactionTransformer->>StringBuilder: ctor(): StringBuilder
AseXMLTransactionTransformer->>XMLUtil: transform(HashMap, StringBuilder): String // generate raw xml
AseXMLTransactionTransformer->>XMLUtil: transform(String, InputStream): String // apply xslt to the generated raw xml
FileGenerator->>FileGenerator: println(String): void
Service->>Transaction: getTransaction(): String // get transId
Service->>Transaction: setTransaction(String): void
Service->>Transaction: process(): void
```