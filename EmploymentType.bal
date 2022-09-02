import ballerina/sql;

public type EmploymentType record {
    int? id = ();
    string name;
    string description;
};

public isolated function getEmploymentTypes() returns EmploymentType[]|error {
    EmploymentType[] employmentTypes = [];
    stream<EmploymentType, error?> resultStream = smsDBClient->query(
        `SELECT 
            id  , 
            name , 
            description  
        FROM employment_type`
    );
    check from EmploymentType employmentType in resultStream
        do {
            employmentTypes.push(employmentType);
        };
    check resultStream.close();
    return employmentTypes;
}

public isolated function getEmploymentType(int id) returns EmploymentType|error {
    EmploymentType employmentType = check smsDBClient->queryRow(
        `SELECT * FROM employment_type WHERE id = ${id}`
    );
    return employmentType;
}

public isolated function addEmploymentType(EmploymentType employmentType) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        INSERT INTO employment_type (  
            name , 
            description  )
        VALUES (
            ${employmentType.name}, 
            ${employmentType.description} 
        )
    `);
    int|string? lastInsertId = result.lastInsertId;
    if lastInsertId is int {
        return lastInsertId;
    } else {
        return error("Unable to obtain last insert ID for employment_type");
    }
}

public isolated function updateEmploymentType(EmploymentType employmentType) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        UPDATE employment_type SET  
            name =  ${employmentType.name}, 
            description =  ${employmentType.description}        
        WHERE id = ${employmentType.id} 
    `);
    int|string? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain last affected count for employment_type update");
    }
}

isolated function deleteEmploymentType(int id) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        DELETE FROM employment_type WHERE id = ${id}
    `);
    int? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain the affected row count for employment_type delete");
    }
}
