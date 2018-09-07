DROP TRIGGER expLevelTrigger;
DROP TRIGGER highAttend_Trigger;
DROP TRIGGER log_Yoga_Refund_Trigger;
DROP PROCEDURE addClass;
DROP PROCEDURE addStudent;
DROP PROCEDURE addEnroll;
DROP PROCEDURE deleteEnroll;

ALTER TABLE Class ADD ClassCount INTEGER DEFAULT 0;

Update Class SET ClassCount = 3 WHERE Name = 'Fun with Yoga';
Update Class SET ClassCount = 3 WHERE Name = 'Stretch Yoga';
Update Class SET ClassCount = 2 WHERE Name = 'Lunch Yoga';
Update Class SET ClassCount = 2 WHERE Name = 'Yoga for All';
Update Class SET ClassCount = 2 WHERE Name = 'Yoga Inversions';
Update Class SET ClassCount = 2 WHERE Name = 'Advanced Yoga';
Update Class SET ClassCount = 3 WHERE Name = 'Relaxation Yoga';

CREATE OR REPLACE TRIGGER expLevelTrigger
	BEFORE INSERT on Enroll
	FOR EACH ROW
DECLARE
	student_exp CHAR(1);
	class_exp CHAR(1);
BEGIN
	SELECT Exp_Level INTO student_exp FROM Student WHERE Student.SID = :new.SID;
	SELECT Class_Level INTO class_exp FROM Class WHERE Name = :new.Class_Name;
	IF (student_exp = 'B' AND (class_exp != 'B' AND class_exp != 'A'))
		OR (student_exp = 'I' AND class_exp = 'E')
		THEN
		raise_application_error( -20000, 'Student level cannot be below class');
	END IF;
END;
/

CREATE OR REPLACE TRIGGER highAttend_Trigger
	BEFORE INSERT on Enroll
	FOR EACH ROW
DECLARE
	student_count INTEGER;
BEGIN
	SELECT COUNT(*) INTO student_count FROM Enroll WHERE Class_Name = :new.Class_Name;
	IF (student_count = 3) THEN
		INSERT INTO highAttend (Log_ID, Name, TID, Log_Date)
		VALUES (Attend_seq.nextval, :new.Class_Name, :new.TID, SYSDATE);
	END IF;
	EXCEPTION
		WHEN OTHERS THEN
		RAISE_APPLICATION_ERROR(-20001, 'Database error');
END;
/

CREATE OR REPLACE TRIGGER log_Yoga_Refund_Trigger
	AFTER DELETE on Enroll
	FOR EACH ROW
BEGIN
	INSERT INTO Log_Refund_Yoga (Refund_ID, SID, Payment)
	VALUES (Refund_seq.nextval, :old.SID, :old.Payment);
	EXCEPTION
		WHEN OTHERS THEN
		RAISE_APPLICATION_ERROR(-20001, 'Database error');
End;
/

CREATE OR REPLACE PROCEDURE addClass 
(aClass IN Class.Name%TYPE,
 aDuration IN Class.duration%TYPE,
 aClassLevel IN Class.Class_Level%TYPE,
 aTid IN Class.TID%TYPE,
 aDay IN Class.Day%TYPE,
 aTime IN Class.Time%TYPE,
 aCost IN Class.Cost%TYPE)
IS

BEGIN
INSERT INTO Class(Name,Duration,Class_Level,TID,Day,Time,Cost)
VALUES
(aClass,aDuration,aClassLevel,aTid,aDay,aTime,aCost);
EXCEPTION
	WHEN DUP_VAL_ON_INDEX THEN
		dbms_output.put_line('Class already exists');
	WHEN OTHERS THEN
		dbms_output.put_line('TID does not exist');
		RAISE;
dbms_output.put_line('Row added in class');
END addClass;
/

CREATE OR REPLACE PROCEDURE addStudent
(aSid IN Student.SID%TYPE,
 aFirst IN Student.First%TYPE,
 aLast IN Student.Last%TYPE,
 aExpLevel IN Student.Exp_Level%TYPE,
 aCity IN Student.City%TYPE,
 aState IN Student.State%TYPE
 ) IS

BEGIN
INSERT INTO Student(SID,First,Last,Exp_Level,City,State)
VALUES
(aSid,aFirst,aLast,aExpLevel,aCity,aState);
dbms_output.put_line('Row added in Student');
EXCEPTION
	WHEN DUP_VAL_ON_INDEX THEN
		dbms_output.put_line('Student already exists');
END addStudent;
/

CREATE OR REPLACE PROCEDURE addEnroll
(aClassName IN Enroll.Class_Name%TYPE,
 aTid IN Enroll.TID%TYPE,
 aSid IN Enroll.SID%TYPE,
 aPayment IN Enroll.Payment%TYPE
 ) IS

BEGIN
INSERT INTO Enroll(Class_Name,TID,SID,Payment)
VALUES
(aClassName,aTid,aSid,aPayment);
EXCEPTION
	WHEN DUP_VAL_ON_INDEX THEN
		dbms_output.put_line('Enrollment already exists');
	WHEN NO_DATA_FOUND THEN
		dbms_output.put_line('One or more entered PKs do not exist in tables');
		RAISE;
dbms_output.put_line('Row added in Enroll');
END addEnroll;
/

CREATE OR REPLACE PROCEDURE deleteEnroll
(aClassName IN Enroll.Class_Name%TYPE,
 aTID IN Enroll.TID%TYPE,
 aSID IN Enroll.SID%TYPE)
 IS
 BEGIN
 DELETE FROM Enroll
 WHERE Class_Name = aClassName
 AND TID = aTID
 AND SID = aSID;
 dbms_output.put_line('Row deleted from Enroll');
 --ROWCOUNT would not work in SQL plus for an empty delete check --
 EXCEPTION
	WHEN OTHERS THEN
		dbms_output.put_line('Incorrect call');
		RAISE;
 END;
 /
 
COMMIT;

-- Test of Exp level Trigger --
INSERT INTO Enroll (Class_Name, TID, SID, Payment)
VALUES ('Advanced Yoga', 4, 102, 25.00);

-- Test of highAttend Trigger --
INSERT INTO Enroll (Class_Name, TID, SID, Payment)
VALUES ('Fun with Yoga', 1, 109, 15.00);

SELECT * FROM HighAttend;

-- Test of log refund Trigger --
DELETE FROM Enroll
WHERE Class_Name = 'Fun with Yoga'
AND TID = 1
AND SID = 104;

SELECT * FROM Log_Refund_Yoga;

-- Test of addClass procedure --
CALL addClass('Extreme Yoga', 90, 'E', 3, 'Wed', '3:00 PM', 30.00);

SELECT * FROM Class;

-- Test of addStudent procedure --
CALL addStudent(111, 'Lotta', 'Work', 'E', 'Fredericksburg', 'VA');

SELECT * FROM Student;

-- Test of addEnroll procedure --
CALL addEnroll('Fun with Yoga', 1, 105, 15.00);

SELECT * FROM Enroll;

-- Test of deleteEnroll procedure --
CALL deleteEnroll('Fun with Yoga', 1, 105);

SELECT * FROM Enroll;

ROLLBACK;