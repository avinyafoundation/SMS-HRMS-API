import ballerinax/mysql;
import ballerinax/mysql.driver as _;
import ballerina/http;

configurable string dbUser = ?;
configurable string dbHost = ?;
configurable string dbDatabase = ?;
configurable int dbPort = ?;
configurable string dbPassword = ?;

public type Customer record {
    int? id = ();
    string first_name;
    string last_name;
};

public final mysql:Client smsDBClient = check new (host = dbHost, user = dbUser, password = dbPassword, database = dbDatabase, port = dbPort);

# School management system (SMS) endpoint
public listener http:Listener smsEP = new(9090);

type Province record {
    int? id = ();
    string name_en;
};

isolated function getProvinces() returns Province[]|error {
    Province[] provinces = [];
    stream<Province, error?> resultStream = smsDBClient->query(
        `SELECT id, name_en FROM province`
    );
    check from Province province in resultStream
        do {
            provinces.push(province);
        };
    check resultStream.close();
    return provinces;
}


service / on smsEP {

    # A root resource explaining what this service is all about 
    # + return - welcome message or error
    resource function get .() returns string|error {
        return "Hello, Welcome to school management system (SMS) API\n" +
               "For more information please have a look at our API documentation";
    }

     # A root resource explaining what this service /sms is all about 
    # + return - welcome message or error
    resource function get sms() returns string|error {
        return "Hello, Welcome to school management system /sms API space\n" +
               "For more information please have a look at our API documentation";
    }

    # A root resource explaining what HRM service withn SMS is all about 
    # + return - welcome message or error
    resource function get sms/hrm() returns string|error {
        return "Hello, Welcome to school management system's HRM API space\n" +
               "For more information please have a look at our API documentation";
    }

    resource isolated function get sms/util/provinces() returns Province[]|error? {
        return getProvinces();
    }

    isolated resource function get sms/util/addresstypes() returns AddressType[]|error? {
        return getAddressTypes();
    }

    isolated resource function get sms/util/addresstypes/[int id]() returns AddressType|error? {
        return getAddressType(id);
    }

    isolated resource function post sms/util/addresstypes(@http:Payload AddressType addressType) returns int|error? {
        return addAddressType(addressType);
    }

    isolated resource function put sms/util/addresstypes(@http:Payload AddressType addressType) returns int|error? {
        return updateAddressType(addressType);
    }

    isolated resource function delete sms/util/addresstypes/[int id]() returns int|error? {
        return deleteAddressType(id);       
    }

    isolated resource function get sms/util/addresses() returns Address[]|error? {
        return getAddresses();
    }

    isolated resource function get sms/util/addresses/[int id]() returns Address|error? {
        return getAddress(id);
    }

    isolated resource function post sms/util/addresses(@http:Payload Address address) returns int|error? {
        return addAddress(address);
    }

    isolated resource function put sms/util/addresses(@http:Payload Address address) returns int|error? {
        return updateAddress(address);
    }

    isolated resource function delete sms/util/addresses/[int id]() returns int|error? {
        return deleteAddress(id);       
    }

    isolated resource function get sms/hrm/employees() returns Employee[]|error? {
        return getEmployees();
    }

    isolated resource function get sms/hrm/employees/[int id]() returns Employee|error? {
        return getEmployee(id);
    }

    isolated resource function post sms/hrm/employees(@http:Payload Employee employee) returns int|error? {
        return addEmployee(employee);
    }

    isolated resource function put sms/hrm/employees(@http:Payload Employee employee) returns int|error? {
        return updateEmployee(employee);
    }

    isolated resource function delete sms/hrm/employees/[int id]() returns int|error? {
        return deleteEmployee(id);       
    }

    isolated resource function get sms/hrm/employee_addresse() returns EmployeeAddress[]|error? {
        return getEmployeeAddresses();
    }

    isolated resource function get sms/hrm/employee_addresse/[int employee_id]/[int address_id]() returns EmployeeAddress|error? {
        return getEmployeeAddress(employee_id, address_id);
    }

    isolated resource function get sms/hrm/employee_addresse/[int employee_id]() returns EmployeeAddress[]|error? {
        return getAddressesForEmployee(employee_id);
    }

    isolated resource function post sms/hrm/employee_addresse(@http:Payload EmployeeAddress employeeAddress) returns int|error? {
        return addEmployeeAddress(employeeAddress);
    }

    isolated resource function put sms/hrm/employee_addresse(@http:Payload EmployeeAddress employeeAddress) returns int|error? {
        return updateEmployeeAddress(employeeAddress);
    }

    isolated resource function delete sms/hrm/employee_addresse/[int employee_id]/[int address_id]() returns int|error? {
        return deleteEmployeeAddress(employee_id, address_id);       
    }

    isolated resource function get sms/hrm/employment_types() returns EmploymentType[]|error? {
        return getEmploymentTypes();
    }

    isolated resource function get sms/hrm/employment_types/[int id]() returns EmploymentType|error? {
        return getEmploymentType(id);
    }

    isolated resource function post sms/hrm/employment_types(@http:Payload EmploymentType employmentType) returns int|error? {
        return addEmploymentType(employmentType);
    }

    isolated resource function put sms/hrm/employment_types(@http:Payload EmploymentType employmentType) returns int|error? {
        return updateEmploymentType(employmentType);
    }

    isolated resource function delete sms/hrm/employment_types/[int id]() returns int|error? {
        return deleteEmploymentType(id);       
    }

    isolated resource function get sms/hrm/employee_employment_types() returns EmployeeEmploymentType[]|error? {
        return getEmployeeEmploymentTypes();
    }

    isolated resource function get sms/hrm/employee_employment_types/[int id]() returns EmployeeEmploymentType|error? {
        return getEmployeeEmploymentType(id);
    }

    isolated resource function post sms/hrm/employee_employment_types(@http:Payload EmployeeEmploymentType employeeEmploymentType) returns int|error? {
        return addEmployeeEmploymentType(employeeEmploymentType);
    }

    isolated resource function put sms/hrm/employee_employment_types(@http:Payload EmployeeEmploymentType employeeEmploymentType) returns int|error? {
        return updateEmployeeEmploymentType(employeeEmploymentType);
    }

    isolated resource function delete sms/hrm/employee_employment_types/[int id]() returns int|error? {
        return deleteEmployeeEmploymentType(id);       
    }

        isolated resource function get sms/hrm/employment_statuses() returns EmploymentStatus[]|error? {
        return getEmploymentStatuses();
    }

    isolated resource function get sms/hrm/employment_statuses/[int id]() returns EmploymentStatus|error? {
        return getEmploymentStatus(id);
    }

    isolated resource function post sms/hrm/employment_statuses(@http:Payload EmploymentStatus employmentStatus) returns int|error? {
        return addEmploymentStatus(employmentStatus);
    }

    isolated resource function put sms/hrm/employment_statuses(@http:Payload EmploymentStatus employmentStatus) returns int|error? {
        return updateEmploymentStatus(employmentStatus);
    }

    isolated resource function delete sms/hrm/employment_statuses/[int id]() returns int|error? {
        return deleteEmploymentStatus(id);       
    }

    
    isolated resource function get sms/hrm/employee_employment_statuses() returns EmployeeEmploymentStatus[]|error? {
        return getEmployeeEmploymentStatuses();
    }

    isolated resource function get sms/hrm/employee_employment_statuses/[int id]() returns EmployeeEmploymentStatus|error? {
        return getEmployeeEmploymentStatus(id);
    }

    isolated resource function post sms/hrm/employee_employment_statuses(@http:Payload EmployeeEmploymentStatus employeeEmploymentStatus) returns int|error? {
        return addEmployeeEmploymentStatus(employeeEmploymentStatus);
    }

    isolated resource function put sms/hrm/employee_employment_statuses(@http:Payload EmployeeEmploymentStatus employeeEmploymentStatus) returns int|error? {
        return updateEmployeeEmploymentStatus(employeeEmploymentStatus);
    }

    isolated resource function delete sms/hrm/employee_employment_statuses/[int id]() returns int|error? {
        return deleteEmployeeEmploymentStatus(id);       
    }

       isolated resource function get sms/hrm/organizations() returns Organization[]|error? {
        return getOrganizations();
    }

    isolated resource function get sms/hrm/organizations/[int id]() returns Organization|error? {
        return getOrganization(id);
    }

    isolated resource function post sms/hrm/organizations(@http:Payload Organization organization) returns int|error? {
        return addOrganization(organization);
    }

    isolated resource function put sms/hrm/organizations(@http:Payload Organization organization) returns int|error? {
        return updateOrganization(organization);
    }

    isolated resource function delete sms/hrm/organizations/[int id]() returns int|error? {
        return deleteOrganization(id);       
    }

    isolated resource function get sms/hrm/organization_addresses() returns OrganizationAddress[]|error? {
        return getOrganizationAddresses();
    }

    isolated resource function get sms/hrm/organization_addresses/[int organization_id]/[int address_id]() returns OrganizationAddress|error? {
        return getOrganizationAddress(organization_id, address_id);
    }

    isolated resource function get sms/hrm/organization_addresses/[int organization_id]() returns OrganizationAddress[]|error? {
        return getAddressesForOrganization(organization_id);
    }

    isolated resource function post sms/hrm/organization_addresses(@http:Payload OrganizationAddress organizationAddress) returns int|error? {
        return addOrganizationAddress(organizationAddress);
    }

    isolated resource function put sms/hrm/organization_addresses(@http:Payload OrganizationAddress organizationAddress) returns int|error? {
        return updateOrganizationAddress(organizationAddress);
    }

    isolated resource function delete sms/hrm/organization_addresses/[int organization_id]/[int address_id]() returns int|error? {
        return deleteOrganizationAddress(organization_id, address_id);       
    }

        isolated resource function get sms/hrm/branches() returns Branch[]|error? {
        return getBranches();
    }

    isolated resource function get sms/hrm/branches/[int id]() returns Branch|error? {
        return getBranch(id);
    }

    isolated resource function post sms/hrm/branches(@http:Payload Branch branch) returns int|error? {
        return addBranch(branch);
    }

    isolated resource function put sms/hrm/branches(@http:Payload Branch branch) returns int|error? {
        return updateBranch(branch);
    }

    isolated resource function delete sms/hrm/branches/[int id]() returns int|error? {
        return deleteBranch(id);       
    }

        isolated resource function get sms/hrm/branch_addresses() returns BranchAddress[]|error? {
        return getBranchAddresses();
    }

    isolated resource function get sms/hrm/branch_addresses/[int branch_id]/[int address_id]() returns BranchAddress|error? {
        return getBranchAddress(branch_id, address_id);
    }

    isolated resource function get sms/hrm/branch_addresses/[int branch_id]() returns BranchAddress[]|error? {
        return getAddressesForBranch(branch_id);
    }

    isolated resource function post sms/hrm/branch_addresses(@http:Payload BranchAddress branchAddress) returns int|error? {
        return addBranchAddress(branchAddress);
    }

    isolated resource function put sms/hrm/branch_addresses(@http:Payload BranchAddress branchAddress) returns int|error? {
        return updateBranchAddress(branchAddress);
    }

    isolated resource function delete sms/hrm/branch_addresses/[int branch_id]/[int address_id]() returns int|error? {
        return deleteBranchAddress(branch_id, address_id);       
    }

    isolated resource function get sms/hrm/offices() returns Office[]|error? {
        return getOffices();
    }

    isolated resource function get sms/hrm/offices/[int id]() returns Office|error? {
        return getOffice(id);
    }

    isolated resource function post sms/hrm/offices(@http:Payload Office office) returns int|error? {
        return addOffice(office);
    }

    isolated resource function put sms/hrm/offices(@http:Payload Office office) returns int|error? {
        return updateOffice(office);
    }

    isolated resource function delete sms/hrm/offices/[int id]() returns int|error? {
        return deleteOffice(id);       
    }

        isolated resource function get sms/hrm/office_addresses() returns OfficeAddress[]|error? {
        return getOfficeAddresses();
    }

    isolated resource function get sms/hrm/office_addresses/[int office_id]/[int address_id]() returns OfficeAddress|error? {
        return getOfficeAddress(office_id, address_id);
    }

    isolated resource function get sms/hrm/office_addresses/[int office_id]() returns OfficeAddress[]|error? {
        return getAddressesForOffice(office_id);
    }

    isolated resource function post sms/hrm/office_addresses(@http:Payload OfficeAddress officeAddress) returns int|error? {
        return addOfficeAddress(officeAddress);
    }

    isolated resource function put sms/hrm/office_addresses(@http:Payload OfficeAddress officeAddress) returns int|error? {
        return updateOfficeAddress(officeAddress);
    }

    isolated resource function delete sms/hrm/office_addresses/[int office_id]/[int address_id]() returns int|error? {
        return deleteOfficeAddress(office_id, address_id);       
    }

        isolated resource function get sms/hrm/team() returns Team[]|error? {
        return getTeams();
    }

    isolated resource function get sms/hrm/team/[int id]() returns Team|error? {
        return getTeam(id);
    }

    isolated resource function post sms/hrm/team(@http:Payload Team team) returns int|error? {
        return addTeam(team);
    }

    isolated resource function put sms/hrm/team(@http:Payload Team team) returns int|error? {
        return updateTeam(team);
    }

    isolated resource function delete sms/hrm/team/[int id]() returns int|error? {
        return deleteTeam(id);       
    }

        isolated resource function get sms/hrm/team_leads() returns TeamLead[]|error? {
        return getTeamLeads();
    }

    isolated resource function get sms/hrm/team_leads/[int id]() returns TeamLead|error? {
        return getTeamLead(id);
    }

    isolated resource function post sms/hrm/team_leads(@http:Payload TeamLead teamLead) returns int|error? {
        return addTeamLead(teamLead);
    }

    isolated resource function put sms/hrm/team_leads(@http:Payload TeamLead teamLead) returns int|error? {
        return updateTeamLead(teamLead);
    }

    isolated resource function delete sms/hrm/team_leads/[int id]() returns int|error? {
        return deleteTeamLead(id);       
    }

        isolated resource function get sms/hrm/job_band() returns JobBand[]|error? {
        return getJobBands();
    }

    isolated resource function get sms/hrm/job_band/[int id]() returns JobBand|error? {
        return getJobBand(id);
    }

    isolated resource function post sms/hrm/job_band(@http:Payload JobBand jobBand) returns int|error? {
        return addJobBand(jobBand);
    }

    isolated resource function put sms/hrm/job_band(@http:Payload JobBand jobBand) returns int|error? {
        return updateJobBand(jobBand);
    }

    isolated resource function delete sms/hrm/job_band/[int id]() returns int|error? {
        return deleteJobBand(id);       
    }

        isolated resource function get sms/hrm/jobs() returns Job[]|error? {
        return getJobs();
    }

    isolated resource function get sms/hrm/jobs/[int id]() returns Job|error? {
        return getJob(id);
    }

    isolated resource function post sms/hrm/jobs(@http:Payload Job job) returns int|error? {
        return addJob(job);
    }

    isolated resource function put sms/hrm/jobs(@http:Payload Job job) returns int|error? {
        return updateJob(job);
    }

    isolated resource function delete sms/hrm/jobs/[int id]() returns int|error? {
        return deleteJob(id);       
    }

        isolated resource function get sms/hrm/job_descriptions() returns JobDescription[]|error? {
        return getJobDescriptions();
    }

    isolated resource function get sms/hrm/job_descriptions/[int id]() returns JobDescription|error? {
        return getJobDescription(id);
    }

    isolated resource function post sms/hrm/job_descriptions(@http:Payload JobDescription jobDescription) returns int|error? {
        return addJobDescription(jobDescription);
    }

    isolated resource function put sms/hrm/job_descriptions(@http:Payload JobDescription jobDescription) returns int|error? {
        return updateJobDescription(jobDescription);
    }

    isolated resource function delete sms/hrm/job_descriptions/[int id]() returns int|error? {
        return deleteJobDescription(id);       
    }

    isolated resource function get sms/hrm/role_responsibility_categories() returns RoleResponsibilityCategory[]|error? {
        return getRoleResponsibilityCategories();
    }

    isolated resource function get sms/hrm/role_responsibility_categories/[int id]() returns RoleResponsibilityCategory|error? {
        return getRoleResponsibilityCategory(id);
    }

    isolated resource function post sms/hrm/role_responsibility_categories(@http:Payload RoleResponsibilityCategory roleResponsibilityCategory) returns int|error? {
        return addRoleResponsibilityCategory(roleResponsibilityCategory);
    }

    isolated resource function put sms/hrm/role_responsibility_categories(@http:Payload RoleResponsibilityCategory roleResponsibilityCategory) returns int|error? {
        return updateRoleResponsibilityCategory(roleResponsibilityCategory);
    }

    isolated resource function delete sms/hrm/role_responsibility_categories/[int id]() returns int|error? {
        return deleteRoleResponsibilityCategory(id);       
    }

    isolated resource function get sms/hrm/job_role_responsibilities() returns JobRoleResponsibility[]|error? {
        return getJobRoleResponsibilities();
    }

    isolated resource function get sms/hrm/job_role_responsibilities/[int id]() returns JobRoleResponsibility|error? {
        return getJobRoleResponsibility(id);
    }

    isolated resource function post sms/hrm/job_role_responsibilities(@http:Payload JobRoleResponsibility jobRoleResponsibility) returns int|error? {
        return addJobRoleResponsibility(jobRoleResponsibility);
    }

    isolated resource function put sms/hrm/job_role_responsibilities(@http:Payload JobRoleResponsibility jobRoleResponsibility) returns int|error? {
        return updateJobRoleResponsibility(jobRoleResponsibility);
    }

    isolated resource function delete sms/hrm/job_role_responsibilities/[int id]() returns int|error? {
        return deleteJobRoleResponsibility(id);       
    }

    isolated resource function get sms/hrm/qualification_categories() returns QualificationCategory[]|error? {
        return getQualificationCategories();
    }

    isolated resource function get sms/hrm/qualification_categories/[int id]() returns QualificationCategory|error? {
        return getQualificationCategory(id);
    }

    isolated resource function post sms/hrm/qualification_categories(@http:Payload QualificationCategory qualificationCategory) returns int|error? {
        return addQualificationCategory(qualificationCategory);
    }

    isolated resource function put sms/hrm/qualification_categories(@http:Payload QualificationCategory qualificationCategory) returns int|error? {
        return updateQualificationCategory(qualificationCategory);
    }

    isolated resource function delete sms/hrm/qualification_categories/[int id]() returns int|error? {
        return deleteQualificationCategory(id);       
    }

    isolated resource function get sms/hrm/job_qualifications() returns JobQualification[]|error? {
        return getJobQualifications();
    }

    isolated resource function get sms/hrm/job_qualifications/[int id]() returns JobQualification|error? {
        return getJobQualification(id);
    }

    isolated resource function post sms/hrm/job_qualifications(@http:Payload JobQualification jobQualification) returns int|error? {
        return addJobQualification(jobQualification);
    }

    isolated resource function put sms/hrm/job_qualifications(@http:Payload JobQualification jobQualification) returns int|error? {
        return updateJobQualification(jobQualification);
    }

    isolated resource function delete sms/hrm/job_qualifications/[int id]() returns int|error? {
        return deleteJobQualification(id);       
    }

    isolated resource function get sms/hrm/skill_categories() returns SkillCategory[]|error? {
        return getSkillCategories();
    }

    isolated resource function get sms/hrm/skill_categories/[int id]() returns SkillCategory|error? {
        return getSkillCategory(id);
    }

    isolated resource function post sms/hrm/skill_categories(@http:Payload SkillCategory skillCategory) returns int|error? {
        return addSkillCategory(skillCategory);
    }

    isolated resource function put sms/hrm/skill_categories(@http:Payload SkillCategory skillCategory) returns int|error? {
        return updateSkillCategory(skillCategory);
    }

    isolated resource function delete sms/hrm/skill_categories/[int id]() returns int|error? {
        return deleteSkillCategory(id);       
    }

    isolated resource function get sms/hrm/job_skills() returns JobSkill[]|error? {
        return getJobSkills();
    }

    isolated resource function get sms/hrm/job_skills/[int id]() returns JobSkill|error? {
        return getJobSkill(id);
    }

    isolated resource function post sms/hrm/job_skills(@http:Payload JobSkill jobSkill) returns int|error? {
        return addJobSkill(jobSkill);
    }

    isolated resource function put sms/hrm/job_skills(@http:Payload JobSkill jobSkill) returns int|error? {
        return updateJobSkill(jobSkill);
    }

    isolated resource function delete sms/hrm/job_skills/[int id]() returns int|error? {
        return deleteJobSkill(id);       
    }

    isolated resource function get sms/hrm/evaluation_criteria_categories() returns EvaluationCriteriaCategory[]|error? {
        return getEvaluationCriteriaCategories();
    }

    isolated resource function get sms/hrm/evaluation_criteria_categories/[int id]() returns EvaluationCriteriaCategory|error? {
        return getEvaluationCriteriaCategory(id);
    }

    isolated resource function post sms/hrm/evaluation_criteria_categories(@http:Payload EvaluationCriteriaCategory evaluationCriteriaCategory) returns int|error? {
        return addEvaluationCriteriaCategory(evaluationCriteriaCategory);
    }

    isolated resource function put sms/hrm/evaluation_criteria_categories(@http:Payload EvaluationCriteriaCategory evaluationCriteriaCategory) returns int|error? {
        return updateEvaluationCriteriaCategory(evaluationCriteriaCategory);
    }

    isolated resource function delete sms/hrm/evaluation_criteria_categories/[int id]() returns int|error? {
        return deleteEvaluationCriteriaCategory(id);       
    }

    isolated resource function get sms/hrm/job_evaluation_criterias() returns JobEvaluationCriteria[]|error? {
        return getJobEvaluationCriterias();
    }

    isolated resource function get sms/hrm/job_evaluation_criterias/[int id]() returns JobEvaluationCriteria|error? {
        return getJobEvaluationCriteria(id);
    }

    isolated resource function post sms/hrm/job_evaluation_criterias(@http:Payload JobEvaluationCriteria jobEvaluationCriteria) returns int|error? {
        return addJobEvaluationCriteria(jobEvaluationCriteria);
    }

    isolated resource function put sms/hrm/job_evaluation_criterias(@http:Payload JobEvaluationCriteria jobEvaluationCriteria) returns int|error? {
        return updateJobEvaluationCriteria(jobEvaluationCriteria);
    }

    isolated resource function delete sms/hrm/job_evaluation_criterias/[int id]() returns int|error? {
        return deleteJobEvaluationCriteria(id);       
    }

    isolated resource function get sms/hrm/office_employees() returns OfficeEmployee[]|error? {
        return getOfficeEmployees();
    }

    isolated resource function get sms/hrm/office_employees/[int id]() returns OfficeEmployee|error? {
        return getOfficeEmployee(id);
    }

    isolated resource function post sms/hrm/office_employees(@http:Payload OfficeEmployee officeEmployee) returns int|error? {
        return addOfficeEmployee(officeEmployee);
    }

    isolated resource function put sms/hrm/office_employees(@http:Payload OfficeEmployee officeEmployee) returns int|error? {
        return updateOfficeEmployee(officeEmployee);
    }

    isolated resource function delete sms/hrm/office_employees/[int id]() returns int|error? {
        return deleteOfficeEmployee(id);       
    }

    isolated resource function get sms/hrm/positions_vacant() returns PositionsVacant[]|error? {
        return getPositionsVacants();
    }

    isolated resource function get sms/hrm/positions_vacant/[int id]() returns PositionsVacant|error? {
        return getPositionsVacant(id);
    }

    isolated resource function post sms/hrm/positions_vacant(@http:Payload PositionsVacant positionsVacant) returns int|error? {
        return addPositionsVacant(positionsVacant);
    }

    isolated resource function put sms/hrm/positions_vacant(@http:Payload PositionsVacant positionsVacant) returns int|error? {
        return updatePositionsVacant(positionsVacant);
    }

    isolated resource function delete sms/hrm/positions_vacant/[int id]() returns int|error? {
        return deletePositionsVacant(id);       
    }

    isolated resource function get sms/hrm/applicants() returns Applicant[]|error? {
        return getApplicants();
    }

    isolated resource function get sms/hrm/applicants/[int id]() returns Applicant|error? {
        return getApplicant(id);
    }

    isolated resource function post sms/hrm/applicants(@http:Payload Applicant applicant) returns int|error? {
        return addApplicant(applicant);
    }

    isolated resource function put sms/hrm/applicants(@http:Payload Applicant applicant) returns int|error? {
        return updateApplicant(applicant);
    }

    isolated resource function delete sms/hrm/applicants/[int id]() returns int|error? {
        return deleteApplicant(id);       
    }

    isolated resource function get sms/hrm/applicant_addresses() returns ApplicantAddress[]|error? {
        return getApplicantAddresses();
    }

    isolated resource function get sms/hrm/applicant_addresses/[int applicant_id]/[int address_id]() returns ApplicantAddress|error? {
        return getApplicantAddress(applicant_id, address_id);
    }

    isolated resource function get sms/hrm/applicant_addresses/[int applicant_id]() returns ApplicantAddress[]|error? {
        return getAddressesForApplicant(applicant_id);
    }

    isolated resource function post sms/hrm/applicant_addresses(@http:Payload ApplicantAddress applicantAddress) returns int|error? {
        return addApplicantAddress(applicantAddress);
    }

    isolated resource function put sms/hrm/applicant_addresses(@http:Payload ApplicantAddress applicantAddress) returns int|error? {
        return updateApplicantAddress(applicantAddress);
    }

    isolated resource function delete sms/hrm/applicant_addresses/[int applicant_id]/[int address_id]() returns int|error? {
        return deleteApplicantAddress(applicant_id, address_id);       
    }

    isolated resource function get sms/hrm/application_statuses() returns ApplicationStatus[]|error? {
        return getApplicationStatuses();
    }

    isolated resource function get sms/hrm/application_statuses/[int id]() returns ApplicationStatus|error? {
        return getApplicationStatus(id);
    }

    isolated resource function post sms/hrm/application_statuses(@http:Payload ApplicationStatus applicationStatus) returns int|error? {
        return addApplicationStatus(applicationStatus);
    }

    isolated resource function put sms/hrm/application_statuses(@http:Payload ApplicationStatus applicationStatus) returns int|error? {
        return updateApplicationStatus(applicationStatus);
    }

    isolated resource function delete sms/hrm/application_statuses/[int id]() returns int|error? {
        return deleteApplicationStatus(id);       
    }

    isolated resource function get sms/hrm/applicant_application_statuses() returns ApplicantApplicationStatus[]|error? {
        return getApplicantApplicationStatuses();
    }

    isolated resource function get sms/hrm/applicant_application_statuses/[int id]() returns ApplicantApplicationStatus|error? {
        return getApplicantApplicationStatus(id);
    }

    isolated resource function post sms/hrm/applicant_application_statuses(@http:Payload ApplicantApplicationStatus applicantApplicationStatus) returns int|error? {
        return addApplicantApplicationStatus(applicantApplicationStatus);
    }

    isolated resource function put sms/hrm/applicant_application_statuses(@http:Payload ApplicantApplicationStatus applicantApplicationStatus) returns int|error? {
        return updateApplicantApplicationStatus(applicantApplicationStatus);
    }

    isolated resource function delete sms/hrm/applicant_application_statuses/[int id]() returns int|error? {
        return deleteApplicantApplicationStatus(id);       
    }

    isolated resource function get sms/hrm/applicant_qualifications() returns ApplicantQualification[]|error? {
        return getApplicantQualifications();
    }

    isolated resource function get sms/hrm/applicant_qualifications/[int id]() returns ApplicantQualification|error? {
        return getApplicantQualification(id);
    }

    isolated resource function post sms/hrm/applicant_qualifications(@http:Payload ApplicantQualification applicantQualification) returns int|error? {
        return addApplicantQualification(applicantQualification);
    }

    isolated resource function put sms/hrm/applicant_qualifications(@http:Payload ApplicantQualification applicantQualification) returns int|error? {
        return updateApplicantQualification(applicantQualification);
    }

    isolated resource function delete sms/hrm/applicant_qualifications/[int id]() returns int|error? {
        return deleteApplicantQualification(id);       
    }

    isolated resource function get sms/hrm/applicant_skills() returns ApplicantSkill[]|error? {
        return getApplicantSkills();
    }

    isolated resource function get sms/hrm/applicant_skills/[int id]() returns ApplicantSkill|error? {
        return getApplicantSkill(id);
    }

    isolated resource function post sms/hrm/applicant_skills(@http:Payload ApplicantSkill applicantSkill) returns int|error? {
        return addApplicantSkill(applicantSkill);
    }

    isolated resource function put sms/hrm/applicant_skills(@http:Payload ApplicantSkill applicantSkill) returns int|error? {
        return updateApplicantSkill(applicantSkill);
    }

    isolated resource function delete sms/hrm/applicant_skills/[int id]() returns int|error? {
        return deleteApplicantSkill(id);       
    }

    isolated resource function get sms/hrm/applicant_evaluations() returns ApplicantEvaluation[]|error? {
        return getApplicantEvaluations();
    }

    isolated resource function get sms/hrm/applicant_evaluations/[int id]() returns ApplicantEvaluation|error? {
        return getApplicantEvaluation(id);
    }

    isolated resource function post sms/hrm/applicant_evaluations(@http:Payload ApplicantEvaluation applicantEvaluation) returns int|error? {
        return addApplicantEvaluation(applicantEvaluation);
    }

    isolated resource function put sms/hrm/applicant_evaluations(@http:Payload ApplicantEvaluation applicantEvaluation) returns int|error? {
        return updateApplicantEvaluation(applicantEvaluation);
    }

    isolated resource function delete sms/hrm/applicant_evaluations/[int id]() returns int|error? {
        return deleteApplicantEvaluation(id);       
    }

    isolated resource function get sms/hrm/applicant_interviews() returns ApplicantInterview[]|error? {
        return getApplicantInterviews();
    }

    isolated resource function get sms/hrm/applicant_interviews/[int id]() returns ApplicantInterview|error? {
        return getApplicantInterview(id);
    }

    isolated resource function post sms/hrm/applicant_interviews(@http:Payload ApplicantInterview applicantInterview) returns int|error? {
        return addApplicantInterview(applicantInterview);
    }

    isolated resource function put sms/hrm/applicant_interviews(@http:Payload ApplicantInterview applicantInterview) returns int|error? {
        return updateApplicantInterview(applicantInterview);
    }

    isolated resource function delete sms/hrm/applicant_interviews/[int id]() returns int|error? {
        return deleteApplicantInterview(id);       
    }

    isolated resource function get sms/hrm/job_offers() returns JobOffer[]|error? {
        return getJobOffers();
    }

    isolated resource function get sms/hrm/job_offers/[int id]() returns JobOffer|error? {
        return getJobOffer(id);
    }

    isolated resource function post sms/hrm/job_offers(@http:Payload JobOffer jobOffer) returns int|error? {
        return addJobOffer(jobOffer);
    }

    isolated resource function put sms/hrm/job_offers(@http:Payload JobOffer jobOffer) returns int|error? {
        return updateJobOffer(jobOffer);
    }

    isolated resource function delete sms/hrm/job_offers/[int id]() returns int|error? {
        return deleteJobOffer(id);       
    }

    isolated resource function get sms/hrm/employee_qualifications() returns EmployeeQualification[]|error? {
        return getEmployeeQualifications();
    }

    isolated resource function get sms/hrm/employee_qualifications/[int id]() returns EmployeeQualification|error? {
        return getEmployeeQualification(id);
    }

    isolated resource function post sms/hrm/employee_qualifications(@http:Payload EmployeeQualification employeeQualification) returns int|error? {
        return addEmployeeQualification(employeeQualification);
    }

    isolated resource function put sms/hrm/employee_qualifications(@http:Payload EmployeeQualification employeeQualification) returns int|error? {
        return updateEmployeeQualification(employeeQualification);
    }

    isolated resource function delete sms/hrm/employee_qualifications/[int id]() returns int|error? {
        return deleteEmployeeQualification(id);       
    }

    isolated resource function get sms/hrm/employee_skills() returns EmployeeSkill[]|error? {
        return getEmployeeSkills();
    }

    isolated resource function get sms/hrm/employee_skills/[int id]() returns EmployeeSkill|error? {
        return getEmployeeSkill(id);
    }

    isolated resource function post sms/hrm/employee_skills(@http:Payload EmployeeSkill employeeSkill) returns int|error? {
        return addEmployeeSkill(employeeSkill);
    }

    isolated resource function put sms/hrm/employee_skills(@http:Payload EmployeeSkill employeeSkill) returns int|error? {
        return updateEmployeeSkill(employeeSkill);
    }

    isolated resource function delete sms/hrm/employee_skills/[int id]() returns int|error? {
        return deleteEmployeeSkill(id);       
    }

    isolated resource function get sms/hrm/evaluation_cycles() returns EvaluationCycle[]|error? {
        return getEvaluationCycles();
    }

    isolated resource function get sms/hrm/evaluation_cycles/[int id]() returns EvaluationCycle|error? {
        return getEvaluationCycle(id);
    }

    isolated resource function post sms/hrm/evaluation_cycles(@http:Payload EvaluationCycle evaluationCycle) returns int|error? {
        return addEvaluationCycle(evaluationCycle);
    }

    isolated resource function put sms/hrm/evaluation_cycles(@http:Payload EvaluationCycle evaluationCycle) returns int|error? {
        return updateEvaluationCycle(evaluationCycle);
    }

    isolated resource function delete sms/hrm/evaluation_cycles/[int id]() returns int|error? {
        return deleteEvaluationCycle(id);       
    }

    isolated resource function get sms/hrm/employee_evaluations() returns EmployeeEvaluation[]|error? {
        return getEmployeeEvaluations();
    }

    isolated resource function get sms/hrm/employee_evaluations/[int id]() returns EmployeeEvaluation|error? {
        return getEmployeeEvaluation(id);
    }

    isolated resource function post sms/hrm/employee_evaluations(@http:Payload EmployeeEvaluation employeeEvaluation) returns int|error? {
        return addEmployeeEvaluation(employeeEvaluation);
    }

    isolated resource function put sms/hrm/employee_evaluations(@http:Payload EmployeeEvaluation employeeEvaluation) returns int|error? {
        return updateEmployeeEvaluation(employeeEvaluation);
    }

    isolated resource function delete sms/hrm/employee_evaluations/[int id]() returns int|error? {
        return deleteEmployeeEvaluation(id);       
    }

     isolated resource function get sms/hrm/attendance_types() returns AttendanceType[]|error? {
        return getAttendanceTypes();
    }

    isolated resource function get sms/hrm/attendance_types/[int id]() returns AttendanceType|error? {
        return getAttendanceType(id);
    }

    isolated resource function post sms/hrm/attendance_types(@http:Payload AttendanceType attendanceType) returns int|error? {
        return addAttendanceType(attendanceType);
    }

    isolated resource function put sms/hrm/attendance_types(@http:Payload AttendanceType attendanceType) returns int|error? {
        return updateAttendanceType(attendanceType);
    }

    isolated resource function delete sms/hrm/attendance_types/[int id]() returns int|error? {
        return deleteAttendanceType(id);       
    }

    isolated resource function get sms/hrm/employee_attendances() returns EmployeeAttendance[]|error? {
        return getEmployeeAttendances();
    }

    isolated resource function get sms/hrm/employee_attendances/[int id]() returns EmployeeAttendance|error? {
        return getEmployeeAttendance(id);
    }

    isolated resource function post sms/hrm/employee_attendances(@http:Payload EmployeeAttendance employeeAttendance) returns int|error? {
        return addEmployeeAttendance(employeeAttendance);
    }

    isolated resource function put sms/hrm/employee_attendances(@http:Payload EmployeeAttendance employeeAttendance) returns int|error? {
        return updateEmployeeAttendance(employeeAttendance);
    }

    isolated resource function delete sms/hrm/employee_attendances/[int id]() returns int|error? {
        return deleteEmployeeAttendance(id);       
    }

    isolated resource function get sms/hrm/leave_types() returns LeaveType[]|error? {
        return getLeaveTypes();
    }

    isolated resource function get sms/hrm/leave_types/[int id]() returns LeaveType|error? {
        return getLeaveType(id);
    }

    isolated resource function post sms/hrm/leave_types(@http:Payload LeaveType leaveType) returns int|error? {
        return addLeaveType(leaveType);
    }

    isolated resource function put sms/hrm/leave_types(@http:Payload LeaveType leaveType) returns int|error? {
        return updateLeaveType(leaveType);
    }

    isolated resource function delete sms/hrm/leave_types/[int id]() returns int|error? {
        return deleteLeaveType(id);       
    }

    isolated resource function get sms/hrm/employee_leaves() returns EmployeeLeave[]|error? {
        return getEmployeeLeaves();
    }

    isolated resource function get sms/hrm/employee_leaves/[int id]() returns EmployeeLeave|error? {
        return getEmployeeLeave(id);
    }

    isolated resource function post sms/hrm/employee_leaves(@http:Payload EmployeeLeave employeeLeave) returns int|error? {
        return addEmployeeLeave(employeeLeave);
    }

    isolated resource function put sms/hrm/employee_leaves(@http:Payload EmployeeLeave employeeLeave) returns int|error? {
        return updateEmployeeLeave(employeeLeave);
    }

    isolated resource function delete sms/hrm/employee_leaves/[int id]() returns int|error? {
        return deleteEmployeeLeave(id);       
    }

}

