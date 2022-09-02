import ballerina/sql;

public type Organization record {
    int? id = ();
    string name;
    string description;
    string phone_number1;
    string phone_number2;
};

public isolated function getOrganizations() returns Organization[]|error {
    Organization[] organizations = [];
    stream<Organization, error?> resultStream = smsDBClient->query(
        `SELECT 
            id  , 
            name , 
            description , 
            phone_number1 , 
            phone_number2  
        FROM organization`
    );
    check from Organization organization in resultStream
        do {
            organizations.push(organization);
        };
    check resultStream.close();
    return organizations;
}

public isolated function getOrganization(int id) returns Organization|error {
    Organization organization = check smsDBClient->queryRow(
        `SELECT * FROM organization WHERE id = ${id}`
    );
    return organization;
}

public isolated function addOrganization(Organization organization) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        INSERT INTO organization (  
            name , 
            description , 
            phone_number1 , 
            phone_number2  )
        VALUES (
            ${organization.name}, 
            ${organization.description}, 
            ${organization.phone_number1}, 
            ${organization.phone_number2} 
        )
    `);
    int|string? lastInsertId = result.lastInsertId;
    if lastInsertId is int {
        return lastInsertId;
    } else {
        return error("Unable to obtain last insert ID for organization");
    }
}

public isolated function updateOrganization(Organization organization) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        UPDATE organization SET  
            name =  ${organization.name}, 
            description =  ${organization.description}, 
            phone_number1 =  ${organization.phone_number1}, 
            phone_number2 =  ${organization.phone_number2}        
        WHERE id = ${organization.id} 
    `);
    int|string? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain last affected count for organization update");
    }
}

isolated function deleteOrganization(int id) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        DELETE FROM organization WHERE id = ${id}
    `);
    int? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain the affected row count for organization delete");
    }
}
