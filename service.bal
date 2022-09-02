import ballerinax/mysql;
import ballerinax/mysql.driver as _;
import ballerina/http;

configurable string dbUser = ?;
configurable string dbHost = ?;
configurable string dbDatabase = ?;
configurable int dbPort = ?;
configurable string dbPassword = ?;

public type Customer record {
    int? id = ();
    string first_name;
    string last_name;
};

public final mysql:Client smsDBClient = check new (host = dbHost, user = dbUser, password = dbPassword, database = dbDatabase, port = dbPort);

# School management system (SMS) endpoint
public listener http:Listener smsEP = new(9090);

type Province record {
    int? id = ();
    string name_en;
};

isolated function getProvinces() returns Province[]|error {
    Province[] provinces = [];
    stream<Province, error?> resultStream = smsDBClient->query(
        `SELECT id, name_en FROM province`
    );
    check from Province province in resultStream
        do {
            provinces.push(province);
        };
    check resultStream.close();
    return provinces;
}


service / on smsEP {

    # A root resource explaining what this service is all about 
    # + return - welcome message or error
    resource function get .() returns string|error {
        return "Hello, Welcome to school management system (SMS) API\n" +
               "For more information please have a look at our API documentation";
    }

     # A root resource explaining what this service /sms is all about 
    # + return - welcome message or error
    resource function get sms() returns string|error {
        return "Hello, Welcome to school management system /sms API space\n" +
               "For more information please have a look at our API documentation";
    }

    # A root resource explaining what HRM service withn SMS is all about 
    # + return - welcome message or error
    resource function get sms/hrm() returns string|error {
        return "Hello, Welcome to school management system's HRM API space\n" +
               "For more information please have a look at our API documentation";
    }

    resource isolated function get sms/util/provinces() returns Province[]|error? {
        return getProvinces();
    }

    isolated resource function get sms/util/addresstypes() returns AddressType[]|error? {
        return getAddressTypes();
    }

    isolated resource function get sms/util/addresstypes/[int id]() returns AddressType|error? {
        return getAddressType(id);
    }

    isolated resource function post sms/util/addresstypes(@http:Payload AddressType addressType) returns int|error? {
        return addAddressType(addressType);
    }

    isolated resource function put sms/util/addresstypes(@http:Payload AddressType addressType) returns int|error? {
        return updateAddressType(addressType);
    }

    isolated resource function delete sms/util/addresstypes/[int id]() returns int|error? {
        return deleteAddressType(id);       
    }
}

