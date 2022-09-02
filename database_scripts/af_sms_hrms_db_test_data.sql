USE sms_db;

SHOW tables;
SELECT count(*) AS TOTALNUMBEROFTABLES
   FROM INFORMATION_SCHEMA.TABLES
   WHERE TABLE_SCHEMA = 'sms_db';

INSERT INTO customer VALUES 
(1, 'Elon', 'Musk'), 
(2, 'Bill', 'Gates'), 
(3, 'Sundar', 'Pichai');

INSERT INTO address_type (name, description) VALUES
('Residential', 'Residential address is where you are currently living'),
('Permanent', 'Permanent address is the place where your voter id is registered'),
('Postal', 'Postal address is where mail is delivered');

INSERT INTO address (line1, line2, line3, city_id, address_type_id, notes) VALUES
('40 1/C', 'Old Lane', 'Walahhan Duwa', 6, 1, 'Galle Residance'),
('Gahalawaththa', 'Hiway Road', 'Naya Pamula', 389, 2, 'Studnet permamnant address'),
('PO Box 1001', 'Empower School', 'Office Branch', 2, 2, 'Office address'), 
('7/1/C', 'New Road', 'Walahhan Duwa', 6, 1, 'Rented Residance'),
('Gallawaththa', 'Hiway Road', 'Naya Pamula', 389, 1, 'Boarding house'),
('PO Box 2030', 'Rathnawali School', 'Galle Branch', 2, 2, 'Postal address');


INSERT INTO employee (employee_id, first_name, last_name, name_with_initials, full_name, 
gender, hire_date, id_number, phone_number1, phone_number2, email, cv_location, last_updated) VALUES 
('PF0001', 'Bandula', 'Silva', 'H A B Silva', 'Hapugala Arachchige Bandula Silva', 'Male', '2022-05-20', '773335378V', '0777523817', '071253925', 'bandula.silva77@gmail.com', 'https://github.com/LSFLK/MedicinesforLK/wiki', now()),
('PF0002', 'Yasara', 'Perera', 'N H Y Perera', 'Nanayakkara Hadun Yasara Perera', 'Female', '2022-06-18', '953335378V', '0777423792', '071227788', 'yasara.perera95@gmail.com', 'https://github.com/LSFLK/MedicinesforLK/wiki', now()),
('PF0003', 'Anjula', 'Rodrigo', 'D A Rodrigo', 'Dona Anjula Rodrigo', 'Female', '2022-07-28', '880282349v', '0767523823', '070253923', 'anjula.rodrigo88@gmail.com', 'https://github.com/LSFLK/MedicinesforLK/wiki', now());

INSERT INTO employee_address (employee_id, address_id) VALUES 
(1, 1),
(1, 2),
(2, 4),
(3, 5),
(3, 6);

INSERT INTO employment_type (name, description) VALUES
('Probation', 'Probation employment, before they are confirmed'),
('Permenent', 'Permanent employment'),
('Contract', 'Those who work on contract basis'), 
('Consultant','Consultants who are subject matter experts');

INSERT INTO employee_employment_type (employee_id, employment_type_id, start_date, end_date, last_updated) VALUES
(1, 3, '2022-05-20', NULL, now()),
(2, 2, '2022-06-18', NULL, now()),
(3, 1, '2022-07-28', NULL, now());

INSERT INTO employment_status (name, sequence_no, description )VALUES 
('Active', 10, 'Currently employed and working'),
('Sabbatical', 20, 'Long term sabbatical leave'),
('Suspended', 30, 'Suspended due to policy violation based on disciplinary action taken'), 
('Resigned', 40, 'Resignation submitted in wiritng and accepted'),
('Terminated', 50, 'Employment ended following a decision made by the employer');

INSERT INTO employee_employment_status (employee_id, employment_status_id, start_date, end_date, last_updated) VALUES 
(1, 1, '2022-05-20', NULL, now()),
(2, 1, '2022-06-18', NULL, now()),
(3, 1, '2022-07-28', NULL, now());

