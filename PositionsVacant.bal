import ballerina/sql;

import ballerina/time;

public type PositionsVacant record {
    int? id = ();
    int office_id;
    int job_id;
    int amount;
    string start_date;
    string? end_date = ();
    time:Utc last_updated = time:utcNow();
    string notes;
};

public isolated function getPositionsVacants() returns PositionsVacant[]|error {
    PositionsVacant[] positionsVacants = [];
    stream<PositionsVacant, error?> resultStream = smsDBClient->query(
        `SELECT 
            id  , 
            office_id , 
            job_id , 
            amount , 
            start_date , 
            end_date , 
            last_updated , 
            notes  
        FROM positions_vacant`
    );
    check from PositionsVacant positionsVacant in resultStream
        do {
            positionsVacants.push(positionsVacant);
        };
    check resultStream.close();
    return positionsVacants;
}

public isolated function getPositionsVacant(int id) returns PositionsVacant|error {
    PositionsVacant positionsVacant = check smsDBClient->queryRow(
        `SELECT * FROM positions_vacant WHERE id = ${id}`
    );
    return positionsVacant;
}

public isolated function addPositionsVacant(PositionsVacant positionsVacant) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        INSERT INTO positions_vacant (  
            office_id , 
            job_id , 
            amount , 
            start_date , 
            end_date , 
            last_updated , 
            notes  )
        VALUES (
            ${positionsVacant.office_id}, 
            ${positionsVacant.job_id}, 
            ${positionsVacant.amount}, 
            ${positionsVacant.start_date}, 
            ${positionsVacant.end_date}, 
            ${positionsVacant.last_updated}, 
            ${positionsVacant.notes} 
        )
    `);
    int|string? lastInsertId = result.lastInsertId;
    if lastInsertId is int {
        return lastInsertId;
    } else {
        return error("Unable to obtain last insert ID for positions_vacant");
    }
}

public isolated function updatePositionsVacant(PositionsVacant positionsVacant) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        UPDATE positions_vacant SET  
            office_id =  ${positionsVacant.office_id}, 
            job_id =  ${positionsVacant.job_id}, 
            amount =  ${positionsVacant.amount}, 
            start_date =  ${positionsVacant.start_date}, 
            end_date =  ${positionsVacant.end_date}, 
            last_updated =  ${positionsVacant.last_updated}, 
            notes =  ${positionsVacant.notes}        
        WHERE id = ${positionsVacant.id} 
    `);
    int|string? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain last affected count for positions_vacant update");
    }
}

isolated function deletePositionsVacant(int id) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        DELETE FROM positions_vacant WHERE id = ${id}
    `);
    int? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain the affected row count for positions_vacant delete");
    }
}
