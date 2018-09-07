-- Project 1 Deliverable: Database script
-- Members: Chris Rand, Michael Lopes, Phill Valoyi
SET ECHO ON;
SET SERVEROUTPUT ON;

DROP TABLE Log_Refund_Yoga;
DROP TABLE highAttend;
DROP TABLE Enroll;
DROP TABLE Class;
DROP TABLE Student;
DROP TABLE Instructor;

CREATE TABLE Instructor
(
	 TID INTEGER
	,Fname VARCHAR(20) NOT NULL
	,Lname VARCHAR(20) NOT NULL
	,City VARCHAR(20)
	,State CHAR(2)
	,Rate_hour Decimal(5,2) NOT NULL
	,CONSTRAINT Instructor_PK PRIMARY KEY (TID)
);

CREATE TABLE Student
(
	 SID INTEGER
	,First VARCHAR(20) NOT NULL
	,Last VARCHAR(20) NOT NULL
	,Exp_Level CHAR(1) NOT NULL
	,City VARCHAR(20)
	,State Char(2)
	,CONSTRAINT Student_PK PRIMARY KEY (SID)
	,CONSTRAINT Check_Exp CHECK (Exp_Level in ('B', 'I', 'E'))
);

CREATE TABLE Class
(
	 Name VARCHAR(20)
	,Duration INTEGER
	,Class_Level CHAR(1)
	,TID INTEGER
	,Day VARCHAR(5) NOT NULL
	,Time VARCHAR(8) NOT NULL
	,Cost Decimal(5,2)
	,CONSTRAINT Class_PK PRIMARY KEY (Name, TID)
	,CONSTRAINT Class_FK FOREIGN KEY (TID) REFERENCES Instructor
	,CONSTRAINT Check_Day CHECK (Day != 'Fri' AND Day != 'Sun')
	,CONSTRAINT Check_Level CHECK (Class_Level in ('B', 'I', 'E', 'A'))
);

CREATE TABLE Enroll
(
	 Class_Name VARCHAR(20)
	,TID INTEGER
	,SID INTEGER
	,Payment Decimal(5,2)
	,CONSTRAINT Enroll_PK PRIMARY KEY (Class_Name, TID, SID)
	,CONSTRAINT Enroll_Class_FK FOREIGN KEY (Class_Name, TID) REFERENCES Class(Name, TID)
	,CONSTRAINT Enroll_Instructor_FK FOREIGN KEY (TID) REFERENCES Instructor
	,CONSTRAINT Enroll_Student_FK FOREIGN KEY (SID) REFERENCES Student
	,CONSTRAINT Check_Payment CHECK (Payment >= 10 AND Payment <= 100)
);

CREATE TABLE highAttend
(
	 Log_ID INTEGER
	,Name VARCHAR(20)
	,TID INTEGER
	,Log_Date DATE
	,CONSTRAINT highAttend_PK PRIMARY KEY (Log_ID, Name)
);

CREATE TABLE Log_Refund_Yoga
(
	 Refund_ID INTEGER
	,SID INTEGER
	,Payment Decimal(5,2)
	,CONSTRAINT Refund_PK PRIMARY KEY (Refund_ID, SID)
	,CONSTRAINT Refund_Student_FK FOREIGN KEY (SID) REFERENCES Student
);

COMMIT;

DROP SEQUENCE Attend_seq;

CREATE SEQUENCE Attend_seq
	MINVALUE 0
	START WITH 0
	INCREMENT BY 1;
	
COMMIT;

DROP SEQUENCE Refund_seq;

CREATE SEQUENCE Refund_seq
	MINVALUE 0
	START WITH 0
	INCREMENT BY 1;
	
COMMIT;

INSERT INTO Instructor 
VALUES (1, 'Sally', 'Greenville', 'Radford', 'VA', 40.00);

INSERT INTO Instructor 
VALUES (2, 'John', 'Wooding', 'Blacksburg', 'VA', 60.00);

INSERT INTO Instructor 
VALUES (3, 'Debbie', 'Delfield', 'Roanoke', 'VA', 45.00);

INSERT INTO Instructor 
VALUES (4, 'Elaine', 'Tobies', 'Radford', 'VA', 50.00);






INSERT INTO Student 
VALUES (101, 'Sally', 'Treville', 'E', 'Salem', 'VA');

INSERT INTO Student 
VALUES (102, 'Gerald', 'Warner', 'B', 'Roanoke', 'VA');

INSERT INTO Student 
VALUES (104, 'Katie', 'Johnson', 'B', 'Blacksburg', 'VA');

INSERT INTO Student 
VALUES (105, 'Matt', 'Kingston', 'E', 'Radford', 'VA');

INSERT INTO Student 
VALUES (106, 'Ellen', 'Maples', 'I', 'Radford', 'VA');