INSERT INTO organization (name, description, phone_number1, phone_number2) VALUES 
('Weerawarana Foundation', 'Parent foundation founded by Sanjiva', '0112 802 90', '0114 202 30'),
('Peak Foundation', 'Foundation for all matters education', '0112 702 88', '0114 302 77');

INSERT INTO organization_address (organization_id, address_id) VALUES 
(1, 3),
(2, 6);

INSERT INTO branch (organization_id, name, description, phone_number1, phone_number2) VALUES 
(2, 'School Homagama', 'Peak Homagama Branch', '0112 902 78', '0114 352 47'), 
(2, 'School Galle', 'Peak Galle Branch', '0118 955 78', '0114 366 97'), 
(2, 'School Gampaha', 'Peak Gampaha Branch', '0112 992 23', '0114 328 17');

INSERT INTO branch_address (branch_id, address_id) VALUES 
(1, 3),
(2, 6),
(3, 1);

INSERT INTO office (branch_id, name, description, phone_number1, phone_number2) VALUES 
(2, 'Peack Gall 1', 'Peak Galle office 1', '0118 902 78', '0114 352 47'), 
(2, 'Peak Galle 2', 'Peak Galle Office 2', '0118 955 78', '0114 366 97'), 
(2, 'Peak Galle 3', 'Peak Galle Office 3', '0118 992 23', '0114 328 17');

INSERT INTO office_address (office_id, address_id) VALUES 
(1, 3),
(2, 6),
(3, 1);

INSERT INTO team (parent_id, name, description) VALUES 
(NULL,'Admin', 'Team responsible for all administration tasks'),
(NULL, 'Sales', 'Sales Team'),
(NULL, 'Acadamic', 'Team of teachers.'),
(3, 'PBL Staff', 'Team of PBL teachers');

INSERT INTO team_lead (team_id, employee_id, lead_order, title, start_date, end_date, last_updated, description) VALUES 
(1, 1, 1, 'Admin Officer', '2022-08-01', NULL, now(), 'Responsible for overall administation of the school'),
(3, 2, 1, 'Head of Acadamics', '2022-09-01', NULL, now(), 'Responsible for managing overall acadamic staff'),
(4, 3, 1, 'Lead PBL Teacher', '2022-10-01', NULL, now(), 'Responsible for PBL acadamic programme');

