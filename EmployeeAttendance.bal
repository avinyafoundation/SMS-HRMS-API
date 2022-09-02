import ballerina/sql;

import ballerina/time;

public type EmployeeAttendance record {
    int? id = ();
    int employee_id;
    int attendance_type_id;
    time:Utc time_stamp = time:utcNow();
    time:Utc last_updated = time:utcNow();
};

public isolated function getEmployeeAttendances() returns EmployeeAttendance[]|error {
    EmployeeAttendance[] employeeAttendances = [];
    stream<EmployeeAttendance, error?> resultStream = smsDBClient->query(
        `SELECT 
            id  , 
            employee_id , 
            attendance_type_id , 
            time_stamp , 
            last_updated  
        FROM employee_attendance`
    );
    check from EmployeeAttendance employeeAttendance in resultStream
        do {
            employeeAttendances.push(employeeAttendance);
        };
    check resultStream.close();
    return employeeAttendances;
}

public isolated function getEmployeeAttendance(int id) returns EmployeeAttendance|error {
    EmployeeAttendance employeeAttendance = check smsDBClient->queryRow(
        `SELECT * FROM employee_attendance WHERE id = ${id}`
    );
    return employeeAttendance;
}

public isolated function addEmployeeAttendance(EmployeeAttendance employeeAttendance) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        INSERT INTO employee_attendance (  
            employee_id , 
            attendance_type_id , 
            time_stamp , 
            last_updated  )
        VALUES (
            ${employeeAttendance.employee_id}, 
            ${employeeAttendance.attendance_type_id}, 
            ${employeeAttendance.time_stamp}, 
            ${employeeAttendance.last_updated} 
        )
    `);
    int|string? lastInsertId = result.lastInsertId;
    if lastInsertId is int {
        return lastInsertId;
    } else {
        return error("Unable to obtain last insert ID for employee_attendance");
    }
}

public isolated function updateEmployeeAttendance(EmployeeAttendance employeeAttendance) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        UPDATE employee_attendance SET  
            employee_id =  ${employeeAttendance.employee_id}, 
            attendance_type_id =  ${employeeAttendance.attendance_type_id}, 
            time_stamp =  ${employeeAttendance.time_stamp}, 
            last_updated =  ${employeeAttendance.last_updated}        
        WHERE id = ${employeeAttendance.id} 
    `);
    int|string? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain last affected count for employee_attendance update");
    }
}

isolated function deleteEmployeeAttendance(int id) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        DELETE FROM employee_attendance WHERE id = ${id}
    `);
    int? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain the affected row count for employee_attendance delete");
    }
}
