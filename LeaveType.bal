import ballerina/sql;

public type LeaveType record {
    int? id = ();
    int employment_type_id;
    string name;
    int allocation;
    string description;
};

public isolated function getLeaveTypes() returns LeaveType[]|error {
    LeaveType[] leaveTypes = [];
    stream<LeaveType, error?> resultStream = smsDBClient->query(
        `SELECT 
            id  , 
            employment_type_id , 
            name , 
            allocation , 
            description  
        FROM leave_type`
    );
    check from LeaveType leaveType in resultStream
        do {
            leaveTypes.push(leaveType);
        };
    check resultStream.close();
    return leaveTypes;
}

public isolated function getLeaveType(int id) returns LeaveType|error {
    LeaveType leaveType = check smsDBClient->queryRow(
        `SELECT * FROM leave_type WHERE id = ${id}`
    );
    return leaveType;
}

public isolated function addLeaveType(LeaveType leaveType) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        INSERT INTO leave_type (  
            employment_type_id , 
            name , 
            allocation , 
            description  )
        VALUES (
            ${leaveType.employment_type_id}, 
            ${leaveType.name}, 
            ${leaveType.allocation}, 
            ${leaveType.description} 
        )
    `);
    int|string? lastInsertId = result.lastInsertId;
    if lastInsertId is int {
        return lastInsertId;
    } else {
        return error("Unable to obtain last insert ID for leave_type");
    }
}

public isolated function updateLeaveType(LeaveType leaveType) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        UPDATE leave_type SET  
            employment_type_id =  ${leaveType.employment_type_id}, 
            name =  ${leaveType.name}, 
            allocation =  ${leaveType.allocation}, 
            description =  ${leaveType.description}        
        WHERE id = ${leaveType.id} 
    `);
    int|string? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain last affected count for leave_type update");
    }
}

isolated function deleteLeaveType(int id) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        DELETE FROM leave_type WHERE id = ${id}
    `);
    int? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain the affected row count for leave_type delete");
    }
}
