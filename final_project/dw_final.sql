SELECT * FROM ychen.IC_BP;
SELECT * FROM qbs181.dbo.Demographics;
SELECT * FROM ychen.bpanddemo;

-- Q1.a
--Convert BPalerts to BPstatus
ALTER TABLE ychen.IC_BP ADD BPStatus INT;

-- Q1.b
--Create a new column names BPAlerts
--Redefine BP alerts into binomial variables where 1 as Controlled blood pressure and 0 as uncontrolled
UPDATE ychen.IC_BP SET BPStatus = 1 WHERE BPAlerts = 'Hypo1';
UPDATE ychen.IC_BP SET BPStatus = 1 WHERE BPAlerts = 'Normal';
UPDATE ychen.IC_BP SET BPStatus = 0 WHERE BPAlerts = 'Hypo2'
UPDATE ychen.IC_BP SET BPStatus = 0 WHERE BPAlerts = 'HTN1'
UPDATE ychen.IC_BP SET BPStatus = 0 WHERE BPAlerts = 'HTN2'
UPDATE ychen.IC_BP SET BPStatus = 0 WHERE BPAlerts = 'HTN3'

-- Q1.c Merge IC_BP with demographics to obtain patients' enrollment dates from the latter table
-- Create a merged table named bpanddemo
SELECT ychen.IC_BP.*, try_convert(DATETIME2, dbo.Demographics.tri_enrollmentcompletedate) AS Enrollmentdate
INTO ychen.bpanddemo
FROM ychen.IC_BP
INNER JOIN qbs181.dbo.Demographics
ON dbo.Demographics.contactid = ychen.IC_BP.ID
ORDER BY ID;
--View the merged table bpanddemo
SELECT * FROM ychen.bpanddemo;


--Q1.d In the frist 12 weeks of enrollment for each patients, their weekly average BPStatus is calculated
--Create a column named Diffinweek (Difference in week)
--and obtain the time(week) when coming back for follow-ups from their first enrollment
ALTER TABLE ychen.bpanddemo ADD DiffinWeek INT
UPDATE ychen.bpanddemo SET DiffinWeek = DATEDIFF(WEEK, Enrollmentdate, ObservedTime);

--Calculate each patients' weekly average BPStatus scores in the first 12 weeks
SELECT ID, DiffinWeek, CAST(AVG(BPStatus) AS DECIMAL(10,2)) AS BPAverageScore
FROM (SELECT * FROM ychen.bpanddemo
    WHERE diffinweek <= 12 AND diffinweek >= 0) t2
GROUP BY ID, DiffinWeek
ORDER BY ID, DiffinWeek;


--Q1.e Compare the BPStatus scores at baseline (firstweek) and follow-up on 12th week
SELECT firstweek.ID, firstweek.FirstWeekAvgBPScore, twelfthweek.TwelfthWeekBPStatus
FROM (
    SELECT ID, AVG(BPStatus) AS FirstWeekAvgBPScore
    FROM ychen.bpanddemo
    WHERE DiffinWeek = 0
    GROUP BY ID) firstweek
INNER JOIN (
    SELECT ID, AVG(BPStatus) AS TwelfthWeekBPStatus
    FROM ychen.bpanddemo
    WHERE DiffinWeek = 12
    GROUP BY ID) twelfthweek
ON firstweek.ID = twelfthweek.ID;


--1.f
--How many BPStatus of observations converted from 0 to 1?
--2 out of 9.


----------------------------------------------
--2. Merge three tables (Demographics, ChronicConditions & Text)
SELECT
    demo.*, chro.*, text.*
INTO ychen.wholesurvey
FROM 
    dbo.Demographics demo
INNER JOIN dbo.ChronicConditions chro
ON demo.contactid = chro.tri_patientid
    INNER JOIN dbo.[Text] TEXT
    ON chro.tri_patientid = text.tri_contactId;

--Obtain the final dataset such that we have 1 Row per ID 
--by choosing on the latest date when the text was sent (if sent on multiple days)
SELECT b.*
FROM ( 
    SELECT contactid, MAX(TextSentDate) AS LatestSentDate
    FROM ychen.wholesurvey
    GROUP BY contactid) a
INNER JOIN ychen.wholesurvey b
ON a.contactid = b.contactid AND b.TextSentDate = LatestSentDate; --4619 / 3346

--View the results
SELECT * FROM ychen.wholesurvey;




 
