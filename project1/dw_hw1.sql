SELECT * INTO ychen.demo FROM Demographics

SELECT * FROM ychen.demo WHERE Gender='NULL'

-- Altering columns names
EXEC sp_rename 'ychen.demo.tri_age', 'Age';
EXEC sp_rename 'ychen.demo.gendercode', 'Gender';
EXEC sp_rename 'ychen.demo.contactid', 'ID';
EXEC sp_rename 'ychen.demo.address1_stateorprovince', 'State';
EXEC sp_rename 'ychen.demo.tri_imaginecareenrollmentemailsentdate' , 'EmailSentdate';
EXEC sp_rename 'ychen.demo.tri_enrollmentcompletedate' , 'Completedate';


-- Problem 2
-- Create and edit a new column
ALTER TABLE ychen.demo ADD EnrollmentStatus NVARCHAR(255);
UPDATE ychen.demo SET EnrollmentStatus = 'Complete' where tri_imaginecareenrollmentstatus = 167410011
UPDATE ychen.demo SET EnrollmentStatus = 'Email sent' where tri_imaginecareenrollmentstatus = 167410001
UPDATE ychen.demo SET EnrollmentStatus = 'Non responder' where tri_imaginecareenrollmentstatus = 167410004
UPDATE ychen.demo SET EnrollmentStatus = 'Facilitated Enrollment' where tri_imaginecareenrollmentstatus = 167410005
UPDATE ychen.demo SET EnrollmentStatus = 'Incomplete Enrollment' where tri_imaginecareenrollmentstatus = 167410002
UPDATE ychen.demo SET EnrollmentStatus = 'Opted Out' where tri_imaginecareenrollmentstatus = 167410003
UPDATE ychen.demo SET EnrollmentStatus = 'Unprocessed' where tri_imaginecareenrollmentstatus = 167410000
UPDATE ychen.demo SET EnrollmentStatus = 'Second email sent' where tri_imaginecareenrollmentstatus = 167410006

SELECT tri_imaginecareenrollmentstatus, EnrollmentStatus FROM ychen.demo

-- Problem 3
ALTER TABLE ychen.demo ADD Sex VARCHAR(100)
UPDATE ychen.demo SET Sex = 'female' where Gender = '2'
UPDATE ychen.demo SET Sex = 'male' where Gender = '1'
UPDATE ychen.demo SET Sex = 'other' where tri_imaginecareenrollmentstatus = 167410000 
UPDATE ychen.demo SET Sex = 'unknown' where Gender = 'NULL'

SELECT Gender, Sex From ychen.demo

-- Problem 4
ALTER TABLE ychen.demo ADD Age_group VARCHAR(100)
UPDATE ychen.demo SET Age_group = '0-25' where Age BETWEEN 0 AND 25
UPDATE ychen.demo SET Age_group = '26-50' where Age BETWEEN 26 AND 50
UPDATE ychen.demo SET Age_group = '51-75' where Age BETWEEN 51 AND 75
UPDATE ychen.demo SET Age_group = '76-100' where Age BETWEEN 76 AND 100

SELECT Age, Age_group FROM ychen.demo

