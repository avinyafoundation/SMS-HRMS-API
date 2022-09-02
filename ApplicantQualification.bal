import ballerina/sql;

import ballerina/time;

public type ApplicantQualification record {
    int? id = ();
    int applicant_id;
    int job_qualification_id;
    int rating;
    string description;
    time:Utc last_updated = time:utcNow();
};

public isolated function getApplicantQualifications() returns ApplicantQualification[]|error {
    ApplicantQualification[] applicantQualifications = [];
    stream<ApplicantQualification, error?> resultStream = smsDBClient->query(
        `SELECT 
            id  , 
            applicant_id , 
            job_qualification_id , 
            rating , 
            description , 
            last_updated  
        FROM applicant_qualification`
    );
    check from ApplicantQualification applicantQualification in resultStream
        do {
            applicantQualifications.push(applicantQualification);
        };
    check resultStream.close();
    return applicantQualifications;
}

public isolated function getApplicantQualification(int id) returns ApplicantQualification|error {
    ApplicantQualification applicantQualification = check smsDBClient->queryRow(
        `SELECT * FROM applicant_qualification WHERE id = ${id}`
    );
    return applicantQualification;
}

public isolated function addApplicantQualification(ApplicantQualification applicantQualification) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        INSERT INTO applicant_qualification (  
            applicant_id , 
            job_qualification_id , 
            rating , 
            description , 
            last_updated  )
        VALUES (
            ${applicantQualification.applicant_id}, 
            ${applicantQualification.job_qualification_id}, 
            ${applicantQualification.rating}, 
            ${applicantQualification.description}, 
            ${applicantQualification.last_updated} 
        )
    `);
    int|string? lastInsertId = result.lastInsertId;
    if lastInsertId is int {
        return lastInsertId;
    } else {
        return error("Unable to obtain last insert ID for applicant_qualification");
    }
}

public isolated function updateApplicantQualification(ApplicantQualification applicantQualification) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        UPDATE applicant_qualification SET  
            applicant_id =  ${applicantQualification.applicant_id}, 
            job_qualification_id =  ${applicantQualification.job_qualification_id}, 
            rating =  ${applicantQualification.rating}, 
            description =  ${applicantQualification.description}, 
            last_updated =  ${applicantQualification.last_updated}        
        WHERE id = ${applicantQualification.id} 
    `);
    int|string? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain last affected count for applicant_qualification update");
    }
}

isolated function deleteApplicantQualification(int id) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        DELETE FROM applicant_qualification WHERE id = ${id}
    `);
    int? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain the affected row count for applicant_qualification delete");
    }
}