INSERT INTO Student 
VALUES (108, 'Tom', 'Rivers', 'E', 'Radford', 'VA');

INSERT INTO Student 
VALUES (109, 'Barbara', 'Singleton', 'E', 'Radford', 'VA');

INSERT INTO Student 
VALUES (110, 'Jonathan', 'Stiner', 'I', 'Salem', 'VA');




INSERT INTO Class (Name, Duration, Class_Level, TID, Day, Time, Cost)
VALUES ('Fun with Yoga', '60', 'B', 1, 'Mon', '6:00 PM', 15.00);

INSERT INTO Class (Name, Duration, Class_Level, TID, Day, Time, Cost)
VALUES ('Stretch Yoga', '90', 'I', 2, 'Tues', '5:30 PM', 20.00);

INSERT INTO Class (Name, Duration, Class_Level, TID, Day, Time, Cost)
VALUES ('Lunch Yoga', '50', 'A', 3, 'Wed', '12:30 PM', 15.00);

INSERT INTO Class (Name, Duration, Class_Level, TID, Day, Time, Cost)
VALUES ('Yoga for All', '90', 'A', 4, 'Thurs', '7:00 PM', 25.00);

INSERT INTO Class (Name, Duration, Class_Level, TID, Day, Time, Cost)
VALUES ('Yoga Inversions', '60', 'I', 1, 'Sat', '10:00 PM', 20.00);

INSERT INTO Class (Name, Duration, Class_Level, TID, Day, Time, Cost)
VALUES ('Advanced Yoga', '90', 'E', 4, 'Sat', '2:00 PM', 25.00);

INSERT INTO Class (Name, Duration, Class_Level, TID, Day, Time, Cost)
VALUES ('Relaxation Yoga', '90', 'I', 4, 'Mon', '7:30 PM', 40.00);





INSERT INTO Enroll 
VALUES ('Fun with Yoga', 1, 102, 15.00);

INSERT INTO Enroll 
VALUES ('Fun with Yoga', 1, 104, 15.00);

INSERT INTO Enroll 
VALUES ('Fun with Yoga', 1, 108, 15.00);

INSERT INTO Enroll 
VALUES ('Stretch Yoga', 2, 106, 20.00);

INSERT INTO Enroll 
VALUES ('Stretch Yoga', 2, 108, 20.00);

INSERT INTO Enroll 
VALUES ('Lunch Yoga', 3, 102, 15.00);

INSERT INTO Enroll 
VALUES ('Lunch Yoga', 3, 109, 15.00);

INSERT INTO Enroll 
VALUES ('Yoga for All', 4, 106, 10.00);

INSERT INTO Enroll 
VALUES ('Yoga for All', 4, 108, 25.00);

INSERT INTO Enroll 
VALUES ('Yoga Inversions', 1, 106, 25.00);

INSERT INTO Enroll 
VALUES ('Yoga Inversions', 1, 105, 25.00);

INSERT INTO Enroll 
VALUES ('Advanced Yoga', 4, 106, 25.00);

INSERT INTO Enroll 
VALUES ('Advanced Yoga', 4, 108, 25.00);

INSERT INTO Enroll 
VALUES ('Stretch Yoga', 2, 110, 20.00);

INSERT INTO Enroll 
VALUES ('Relaxation Yoga', 4, 101, 10.00);

INSERT INTO Enroll 
VALUES ('Relaxation Yoga', 4, 106, 10.00);

INSERT INTO Enroll 
VALUES ('Relaxation Yoga', 4, 108, 10.00);



INSERT INTO Class (Name, Duration, Class_Level, TID, Day, Time, Cost)
VALUES ('Swag Yoga', '90', 'I', 4, 'Fri', '7:30 PM', 40.00);

INSERT INTO Class (Name, Duration, Class_Level, TID, Day, Time, Cost)
VALUES ('Not Yoga', '90', 'I', 4, 'Sun', '7:30 PM', 40.00);


INSERT INTO Student 
VALUES (110, 'Jonathan', 'Stiner', 'S', 'Salem', 'VA');

INSERT INTO Class (Name, Duration, Class_Level, TID, Day, Time, Cost)
VALUES ('Almost Yoga', '90', 'S', 4, 'Sat', '2:00 PM', 25.00);

INSERT INTO Enroll 
VALUES ('Advanced Yoga', 4, 104, 25.00);


INSERT INTO Student (SID, City, State)
VALUES (111, 'Salem', 'VA');


INSERT INTO Enroll 
VALUES ('Advanced Yoga', 4, 109, 5.00);


INSERT INTO Instructor (TID, City, State)
VALUES (5, 'Radford', 'VA');

INSERT INTO Class (Duration, Class_Level, TID, Cost)
VALUES ('90', 'S', 4, 25.00);

