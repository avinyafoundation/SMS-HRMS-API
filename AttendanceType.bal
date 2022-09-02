import ballerina/sql;

public type AttendanceType record {
    int? id = ();
    int employment_type_id;
    string name;
    string description;
};

public isolated function getAttendanceTypes() returns AttendanceType[]|error {
    AttendanceType[] attendanceTypes = [];
    stream<AttendanceType, error?> resultStream = smsDBClient->query(
        `SELECT 
            id  , 
            employment_type_id , 
            name , 
            description  
        FROM attendance_type`
    );
    check from AttendanceType attendanceType in resultStream
        do {
            attendanceTypes.push(attendanceType);
        };
    check resultStream.close();
    return attendanceTypes;
}

public isolated function getAttendanceType(int id) returns AttendanceType|error {
    AttendanceType attendanceType = check smsDBClient->queryRow(
        `SELECT * FROM attendance_type WHERE id = ${id}`
    );
    return attendanceType;
}

public isolated function addAttendanceType(AttendanceType attendanceType) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        INSERT INTO attendance_type (  
            employment_type_id , 
            name , 
            description  )
        VALUES (
            ${attendanceType.employment_type_id}, 
            ${attendanceType.name}, 
            ${attendanceType.description} 
        )
    `);
    int|string? lastInsertId = result.lastInsertId;
    if lastInsertId is int {
        return lastInsertId;
    } else {
        return error("Unable to obtain last insert ID for attendance_type");
    }
}

public isolated function updateAttendanceType(AttendanceType attendanceType) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        UPDATE attendance_type SET  
            employment_type_id =  ${attendanceType.employment_type_id}, 
            name =  ${attendanceType.name}, 
            description =  ${attendanceType.description}        
        WHERE id = ${attendanceType.id} 
    `);
    int|string? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain last affected count for attendance_type update");
    }
}

isolated function deleteAttendanceType(int id) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        DELETE FROM attendance_type WHERE id = ${id}
    `);
    int? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain the affected row count for attendance_type delete");
    }
}
