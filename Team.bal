import ballerina/sql;

public type Team record {
    int? id = ();
    int? parent_id = ();
    string name;
    string description;
};

public isolated function getTeams() returns Team[]|error {
    Team[] teams = [];
    stream<Team, error?> resultStream = smsDBClient->query(
        `SELECT 
            id  , 
            parent_id , 
            name , 
            description  
        FROM team`
    );
    check from Team team in resultStream
        do {
            teams.push(team);
        };
    check resultStream.close();
    return teams;
}

public isolated function getTeam(int id) returns Team|error {
    Team team = check smsDBClient->queryRow(
        `SELECT * FROM team WHERE id = ${id}`
    );
    return team;
}

public isolated function addTeam(Team team) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        INSERT INTO team (  
            parent_id , 
            name , 
            description  )
        VALUES (
            ${team.parent_id}, 
            ${team.name}, 
            ${team.description} 
        )
    `);
    int|string? lastInsertId = result.lastInsertId;
    if lastInsertId is int {
        return lastInsertId;
    } else {
        return error("Unable to obtain last insert ID for team");
    }
}

public isolated function updateTeam(Team team) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        UPDATE team SET  
            parent_id =  ${team.parent_id}, 
            name =  ${team.name}, 
            description =  ${team.description}        
        WHERE id = ${team.id} 
    `);
    int|string? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain last affected count for team update");
    }
}

isolated function deleteTeam(int id) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        DELETE FROM team WHERE id = ${id}
    `);
    int? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain the affected row count for team delete");
    }
}
