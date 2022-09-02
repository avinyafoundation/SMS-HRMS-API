import ballerina/sql;

public type Branch record {
    int? id = ();
    int organization_id;
    string name;
    string description;
    string phone_number1;
    string phone_number2;
};

public isolated function getBranches() returns Branch[]|error {
    Branch[] branches = [];
    stream<Branch, error?> resultStream = smsDBClient->query(
        `SELECT 
            id  , 
            organization_id , 
            name , 
            description , 
            phone_number1 , 
            phone_number2  
        FROM branch`
    );
    check from Branch branch in resultStream
        do {
            branches.push(branch);
        };
    check resultStream.close();
    return branches;
}

public isolated function getBranch(int id) returns Branch|error {
    Branch branch = check smsDBClient->queryRow(
        `SELECT * FROM branch WHERE id = ${id}`
    );
    return branch;
}

public isolated function addBranch(Branch branch) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        INSERT INTO branch (  
            organization_id , 
            name , 
            description , 
            phone_number1 , 
            phone_number2  )
        VALUES (
            ${branch.organization_id}, 
            ${branch.name}, 
            ${branch.description}, 
            ${branch.phone_number1}, 
            ${branch.phone_number2} 
        )
    `);
    int|string? lastInsertId = result.lastInsertId;
    if lastInsertId is int {
        return lastInsertId;
    } else {
        return error("Unable to obtain last insert ID for branch");
    }
}

public isolated function updateBranch(Branch branch) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        UPDATE branch SET  
            organization_id =  ${branch.organization_id}, 
            name =  ${branch.name}, 
            description =  ${branch.description}, 
            phone_number1 =  ${branch.phone_number1}, 
            phone_number2 =  ${branch.phone_number2}        
        WHERE id = ${branch.id} 
    `);
    int|string? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain last affected count for branch update");
    }
}

isolated function deleteBranch(int id) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        DELETE FROM branch WHERE id = ${id}
    `);
    int? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain the affected row count for branch delete");
    }
}
