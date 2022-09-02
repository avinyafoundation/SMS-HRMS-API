import ballerina/sql;

public type JobRoleResponsibility record {
    int? id = ();
    int job_id;
    int role_responsibility_category_id;
    int sequence_no;
    string description;
};

public isolated function getJobRoleResponsibilities() returns JobRoleResponsibility[]|error {
    JobRoleResponsibility[] jobRoleResponsibilities = [];
    stream<JobRoleResponsibility, error?> resultStream = smsDBClient->query(
        `SELECT 
            id  , 
            job_id , 
            role_responsibility_category_id , 
            sequence_no , 
            description  
        FROM job_role_responsibility`
    );
    check from JobRoleResponsibility jobRoleResponsibility in resultStream
        do {
            jobRoleResponsibilities.push(jobRoleResponsibility);
        };
    check resultStream.close();
    return jobRoleResponsibilities;
}

public isolated function getJobRoleResponsibility(int id) returns JobRoleResponsibility|error {
    JobRoleResponsibility jobRoleResponsibility = check smsDBClient->queryRow(
        `SELECT * FROM job_role_responsibility WHERE id = ${id}`
    );
    return jobRoleResponsibility;
}

public isolated function addJobRoleResponsibility(JobRoleResponsibility jobRoleResponsibility) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        INSERT INTO job_role_responsibility (  
            job_id , 
            role_responsibility_category_id , 
            sequence_no , 
            description  )
        VALUES (
            ${jobRoleResponsibility.job_id}, 
            ${jobRoleResponsibility.role_responsibility_category_id}, 
            ${jobRoleResponsibility.sequence_no}, 
            ${jobRoleResponsibility.description} 
        )
    `);
    int|string? lastInsertId = result.lastInsertId;
    if lastInsertId is int {
        return lastInsertId;
    } else {
        return error("Unable to obtain last insert ID for job_role_responsibility");
    }
}

public isolated function updateJobRoleResponsibility(JobRoleResponsibility jobRoleResponsibility) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        UPDATE job_role_responsibility SET  
            job_id =  ${jobRoleResponsibility.job_id}, 
            role_responsibility_category_id =  ${jobRoleResponsibility.role_responsibility_category_id}, 
            sequence_no =  ${jobRoleResponsibility.sequence_no}, 
            description =  ${jobRoleResponsibility.description}        
        WHERE id = ${jobRoleResponsibility.id} 
    `);
    int|string? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain last affected count for job_role_responsibility update");
    }
}

isolated function deleteJobRoleResponsibility(int id) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        DELETE FROM job_role_responsibility WHERE id = ${id}
    `);
    int? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain the affected row count for job_role_responsibility delete");
    }
}
