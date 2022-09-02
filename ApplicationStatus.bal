import ballerina/sql;

public type ApplicationStatus record {
    int? id = ();
    string name;
    int sequence_no;
    string description;
};

public isolated function getApplicationStatuses() returns ApplicationStatus[]|error {
    ApplicationStatus[] applicationStatuses = [];
    stream<ApplicationStatus, error?> resultStream = smsDBClient->query(
        `SELECT 
            id  , 
            name , 
            sequence_no , 
            description  
        FROM application_status`
    );
    check from ApplicationStatus applicationStatus in resultStream
        do {
            applicationStatuses.push(applicationStatus);
        };
    check resultStream.close();
    return applicationStatuses;
}

public isolated function getApplicationStatus(int id) returns ApplicationStatus|error {
    ApplicationStatus applicationStatus = check smsDBClient->queryRow(
        `SELECT * FROM application_status WHERE id = ${id}`
    );
    return applicationStatus;
}

public isolated function addApplicationStatus(ApplicationStatus applicationStatus) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        INSERT INTO application_status (  
            name , 
            sequence_no , 
            description  )
        VALUES (
            ${applicationStatus.name}, 
            ${applicationStatus.sequence_no}, 
            ${applicationStatus.description} 
        )
    `);
    int|string? lastInsertId = result.lastInsertId;
    if lastInsertId is int {
        return lastInsertId;
    } else {
        return error("Unable to obtain last insert ID for application_status");
    }
}

public isolated function updateApplicationStatus(ApplicationStatus applicationStatus) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        UPDATE application_status SET  
            name =  ${applicationStatus.name}, 
            sequence_no =  ${applicationStatus.sequence_no}, 
            description =  ${applicationStatus.description}        
        WHERE id = ${applicationStatus.id} 
    `);
    int|string? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain last affected count for application_status update");
    }
}

isolated function deleteApplicationStatus(int id) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        DELETE FROM application_status WHERE id = ${id}
    `);
    int? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain the affected row count for application_status delete");
    }
}
