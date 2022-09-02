import ballerina/sql;

public type QualificationCategory record {
    int? id = ();
    string name;
    string description;
};

public isolated function getQualificationCategories() returns QualificationCategory[]|error {
    QualificationCategory[] qualificationCategories = [];
    stream<QualificationCategory, error?> resultStream = smsDBClient->query(
        `SELECT 
            id  , 
            name , 
            description  
        FROM qualification_category`
    );
    check from QualificationCategory qualificationCategory in resultStream
        do {
            qualificationCategories.push(qualificationCategory);
        };
    check resultStream.close();
    return qualificationCategories;
}

public isolated function getQualificationCategory(int id) returns QualificationCategory|error {
    QualificationCategory qualificationCategory = check smsDBClient->queryRow(
        `SELECT * FROM qualification_category WHERE id = ${id}`
    );
    return qualificationCategory;
}

public isolated function addQualificationCategory(QualificationCategory qualificationCategory) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        INSERT INTO qualification_category (  
            name , 
            description  )
        VALUES (
            ${qualificationCategory.name}, 
            ${qualificationCategory.description} 
        )
    `);
    int|string? lastInsertId = result.lastInsertId;
    if lastInsertId is int {
        return lastInsertId;
    } else {
        return error("Unable to obtain last insert ID for qualification_category");
    }
}

public isolated function updateQualificationCategory(QualificationCategory qualificationCategory) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        UPDATE qualification_category SET  
            name =  ${qualificationCategory.name}, 
            description =  ${qualificationCategory.description}        
        WHERE id = ${qualificationCategory.id} 
    `);
    int|string? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain last affected count for qualification_category update");
    }
}

isolated function deleteQualificationCategory(int id) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        DELETE FROM qualification_category WHERE id = ${id}
    `);
    int? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain the affected row count for qualification_category delete");
    }
}
