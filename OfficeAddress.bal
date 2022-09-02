import ballerina/sql;

public type OfficeAddress record {
    int office_id;
    int address_id;
};

public isolated function getOfficeAddresses() returns OfficeAddress[]|error {
    OfficeAddress[] officeAddresses = [];
    stream<OfficeAddress, error?> resultStream = smsDBClient->query(
        `SELECT 
            office_id , 
            address_id  
        FROM office_address`
    );
    check from OfficeAddress officeAddress in resultStream
        do {
            officeAddresses.push(officeAddress);
        };
    check resultStream.close();
    return officeAddresses;
}

public isolated function getOfficeAddress(int office_id, int address_id) returns OfficeAddress|error {
    OfficeAddress officeAddress = check smsDBClient->queryRow(
        `SELECT * FROM office_address WHERE office_id = ${office_id} AND address_id = ${address_id}`
    );
    return officeAddress;
}

public isolated function getAddressesForOffice(int office_id) returns OfficeAddress[]|error {
    OfficeAddress[] officeAddresses = [];
    stream<OfficeAddress, error?> resultStream = smsDBClient->query(
        `SELECT 
            office_id , 
            address_id  
        FROM office_address WHERE office_id = ${office_id}`
    );
    check from OfficeAddress officeAddress in resultStream
        do {
            officeAddresses.push(officeAddress);
        };
    check resultStream.close();
    return officeAddresses;
}

public isolated function addOfficeAddress(OfficeAddress officeAddress) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        INSERT INTO office_address (  
            office_id , 
            address_id  )
        VALUES (
            ${officeAddress.office_id}, 
            ${officeAddress.address_id} 
        )
    `);
    int|string? lastInsertId = result.lastInsertId;
    if lastInsertId is int {
        return lastInsertId;
    } else {
        return error("Unable to obtain last insert ID for office_address");
    }
}

public isolated function updateOfficeAddress(OfficeAddress officeAddress) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        UPDATE office_address SET  
            office_id =  ${officeAddress.office_id}, 
            address_id =  ${officeAddress.address_id}        
        WHERE office_address = ${officeAddress.office_id}  
    `);
    int|string? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain last affected count for office_address update");
    }
}

isolated function deleteOfficeAddress(int office_id, int address_id) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        DELETE FROM office_address WHERE office_id = ${office_id} AND address_id = ${address_id}
    `);
    int? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain the affected row count for office_address delete");
    }
}
