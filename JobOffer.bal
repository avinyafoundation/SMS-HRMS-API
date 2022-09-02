import ballerina/sql;

import ballerina/time;

public type JobOffer record {
    int? id = ();
    int applicant_id;
    string offer_status;
    int approved_by;
    string start_date;
    string? end_date = ();
    time:Utc last_updated = time:utcNow();
    decimal salary;
    string description;
    string notes;
};

public isolated function getJobOffers() returns JobOffer[]|error {
    JobOffer[] jobOffers = [];
    stream<JobOffer, error?> resultStream = smsDBClient->query(
        `SELECT 
            id  , 
            applicant_id , 
            offer_status , 
            approved_by , 
            start_date , 
            end_date , 
            last_updated , 
            salary , 
            description , 
            notes  
        FROM job_offer`
    );
    check from JobOffer jobOffer in resultStream
        do {
            jobOffers.push(jobOffer);
        };
    check resultStream.close();
    return jobOffers;
}

public isolated function getJobOffer(int id) returns JobOffer|error {
    JobOffer jobOffer = check smsDBClient->queryRow(
        `SELECT * FROM job_offer WHERE id = ${id}`
    );
    return jobOffer;
}

public isolated function addJobOffer(JobOffer jobOffer) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        INSERT INTO job_offer (  
            applicant_id , 
            offer_status , 
            approved_by , 
            start_date , 
            end_date , 
            last_updated , 
            salary , 
            description , 
            notes  )
        VALUES (
            ${jobOffer.applicant_id}, 
            ${jobOffer.offer_status}, 
            ${jobOffer.approved_by}, 
            ${jobOffer.start_date}, 
            ${jobOffer.end_date}, 
            ${jobOffer.last_updated}, 
            ${jobOffer.salary}, 
            ${jobOffer.description}, 
            ${jobOffer.notes} 
        )
    `);
    int|string? lastInsertId = result.lastInsertId;
    if lastInsertId is int {
        return lastInsertId;
    } else {
        return error("Unable to obtain last insert ID for job_offer");
    }
}

public isolated function updateJobOffer(JobOffer jobOffer) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        UPDATE job_offer SET  
            applicant_id =  ${jobOffer.applicant_id}, 
            offer_status =  ${jobOffer.offer_status}, 
            approved_by =  ${jobOffer.approved_by}, 
            start_date =  ${jobOffer.start_date}, 
            end_date =  ${jobOffer.end_date}, 
            last_updated =  ${jobOffer.last_updated}, 
            salary =  ${jobOffer.salary}, 
            description =  ${jobOffer.description}, 
            notes =  ${jobOffer.notes}        
        WHERE id = ${jobOffer.id} 
    `);
    int|string? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain last affected count for job_offer update");
    }
}

isolated function deleteJobOffer(int id) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        DELETE FROM job_offer WHERE id = ${id}
    `);
    int? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain the affected row count for job_offer delete");
    }
}
