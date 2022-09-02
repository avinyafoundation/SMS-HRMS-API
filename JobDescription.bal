import ballerina/sql;

public type JobDescription record {
    int? id = ();
    int job_id;
    int sequence_no;
    string description;
};

public isolated function getJobDescriptions() returns JobDescription[]|error {
    JobDescription[] jobDescriptions = [];
    stream<JobDescription, error?> resultStream = smsDBClient->query(
        `SELECT 
            id  , 
            job_id , 
            sequence_no , 
            description  
        FROM job_description`
    );
    check from JobDescription jobDescription in resultStream
        do {
            jobDescriptions.push(jobDescription);
        };
    check resultStream.close();
    return jobDescriptions;
}

public isolated function getJobDescription(int id) returns JobDescription|error {
    JobDescription jobDescription = check smsDBClient->queryRow(
        `SELECT * FROM job_description WHERE id = ${id}`
    );
    return jobDescription;
}

public isolated function addJobDescription(JobDescription jobDescription) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        INSERT INTO job_description (  
            job_id , 
            sequence_no , 
            description  )
        VALUES (
            ${jobDescription.job_id}, 
            ${jobDescription.sequence_no}, 
            ${jobDescription.description} 
        )
    `);
    int|string? lastInsertId = result.lastInsertId;
    if lastInsertId is int {
        return lastInsertId;
    } else {
        return error("Unable to obtain last insert ID for job_description");
    }
}

public isolated function updateJobDescription(JobDescription jobDescription) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        UPDATE job_description SET  
            job_id =  ${jobDescription.job_id}, 
            sequence_no =  ${jobDescription.sequence_no}, 
            description =  ${jobDescription.description}        
        WHERE id = ${jobDescription.id} 
    `);
    int|string? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain last affected count for job_description update");
    }
}

isolated function deleteJobDescription(int id) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        DELETE FROM job_description WHERE id = ${id}
    `);
    int? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain the affected row count for job_description delete");
    }
}
