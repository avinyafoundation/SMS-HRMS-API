import ballerina/sql;

public type EvaluationCriteriaCategory record {
    int? id = ();
    string name;
    string description;
};

public isolated function getEvaluationCriteriaCategories() returns EvaluationCriteriaCategory[]|error {
    EvaluationCriteriaCategory[] evaluationCriteriaCategories = [];
    stream<EvaluationCriteriaCategory, error?> resultStream = smsDBClient->query(
        `SELECT 
            id  , 
            name , 
            description  
        FROM evaluation_criteria_category`
    );
    check from EvaluationCriteriaCategory evaluationCriteriaCategory in resultStream
        do {
            evaluationCriteriaCategories.push(evaluationCriteriaCategory);
        };
    check resultStream.close();
    return evaluationCriteriaCategories;
}

public isolated function getEvaluationCriteriaCategory(int id) returns EvaluationCriteriaCategory|error {
    EvaluationCriteriaCategory evaluationCriteriaCategory = check smsDBClient->queryRow(
        `SELECT * FROM evaluation_criteria_category WHERE id = ${id}`
    );
    return evaluationCriteriaCategory;
}

public isolated function addEvaluationCriteriaCategory(EvaluationCriteriaCategory evaluationCriteriaCategory) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        INSERT INTO evaluation_criteria_category (  
            name , 
            description  )
        VALUES (
            ${evaluationCriteriaCategory.name}, 
            ${evaluationCriteriaCategory.description} 
        )
    `);
    int|string? lastInsertId = result.lastInsertId;
    if lastInsertId is int {
        return lastInsertId;
    } else {
        return error("Unable to obtain last insert ID for evaluation_criteria_category");
    }
}

public isolated function updateEvaluationCriteriaCategory(EvaluationCriteriaCategory evaluationCriteriaCategory) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        UPDATE evaluation_criteria_category SET  
            name =  ${evaluationCriteriaCategory.name}, 
            description =  ${evaluationCriteriaCategory.description}        
        WHERE id = ${evaluationCriteriaCategory.id} 
    `);
    int|string? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain last affected count for evaluation_criteria_category update");
    }
}

isolated function deleteEvaluationCriteriaCategory(int id) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        DELETE FROM evaluation_criteria_category WHERE id = ${id}
    `);
    int? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain the affected row count for evaluation_criteria_category delete");
    }
}
