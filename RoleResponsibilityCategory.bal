import ballerina/sql;

public type RoleResponsibilityCategory record {
    int? id = ();
    string name;
    string description;
};

public isolated function getRoleResponsibilityCategories() returns RoleResponsibilityCategory[]|error {
    RoleResponsibilityCategory[] roleResponsibilityCategories = [];
    stream<RoleResponsibilityCategory, error?> resultStream = smsDBClient->query(
        `SELECT 
            id  , 
            name , 
            description  
        FROM role_responsibility_category`
    );
    check from RoleResponsibilityCategory roleResponsibilityCategory in resultStream
        do {
            roleResponsibilityCategories.push(roleResponsibilityCategory);
        };
    check resultStream.close();
    return roleResponsibilityCategories;
}

public isolated function getRoleResponsibilityCategory(int id) returns RoleResponsibilityCategory|error {
    RoleResponsibilityCategory roleResponsibilityCategory = check smsDBClient->queryRow(
        `SELECT * FROM role_responsibility_category WHERE id = ${id}`
    );
    return roleResponsibilityCategory;
}

public isolated function addRoleResponsibilityCategory(RoleResponsibilityCategory roleResponsibilityCategory) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        INSERT INTO role_responsibility_category (  
            name , 
            description  )
        VALUES (
            ${roleResponsibilityCategory.name}, 
            ${roleResponsibilityCategory.description} 
        )
    `);
    int|string? lastInsertId = result.lastInsertId;
    if lastInsertId is int {
        return lastInsertId;
    } else {
        return error("Unable to obtain last insert ID for role_responsibility_category");
    }
}

public isolated function updateRoleResponsibilityCategory(RoleResponsibilityCategory roleResponsibilityCategory) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        UPDATE role_responsibility_category SET  
            name =  ${roleResponsibilityCategory.name}, 
            description =  ${roleResponsibilityCategory.description}        
        WHERE id = ${roleResponsibilityCategory.id} 
    `);
    int|string? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain last affected count for role_responsibility_category update");
    }
}

isolated function deleteRoleResponsibilityCategory(int id) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        DELETE FROM role_responsibility_category WHERE id = ${id}
    `);
    int? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain the affected row count for role_responsibility_category delete");
    }
}
