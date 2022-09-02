import ballerina/sql;

import ballerina/time;

public type TeamLead record {
    int? id = ();
    int team_id;
    int employee_id;
    int lead_order;
    string title;
    string start_date;
    string? end_date = ();
    time:Utc last_updated = time:utcNow();
    string description;
};

public isolated function getTeamLeads() returns TeamLead[]|error {
    TeamLead[] teamLeads = [];
    stream<TeamLead, error?> resultStream = smsDBClient->query(
        `SELECT 
            id  , 
            team_id , 
            employee_id , 
            lead_order , 
            title , 
            start_date , 
            end_date , 
            last_updated , 
            description  
        FROM team_lead`
    );
    check from TeamLead teamLead in resultStream
        do {
            teamLeads.push(teamLead);
        };
    check resultStream.close();
    return teamLeads;
}

public isolated function getTeamLead(int id) returns TeamLead|error {
    TeamLead teamLead = check smsDBClient->queryRow(
        `SELECT * FROM team_lead WHERE id = ${id}`
    );
    return teamLead;
}

public isolated function addTeamLead(TeamLead teamLead) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        INSERT INTO team_lead (  
            team_id , 
            employee_id , 
            lead_order , 
            title , 
            start_date , 
            end_date , 
            last_updated , 
            description  )
        VALUES (
            ${teamLead.team_id}, 
            ${teamLead.employee_id}, 
            ${teamLead.lead_order}, 
            ${teamLead.title}, 
            ${teamLead.start_date}, 
            ${teamLead.end_date}, 
            ${teamLead.last_updated}, 
            ${teamLead.description} 
        )
    `);
    int|string? lastInsertId = result.lastInsertId;
    if lastInsertId is int {
        return lastInsertId;
    } else {
        return error("Unable to obtain last insert ID for team_lead");
    }
}

public isolated function updateTeamLead(TeamLead teamLead) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        UPDATE team_lead SET  
            team_id =  ${teamLead.team_id}, 
            employee_id =  ${teamLead.employee_id}, 
            lead_order =  ${teamLead.lead_order}, 
            title =  ${teamLead.title}, 
            start_date =  ${teamLead.start_date}, 
            end_date =  ${teamLead.end_date}, 
            last_updated =  ${teamLead.last_updated}, 
            description =  ${teamLead.description}        
        WHERE id = ${teamLead.id} 
    `);
    int|string? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain last affected count for team_lead update");
    }
}

isolated function deleteTeamLead(int id) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        DELETE FROM team_lead WHERE id = ${id}
    `);
    int? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain the affected row count for team_lead delete");
    }
}