INSERT INTO job_band (name, description, level, min_salary, max_salary) VALUES 
('Very early career', 'Learning technical and professional skills.', 10, 15000.00, 40000.00),
('Early career', 'Basic skills developed. Work contributes to success of team and product goals.', 20, 40000.00, 80000.00), 
('Seasoned professional', 'Variety of technical skills developed. Strong problem solver. Key for success of team/product goals.', 30, 80000.00, 120000.00),
('Associate / Supervisor.', 'Entry-level professional with limited or no prior experience to contribute on a project or work team.', 40, 120000.00, 200000.00),
('Intermediate / Manager.', 'Fully competent and productive professional contributor who applies acquired job skills, policies, and procedures to complete substantive assignments/projects/tasks of moderate scope and complexity.', 50, 200000.00, 300000.00),
('Senior / Senior Manager', 'Recognized subject matter expert who knows how to apply theory and put it into practice with in-depth understanding of the professional field with limited oversight from managers.', 60, 300000.00, 400000.00), 
('Very senior', 'Can solve most problems or issues that arise. Uses experience to forward company goals/objectives.', 70, 400000.00, 500000.00), 
('Asistant Director', 'Manages a large team typically consisting of both experienced professionals and subordinate Managers. Focuses on tactical and operational plans with short to mid-term focus; significant responsibility to achieve broadly stated goals through subordinate Managers.', 80, 500000.00, 600000.00), 
('Director', 'Oversees through subordinate Managers a large, complex organization with multiple functional disciplines/occupations, OR manages a program, regardless of size, that has critical impact upon the campus.', 90, 600000.00, 700000.00), 
('Exceptional', 'Considered an expert or thought leader within the organization (and sometimes externally as well). Drives timeline, features, and development through broad influence.', 100, 700000.00, 800000.00), 
('Principle', 'Recognized master in professional discipline with significant impact and influence on campus policy and program development. Establishes critical strategic and operational goals; develops and implements new products, processes, standards or operational plans to achieve strategies.', 110, 800000.00, 900000.00), 
('Senior or Executive Director', 'Directs through subordinate Managers multiple large and complex critical programs impacting broad constituencies across major portions of campus. Identifies objectives, manages very significant human, financial, and physical resources, and functions with an extremely high degree of autonomy. Accountable for formulating and administering policies and programs for major functions.', 120, 1000000.00, 1100000.00),  
('Associate Vice President', 'Accountable for leading departments or major areas within a division through managers and directors. Works under broad, administrative direction with responsibility for providing strategic leadership and direction in the planning, implementing, improving, and evaluating of an administrative department and promoting operational improvements.', 130, 1100000.00, 1200000.00), 
('Vice President', 'Accountable for leading business units', 140, 1200000.00, 1300000.00), 
('Luminary', 'Central to the organization ‘s success. Translates organizational strategic goals into department and team plans. Provides fundamental contributions to long-term company planning in area of expertise.', 150, 1300000.00, 1400000.00), 
('Senior Vice President', 'Responsible for a whole pollar or virtical of the organization', 160, 1400000.00, 1500000.00), 
('CxO', 'senior executive who works together with other senior executives to ensure a company stays true to its preset strategy, plans, and policies', 170, 1500000.00, 1600000.00), 
('Fellow', 'Honorary position', 180, 350.00, 350.00);

INSERT INTO job (name, description, team_id, job_band_id) VALUES
('Associate HR Officer', 'Responsible for routine HR activities', 1, 4), 
('Operations Officer', 'Responsible for routine operations activities', 1, 5),
('Junior PBL Teacher', 'Teacher with no experiance', 3, 4),
('PBL Teacher', 'Teacher with some experiance', 3, 5),
('Senior PBL Teacher', 'Teacher with years of experiance', 3, 6);

INSERT INTO job_description (job_id, sequence_no, description) VALUES 
(3, 10, 'Teach the assgined subjects'),
(3, 20, 'Be a buddy and a mentor to the students'),
(3, 30, 'Ensure the growth of students from both subjet matter and social status');

INSERT INTO role_responsibility_category (name, description) VALUES 
('Strategic', 'Alignment to long term organization plans. Contribution to strategic planning and achivement of strategic goals'),
('Tactical', 'Alignment to short to mid term organization plans. Contibution to tactical plans leading to the achivement of strategic goals.'),
('Operational', 'ALignment to operational misletones and conditions. Contibution to operational plans leading to the achivement of tactical goals.');

INSERT INTO job_role_responsibility (job_id, role_responsibility_category_id, sequence_no, description) VALUES
(3, 1, 10, 'Understand organization vision and strategy'),
(3, 2, 20, 'Understand and contribute to tactical planning leading to the realization of vision and strategy'),
(3, 3, 30, 'Stive for operational excellence of the class room');

INSERT INTO qualification_category (name, description) VALUES 
('Educational', 'General educational qualifications'),
('Industry Related', 'Related to the industry'), 
('Role Related', 'Related to the role played'),
('Work Oriented', 'Not be directly relevant to the job role, but instead, useful for the job in a different way. E.g. First aid course or fire safety.');

 INSERT INTO job_qualification (job_id, qualification_category_id, sequence_no, description) VALUES
 (3, 1, 10, 'GCE A/L with at least 2 C passes'),
 (3, 2, 10, 'Diploma in teaching'),
 (3, 3, 10, 'Education filed related diploma');

