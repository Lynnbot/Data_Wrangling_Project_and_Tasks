-- DROP TABLE ychen.PhoneCall;
DROP TABLE ychen.CallType;
SELECT * From PhoneCall


SELECT * INTO ychen.PhoneCall FROM PhoneCall
SELECT * INTO ychen.CallDuration FROM CallDuration

-- Problem 1
ALTER TABLE ychen.PhoneCall ADD EnrollmentGroup VARCHAR(255)
UPDATE	ychen.PhoneCall	SET	EnrollmentGroup	= 'Clinical Alert'	where	EncounterCode	=	125060000
UPDATE	ychen.PhoneCall	SET	EnrollmentGroup	=	'Health Coaching'	where	EncounterCode	=	125060001
UPDATE	ychen.PhoneCall	SET	EnrollmentGroup	=	'Techinical Question'	where	EncounterCode	=	125060002
UPDATE	ychen.PhoneCall	SET	EnrollmentGroup	=	'Administrative'	where	EncounterCode	=	125060003
UPDATE	ychen.PhoneCall	SET	EnrollmentGroup	=	'Other'	where	EncounterCode	=	125060004
UPDATE	ychen.PhoneCall	SET	EnrollmentGroup	=	'Lack of engagement'	where	EncounterCode	=	125060005

SELECT * FROM ychen.PhoneCall


--Problem 2
SELECT EnrollmentGroup, COUNT(*) AS 'No.'
FROM ychen.PhoneCall
GROUP BY EnrollmentGroup

--Problem 3
SELECT * FROM ychen.CallDuration


SELECT * INTO ychen.CallInfo FROM ychen.PhoneCall
INNER JOIN ychen.CallDuration
ON ychen.PhoneCall.CustomerId = ychen.CallDuration.tri_CustomerIDEntityReference;
  

--Problem 4
-- Counts of Call Outcome
SELECT CallOutcome As 'CallOutcome', COUNT(*) AS 'No.' INTO ychen.CallOutcomeStat FROM ychen.CallDuration GROUP BY CallOutcome;
ALTER TABLE ychen.CallOutcomeStat ADD Outcome VARCHAR(255);
UPDATE ychen.CallOutcomeStat SET Outcome =  'No response' WHERE CallOutcome = 1;
UPDATE ychen.CallOutcomeStat SET Outcome =  'Left voice mail' WHERE CallOutcome = 2;
UPDATE ychen.CallOutcomeStat SET Outcome =  'Successful' WHERE CallOutcome = 3;

SELECT * FROM ychen.CallOutcomeStat ORDER BY CallOutcome

-- Counts of Call Type
SELECT CallType As 'CallTypeValue', COUNT(*) AS 'No.' INTO ychen.CallType FROM ychen.CallDuration GROUP BY CallType;
ALTER TABLE ychen.CallType ADD Calltype VARCHAR(255);
UPDATE ychen.CallType SET Calltype =  'Inbound' WHERE CallTypeValue = 1;
UPDATE ychen.CallType SET Calltype =  'Outbound' WHERE CallTypeValue = 2;

SELECT * FROM ychen.CallType

-- Call duration by enrollment groups
SELECT EnrollmentGroup, SUM(CallDuration) AS 'SumofCallDuration'
FROM ychen.CallInfo GROUP BY EnrollmentGroup ORDER BY EnrollmentGroup;

--Problem 5
-- Merge three tables
SELECT * INTO ychen.PatientData FROM Text
LEFT JOIN qbs181.dbo.ChronicConditions
ON Text.tri_contactId = qbs181.dbo.ChronicConditions.tri_patientid
LEFT JOIN qbs181.dbo.Demographics
ON Text.tri_contactId = qbs181.dbo.Demographics.contactid;

-- Find the # of texts per week by senders.
 -- First, find the range of week by senders
SELECT SenderName, DATEDIFF(wk, MIN(ychen.PatientData.TextSentDate), MAX(ychen.PatientData.TextSentDate) AS 'Weeks'
FROM ychen.PatientData
GROUP BY SenderName

SELECT * FROM ychen.PatientData

 -- Second, find the total # of sent texts by senders
SELECT SenderName, COUNT(*) AS '#SentTexts' FROM TEXT
WHERE TextSentDate IS NOT NULL
GROUP BY SenderName


--Problem 6
SELECT * INTO ychen.Textsandchronic FROM Text
LEFT JOIN ChronicConditions
ON ChronicConditions.tri_patientid = Text.tri_contactId

SELECT SenderName, DATEDIFF(wk, MIN(ychen.Textsandchronic.TextSentDate), MAX(ychen.Textsandchronic.TextSentDate)) AS 'Weeks'
FROM ychen.Textsandchronic
GROUP BY SenderName

SELECT tri_name, COUNT(*) SentTexts,
DATEDIFF(wk, MIN(ychen.Textsandchronic.TextSentDate), MAX(ychen.Textsandchronic.TextSentDate)) Weeks,
FROM ychen.Textsandchronic
WHERE TextSentDate IS NOT NULL
GROUP BY tri_name
ORDER BY tri_name

