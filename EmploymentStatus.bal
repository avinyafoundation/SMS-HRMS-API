import ballerina/sql;

public type EmploymentStatus record {
    int? id = ();
    string name;
    int sequence_no;
    string description;
};

public isolated function getEmploymentStatuses() returns EmploymentStatus[]|error {
    EmploymentStatus[] employmentStatuses = [];
    stream<EmploymentStatus, error?> resultStream = smsDBClient->query(
        `SELECT 
            id  , 
            name , 
            sequence_no , 
            description  
        FROM employment_status`
    );
    check from EmploymentStatus employmentStatus in resultStream
        do {
            employmentStatuses.push(employmentStatus);
        };
    check resultStream.close();
    return employmentStatuses;
}

public isolated function getEmploymentStatus(int id) returns EmploymentStatus|error {
    EmploymentStatus employmentStatus = check smsDBClient->queryRow(
        `SELECT * FROM employment_status WHERE id = ${id}`
    );
    return employmentStatus;
}

public isolated function addEmploymentStatus(EmploymentStatus employmentStatus) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        INSERT INTO employment_status (  
            name , 
            sequence_no , 
            description  )
        VALUES (
            ${employmentStatus.name}, 
            ${employmentStatus.sequence_no}, 
            ${employmentStatus.description} 
        )
    `);
    int|string? lastInsertId = result.lastInsertId;
    if lastInsertId is int {
        return lastInsertId;
    } else {
        return error("Unable to obtain last insert ID for employment_status");
    }
}

public isolated function updateEmploymentStatus(EmploymentStatus employmentStatus) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        UPDATE employment_status SET  
            name =  ${employmentStatus.name}, 
            sequence_no =  ${employmentStatus.sequence_no}, 
            description =  ${employmentStatus.description}        
        WHERE id = ${employmentStatus.id} 
    `);
    int|string? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain last affected count for employment_status update");
    }
}

isolated function deleteEmploymentStatus(int id) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        DELETE FROM employment_status WHERE id = ${id}
    `);
    int? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain the affected row count for employment_status delete");
    }
}
