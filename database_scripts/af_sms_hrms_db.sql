
CREATE DATABASE IF NOT EXISTS sms_db;

USE sms_db;

CREATE TABLE IF NOT EXISTS customer (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL
);

-- General Data
CREATE TABLE IF NOT EXISTS country (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  iso char(2) NOT NULL,
  name varchar(80) NOT NULL,
  nicename varchar(80) NOT NULL,
  iso3 char(3) DEFAULT NULL,
  numcode SMALLINT DEFAULT NULL,
  phonecode INT NOT NULL
); 

CREATE TABLE IF NOT EXISTS province (
  id INT NOT NULL PRIMARY KEY,
  name_en varchar(45) NOT NULL,
  name_si varchar(45) DEFAULT NULL,
  name_ta varchar(45) DEFAULT NULL, 
  country_id INT DEFAULT NULL, 
  INDEX (country_id),
  FOREIGN KEY (country_id) REFERENCES country(id)
);

CREATE TABLE IF NOT EXISTS district (
  id INT NOT NULL PRIMARY KEY,
  province_id INT NOT NULL, 
  name_en varchar(45) DEFAULT NULL,
  name_si varchar(45) DEFAULT NULL,
  name_ta varchar(45) DEFAULT NULL,
  INDEX (province_id),
  FOREIGN KEY (province_id) REFERENCES province(id)
);

CREATE TABLE IF NOT EXISTS city (
  id INT NOT NULL PRIMARY KEY,
  district_id INT NOT NULL,
  name_en varchar(45) DEFAULT NULL,
  name_si varchar(45) DEFAULT NULL,
  name_ta varchar(45) DEFAULT NULL,
  sub_name_en varchar(45) DEFAULT NULL,
  sub_name_si varchar(45) DEFAULT NULL,
  sub_name_ta varchar(45) DEFAULT NULL,
  postcode varchar(10) DEFAULT NULL,
  latitude decimal(10,8) DEFAULT NULL,
  longitude decimal(11,8) DEFAULT NULL,
  INDEX (district_id),
  FOREIGN KEY (district_id) REFERENCES district(id)
);

CREATE TABLE IF NOT EXISTS address_type (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(20) NOT NULL,
  description VARCHAR(100) DEFAULT NULL
);

CREATE TABLE IF NOT EXISTS address (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  line1 VARCHAR(100) NOT NULL,
  line2 VARCHAR(100) DEFAULT NULL,
  line3 VARCHAR(100) DEFAULT NULL,
  city_id INT NOT NULL,
  address_type_id INT NOT NULL,
  notes VARCHAR(1024) DEFAULT NULL,
  INDEX (city_id),
  INDEX (address_type_id),
  FOREIGN KEY (city_id) REFERENCES city(id),
  FOREIGN KEY (address_type_id) REFERENCES address_type(id)
);

