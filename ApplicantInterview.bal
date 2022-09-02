import ballerina/sql;

import ballerina/time;

public type ApplicantInterview record {
    int? id = ();
    int applicant_id;
    int interviewer_id;
    time:Utc date_time;
    string description;
    string current_status;
    string outcome;
    int rating;
    string? comments = (); # ENUM ('Pending', 'Done', 'Cancelled', 'Postponed', 'No show')  NOT NULL DEFAULT 'Pending'
    string? notes = (); # ENUM ('Selected', 'Rejected', 'On hold', 'Short List', 'Cross-check', 'Maybe', 'TBD')  NOT NULL DEFAULT 'TBD',  
    time:Utc last_updated = time:utcNow();
};

public isolated function getApplicantInterviews() returns ApplicantInterview[]|error {
    ApplicantInterview[] applicantInterviews = [];
    stream<ApplicantInterview, error?> resultStream = smsDBClient->query(
        `SELECT 
            id  , 
            applicant_id , 
            interviewer_id , 
            date_time , 
            description , 
            current_status , 
            outcome , 
            rating , 
            comments , 
            notes , 
            last_updated  
        FROM applicant_interview`
    );
    check from ApplicantInterview applicantInterview in resultStream
        do {
            applicantInterviews.push(applicantInterview);
        };
    check resultStream.close();
    return applicantInterviews;
}

public isolated function getApplicantInterview(int id) returns ApplicantInterview|error {
    ApplicantInterview applicantInterview = check smsDBClient->queryRow(
        `SELECT * FROM applicant_interview WHERE id = ${id}`
    );
    return applicantInterview;
}

public isolated function addApplicantInterview(ApplicantInterview applicantInterview) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        INSERT INTO applicant_interview (  
            applicant_id , 
            interviewer_id , 
            date_time , 
            description , 
            current_status , 
            outcome , 
            rating , 
            comments , 
            notes , 
            last_updated  )
        VALUES (
            ${applicantInterview.applicant_id}, 
            ${applicantInterview.interviewer_id}, 
            ${applicantInterview.date_time}, 
            ${applicantInterview.description}, 
            ${applicantInterview.current_status}, 
            ${applicantInterview.outcome}, 
            ${applicantInterview.rating}, 
            ${applicantInterview.comments}, 
            ${applicantInterview.notes}, 
            ${applicantInterview.last_updated} 
        )
    `);
    int|string? lastInsertId = result.lastInsertId;
    if lastInsertId is int {
        return lastInsertId;
    } else {
        return error("Unable to obtain last insert ID for applicant_interview");
    }
}

public isolated function updateApplicantInterview(ApplicantInterview applicantInterview) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        UPDATE applicant_interview SET  
            applicant_id =  ${applicantInterview.applicant_id}, 
            interviewer_id =  ${applicantInterview.interviewer_id}, 
            date_time =  ${applicantInterview.date_time}, 
            description =  ${applicantInterview.description}, 
            current_status =  ${applicantInterview.current_status}, 
            outcome =  ${applicantInterview.outcome}, 
            rating =  ${applicantInterview.rating}, 
            comments =  ${applicantInterview.comments}, 
            notes =  ${applicantInterview.notes}, 
            last_updated =  ${applicantInterview.last_updated}        
        WHERE id = ${applicantInterview.id} 
    `);
    int|string? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain last affected count for applicant_interview update");
    }
}

isolated function deleteApplicantInterview(int id) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        DELETE FROM applicant_interview WHERE id = ${id}
    `);
    int? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain the affected row count for applicant_interview delete");
    }
}
