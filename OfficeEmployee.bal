import ballerina/sql;

import ballerina/time;

public type OfficeEmployee record {
    int? id = ();
    int office_id;
    int job_id;
    int employee_id;
    string start_date;
    string? end_date = ();
    time:Utc last_updated = time:utcNow();
    string title;
    string notes;
};

public isolated function getOfficeEmployees() returns OfficeEmployee[]|error {
    OfficeEmployee[] officeEmployees = [];
    stream<OfficeEmployee, error?> resultStream = smsDBClient->query(
        `SELECT 
            id  , 
            office_id , 
            job_id , 
            employee_id , 
            start_date , 
            end_date , 
            last_updated , 
            title , 
            notes  
        FROM office_employee`
    );
    check from OfficeEmployee officeEmployee in resultStream
        do {
            officeEmployees.push(officeEmployee);
        };
    check resultStream.close();
    return officeEmployees;
}

public isolated function getOfficeEmployee(int id) returns OfficeEmployee|error {
    OfficeEmployee officeEmployee = check smsDBClient->queryRow(
        `SELECT * FROM office_employee WHERE id = ${id}`
    );
    return officeEmployee;
}

public isolated function addOfficeEmployee(OfficeEmployee officeEmployee) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        INSERT INTO office_employee (  
            office_id , 
            job_id , 
            employee_id , 
            start_date , 
            end_date , 
            last_updated , 
            title , 
            notes  )
        VALUES (
            ${officeEmployee.office_id}, 
            ${officeEmployee.job_id}, 
            ${officeEmployee.employee_id}, 
            ${officeEmployee.start_date}, 
            ${officeEmployee.end_date}, 
            ${officeEmployee.last_updated}, 
            ${officeEmployee.title}, 
            ${officeEmployee.notes} 
        )
    `);
    int|string? lastInsertId = result.lastInsertId;
    if lastInsertId is int {
        return lastInsertId;
    } else {
        return error("Unable to obtain last insert ID for office_employee");
    }
}

public isolated function updateOfficeEmployee(OfficeEmployee officeEmployee) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        UPDATE office_employee SET  
            office_id =  ${officeEmployee.office_id}, 
            job_id =  ${officeEmployee.job_id}, 
            employee_id =  ${officeEmployee.employee_id}, 
            start_date =  ${officeEmployee.start_date}, 
            end_date =  ${officeEmployee.end_date}, 
            last_updated =  ${officeEmployee.last_updated}, 
            title =  ${officeEmployee.title}, 
            notes =  ${officeEmployee.notes}        
        WHERE id = ${officeEmployee.id} 
    `);
    int|string? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain last affected count for office_employee update");
    }
}

isolated function deleteOfficeEmployee(int id) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        DELETE FROM office_employee WHERE id = ${id}
    `);
    int? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain the affected row count for office_employee delete");
    }
}
