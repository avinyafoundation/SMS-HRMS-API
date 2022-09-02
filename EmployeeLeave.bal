import ballerina/sql;

import ballerina/time;

public type EmployeeLeave record {
    int? id = ();
    int employee_id;
    int leave_type_id;
    time:Utc applied_on = time:utcNow();
    string start_date;
    string? end_date = ();
    int approved_by;
    time:Utc last_updated = time:utcNow();
};

public isolated function getEmployeeLeaves() returns EmployeeLeave[]|error {
    EmployeeLeave[] employeeLeaves = [];
    stream<EmployeeLeave, error?> resultStream = smsDBClient->query(
        `SELECT 
            id  , 
            employee_id , 
            leave_type_id , 
            applied_on , 
            start_date , 
            end_date , 
            approved_by , 
            last_updated  
        FROM employee_leave`
    );
    check from EmployeeLeave employeeLeave in resultStream
        do {
            employeeLeaves.push(employeeLeave);
        };
    check resultStream.close();
    return employeeLeaves;
}

public isolated function getEmployeeLeave(int id) returns EmployeeLeave|error {
    EmployeeLeave employeeLeave = check smsDBClient->queryRow(
        `SELECT * FROM employee_leave WHERE id = ${id}`
    );
    return employeeLeave;
}

public isolated function addEmployeeLeave(EmployeeLeave employeeLeave) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        INSERT INTO employee_leave (  
            employee_id , 
            leave_type_id , 
            applied_on , 
            start_date , 
            end_date , 
            approved_by , 
            last_updated  )
        VALUES (
            ${employeeLeave.employee_id}, 
            ${employeeLeave.leave_type_id}, 
            ${employeeLeave.applied_on}, 
            ${employeeLeave.start_date}, 
            ${employeeLeave.end_date}, 
            ${employeeLeave.approved_by}, 
            ${employeeLeave.last_updated} 
        )
    `);
    int|string? lastInsertId = result.lastInsertId;
    if lastInsertId is int {
        return lastInsertId;
    } else {
        return error("Unable to obtain last insert ID for employee_leave");
    }
}

public isolated function updateEmployeeLeave(EmployeeLeave employeeLeave) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        UPDATE employee_leave SET  
            employee_id =  ${employeeLeave.employee_id}, 
            leave_type_id =  ${employeeLeave.leave_type_id}, 
            applied_on =  ${employeeLeave.applied_on}, 
            start_date =  ${employeeLeave.start_date}, 
            end_date =  ${employeeLeave.end_date}, 
            approved_by =  ${employeeLeave.approved_by}, 
            last_updated =  ${employeeLeave.last_updated}        
        WHERE id = ${employeeLeave.id} 
    `);
    int|string? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain last affected count for employee_leave update");
    }
}

isolated function deleteEmployeeLeave(int id) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        DELETE FROM employee_leave WHERE id = ${id}
    `);
    int? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain the affected row count for employee_leave delete");
    }
}
