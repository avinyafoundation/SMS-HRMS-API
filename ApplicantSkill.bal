import ballerina/sql;

import ballerina/time;

public type ApplicantSkill record {
    int? id = ();
    int applicant_id;
    int job_skill_id;
    int evaluator_id;
    int rating;
    string description;
    time:Utc last_updated = time:utcNow();
};

public isolated function getApplicantSkills() returns ApplicantSkill[]|error {
    ApplicantSkill[] applicantSkills = [];
    stream<ApplicantSkill, error?> resultStream = smsDBClient->query(
        `SELECT 
            id  , 
            applicant_id , 
            job_skill_id , 
            evaluator_id , 
            rating , 
            description , 
            last_updated  
        FROM applicant_skill`
    );
    check from ApplicantSkill applicantSkill in resultStream
        do {
            applicantSkills.push(applicantSkill);
        };
    check resultStream.close();
    return applicantSkills;
}

public isolated function getApplicantSkill(int id) returns ApplicantSkill|error {
    ApplicantSkill applicantSkill = check smsDBClient->queryRow(
        `SELECT * FROM applicant_skill WHERE id = ${id}`
    );
    return applicantSkill;
}

public isolated function addApplicantSkill(ApplicantSkill applicantSkill) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        INSERT INTO applicant_skill (  
            applicant_id , 
            job_skill_id , 
            evaluator_id , 
            rating , 
            description , 
            last_updated  )
        VALUES (
            ${applicantSkill.applicant_id}, 
            ${applicantSkill.job_skill_id}, 
            ${applicantSkill.evaluator_id}, 
            ${applicantSkill.rating}, 
            ${applicantSkill.description}, 
            ${applicantSkill.last_updated} 
        )
    `);
    int|string? lastInsertId = result.lastInsertId;
    if lastInsertId is int {
        return lastInsertId;
    } else {
        return error("Unable to obtain last insert ID for applicant_skill");
    }
}

public isolated function updateApplicantSkill(ApplicantSkill applicantSkill) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        UPDATE applicant_skill SET  
            applicant_id =  ${applicantSkill.applicant_id}, 
            job_skill_id =  ${applicantSkill.job_skill_id}, 
            evaluator_id =  ${applicantSkill.evaluator_id}, 
            rating =  ${applicantSkill.rating}, 
            description =  ${applicantSkill.description}, 
            last_updated =  ${applicantSkill.last_updated}        
        WHERE id = ${applicantSkill.id} 
    `);
    int|string? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain last affected count for applicant_skill update");
    }
}

isolated function deleteApplicantSkill(int id) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        DELETE FROM applicant_skill WHERE id = ${id}
    `);
    int? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain the affected row count for applicant_skill delete");
    }
}
