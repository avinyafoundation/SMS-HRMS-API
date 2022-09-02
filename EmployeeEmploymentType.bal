import ballerina/sql;

import ballerina/time;

public type EmployeeEmploymentType record {
    int? id = ();
    int employee_id;
    int employment_type_id;
    string start_date;
    string? end_date = ();
    time:Utc last_updated = time:utcNow();
};

public isolated function getEmployeeEmploymentTypes() returns EmployeeEmploymentType[]|error {
    EmployeeEmploymentType[] employeeEmploymentTypes = [];
    stream<EmployeeEmploymentType, error?> resultStream = smsDBClient->query(
        `SELECT 
            id  , 
            employee_id , 
            employment_type_id , 
            start_date , 
            end_date , 
            last_updated  
        FROM employee_employment_type`
    );
    check from EmployeeEmploymentType employeeEmploymentType in resultStream
        do {
            employeeEmploymentTypes.push(employeeEmploymentType);
        };
    check resultStream.close();
    return employeeEmploymentTypes;
}

public isolated function getEmployeeEmploymentType(int id) returns EmployeeEmploymentType|error {
    EmployeeEmploymentType employeeEmploymentType = check smsDBClient->queryRow(
        `SELECT * FROM employee_employment_type WHERE id = ${id}`
    );
    return employeeEmploymentType;
}

public isolated function addEmployeeEmploymentType(EmployeeEmploymentType employeeEmploymentType) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        INSERT INTO employee_employment_type (  
            employee_id , 
            employment_type_id , 
            start_date , 
            end_date , 
            last_updated  )
        VALUES (
            ${employeeEmploymentType.employee_id}, 
            ${employeeEmploymentType.employment_type_id}, 
            ${employeeEmploymentType.start_date}, 
            ${employeeEmploymentType.end_date}, 
            ${employeeEmploymentType.last_updated} 
        )
    `);
    int|string? lastInsertId = result.lastInsertId;
    if lastInsertId is int {
        return lastInsertId;
    } else {
        return error("Unable to obtain last insert ID for employee_employment_type");
    }
}

public isolated function updateEmployeeEmploymentType(EmployeeEmploymentType employeeEmploymentType) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        UPDATE employee_employment_type SET  
            employee_id =  ${employeeEmploymentType.employee_id}, 
            employment_type_id =  ${employeeEmploymentType.employment_type_id}, 
            start_date =  ${employeeEmploymentType.start_date}, 
            end_date =  ${employeeEmploymentType.end_date}, 
            last_updated =  ${employeeEmploymentType.last_updated}        
        WHERE id = ${employeeEmploymentType.id} 
    `);
    int|string? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain last affected count for employee_employment_type update");
    }
}

isolated function deleteEmployeeEmploymentType(int id) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        DELETE FROM employee_employment_type WHERE id = ${id}
    `);
    int? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain the affected row count for employee_employment_type delete");
    }
}