INSERT INTO skill_category (name, description) VALUES 
('Relationship', 'Interpersonal communication skills that directly aid individuals or groups in dealing with each other'),
('Communication', 'Fundamental verbal and written communication skills for interaction with individuals and groups.'), 
('Management/Leadership', 'The use of organizational, managerial, and leadership skills to accomplish organizational goals'),
('Analytical', 'NLogical processing of information and data to produce useable results.'),
('Creative', 'Process, generate and connect ideas and information into something new'),
('Physical/Technical', 'Interaction of the body with physical objects including machines and technological systems.'),
('Learning', 'Ability to learn, unlearn and relearn'),
('Teaching', 'Ability to teach someone something in an effective manner');

INSERT INTO job_skill (job_id, skill_category_id, sequence_no, description ) VALUES 
(3, 8, 10, 'Work effectively with student groups'),
(3, 8, 20, 'Motivate student to do their best'), 
(3, 8, 30, 'Empathise with your students');

INSERT INTO evaluation_criteria_category (name, description) VALUES 
('Quality of work', 'Quaoity of work and meets the standards.'),
('Execution', 'How well the employee organizes, schedules, and completes tasks'),
('Progress', 'Meet the goals and grown'),
('Adaptability', 'Handle change positively'),
('Initiative', 'Assess and initiate things independently.'),
('Communication', 'Share thoughts and ideas effectively'),
('Job knowledge', 'Display an acceptable level of knowledge regarding their specific role'),
('Problem-solving and decision-making', 'Effectively identify a problem and devise an appropriate solution'),
('Planning and organization', 'Organized and consistently prepared'),
('Teamwork', 'Pleasant and polite to other employees');

INSERT INTO job_evaluation_criteria (job_id, evaluation_criteria_category_id, sequence_no, description) VALUES 
(3, 1, 10, 'Take attendance all the time'), 
(3, 1, 20, 'Submit class notes then and there'),
(3, 2, 10, 'Work is well organized'); 

INSERT INTO office_employee (office_id, job_id, employee_id, start_date, end_date, last_updated, title, notes) VALUES
(1, 3, 2, '2022-08-31', NULL, now(), "PBL Teacher", "PBL teacher 001"),
(1, 3, 3, '2022-08-31', NULL, now(), "PBL Teacher", "PBL teacher 001");

INSERT INTO positions_vacant (office_id, job_id, amount, start_date, end_date, last_updated, notes) VALUES 
(1, 1, 1, '2022-08-20', '2022-11-30', now(), 'HR person for new school'),
(1, 2, 1, '2022-08-20', '2022-11-30', now(), 'Operations person for new school'),
(1, 3, 8, '2022-08-20', '2022-11-30', now(), 'PBL teachers for new school');

INSERT INTO applicant (positions_vacant_id, first_name, last_name, name_with_initials, full_name, 
gender, applied_date, id_number, phone_number1, phone_number2, email, cv_location, last_updated) VALUES 
(3, 'Bandara', 'Silva', 'H A B Silva', 'Hapugala Arachchige Bandara Silva', 'Male', '2022-05-20', '773335378V', '0777523817', '071253925', 'bandula.silva77@gmail.com', 'https://github.com/LSFLK/MedicinesforLK/wiki', now()),
(3, 'Thushara', 'Perera', 'N H T Perera', 'Nanayakkara Hadun Thushara Perera', 'Female', '2022-06-18', '953335378V', '0777423792', '071227788', 'yasara.perera95@gmail.com', 'https://github.com/LSFLK/MedicinesforLK/wiki', now()),
(3, 'Manjula', 'Rodrigo', 'D M Rodrigo', 'Dona Manjula Rodrigo', 'Female', '2022-07-28', '880282349v', '0767523823', '070253923', 'anjula.rodrigo88@gmail.com', 'https://github.com/LSFLK/MedicinesforLK/wiki', now());

