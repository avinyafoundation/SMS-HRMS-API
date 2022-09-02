import ballerina/sql;

public type JobQualification record {
    int? id = ();
    int job_id;
    int qualification_category_id;
    int sequence_no;
    string description;
};

public isolated function getJobQualifications() returns JobQualification[]|error {
    JobQualification[] jobQualifications = [];
    stream<JobQualification, error?> resultStream = smsDBClient->query(
        `SELECT 
            id  , 
            job_id , 
            qualification_category_id , 
            sequence_no , 
            description  
        FROM job_qualification`
    );
    check from JobQualification jobQualification in resultStream
        do {
            jobQualifications.push(jobQualification);
        };
    check resultStream.close();
    return jobQualifications;
}

public isolated function getJobQualification(int id) returns JobQualification|error {
    JobQualification jobQualification = check smsDBClient->queryRow(
        `SELECT * FROM job_qualification WHERE id = ${id}`
    );
    return jobQualification;
}

public isolated function addJobQualification(JobQualification jobQualification) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        INSERT INTO job_qualification (  
            job_id , 
            qualification_category_id , 
            sequence_no , 
            description  )
        VALUES (
            ${jobQualification.job_id}, 
            ${jobQualification.qualification_category_id}, 
            ${jobQualification.sequence_no}, 
            ${jobQualification.description} 
        )
    `);
    int|string? lastInsertId = result.lastInsertId;
    if lastInsertId is int {
        return lastInsertId;
    } else {
        return error("Unable to obtain last insert ID for job_qualification");
    }
}

public isolated function updateJobQualification(JobQualification jobQualification) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        UPDATE job_qualification SET  
            job_id =  ${jobQualification.job_id}, 
            qualification_category_id =  ${jobQualification.qualification_category_id}, 
            sequence_no =  ${jobQualification.sequence_no}, 
            description =  ${jobQualification.description}        
        WHERE id = ${jobQualification.id} 
    `);
    int|string? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain last affected count for job_qualification update");
    }
}

isolated function deleteJobQualification(int id) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        DELETE FROM job_qualification WHERE id = ${id}
    `);
    int? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain the affected row count for job_qualification delete");
    }
}
