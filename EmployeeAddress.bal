import ballerina/sql;

public type EmployeeAddress record {
    int employee_id;
    int address_id;
};

public isolated function getEmployeeAddresses() returns EmployeeAddress[]|error {
    EmployeeAddress[] employeeAddresses = [];
    stream<EmployeeAddress, error?> resultStream = smsDBClient->query(
        `SELECT 
            employee_id , 
            address_id  
        FROM employee_address`
    );
    check from EmployeeAddress employeeAddress in resultStream
        do {
            employeeAddresses.push(employeeAddress);
        };
    check resultStream.close();
    return employeeAddresses;
}

public isolated function getEmployeeAddress(int employee_id, int address_id) returns EmployeeAddress|error {
    EmployeeAddress employeeAddress = check smsDBClient->queryRow(
        `SELECT * FROM employee_address WHERE employee_id = ${employee_id} AND address_id = ${address_id}`
    );
    return employeeAddress;
}

public isolated function getAddressesForEmployee(int employee_id) returns EmployeeAddress[]|error {
    EmployeeAddress[] employeeAddresses = [];
    stream<EmployeeAddress, error?> resultStream = smsDBClient->query(
        `SELECT 
            employee_id , 
            address_id  
        FROM employee_address WHERE employee_id = ${employee_id}`
    );
    check from EmployeeAddress employeeAddress in resultStream
        do {
            employeeAddresses.push(employeeAddress);
        };
    check resultStream.close();
    return employeeAddresses;
}

public isolated function addEmployeeAddress(EmployeeAddress employeeAddress) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        INSERT INTO employee_address (  
            employee_id , 
            address_id  )
        VALUES (
            ${employeeAddress.employee_id}, 
            ${employeeAddress.address_id} 
        )
    `);
    int|string? lastInsertId = result.lastInsertId;
    if lastInsertId is int {
        return lastInsertId;
    } else {
        return error("Unable to obtain last insert ID for employee_address");
    }
}

public isolated function updateEmployeeAddress(EmployeeAddress employeeAddress) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        UPDATE employee_address SET  
            employee_id =  ${employeeAddress.employee_id}, 
            address_id =  ${employeeAddress.address_id}        
        WHERE employee_address = ${employeeAddress.employee_id}  
    `);
    int|string? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain last affected count for employee_address update");
    }
}

isolated function deleteEmployeeAddress(int employee_id, int address_id) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        DELETE FROM employee_address WHERE employee_id = ${employee_id} AND address_id = ${address_id}
    `);
    int? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain the affected row count for employee_address delete");
    }
}
