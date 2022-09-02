import ballerina/sql;

public type Job record {
    int? id = ();
    string name;
    string description;
    int team_id;
    int job_band_id;
};

public isolated function getJobs() returns Job[]|error {
    Job[] jobs = [];
    stream<Job, error?> resultStream = smsDBClient->query(
        `SELECT 
            id  , 
            name , 
            description , 
            team_id , 
            job_band_id  
        FROM job`
    );
    check from Job job in resultStream
        do {
            jobs.push(job);
        };
    check resultStream.close();
    return jobs;
}

public isolated function getJob(int id) returns Job|error {
    Job job = check smsDBClient->queryRow(
        `SELECT * FROM job WHERE id = ${id}`
    );
    return job;
}

public isolated function addJob(Job job) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        INSERT INTO job (  
            name , 
            description , 
            team_id , 
            job_band_id  )
        VALUES (
            ${job.name}, 
            ${job.description}, 
            ${job.team_id}, 
            ${job.job_band_id} 
        )
    `);
    int|string? lastInsertId = result.lastInsertId;
    if lastInsertId is int {
        return lastInsertId;
    } else {
        return error("Unable to obtain last insert ID for job");
    }
}

public isolated function updateJob(Job job) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        UPDATE job SET  
            name =  ${job.name}, 
            description =  ${job.description}, 
            team_id =  ${job.team_id}, 
            job_band_id =  ${job.job_band_id}        
        WHERE id = ${job.id} 
    `);
    int|string? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain last affected count for job update");
    }
}

isolated function deleteJob(int id) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        DELETE FROM job WHERE id = ${id}
    `);
    int? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain the affected row count for job delete");
    }
}
