import ballerinax/mysql;
import ballerinax/mysql.driver as _;
import ballerina/http;

type DBConfig record {|
    string USER;
    string PASSWORD;
    string HOST;
    int PORT;
    string DATABASE;
|};

type EndpointPorts record {|
    int sms_endpoint;
    int hrm_endpoint;
    int acadamic_endpoint;
    int inventory_endpoint;
|};

configurable DBConfig db_config = ?;
configurable EndpointPorts endpoint_ports = ?;

public type Customer record {
    int? id = ();
    string first_name;
    string last_name;
};

public final mysql:Client smsDBClient = check new (db_config.HOST, db_config.USER, db_config.PASSWORD, db_config.DATABASE, db_config.PORT);

# School management system (SMS) endpoint
public listener http:Listener smsEP = new(endpoint_ports.sms_endpoint);

service / on smsEP {

    # A root resource explaining what this service is all about 
    # + return - welcome message or error
    resource function get .() returns string|error {
        return "Hello, Welcome to school management system (SMS) API\n" +
               "For more information please have a look at our API documentation";
    }
}

# A service representing SMS API with /sms 
service /sms on smsEP {

    # A root resource explaining what this service /sms is all about 
    # + return - welcome message or error
    resource function get .() returns string|error {
        return "Hello, Welcome to school management system /sms API space\n" +
               "For more information please have a look at our API documentation";
    }
}

# A service representing HRM API within /sms/hrm
service /sms/hrm on smsEP {

    # A root resource explaining what HRM service withn SMS is all about 
    # + return - welcome message or error
    resource function get .() returns string|error {
        return "Hello, Welcome to school management system's HRM API space\n" +
               "For more information please have a look at our API documentation";
    }
}

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

service /sms/util/provinces on smsEP {
    resource isolated function get .() returns Province[]|error? {
        return getProvinces();
    }
}
