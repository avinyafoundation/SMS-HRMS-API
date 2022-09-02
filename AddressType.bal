import ballerina/sql;

public type AddressType record {
    int? id = ();
    string name;
    string description;
};

public isolated function getAddressTypes() returns AddressType[]|error {
    AddressType[] addressTypes = [];
    stream<AddressType, error?> resultStream = smsDBClient->query(
        `SELECT 
            id  , 
            name , 
            description  
        FROM address_type`
    );
    check from AddressType addressType in resultStream
        do {
            addressTypes.push(addressType);
        };
    check resultStream.close();
    return addressTypes;
}

public isolated function getAddressType(int id) returns AddressType|error {
    AddressType addressType = check smsDBClient->queryRow(
        `SELECT * FROM address_type WHERE id = ${id}`
    );
    return addressType;
}

public isolated function addAddressType(AddressType addressType) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        INSERT INTO address_type (  
            name , 
            description  )
        VALUES (
            ${addressType.name}, 
            ${addressType.description} 
        )
    `);
    int|string? lastInsertId = result.lastInsertId;
    if lastInsertId is int {
        return lastInsertId;
    } else {
        return error("Unable to obtain last insert ID for address_type");
    }
}

public isolated function updateAddressType(AddressType addressType) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        UPDATE address_type SET  
            name =  ${addressType.name}, 
            description =  ${addressType.description}        
        WHERE id = ${addressType.id} 
    `);
    int|string? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain last affected count for address_type update");
    }
}

isolated function deleteAddressType(int id) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        DELETE FROM address_type WHERE id = ${id}
    `);
    int? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain the affected row count for address_type delete");
    }
}
