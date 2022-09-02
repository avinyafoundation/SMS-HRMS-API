import ballerina/sql;

public type Office record {
    int? id = ();
    int branch_id;
    string name;
    string description;
    string phone_number1;
    string phone_number2;
};

public isolated function getOffices() returns Office[]|error {
    Office[] offices = [];
    stream<Office, error?> resultStream = smsDBClient->query(
        `SELECT 
            id  , 
            branch_id , 
            name , 
            description , 
            phone_number1 , 
            phone_number2  
        FROM office`
    );
    check from Office office in resultStream
        do {
            offices.push(office);
        };
    check resultStream.close();
    return offices;
}

public isolated function getOffice(int id) returns Office|error {
    Office office = check smsDBClient->queryRow(
        `SELECT * FROM office WHERE id = ${id}`
    );
    return office;
}

public isolated function addOffice(Office office) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        INSERT INTO office (  
            branch_id , 
            name , 
            description , 
            phone_number1 , 
            phone_number2  )
        VALUES (
            ${office.branch_id}, 
            ${office.name}, 
            ${office.description}, 
            ${office.phone_number1}, 
            ${office.phone_number2} 
        )
    `);
    int|string? lastInsertId = result.lastInsertId;
    if lastInsertId is int {
        return lastInsertId;
    } else {
        return error("Unable to obtain last insert ID for office");
    }
}

public isolated function updateOffice(Office office) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        UPDATE office SET  
            branch_id =  ${office.branch_id}, 
            name =  ${office.name}, 
            description =  ${office.description}, 
            phone_number1 =  ${office.phone_number1}, 
            phone_number2 =  ${office.phone_number2}        
        WHERE id = ${office.id} 
    `);
    int|string? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain last affected count for office update");
    }
}

isolated function deleteOffice(int id) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        DELETE FROM office WHERE id = ${id}
    `);
    int? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain the affected row count for office delete");
    }
}
