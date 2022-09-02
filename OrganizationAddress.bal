import ballerina/sql;

public type OrganizationAddress record {
    int organization_id;
    int address_id;
};

public isolated function getOrganizationAddresses() returns OrganizationAddress[]|error {
    OrganizationAddress[] organizationAddresses = [];
    stream<OrganizationAddress, error?> resultStream = smsDBClient->query(
        `SELECT 
            organization_id , 
            address_id  
        FROM organization_address`
    );
    check from OrganizationAddress organizationAddress in resultStream
        do {
            organizationAddresses.push(organizationAddress);
        };
    check resultStream.close();
    return organizationAddresses;
}

public isolated function getOrganizationAddress(int organization_id, int address_id) returns OrganizationAddress|error {
    OrganizationAddress organizationAddress = check smsDBClient->queryRow(
        `SELECT * FROM organization_address WHERE organization_id = ${organization_id} AND address_id = ${address_id}`
    );
    return organizationAddress;
}

public isolated function getAddressesForOrganization(int organization_id) returns OrganizationAddress[]|error {
    OrganizationAddress[] organizationAddresses = [];
    stream<OrganizationAddress, error?> resultStream = smsDBClient->query(
        `SELECT 
            organization_id , 
            address_id  
        FROM organization_address WHERE organization_id = ${organization_id}`
    );
    check from OrganizationAddress organizationAddress in resultStream
        do {
            organizationAddresses.push(organizationAddress);
        };
    check resultStream.close();
    return organizationAddresses;
}

public isolated function addOrganizationAddress(OrganizationAddress organizationAddress) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        INSERT INTO organization_address (  
            organization_id , 
            address_id  )
        VALUES (
            ${organizationAddress.organization_id}, 
            ${organizationAddress.address_id} 
        )
    `);
    int|string? lastInsertId = result.lastInsertId;
    if lastInsertId is int {
        return lastInsertId;
    } else {
        return error("Unable to obtain last insert ID for organization_address");
    }
}

public isolated function updateOrganizationAddress(OrganizationAddress organizationAddress) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        UPDATE organization_address SET  
            organization_id =  ${organizationAddress.organization_id}, 
            address_id =  ${organizationAddress.address_id}        
        WHERE organization_address = ${organizationAddress.organization_id}  
    `);
    int|string? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain last affected count for organization_address update");
    }
}

isolated function deleteOrganizationAddress(int organization_id, int address_id) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        DELETE FROM organization_address WHERE organization_id = ${organization_id} AND address_id = ${address_id}
    `);
    int? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain the affected row count for organization_address delete");
    }
}
