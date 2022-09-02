import ballerina/sql;

public type Address record {
    int? id = ();
    string line1;
    string line2;
    string line3;
    int city_id;
    int address_type_id;
    string notes;
};

public isolated function getAddresses() returns Address[]|error {
    Address[] addresses = [];
    stream<Address, error?> resultStream = smsDBClient->query(
        `SELECT 
            id  , 
            line1 , 
            line2 , 
            line3 , 
            city_id , 
            address_type_id , 
            notes  
        FROM address`
    );
    check from Address address in resultStream
        do {
            addresses.push(address);
        };
    check resultStream.close();
    return addresses;
}

public isolated function getAddress(int id) returns Address|error {
    Address address = check smsDBClient->queryRow(
        `SELECT * FROM address WHERE id = ${id}`
    );
    return address;
}

public isolated function addAddress(Address address) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        INSERT INTO address (  
            line1 , 
            line2 , 
            line3 , 
            city_id , 
            address_type_id , 
            notes  )
        VALUES (
            ${address.line1}, 
            ${address.line2}, 
            ${address.line3}, 
            ${address.city_id}, 
            ${address.address_type_id}, 
            ${address.notes} 
        )
    `);
    int|string? lastInsertId = result.lastInsertId;
    if lastInsertId is int {
        return lastInsertId;
    } else {
        return error("Unable to obtain last insert ID for address");
    }
}

public isolated function updateAddress(Address address) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        UPDATE address SET  
            line1 =  ${address.line1}, 
            line2 =  ${address.line2}, 
            line3 =  ${address.line3}, 
            city_id =  ${address.city_id}, 
            address_type_id =  ${address.address_type_id}, 
            notes =  ${address.notes}        
        WHERE id = ${address.id} 
    `);
    int|string? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain last affected count for address update");
    }
}

isolated function deleteAddress(int id) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        DELETE FROM address WHERE id = ${id}
    `);
    int? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain the affected row count for address delete");
    }
}
