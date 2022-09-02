import ballerina/sql;

import ballerina/time;

public type Applicant record {
    int? id = ();
    string positions_vacant_id;
    string first_name;
    string last_name;
    string name_with_initials;
    string full_name;
    string gender;
    string applied_date;
    string id_number;
    string phone_number1;
    string? phone_number2 = ();
    string? email = ();
    string? cv_location = ();
    time:Utc last_updated = time:utcNow();
};

public isolated function getApplicants() returns Applicant[]|error {
    Applicant[] applicants = [];
    stream<Applicant, error?> resultStream = smsDBClient->query(
        `SELECT 
            id  , 
            positions_vacant_id , 
            first_name , 
            last_name , 
            name_with_initials , 
            full_name , 
            gender , 
            applied_date , 
            id_number , 
            phone_number1 , 
            phone_number2 , 
            email , 
            cv_location , 
            last_updated  
        FROM applicant`
    );
    check from Applicant applicant in resultStream
        do {
            applicants.push(applicant);
        };
    check resultStream.close();
    return applicants;
}

public isolated function getApplicant(int id) returns Applicant|error {
    Applicant applicant = check smsDBClient->queryRow(
        `SELECT * FROM applicant WHERE id = ${id}`
    );
    return applicant;
}

public isolated function addApplicant(Applicant applicant) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        INSERT INTO applicant (  
            positions_vacant_id , 
            first_name , 
            last_name , 
            name_with_initials , 
            full_name , 
            gender , 
            applied_date , 
            id_number , 
            phone_number1 , 
            phone_number2 , 
            email , 
            cv_location , 
            last_updated  )
        VALUES (
            ${applicant.positions_vacant_id}, 
            ${applicant.first_name}, 
            ${applicant.last_name}, 
            ${applicant.name_with_initials}, 
            ${applicant.full_name}, 
            ${applicant.gender}, 
            ${applicant.applied_date}, 
            ${applicant.id_number}, 
            ${applicant.phone_number1}, 
            ${applicant.phone_number2}, 
            ${applicant.email}, 
            ${applicant.cv_location}, 
            ${applicant.last_updated} 
        )
    `);
    int|string? lastInsertId = result.lastInsertId;
    if lastInsertId is int {
        return lastInsertId;
    } else {
        return error("Unable to obtain last insert ID for applicant");
    }
}

public isolated function updateApplicant(Applicant applicant) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        UPDATE applicant SET  
            positions_vacant_id =  ${applicant.positions_vacant_id}, 
            first_name =  ${applicant.first_name}, 
            last_name =  ${applicant.last_name}, 
            name_with_initials =  ${applicant.name_with_initials}, 
            full_name =  ${applicant.full_name}, 
            gender =  ${applicant.gender}, 
            applied_date =  ${applicant.applied_date}, 
            id_number =  ${applicant.id_number}, 
            phone_number1 =  ${applicant.phone_number1}, 
            phone_number2 =  ${applicant.phone_number2}, 
            email =  ${applicant.email}, 
            cv_location =  ${applicant.cv_location}, 
            last_updated =  ${applicant.last_updated}        
        WHERE id = ${applicant.id} 
    `);
    int|string? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain last affected count for applicant update");
    }
}

isolated function deleteApplicant(int id) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        DELETE FROM applicant WHERE id = ${id}
    `);
    int? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain the affected row count for applicant delete");
    }
}
