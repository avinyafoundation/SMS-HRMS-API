import ballerina/sql;

public type JobSkill record {
    int? id = ();
    int job_id;
    int skill_category_id;
    int sequence_no;
    string description;
};

public isolated function getJobSkills() returns JobSkill[]|error {
    JobSkill[] jobSkills = [];
    stream<JobSkill, error?> resultStream = smsDBClient->query(
        `SELECT 
            id  , 
            job_id , 
            skill_category_id , 
            sequence_no , 
            description  
        FROM job_skill`
    );
    check from JobSkill jobSkill in resultStream
        do {
            jobSkills.push(jobSkill);
        };
    check resultStream.close();
    return jobSkills;
}

public isolated function getJobSkill(int id) returns JobSkill|error {
    JobSkill jobSkill = check smsDBClient->queryRow(
        `SELECT * FROM job_skill WHERE id = ${id}`
    );
    return jobSkill;
}

public isolated function addJobSkill(JobSkill jobSkill) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        INSERT INTO job_skill (  
            job_id , 
            skill_category_id , 
            sequence_no , 
            description  )
        VALUES (
            ${jobSkill.job_id}, 
            ${jobSkill.skill_category_id}, 
            ${jobSkill.sequence_no}, 
            ${jobSkill.description} 
        )
    `);
    int|string? lastInsertId = result.lastInsertId;
    if lastInsertId is int {
        return lastInsertId;
    } else {
        return error("Unable to obtain last insert ID for job_skill");
    }
}

public isolated function updateJobSkill(JobSkill jobSkill) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        UPDATE job_skill SET  
            job_id =  ${jobSkill.job_id}, 
            skill_category_id =  ${jobSkill.skill_category_id}, 
            sequence_no =  ${jobSkill.sequence_no}, 
            description =  ${jobSkill.description}        
        WHERE id = ${jobSkill.id} 
    `);
    int|string? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain last affected count for job_skill update");
    }
}

isolated function deleteJobSkill(int id) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        DELETE FROM job_skill WHERE id = ${id}
    `);
    int? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain the affected row count for job_skill delete");
    }
}