-- HRM tables 
CREATE TABLE IF NOT EXISTS employee (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  employee_id VARCHAR(20) NOT NULL,
  first_name VARCHAR(256) NOT NULL,
  last_name VARCHAR(256) NOT NULL,
  name_with_initials VARCHAR(512) DEFAULT NULL,
  full_name VARCHAR(1024) DEFAULT NULL,
  gender ENUM ('Male','Female', 'Oter', 'Not Specified')  NOT NULL DEFAULT 'Not Specified',    
  hire_date DATE NOT NULL,
  id_number VARCHAR(20),
  phone_number1 VARCHAR(20) DEFAULT NULL,
  phone_number2 VARCHAR(20) DEFAULT NULL,
  email VARCHAR(320) DEFAULT NULL,
  cv_location VARCHAR(2048) NOT NULL, -- a URL or a cloud storage location such as git/Gdrive
  last_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS employee_address (
  employee_id INT NOT NULL,
  address_id INT NOT NULL,
  PRIMARY KEY (employee_id, address_id),
  INDEX (employee_id),
  INDEX (address_id),
  FOREIGN KEY (employee_id) REFERENCES employee(id) ON DELETE CASCADE,
  FOREIGN KEY (address_id) REFERENCES address(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS employment_type (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(20) NOT NULL, -- probation, permenent, contract, consultant etc. 
  description VARCHAR(1024) DEFAULT NULL
);

CREATE TABLE IF NOT EXISTS employee_employment_type (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  employee_id INT NOT NULL,
  employment_type_id INT NOT NULL,
  start_date DATE NOT NULL DEFAULT (CURRENT_DATE),
  end_date DATE DEFAULT NULL,
  last_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX (employee_id),
  FOREIGN KEY (employee_id) REFERENCES employee(id) ON DELETE CASCADE,
  INDEX (employment_type_id),
  FOREIGN KEY (employment_type_id) REFERENCES employment_type(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS employment_status (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(20) NOT NULL, -- active, suspended, resigned, terminated  
  sequence_no INT NOT NULL DEFAULT 0,
  description VARCHAR(1024) DEFAULT NULL
);

CREATE TABLE IF NOT EXISTS employee_employment_status (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  employee_id INT NOT NULL,
  employment_status_id INT NOT NULL,
  start_date DATE NOT NULL DEFAULT (CURRENT_DATE),
  end_date DATE DEFAULT NULL,
  last_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX (employee_id),
  INDEX (employment_status_id),
  FOREIGN KEY (employee_id) REFERENCES employee(id) ON DELETE CASCADE,
  FOREIGN KEY (employment_status_id) REFERENCES employment_status(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS organization (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(256) NOT NULL,
  description VARCHAR(1024) DEFAULT NULL,
  phone_number1 VARCHAR(20) DEFAULT NULL,
  phone_number2 VARCHAR(20) DEFAULT NULL
);

CREATE TABLE IF NOT EXISTS organization_address (
  organization_id INT NOT NULL,
  address_id INT NOT NULL,
  PRIMARY KEY (organization_id, address_id),
  INDEX (organization_id),
  INDEX (address_id),
  FOREIGN KEY (organization_id) REFERENCES organization(id) ON DELETE CASCADE,
  FOREIGN KEY (address_id) REFERENCES address(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS branch (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  organization_id INT NOT NULL,
  name VARCHAR(256) NOT NULL,
  description VARCHAR(1024) DEFAULT NULL,
  phone_number1 VARCHAR(20) DEFAULT NULL,
  phone_number2 VARCHAR(20) DEFAULT NULL,
  INDEX (organization_id),
  FOREIGN KEY (organization_id) REFERENCES organization(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS branch_address (
  branch_id INT NOT NULL,
  address_id INT NOT NULL,
  PRIMARY KEY (branch_id, address_id),
  INDEX (branch_id),
  INDEX (address_id),
  FOREIGN KEY (branch_id) REFERENCES branch(id) ON DELETE CASCADE,
  FOREIGN KEY (address_id) REFERENCES address(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS office (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  branch_id INT NOT NULL,
  name VARCHAR(256) NOT NULL,
  description VARCHAR(1024) DEFAULT NULL,
  phone_number1 VARCHAR(20) DEFAULT NULL,
  phone_number2 VARCHAR(20) DEFAULT NULL,
  INDEX (branch_id),
  FOREIGN KEY (branch_id) REFERENCES branch(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS office_address (
  office_id INT NOT NULL,
  address_id INT NOT NULL,
  PRIMARY KEY (office_id, address_id),
  INDEX (office_id),
  INDEX (address_id),
  FOREIGN KEY (office_id) REFERENCES office(id) ON DELETE CASCADE,
  FOREIGN KEY (address_id) REFERENCES address(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS team (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(256) NOT NULL,
  parent_id INT DEFAULT NULL,
  description VARCHAR(1024) DEFAULT NULL,
  INDEX (parent_id),
  FOREIGN KEY (parent_id) REFERENCES team(id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS team_lead (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  team_id INT NOT NULL,
  employee_id INT NOT NULL,
  lead_order INT NOT NULL DEFAULT 0, -- there could be multiple leads senior, deputy, assistant etc 
  title VARCHAR(256) NOT NULL,
  start_date DATE NOT NULL DEFAULT (CURRENT_DATE),
  end_date DATE DEFAULT NULL,
  last_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  description VARCHAR(1024) DEFAULT NULL,
  INDEX (team_id),
  FOREIGN KEY (team_id) REFERENCES team(id) ON DELETE CASCADE,
  INDEX (employee_id),
  FOREIGN KEY (employee_id) REFERENCES employee(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS job_band (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(256) NOT NULL,
  description VARCHAR(1024) DEFAULT NULL,
  level INT NOT NULL DEFAULT 0,
  min_salary DECIMAL(13,2) NOT NULL DEFAULT 0.0,
  max_salary DECIMAL(13,2) NOT NULL DEFAULT 0.0
);

CREATE TABLE IF NOT EXISTS job (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(256) NOT NULL,
  description VARCHAR(1024) DEFAULT NULL,
  team_id INT NOT NULL,
  job_band_id INT NOT NULL,
  INDEX (team_id),
  FOREIGN KEY (team_id) REFERENCES team(id) ON DELETE CASCADE,
  INDEX (job_band_id),
  FOREIGN KEY (job_band_id) REFERENCES job_band(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS job_description (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  job_id INT NOT NULL,
  sequence_no INT NOT NULL DEFAULT 100,
  description VARCHAR(1024) DEFAULT NULL,
  INDEX (job_id),
  FOREIGN KEY (job_id) REFERENCES job(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS role_responsibility_category (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  description VARCHAR(1024) DEFAULT NULL
);

CREATE TABLE IF NOT EXISTS job_role_responsibility (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  job_id INT NOT NULL,
  role_responsibility_category_id INT NOT NULL,
  sequence_no INT NOT NULL DEFAULT 100,
  description VARCHAR(1024) DEFAULT NULL,
  INDEX (job_id),
  FOREIGN KEY (job_id) REFERENCES job(id) ON DELETE CASCADE,
  INDEX (role_responsibility_category_id),
  FOREIGN KEY (role_responsibility_category_id) REFERENCES role_responsibility_category(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS qualification_category (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  description VARCHAR(1024) DEFAULT NULL
);

CREATE TABLE IF NOT EXISTS job_qualification (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  job_id INT NOT NULL,
  qualification_category_id INT NOT NULL,
  sequence_no INT NOT NULL DEFAULT 100,
  description VARCHAR(1024) DEFAULT NULL,
  INDEX (job_id),
  FOREIGN KEY (job_id) REFERENCES job(id) ON DELETE CASCADE,
  INDEX (qualification_category_id),
  FOREIGN KEY (qualification_category_id) REFERENCES qualification_category(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS skill_category (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  description VARCHAR(1024) DEFAULT NULL
);

CREATE TABLE IF NOT EXISTS job_skill (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  job_id INT NOT NULL,
  skill_category_id INT NOT NULL,
  sequence_no INT NOT NULL DEFAULT 100,
  description VARCHAR(1024) DEFAULT NULL,
  INDEX (job_id),
  FOREIGN KEY (job_id) REFERENCES job(id) ON DELETE CASCADE,
  INDEX (skill_category_id),
  FOREIGN KEY (skill_category_id) REFERENCES skill_category(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS evaluation_criteria_category (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  description VARCHAR(1024) DEFAULT NULL
);

CREATE TABLE IF NOT EXISTS job_evaluation_criteria (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  job_id INT NOT NULL,
  evaluation_criteria_category_id INT NOT NULL,
  sequence_no INT NOT NULL DEFAULT 100,
  description VARCHAR(1024) DEFAULT NULL,
  INDEX (job_id),
  FOREIGN KEY (job_id) REFERENCES job(id) ON DELETE CASCADE,
  INDEX (evaluation_criteria_category_id),
  FOREIGN KEY (evaluation_criteria_category_id) REFERENCES evaluation_criteria_category(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS office_employee (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  office_id INT NOT NULL,
  job_id INT NOT NULL,
  employee_id INT NOT NULL,
  start_date DATE NOT NULL DEFAULT (CURRENT_DATE),
  end_date DATE DEFAULT NULL,
  last_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  title VARCHAR(256) DEFAULT NULL, -- there could be additional title in addition to job name
  notes VARCHAR(1024) DEFAULT NULL,
  -- in case someone is re-hired, then a new employee ID must be created, cannot reuse old ID
  INDEX (office_id),
  FOREIGN KEY (office_id) REFERENCES office(id) ON DELETE CASCADE,
  INDEX (job_id),
  FOREIGN KEY (job_id) REFERENCES job(id) ON DELETE CASCADE,
  INDEX (employee_id),
  FOREIGN KEY (employee_id) REFERENCES employee(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS positions_vacant (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  office_id INT NOT NULL,
  job_id INT NOT NULL,
  amount INT NOT NULL,
  start_date DATE NOT NULL DEFAULT (CURRENT_DATE),
  end_date DATE DEFAULT NULL,
  last_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  notes VARCHAR(1024) DEFAULT NULL,
  INDEX (office_id),
  FOREIGN KEY (office_id) REFERENCES office(id) ON DELETE CASCADE,
  INDEX (job_id),
  FOREIGN KEY (job_id) REFERENCES job(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS applicant (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  positions_vacant_id INT NOT NULL,
  first_name VARCHAR(256) NOT NULL,
  last_name VARCHAR(256) NOT NULL,
  name_with_initials VARCHAR(512) DEFAULT NULL,
  full_name VARCHAR(1024) DEFAULT NULL,
  gender ENUM ('Male','Female', 'Oter', 'Not Specified')  NOT NULL DEFAULT 'Not Specified',    
  applied_date DATE NOT NULL DEFAULT (CURRENT_DATE),
  id_number VARCHAR(20),
  phone_number1 VARCHAR(20) DEFAULT NULL,
  phone_number2 VARCHAR(20) DEFAULT NULL, 
  email VARCHAR(320) DEFAULT NULL,
  cv_location VARCHAR(2048) NOT NULL, -- a URL or a cloud storage location such as git/Gdrive
  last_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX (positions_vacant_id),
  FOREIGN KEY (positions_vacant_id) REFERENCES positions_vacant(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS applicant_address (
  applicant_id INT NOT NULL,
  address_id INT NOT NULL,
  PRIMARY KEY (applicant_id, address_id),
  INDEX (applicant_id),
  FOREIGN KEY (applicant_id) REFERENCES applicant(id) ON DELETE CASCADE,
  INDEX (address_id),
  FOREIGN KEY (address_id) REFERENCES address(id) ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS application_status (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(50) NOT NULL, -- new, short listed, not short listed, called, interviewed, rejected, offered, offer accepted, offer rejected 
  sequence_no INT NOT NULL DEFAULT 0,
  description VARCHAR(1024) DEFAULT NULL
);

CREATE TABLE IF NOT EXISTS applicant_application_status (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  applicant_id INT NOT NULL,
  application_status_id INT NOT NULL,
  start_date DATE NOT NULL DEFAULT (CURRENT_DATE),
  end_date DATE DEFAULT NULL,
  last_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  notes VARCHAR(1024) DEFAULT NULL,
  INDEX (applicant_id),
  FOREIGN KEY (applicant_id) REFERENCES applicant(id) ON DELETE CASCADE,
  INDEX (application_status_id),
  FOREIGN KEY (application_status_id) REFERENCES application_status(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS applicant_qualification (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  applicant_id INT NOT NULL,
  job_qualification_id INT NOT NULL,
  rating INT NOT NULL DEFAULT 0,
  description VARCHAR(1024) DEFAULT NULL,
  last_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX (applicant_id),
  FOREIGN KEY (applicant_id) REFERENCES applicant(id) ON DELETE CASCADE,
  INDEX (job_qualification_id),
  FOREIGN KEY (job_qualification_id) REFERENCES job_qualification(id) ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS applicant_skill (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  applicant_id INT NOT NULL,
  job_skill_id INT NOT NULL,
  evaluator_id INT NOT NULL,
  rating INT NOT NULL DEFAULT 0,
  description VARCHAR(1024) DEFAULT NULL,
  last_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX (applicant_id),
  FOREIGN KEY (applicant_id) REFERENCES applicant(id) ON DELETE CASCADE,
  INDEX (job_skill_id),
  FOREIGN KEY (job_skill_id) REFERENCES job_skill(id) ON DELETE CASCADE,
  INDEX (evaluator_id),
  FOREIGN KEY (evaluator_id) REFERENCES employee(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS applicant_evaluation (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  applicant_id INT NOT NULL,
  job_evaluation_criteria_id INT NOT NULL,
  interviewer_id INT NOT NULL,
  rating INT NOT NULL DEFAULT 0,
  description VARCHAR(1024) DEFAULT NULL,
  last_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX (applicant_id),
  FOREIGN KEY (applicant_id) REFERENCES applicant(id) ON DELETE CASCADE,
  INDEX (job_evaluation_criteria_id),
  FOREIGN KEY (job_evaluation_criteria_id) REFERENCES job_evaluation_criteria(id) ON DELETE CASCADE,
  INDEX (interviewer_id),
  FOREIGN KEY (interviewer_id) REFERENCES employee(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS applicant_interview (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  applicant_id INT NOT NULL,
  interviewer_id INT NOT NULL,
  date_time DATETIME NOT NULL,
  description VARCHAR(1024) DEFAULT NULL, -- what is this interview about
  current_status ENUM ('Pending', 'Done', 'Cancelled', 'Postponed', 'No show')  NOT NULL DEFAULT 'Pending',  
  outcome ENUM ('Selected', 'Rejected', 'On hold', 'Short List', 'Cross-check', 'Maybe', 'TBD')  NOT NULL DEFAULT 'TBD',  
  rating INT NOT NULL DEFAULT 0,
  comments VARCHAR(2048) DEFAULT NULL, -- comments by interviewer on candidate
  notes VARCHAR(1024) DEFAULT NULL, -- notes on what happend and why it got cancelled etc
  last_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX (applicant_id),
  FOREIGN KEY (applicant_id) REFERENCES applicant(id) ON DELETE CASCADE,
  INDEX (interviewer_id),
  FOREIGN KEY (interviewer_id) REFERENCES employee(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS job_offer (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  applicant_id INT NOT NULL,
  offer_status ENUM ('Pending', 'Sent', 'Accepted', 'Rejected', 'Cancelled', 'No show')  NOT NULL DEFAULT 'Pending', 
  approved_by INT NOT NULL,
  start_date DATE NOT NULL DEFAULT (CURRENT_DATE),
  end_date DATE DEFAULT NULL, 
  last_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  salary DECIMAL(8,2) NOT NULL DEFAULT 0.0,
  description VARCHAR(2048) DEFAULT NULL,
  notes VARCHAR(2048) DEFAULT NULL, -- cosider incoporating offer letter templayes per job
  INDEX (applicant_id),
  FOREIGN KEY (applicant_id) REFERENCES applicant(id) ON DELETE CASCADE,
  INDEX (approved_by),
  FOREIGN KEY (approved_by) REFERENCES employee(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS employee_qualification (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  employee_id INT NOT NULL,
  job_qualification_id INT NOT NULL,
  verified_by INT DEFAULT NULL,
  rating INT NOT NULL DEFAULT 0,
  description VARCHAR(1024) DEFAULT NULL,
  last_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX (employee_id),
  FOREIGN KEY (employee_id) REFERENCES employee(id) ON DELETE CASCADE,
  INDEX (job_qualification_id),
  FOREIGN KEY (job_qualification_id) REFERENCES job_qualification(id) ON DELETE CASCADE,
  INDEX (verified_by),
  FOREIGN KEY (verified_by) REFERENCES employee(id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS employee_skill (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  employee_id INT NOT NULL,
  job_skill_id INT NOT NULL,
  evaluator_id INT NOT NULL,
  rating INT NOT NULL DEFAULT 0,
  description VARCHAR(1024) DEFAULT NULL,
  last_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX (employee_id),
  FOREIGN KEY (employee_id) REFERENCES employee(id) ON DELETE CASCADE,
  INDEX (job_skill_id),
  FOREIGN KEY (job_skill_id) REFERENCES job_skill(id) ON DELETE CASCADE,
  INDEX (evaluator_id),
  FOREIGN KEY (evaluator_id) REFERENCES employee(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS evaluation_cycle (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  description VARCHAR(1024) DEFAULT NULL,
  start_date DATE NOT NULL DEFAULT (CURRENT_DATE),
  end_date DATE DEFAULT NULL, 
  last_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  notes VARCHAR(2048) DEFAULT NULL
);

CREATE TABLE IF NOT EXISTS employee_evaluation (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  employee_id INT NOT NULL,
  job_evaluation_criteria_id INT NOT NULL,
  evaluator_id INT NOT NULL,
  evaluation_cycle_id INT NOT NULL,
  rating INT NOT NULL DEFAULT 0,
  description VARCHAR(1024) DEFAULT NULL,
  last_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX (employee_id),
  FOREIGN KEY (employee_id) REFERENCES employee(id) ON DELETE CASCADE,
  INDEX (job_evaluation_criteria_id),
  FOREIGN KEY (job_evaluation_criteria_id) REFERENCES job_evaluation_criteria(id) ON DELETE CASCADE,
  INDEX (evaluator_id),
  FOREIGN KEY (evaluator_id) REFERENCES employee(id) ON DELETE CASCADE,
  INDEX (evaluation_cycle_id),
  FOREIGN KEY (evaluation_cycle_id) REFERENCES evaluation_cycle(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS attendance_type (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  employment_type_id INT NOT NULL,
  name VARCHAR(30) NOT NULL DEFAULT 'Absent', -- ('In', 'Out', 'Break', 'Back', 'Absent') 
  description VARCHAR(1024) DEFAULT NULL,
  INDEX (employment_type_id),
  FOREIGN KEY (employment_type_id) REFERENCES employment_type(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS employee_attendance (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  employee_id INT NOT NULL,
  attendance_type_id INT NOT NULL, 
  time_stamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  last_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  notes VARCHAR(1024) DEFAULT NULL,
  INDEX (employee_id),
  FOREIGN KEY (employee_id) REFERENCES employee(id) ON DELETE CASCADE,
  INDEX (attendance_type_id),
  FOREIGN KEY (attendance_type_id) REFERENCES attendance_type(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS leave_type (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  employment_type_id INT NOT NULL,
  name VARCHAR(30) NOT NULL DEFAULT 'No Pay Leave', -- Casual Leave,	Sick Leave,	Annual Leave,	Maternity Leave
  allocation INT DEFAULT 0,
  description VARCHAR(1024) DEFAULT NULL,
  INDEX (employment_type_id),
  FOREIGN KEY (employment_type_id) REFERENCES employment_type(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS employee_leave (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  employee_id INT NOT NULL,
  leave_type_id INT NOT NULL,
  applied_on TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  start_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  end_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  approved_by INT NOT NULL,
  last_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX (employee_id),
  FOREIGN KEY (employee_id) REFERENCES employee(id) ON DELETE CASCADE,
  INDEX (leave_type_id),
  FOREIGN KEY (leave_type_id) REFERENCES leave_type(id) ON DELETE CASCADE,
  INDEX (approved_by),
  FOREIGN KEY (approved_by) REFERENCES employee(id) ON DELETE CASCADE
);

