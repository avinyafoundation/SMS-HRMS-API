import ballerina/sql;

import ballerina/time;

public type Employee record {
    int? id = ();
    string employee_id;
    string first_name;
    string last_name;
    string name_with_initials;
    string full_name;
    string gender;
    string hire_date;
    string id_number;
    string phone_number1;
    string? phone_number2 = ();
    string? email = ();
    string? cv_location = ();
    time:Utc last_updated = time:utcNow();
};

public isolated function getEmployees() returns Employee[]|error {
    Employee[] employees = [];
    stream<Employee, error?> resultStream = smsDBClient->query(
        `SELECT 
            id  , 
            employee_id , 
            first_name , 
            last_name , 
            name_with_initials , 
            full_name , 
            gender , 
            hire_date , 
            id_number , 
            phone_number1 , 
            phone_number2 , 
            email , 
            cv_location , 
            last_updated  
        FROM employee`
    );
    check from Employee employee in resultStream
        do {
            employees.push(employee);
        };
    check resultStream.close();
    return employees;
}

public isolated function getEmployee(int id) returns Employee|error {
    Employee employee = check smsDBClient->queryRow(
        `SELECT * FROM employee WHERE id = ${id}`
    );
    return employee;
}

public isolated function addEmployee(Employee employee) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        INSERT INTO employee (  
            employee_id , 
            first_name , 
            last_name , 
            name_with_initials , 
            full_name , 
            gender , 
            hire_date , 
            id_number , 
            phone_number1 , 
            phone_number2 , 
            email , 
            cv_location , 
            last_updated  )
        VALUES (
            ${employee.employee_id}, 
            ${employee.first_name}, 
            ${employee.last_name}, 
            ${employee.name_with_initials}, 
            ${employee.full_name}, 
            ${employee.gender}, 
            ${employee.hire_date}, 
            ${employee.id_number}, 
            ${employee.phone_number1}, 
            ${employee.phone_number2}, 
            ${employee.email}, 
            ${employee.cv_location}, 
            ${employee.last_updated} 
        )
    `);
    int|string? lastInsertId = result.lastInsertId;
    if lastInsertId is int {
        return lastInsertId;
    } else {
        return error("Unable to obtain last insert ID for employee");
    }
}

public isolated function updateEmployee(Employee employee) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        UPDATE employee SET  
            employee_id =  ${employee.employee_id}, 
            first_name =  ${employee.first_name}, 
            last_name =  ${employee.last_name}, 
            name_with_initials =  ${employee.name_with_initials}, 
            full_name =  ${employee.full_name}, 
            gender =  ${employee.gender}, 
            hire_date =  ${employee.hire_date}, 
            id_number =  ${employee.id_number}, 
            phone_number1 =  ${employee.phone_number1}, 
            phone_number2 =  ${employee.phone_number2}, 
            email =  ${employee.email}, 
            cv_location =  ${employee.cv_location}, 
            last_updated =  ${employee.last_updated}        
        WHERE id = ${employee.id} 
    `);
    int|string? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain last affected count for employee update");
    }
}

isolated function deleteEmployee(int id) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        DELETE FROM employee WHERE id = ${id}
    `);
    int? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain the affected row count for employee delete");
    }
}
