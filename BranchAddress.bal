import ballerina/sql;

public type BranchAddress record {
    int branch_id;
    int address_id;
};

public isolated function getBranchAddresses() returns BranchAddress[]|error {
    BranchAddress[] branchAddresses = [];
    stream<BranchAddress, error?> resultStream = smsDBClient->query(
        `SELECT 
            branch_id , 
            address_id  
        FROM branch_address`
    );
    check from BranchAddress branchAddress in resultStream
        do {
            branchAddresses.push(branchAddress);
        };
    check resultStream.close();
    return branchAddresses;
}

public isolated function getBranchAddress(int branch_id, int address_id) returns BranchAddress|error {
    BranchAddress branchAddress = check smsDBClient->queryRow(
        `SELECT * FROM branch_address WHERE branch_id = ${branch_id} AND address_id = ${address_id}`
    );
    return branchAddress;
}

public isolated function getAddressesForBranch(int branch_id) returns BranchAddress[]|error {
    BranchAddress[] branchAddresses = [];
    stream<BranchAddress, error?> resultStream = smsDBClient->query(
        `SELECT 
            branch_id , 
            address_id  
        FROM branch_address WHERE branch_id = ${branch_id}`
    );
    check from BranchAddress branchAddress in resultStream
        do {
            branchAddresses.push(branchAddress);
        };
    check resultStream.close();
    return branchAddresses;
}

public isolated function addBranchAddress(BranchAddress branchAddress) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        INSERT INTO branch_address (  
            branch_id , 
            address_id  )
        VALUES (
            ${branchAddress.branch_id}, 
            ${branchAddress.address_id} 
        )
    `);
    int|string? lastInsertId = result.lastInsertId;
    if lastInsertId is int {
        return lastInsertId;
    } else {
        return error("Unable to obtain last insert ID for branch_address");
    }
}

public isolated function updateBranchAddress(BranchAddress branchAddress) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        UPDATE branch_address SET  
            branch_id =  ${branchAddress.branch_id}, 
            address_id =  ${branchAddress.address_id}        
        WHERE branch_address = ${branchAddress.branch_id}  
    `);
    int|string? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain last affected count for branch_address update");
    }
}

isolated function deleteBranchAddress(int branch_id, int address_id) returns int|error {
    sql:ExecutionResult result = check smsDBClient->execute(`
        DELETE FROM branch_address WHERE branch_id = ${branch_id} AND address_id = ${address_id}
    `);
    int? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain the affected row count for branch_address delete");
    }
}
