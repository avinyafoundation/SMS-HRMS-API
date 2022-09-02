import ballerina/sql;

import ballerina/time;

public type EmployeeQualification record {
    int? id = ();
    int employee_id;
    int job_qualification_id;
    int verified_by;
    int rating;
    string description;
    time:Utc last_updated = time:utcNow();
};

public isolated function getEmployeeQualifications() returns EmployeeQualification[]|error {
    EmployeeQualification[] employeeQualifications = [];
    stream<EmployeeQualification, error?> resultStream = smsDBClient->query(
        `SELECT 
            id  , 
            employee_id , 
            job_qualification_id , 
            verified_by , 
            rating , 
            description , 
            last_updated  
        FROM employee_qualification`
    );
    check from EmployeeQualification employeeQualification in resultStream
        do {
            employeeQualifications.push(employeeQualification);
        };
    check resultStream.close();
    return employeeQualifications;
}

public isolated function getEmployeeQualification(int id) returns EmployeeQualification|error {
    EmployeeQualification employeeQualification = check smsDBClient->queryRow(
        `SELECT * FROM employee_qualification WHERE id = ${id}`
    );
    return employeeQualification;
}

public isolated function addEmployeeQualification(EmployeeQualification employeeQualification) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        INSERT INTO employee_qualification (  
            employee_id , 
            job_qualification_id , 
            verified_by , 
            rating , 
            description , 
            last_updated  )
        VALUES (
            ${employeeQualification.employee_id}, 
            ${employeeQualification.job_qualification_id}, 
            ${employeeQualification.verified_by}, 
            ${employeeQualification.rating}, 
            ${employeeQualification.description}, 
            ${employeeQualification.last_updated} 
        )
    `);
    int|string? lastInsertId = result.lastInsertId;
    if lastInsertId is int {
        return lastInsertId;
    } else {
        return error("Unable to obtain last insert ID for employee_qualification");
    }
}

public isolated function updateEmployeeQualification(EmployeeQualification employeeQualification) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        UPDATE employee_qualification SET  
            employee_id =  ${employeeQualification.employee_id}, 
            job_qualification_id =  ${employeeQualification.job_qualification_id}, 
            verified_by =  ${employeeQualification.verified_by}, 
            rating =  ${employeeQualification.rating}, 
            description =  ${employeeQualification.description}, 
            last_updated =  ${employeeQualification.last_updated}        
        WHERE id = ${employeeQualification.id} 
    `);
    int|string? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain last affected count for employee_qualification update");
    }
}

isolated function deleteEmployeeQualification(int id) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        DELETE FROM employee_qualification WHERE id = ${id}
    `);
    int? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain the affected row count for employee_qualification delete");
    }
}
