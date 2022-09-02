import ballerina/sql;

import ballerina/time;

public type ApplicantApplicationStatus record {
    int? id = ();
    int applicant_id;
    int application_status_id;
    string start_date;
    string? end_date = ();
    time:Utc last_updated = time:utcNow();
    string notes;
};

public isolated function getApplicantApplicationStatuses() returns ApplicantApplicationStatus[]|error {
    ApplicantApplicationStatus[] applicantApplicationStatuses = [];
    stream<ApplicantApplicationStatus, error?> resultStream = smsDBClient->query(
        `SELECT 
            id  , 
            applicant_id , 
            application_status_id , 
            start_date , 
            end_date , 
            last_updated , 
            notes  
        FROM applicant_application_status`
    );
    check from ApplicantApplicationStatus applicantApplicationStatus in resultStream
        do {
            applicantApplicationStatuses.push(applicantApplicationStatus);
        };
    check resultStream.close();
    return applicantApplicationStatuses;
}

public isolated function getApplicantApplicationStatus(int id) returns ApplicantApplicationStatus|error {
    ApplicantApplicationStatus applicantApplicationStatus = check smsDBClient->queryRow(
        `SELECT * FROM applicant_application_status WHERE id = ${id}`
    );
    return applicantApplicationStatus;
}

public isolated function addApplicantApplicationStatus(ApplicantApplicationStatus applicantApplicationStatus) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        INSERT INTO applicant_application_status (  
            applicant_id , 
            application_status_id , 
            start_date , 
            end_date , 
            last_updated , 
            notes  )
        VALUES (
            ${applicantApplicationStatus.applicant_id}, 
            ${applicantApplicationStatus.application_status_id}, 
            ${applicantApplicationStatus.start_date}, 
            ${applicantApplicationStatus.end_date}, 
            ${applicantApplicationStatus.last_updated}, 
            ${applicantApplicationStatus.notes} 
        )
    `);
    int|string? lastInsertId = result.lastInsertId;
    if lastInsertId is int {
        return lastInsertId;
    } else {
        return error("Unable to obtain last insert ID for applicant_application_status");
    }
}

public isolated function updateApplicantApplicationStatus(ApplicantApplicationStatus applicantApplicationStatus) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        UPDATE applicant_application_status SET  
            applicant_id =  ${applicantApplicationStatus.applicant_id}, 
            application_status_id =  ${applicantApplicationStatus.application_status_id}, 
            start_date =  ${applicantApplicationStatus.start_date}, 
            end_date =  ${applicantApplicationStatus.end_date}, 
            last_updated =  ${applicantApplicationStatus.last_updated}, 
            notes =  ${applicantApplicationStatus.notes}        
        WHERE id = ${applicantApplicationStatus.id} 
    `);
    int|string? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain last affected count for applicant_application_status update");
    }
}

isolated function deleteApplicantApplicationStatus(int id) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        DELETE FROM applicant_application_status WHERE id = ${id}
    `);
    int? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain the affected row count for applicant_application_status delete");
    }
}