INSERT INTO application_status (name, sequence_no, description) VALUES 
('New', 10, 'New application received'),
('Rejected when short listing', 20, 'Not accepted for further processing'), 
('Short listed', 30, 'Accepted for next phase of applicant evaluation'),
('Called for interviews', 40, 'Interview process initiated'),
('Interviewed', 50, 'Interview process finalized'),
('Rejected', 60, 'Applicant rjected within the interview process'), 
('Offered', 70, 'Applicant sent a job offer after the interview process'),
('Offer Rejected', 80, 'Applicant did not accept the offer'),
('Offer withdrawn', 90, 'Organization whthdrew the offer'),
('Offer Accepted', 100, 'Applicant accepted the offer');

INSERT INTO applicant_application_status (applicant_id, application_status_id, start_date, end_date, last_updated, notes) VALUES 
(1, 1, '2022-07-20', NULL, now(), 'New application via form'),
(2, 3, '2022-07-21', NULL, now(), 'Bandaragama candidate'),
(3, 4,  '2022-07-30', NULL, now(), 'Interview called');

INSERT INTO applicant_qualification (applicant_id, job_qualification_id, rating, description, last_updated) VALUES
(1, 1, 3, 'AL in maths with one 2 Cs', now()),
(2, 1, 4, 'AL in Bio steam with 2 Cs and a A in English', now()),
(3, 1, 5, 'A/L in commerce steam with 3 Cs', now());

INSERT INTO applicant_skill (applicant_id, job_skill_id, evaluator_id, rating, description, last_updated) VALUES
(1, 1, 1, 3, 'Good stuent empathy', now()),
(2, 1, 1, 4, 'Good skill handling yound groups', now()),
(3, 1, 1, 5, 'Has worked in a youth center', now());

INSERT INTO applicant_evaluation (applicant_id, job_evaluation_criteria_id, interviewer_id, rating, description, last_updated) VALUES
(1, 1, 1, 4, 'Punchual and systematic', now()),
(2, 1, 1, 5, 'Systematic and timely', now()),
(3, 1, 1, 4, 'Has kept good time records in the past', now());

INSERT INTO applicant_interview (applicant_id, interviewer_id, date_time, description, current_status, outcome, rating, comments, notes, last_updated) VALUES
(1, 1, '2022-08-20 08:30:00', 'First interview', 'Pending', 'TBD', 0, NULL, NULL, now()),
(2, 1, '2022-08-01 09:30:00', 'First interview', 'Postponed', 'TBD', 0, NULL, NULL, now()),
(3, 1, '2022-08-02 09:30:00', 'First interview', 'Done', 'Maybe', 5, 'Need to think about it', 'Travel distance is a concern', now());

INSERT INTO job_offer (applicant_id, offer_status, approved_by, start_date, end_date, last_updated, salary, description, notes) VALUES
(3, 'Pending', 2, '2022-08-10', '2022-08-24', now(), 100000.00, 'PBL teacher offer', 'alled, on 12th. Cosidering acceptance');

INSERT INTO employee_qualification (employee_id, job_qualification_id, verified_by, rating, description, last_updated) VALUES
(1, 1, 1, 3, 'AL in maths with one 2 Cs 1S', now()),
(2, 1, 2, 4, 'AL in Bio steam with 1 C, 2 Ss and a A in English', now()),
(3, 1, 3, 5, 'A/L in commerce steam with  1 B, 2 Cs', now());

INSERT INTO employee_skill (employee_id, job_skill_id, evaluator_id, rating, description, last_updated) VALUES
(1, 1, 1, 4, 'Good stuent empathy', now()),
(2, 1, 2, 4, 'Good skill handling yound groups', now()),
(3, 1, 3, 5, 'Has worked in a youth center', now());

INSERT INTO evaluation_cycle (name, description, start_date, end_date, last_updated, notes) VALUES
('PA 2023', '2023 evaluation cycle', '2023-08-01', '2023-08-30', now(), 'Annucal cycle in August');

