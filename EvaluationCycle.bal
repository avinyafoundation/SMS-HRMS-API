import ballerina/sql;

import ballerina/time;

public type EvaluationCycle record {
    int? id = ();
    string name;
    string description;
    string start_date;
    string? end_date = ();
    time:Utc last_updated = time:utcNow();
    string notes;
};

public isolated function getEvaluationCycles() returns EvaluationCycle[]|error {
    EvaluationCycle[] evaluationCycles = [];
    stream<EvaluationCycle, error?> resultStream = smsDBClient->query(
        `SELECT 
            id  , 
            name , 
            description , 
            start_date , 
            end_date , 
            last_updated , 
            notes  
        FROM evaluation_cycle`
    );
    check from EvaluationCycle evaluationCycle in resultStream
        do {
            evaluationCycles.push(evaluationCycle);
        };
    check resultStream.close();
    return evaluationCycles;
}

public isolated function getEvaluationCycle(int id) returns EvaluationCycle|error {
    EvaluationCycle evaluationCycle = check smsDBClient->queryRow(
        `SELECT * FROM evaluation_cycle WHERE id = ${id}`
    );
    return evaluationCycle;
}

public isolated function addEvaluationCycle(EvaluationCycle evaluationCycle) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        INSERT INTO evaluation_cycle (  
            name , 
            description , 
            start_date , 
            end_date , 
            last_updated , 
            notes  )
        VALUES (
            ${evaluationCycle.name}, 
            ${evaluationCycle.description}, 
            ${evaluationCycle.start_date}, 
            ${evaluationCycle.end_date}, 
            ${evaluationCycle.last_updated}, 
            ${evaluationCycle.notes} 
        )
    `);
    int|string? lastInsertId = result.lastInsertId;
    if lastInsertId is int {
        return lastInsertId;
    } else {
        return error("Unable to obtain last insert ID for evaluation_cycle");
    }
}

public isolated function updateEvaluationCycle(EvaluationCycle evaluationCycle) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        UPDATE evaluation_cycle SET  
            name =  ${evaluationCycle.name}, 
            description =  ${evaluationCycle.description}, 
            start_date =  ${evaluationCycle.start_date}, 
            end_date =  ${evaluationCycle.end_date}, 
            last_updated =  ${evaluationCycle.last_updated}, 
            notes =  ${evaluationCycle.notes}        
        WHERE id = ${evaluationCycle.id} 
    `);
    int|string? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain last affected count for evaluation_cycle update");
    }
}

isolated function deleteEvaluationCycle(int id) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        DELETE FROM evaluation_cycle WHERE id = ${id}
    `);
    int? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain the affected row count for evaluation_cycle delete");
    }
}
