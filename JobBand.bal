import ballerina/sql;

public type JobBand record {
    int? id = ();
    string name;
    string description;
    int level;
    decimal min_salary;
    decimal max_salary;
};

public isolated function getJobBands() returns JobBand[]|error {
    JobBand[] jobBands = [];
    stream<JobBand, error?> resultStream = smsDBClient->query(
        `SELECT 
            id  , 
            name , 
            description , 
            level , 
            min_salary , 
            max_salary  
        FROM job_band`
    );
    check from JobBand jobBand in resultStream
        do {
            jobBands.push(jobBand);
        };
    check resultStream.close();
    return jobBands;
}

public isolated function getJobBand(int id) returns JobBand|error {
    JobBand jobBand = check smsDBClient->queryRow(
        `SELECT * FROM job_band WHERE id = ${id}`
    );
    return jobBand;
}

public isolated function addJobBand(JobBand jobBand) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        INSERT INTO job_band (  
            name , 
            description , 
            level , 
            min_salary , 
            max_salary  )
        VALUES (
            ${jobBand.name}, 
            ${jobBand.description}, 
            ${jobBand.level}, 
            ${jobBand.min_salary}, 
            ${jobBand.max_salary} 
        )
    `);
    int|string? lastInsertId = result.lastInsertId;
    if lastInsertId is int {
        return lastInsertId;
    } else {
        return error("Unable to obtain last insert ID for job_band");
    }
}

public isolated function updateJobBand(JobBand jobBand) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        UPDATE job_band SET  
            name =  ${jobBand.name}, 
            description =  ${jobBand.description}, 
            level =  ${jobBand.level}, 
            min_salary =  ${jobBand.min_salary}, 
            max_salary =  ${jobBand.max_salary}        
        WHERE id = ${jobBand.id} 
    `);
    int|string? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain last affected count for job_band update");
    }
}

isolated function deleteJobBand(int id) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        DELETE FROM job_band WHERE id = ${id}
    `);
    int? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain the affected row count for job_band delete");
    }
}