INSERT INTO employee_evaluation (employee_id, job_evaluation_criteria_id, evaluator_id, evaluation_cycle_id, rating, description, last_updated) VALUES
(1, 1, 1, 1, 4, 'Punchual and systematic', now()),
(2, 1, 2, 1, 5, 'Systematic and timely', now()),
(3, 1, 3, 1, 4, 'Has kept good time records in the past', now());

INSERT INTO attendance_type (employment_type_id, name, description) VALUES
(1, 'In', 'In at work'),
(1, 'Out', 'Out fom work'), -- lsat out is the off 
(1, 'Break', 'Takes a break'),
(1, 'Back', 'Back at work'),
(1, 'Absent', 'Did not come to work'), 
(2, 'In', 'In at work'),
(2, 'Out', 'Out fom work'), -- lsat out is the off 
(2, 'Break', 'Takes a break'),
(2, 'Back', 'Back at work'),
(2, 'Absent', 'Did not come to work'), 
(3, 'In', 'In at work'),
(3, 'Out', 'Out fom work'), -- lsat out is the off 
(3, 'Break', 'Takes a break'),
(3, 'Back', 'Back at work'),
(3, 'Absent', 'Did not come to work'), 
(4, 'In', 'In at work'),
(4, 'Out', 'Out fom work'), -- lsat out is the off 
(4, 'Break', 'Takes a break'),
(4, 'Back', 'Back at work'),
(4, 'Absent', 'Did not come to work');

INSERT INTO employee_attendance (employee_id, attendance_type_id, time_stamp, last_updated) VALUES
(1, 1, now(), now()),
(2, 1, now(), now()),
(3, 1, now(), now());

INSERT INTO leave_type (employment_type_id, name, allocation, description) VALUES 
(1, 'Casual Leave', 7, 'Casual leave, also know as sick leave'),
(1, 'Annual Leave', 7, 'Paid leave alocated for concluded calendar year of service'),
(1, 'Maternity Leave', 84, 'Leave that mothers or birthing parents typically take shortly before and after giving birth'),
(1, 'No Pay Leave', 0, 'Time off from work during which an employee retains their job, but does not receive a salary'),
(2, 'Casual Leave', 7, 'Casual leave, also know as sick leave'),
(2, 'Annual Leave', 7, 'Paid leave alocated for concluded calendar year of service'),
(2, 'Maternity Leave', 84, 'Leave that mothers or birthing parents typically take shortly before and after giving birth'),
(2, 'No Pay Leave', 0, 'Time off from work during which an employee retains their job, but does not receive a salary'),
(3, 'Casual Leave', 7, 'Casual leave, also know as sick leave'),
(3, 'Annual Leave', 7, 'Paid leave alocated for concluded calendar year of service'),
(3, 'Maternity Leave', 84, 'Leave that mothers or birthing parents typically take shortly before and after giving birth'),
(3, 'No Pay Leave', 0, 'Time off from work during which an employee retains their job, but does not receive a salary'),
(4, 'Casual Leave', 7, 'Casual leave, also know as sick leave'),
(4, 'Annual Leave', 7, 'Paid leave alocated for concluded calendar year of service'),
(4, 'Maternity Leave', 84, 'Leave that mothers or birthing parents typically take shortly before and after giving birth'),
(4, 'No Pay Leave', 0, 'Time off from work during which an employee retains their job, but does not receive a salary');

INSERT INTO employee_leave (employee_id, leave_type_id, applied_on, start_date, end_date, approved_by, last_updated) VALUES
(1, 1, '2022-08-01', '2022-08-02', '2022-08-03', 1, now()),
(2, 1, '2022-08-14', '2022-08-20', '2022-08-22', 1, now()),
(3, 5, '2022-08-01', '2022-08-22', '2022-08-23', 1, now());

