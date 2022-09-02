import ballerina/sql;

import ballerina/time;

public type EmployeeEvaluation record {
    int? id = ();
    int employee_id;
    int job_evaluation_criteria_id;
    int evaluator_id;
    int evaluation_cycle_id;
    int rating;
    string description;
    time:Utc last_updated = time:utcNow();
};

public isolated function getEmployeeEvaluations() returns EmployeeEvaluation[]|error {
    EmployeeEvaluation[] employeeEvaluations = [];
    stream<EmployeeEvaluation, error?> resultStream = smsDBClient->query(
        `SELECT 
            id  , 
            employee_id , 
            job_evaluation_criteria_id , 
            evaluator_id , 
            evaluation_cycle_id , 
            rating , 
            description , 
            last_updated  
        FROM employee_evaluation`
    );
    check from EmployeeEvaluation employeeEvaluation in resultStream
        do {
            employeeEvaluations.push(employeeEvaluation);
        };
    check resultStream.close();
    return employeeEvaluations;
}

public isolated function getEmployeeEvaluation(int id) returns EmployeeEvaluation|error {
    EmployeeEvaluation employeeEvaluation = check smsDBClient->queryRow(
        `SELECT * FROM employee_evaluation WHERE id = ${id}`
    );
    return employeeEvaluation;
}

public isolated function addEmployeeEvaluation(EmployeeEvaluation employeeEvaluation) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        INSERT INTO employee_evaluation (  
            employee_id , 
            job_evaluation_criteria_id , 
            evaluator_id , 
            evaluation_cycle_id , 
            rating , 
            description , 
            last_updated  )
        VALUES (
            ${employeeEvaluation.employee_id}, 
            ${employeeEvaluation.job_evaluation_criteria_id}, 
            ${employeeEvaluation.evaluator_id}, 
            ${employeeEvaluation.evaluation_cycle_id}, 
            ${employeeEvaluation.rating}, 
            ${employeeEvaluation.description}, 
            ${employeeEvaluation.last_updated} 
        )
    `);
    int|string? lastInsertId = result.lastInsertId;
    if lastInsertId is int {
        return lastInsertId;
    } else {
        return error("Unable to obtain last insert ID for employee_evaluation");
    }
}

public isolated function updateEmployeeEvaluation(EmployeeEvaluation employeeEvaluation) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        UPDATE employee_evaluation SET  
            employee_id =  ${employeeEvaluation.employee_id}, 
            job_evaluation_criteria_id =  ${employeeEvaluation.job_evaluation_criteria_id}, 
            evaluator_id =  ${employeeEvaluation.evaluator_id}, 
            evaluation_cycle_id =  ${employeeEvaluation.evaluation_cycle_id}, 
            rating =  ${employeeEvaluation.rating}, 
            description =  ${employeeEvaluation.description}, 
            last_updated =  ${employeeEvaluation.last_updated}        
        WHERE id = ${employeeEvaluation.id} 
    `);
    int|string? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain last affected count for employee_evaluation update");
    }
}

isolated function deleteEmployeeEvaluation(int id) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        DELETE FROM employee_evaluation WHERE id = ${id}
    `);
    int? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain the affected row count for employee_evaluation delete");
    }
}
