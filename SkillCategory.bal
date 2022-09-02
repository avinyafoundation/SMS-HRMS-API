import ballerina/sql;

public type SkillCategory record {
    int? id = ();
    string name;
    string description;
};

public isolated function getSkillCategories() returns SkillCategory[]|error {
    SkillCategory[] skillCategories = [];
    stream<SkillCategory, error?> resultStream = smsDBClient->query(
        `SELECT 
            id  , 
            name , 
            description  
        FROM skill_category`
    );
    check from SkillCategory skillCategory in resultStream
        do {
            skillCategories.push(skillCategory);
        };
    check resultStream.close();
    return skillCategories;
}

public isolated function getSkillCategory(int id) returns SkillCategory|error {
    SkillCategory skillCategory = check smsDBClient->queryRow(
        `SELECT * FROM skill_category WHERE id = ${id}`
    );
    return skillCategory;
}

public isolated function addSkillCategory(SkillCategory skillCategory) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        INSERT INTO skill_category (  
            name , 
            description  )
        VALUES (
            ${skillCategory.name}, 
            ${skillCategory.description} 
        )
    `);
    int|string? lastInsertId = result.lastInsertId;
    if lastInsertId is int {
        return lastInsertId;
    } else {
        return error("Unable to obtain last insert ID for skill_category");
    }
}

public isolated function updateSkillCategory(SkillCategory skillCategory) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        UPDATE skill_category SET  
            name =  ${skillCategory.name}, 
            description =  ${skillCategory.description}        
        WHERE id = ${skillCategory.id} 
    `);
    int|string? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain last affected count for skill_category update");
    }
}

isolated function deleteSkillCategory(int id) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        DELETE FROM skill_category WHERE id = ${id}
    `);
    int? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain the affected row count for skill_category delete");
    }
}
