import ballerina/sql;

public type JobEvaluationCriteria record {
    int? id = ();
    int job_id;
    int evaluation_criteria_category_id;
    int sequence_no;
    string description;
};

public isolated function getJobEvaluationCriterias() returns JobEvaluationCriteria[]|error {
    JobEvaluationCriteria[] jobEvaluationCriterias = [];
    stream<JobEvaluationCriteria, error?> resultStream = smsDBClient->query(
        `SELECT 
            id  , 
            job_id , 
            evaluation_criteria_category_id , 
            sequence_no , 
            description  
        FROM job_evaluation_criteria`
    );
    check from JobEvaluationCriteria jobEvaluationCriteria in resultStream
        do {
            jobEvaluationCriterias.push(jobEvaluationCriteria);
        };
    check resultStream.close();
    return jobEvaluationCriterias;
}

public isolated function getJobEvaluationCriteria(int id) returns JobEvaluationCriteria|error {
    JobEvaluationCriteria jobEvaluationCriteria = check smsDBClient->queryRow(
        `SELECT * FROM job_evaluation_criteria WHERE id = ${id}`
    );
    return jobEvaluationCriteria;
}

public isolated function addJobEvaluationCriteria(JobEvaluationCriteria jobEvaluationCriteria) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        INSERT INTO job_evaluation_criteria (  
            job_id , 
            evaluation_criteria_category_id , 
            sequence_no , 
            description  )
        VALUES (
            ${jobEvaluationCriteria.job_id}, 
            ${jobEvaluationCriteria.evaluation_criteria_category_id}, 
            ${jobEvaluationCriteria.sequence_no}, 
            ${jobEvaluationCriteria.description} 
        )
    `);
    int|string? lastInsertId = result.lastInsertId;
    if lastInsertId is int {
        return lastInsertId;
    } else {
        return error("Unable to obtain last insert ID for job_evaluation_criteria");
    }
}

public isolated function updateJobEvaluationCriteria(JobEvaluationCriteria jobEvaluationCriteria) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        UPDATE job_evaluation_criteria SET  
            job_id =  ${jobEvaluationCriteria.job_id}, 
            evaluation_criteria_category_id =  ${jobEvaluationCriteria.evaluation_criteria_category_id}, 
            sequence_no =  ${jobEvaluationCriteria.sequence_no}, 
            description =  ${jobEvaluationCriteria.description}        
        WHERE id = ${jobEvaluationCriteria.id} 
    `);
    int|string? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain last affected count for job_evaluation_criteria update");
    }
}

isolated function deleteJobEvaluationCriteria(int id) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        DELETE FROM job_evaluation_criteria WHERE id = ${id}
    `);
    int? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain the affected row count for job_evaluation_criteria delete");
    }
}
