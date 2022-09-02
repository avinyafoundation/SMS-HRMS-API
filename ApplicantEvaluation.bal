import ballerina/sql;

import ballerina/time;

public type ApplicantEvaluation record {
    int? id = ();
    int applicant_id;
    int job_evaluation_criteria_id;
    int interviewer_id;
    int rating;
    string description;
    time:Utc last_updated = time:utcNow();
};

public isolated function getApplicantEvaluations() returns ApplicantEvaluation[]|error {
    ApplicantEvaluation[] applicantEvaluations = [];
    stream<ApplicantEvaluation, error?> resultStream = smsDBClient->query(
        `SELECT 
            id  , 
            applicant_id , 
            job_evaluation_criteria_id , 
            interviewer_id , 
            rating , 
            description , 
            last_updated  
        FROM applicant_evaluation`
    );
    check from ApplicantEvaluation applicantEvaluation in resultStream
        do {
            applicantEvaluations.push(applicantEvaluation);
        };
    check resultStream.close();
    return applicantEvaluations;
}

public isolated function getApplicantEvaluation(int id) returns ApplicantEvaluation|error {
    ApplicantEvaluation applicantEvaluation = check smsDBClient->queryRow(
        `SELECT * FROM applicant_evaluation WHERE id = ${id}`
    );
    return applicantEvaluation;
}

public isolated function addApplicantEvaluation(ApplicantEvaluation applicantEvaluation) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        INSERT INTO applicant_evaluation (  
            applicant_id , 
            job_evaluation_criteria_id , 
            interviewer_id , 
            rating , 
            description , 
            last_updated  )
        VALUES (
            ${applicantEvaluation.applicant_id}, 
            ${applicantEvaluation.job_evaluation_criteria_id}, 
            ${applicantEvaluation.interviewer_id}, 
            ${applicantEvaluation.rating}, 
            ${applicantEvaluation.description}, 
            ${applicantEvaluation.last_updated} 
        )
    `);
    int|string? lastInsertId = result.lastInsertId;
    if lastInsertId is int {
        return lastInsertId;
    } else {
        return error("Unable to obtain last insert ID for applicant_evaluation");
    }
}

public isolated function updateApplicantEvaluation(ApplicantEvaluation applicantEvaluation) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        UPDATE applicant_evaluation SET  
            applicant_id =  ${applicantEvaluation.applicant_id}, 
            job_evaluation_criteria_id =  ${applicantEvaluation.job_evaluation_criteria_id}, 
            interviewer_id =  ${applicantEvaluation.interviewer_id}, 
            rating =  ${applicantEvaluation.rating}, 
            description =  ${applicantEvaluation.description}, 
            last_updated =  ${applicantEvaluation.last_updated}        
        WHERE id = ${applicantEvaluation.id} 
    `);
    int|string? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain last affected count for applicant_evaluation update");
    }
}

isolated function deleteApplicantEvaluation(int id) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        DELETE FROM applicant_evaluation WHERE id = ${id}
    `);
    int? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain the affected row count for applicant_evaluation delete");
    }
}
