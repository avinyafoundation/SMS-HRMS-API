import ballerina/sql;

import ballerina/time;

public type EmployeeSkill record {
    int? id = ();
    int employee_id;
    int job_skill_id;
    int evaluator_id;
    int rating;
    string description;
    time:Utc last_updated = time:utcNow();
};

public isolated function getEmployeeSkills() returns EmployeeSkill[]|error {
    EmployeeSkill[] employeeSkills = [];
    stream<EmployeeSkill, error?> resultStream = smsDBClient->query(
        `SELECT 
            id  , 
            employee_id , 
            job_skill_id , 
            evaluator_id , 
            rating , 
            description , 
            last_updated  
        FROM employee_skill`
    );
    check from EmployeeSkill employeeSkill in resultStream
        do {
            employeeSkills.push(employeeSkill);
        };
    check resultStream.close();
    return employeeSkills;
}

public isolated function getEmployeeSkill(int id) returns EmployeeSkill|error {
    EmployeeSkill employeeSkill = check smsDBClient->queryRow(
        `SELECT * FROM employee_skill WHERE id = ${id}`
    );
    return employeeSkill;
}

public isolated function addEmployeeSkill(EmployeeSkill employeeSkill) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        INSERT INTO employee_skill (  
            employee_id , 
            job_skill_id , 
            evaluator_id , 
            rating , 
            description , 
            last_updated  )
        VALUES (
            ${employeeSkill.employee_id}, 
            ${employeeSkill.job_skill_id}, 
            ${employeeSkill.evaluator_id}, 
            ${employeeSkill.rating}, 
            ${employeeSkill.description}, 
            ${employeeSkill.last_updated} 
        )
    `);
    int|string? lastInsertId = result.lastInsertId;
    if lastInsertId is int {
        return lastInsertId;
    } else {
        return error("Unable to obtain last insert ID for employee_skill");
    }
}

public isolated function updateEmployeeSkill(EmployeeSkill employeeSkill) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        UPDATE employee_skill SET  
            employee_id =  ${employeeSkill.employee_id}, 
            job_skill_id =  ${employeeSkill.job_skill_id}, 
            evaluator_id =  ${employeeSkill.evaluator_id}, 
            rating =  ${employeeSkill.rating}, 
            description =  ${employeeSkill.description}, 
            last_updated =  ${employeeSkill.last_updated}        
        WHERE id = ${employeeSkill.id} 
    `);
    int|string? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain last affected count for employee_skill update");
    }
}

isolated function deleteEmployeeSkill(int id) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        DELETE FROM employee_skill WHERE id = ${id}
    `);
    int? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain the affected row count for employee_skill delete");
    }
}
