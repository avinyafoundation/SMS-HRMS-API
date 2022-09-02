import ballerina/sql;

import ballerina/time;

public type EmployeeEmploymentStatus record {
    int? id = ();
    int employee_id;
    int employment_status_id;
    string start_date;
    string? end_date = ();
    time:Utc last_updated = time:utcNow();
};

public isolated function getEmployeeEmploymentStatuses() returns EmployeeEmploymentStatus[]|error {
    EmployeeEmploymentStatus[] employeeEmploymentStatuses = [];
    stream<EmployeeEmploymentStatus, error?> resultStream = smsDBClient->query(
        `SELECT 
            id  , 
            employee_id , 
            employment_status_id , 
            start_date , 
            end_date , 
            last_updated  
        FROM employee_employment_status`
    );
    check from EmployeeEmploymentStatus employeeEmploymentStatus in resultStream
        do {
            employeeEmploymentStatuses.push(employeeEmploymentStatus);
        };
    check resultStream.close();
    return employeeEmploymentStatuses;
}

public isolated function getEmployeeEmploymentStatus(int id) returns EmployeeEmploymentStatus|error {
    EmployeeEmploymentStatus employeeEmploymentStatus = check smsDBClient->queryRow(
        `SELECT * FROM employee_employment_status WHERE id = ${id}`
    );
    return employeeEmploymentStatus;
}

public isolated function addEmployeeEmploymentStatus(EmployeeEmploymentStatus employeeEmploymentStatus) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        INSERT INTO employee_employment_status (  
            employee_id , 
            employment_status_id , 
            start_date , 
            end_date , 
            last_updated  )
        VALUES (
            ${employeeEmploymentStatus.employee_id}, 
            ${employeeEmploymentStatus.employment_status_id}, 
            ${employeeEmploymentStatus.start_date}, 
            ${employeeEmploymentStatus.end_date}, 
            ${employeeEmploymentStatus.last_updated} 
        )
    `);
    int|string? lastInsertId = result.lastInsertId;
    if lastInsertId is int {
        return lastInsertId;
    } else {
        return error("Unable to obtain last insert ID for employee_employment_status");
    }
}

public isolated function updateEmployeeEmploymentStatus(EmployeeEmploymentStatus employeeEmploymentStatus) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        UPDATE employee_employment_status SET  
            employee_id =  ${employeeEmploymentStatus.employee_id}, 
            employment_status_id =  ${employeeEmploymentStatus.employment_status_id}, 
            start_date =  ${employeeEmploymentStatus.start_date}, 
            end_date =  ${employeeEmploymentStatus.end_date}, 
            last_updated =  ${employeeEmploymentStatus.last_updated}        
        WHERE id = ${employeeEmploymentStatus.id} 
    `);
    int|string? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain last affected count for employee_employment_status update");
    }
}

isolated function deleteEmployeeEmploymentStatus(int id) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        DELETE FROM employee_employment_status WHERE id = ${id}
    `);
    int? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain the affected row count for employee_employment_status delete");
    }
}
