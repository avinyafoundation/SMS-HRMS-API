import ballerina/sql;

public type ApplicantAddress record {
    int applicant_id;
    int address_id;
};

public isolated function getApplicantAddresses() returns ApplicantAddress[]|error {
    ApplicantAddress[] applicantAddresses = [];
    stream<ApplicantAddress, error?> resultStream = smsDBClient->query(
        `SELECT 
            applicant_id , 
            address_id  
        FROM applicant_address`
    );
    check from ApplicantAddress applicantAddress in resultStream
        do {
            applicantAddresses.push(applicantAddress);
        };
    check resultStream.close();
    return applicantAddresses;
}

public isolated function getApplicantAddress(int applicant_id, int address_id) returns ApplicantAddress|error {
    ApplicantAddress applicantAddress = check smsDBClient->queryRow(
        `SELECT * FROM applicant_address WHERE applicant_id = ${applicant_id} AND address_id = ${address_id}`
    );
    return applicantAddress;
}

public isolated function getAddressesForApplicant(int applicant_id) returns ApplicantAddress[]|error {
    ApplicantAddress[] applicantAddresses = [];
    stream<ApplicantAddress, error?> resultStream = smsDBClient->query(
        `SELECT 
            applicant_id , 
            address_id  
        FROM applicant_address WHERE applicant_id = ${applicant_id}`
    );
    check from ApplicantAddress applicantAddress in resultStream
        do {
            applicantAddresses.push(applicantAddress);
        };
    check resultStream.close();
    return applicantAddresses;
}

public isolated function addApplicantAddress(ApplicantAddress applicantAddress) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        INSERT INTO applicant_address (  
            applicant_id , 
            address_id  )
        VALUES (
            ${applicantAddress.applicant_id}, 
            ${applicantAddress.address_id} 
        )
    `);
    int|string? lastInsertId = result.lastInsertId;
    if lastInsertId is int {
        return lastInsertId;
    } else {
        return error("Unable to obtain last insert ID for applicant_address");
    }
}

public isolated function updateApplicantAddress(ApplicantAddress applicantAddress) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        UPDATE applicant_address SET  
            applicant_id =  ${applicantAddress.applicant_id}, 
            address_id =  ${applicantAddress.address_id}        
        WHERE applicant_address = ${applicantAddress.applicant_id}  
    `);
    int|string? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain last affected count for applicant_address update");
    }
}

isolated function deleteApplicantAddress(int applicant_id, int address_id) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        DELETE FROM applicant_address WHERE applicant_id = ${applicant_id} AND address_id = ${address_id}
    `);
    int? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain the affected row count for applicant_address delete");
    }
}
