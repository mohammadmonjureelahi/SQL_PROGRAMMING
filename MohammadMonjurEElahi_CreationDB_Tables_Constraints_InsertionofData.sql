create database dbprojectbank;
use dbprojectbank;
--Tables in the project are:
--01. UserLogins
--02. UserSecurityQuestions
--03. SavingsInterestRates
--04. TransactionType
--05. AccountType
--06. AccountStatusType
--07. LoginErrorLog
--08. FailedTransactionErrorType
--09. Employee
--10. Customer
--11. Account
--12. OverDraftLog
--13. LoginAccount
--14. UserSecurityAnswers
--15. CustomerAccount
--16. TransactionLog
--17. FailedTransactionLog




-- Table count 1

create table UserLogins
	(
		UserLoginID smallint primary key not null ,
		UserName char(15) not null,
		UserPassword varchar(20) not null
	);


--Table count 2

create table UserSecurityQuestions

	(
		UserSecurityQuestionID tinyint primary key not null,
		UserSecurityQuestion1 varchar(50) not null,
		UserSecurityQuestion2 varchar(50) not null,
		UserSecurityQuestion3 varchar(50) not null
	);

--Table count 3

create table SavingsInterestRates
	(
		SavingsInterestRateID tinyint primary key not null,
		SavingsInterestRateValue numeric(9,9) not null,
		SavingsInterestRateDescription varchar(20) not null 
	);

--Table count 4

create table TransactionType
	(
		TransactionTypeID tinyint primary key not null,
		TransactionTypeName char(10) not null,
		TransactionTypeDescription varchar(50),
		TransactionFeeAmount smallmoney		
	);

--Table count 5

create table AccountType
	(
		AccountTypeID tinyint primary key not null,
		AccountTypeDescription varchar(30) not null
	
	);




--Table count 6

create table AccountStatusType
	(
		AccountStatusTypeID tinyint primary key not null,
		AccountStatusDescription varchar(30) not null,
	
	);



--Table count 7

create table LoginErrorLog
	(
		ErrorLogID int primary key not null,
		ErrorTime datetime not null,
		FailedTransactionXML xml not null,
	
	);

--Table count 8

create table FailedTransactionErrorType
	(
		FailedTransactionErrorTypeID tinyint primary key not null,
		FailedTransactionDescription varchar(50)
	
	);

--Table count 9

create table Employee
	(
		EmployeeID int primary key not null,
		EmployeeFirstName varchar(25) not null,
		EmployeeMiddleInitial char(1),
		EmployeeLastName varchar(25) not null,
		EmployeeIsManager bit not null
	
	);

--Table count 10


create table Customer
	(
		CustomerID int primary key not null,
		CustomerAddress1 varchar(30) not null,
		CustomerAddress2 varchar(30),
		CustomerFirstName varchar(30) not null,
		CustomerMiddleInitial char(1),
		CustomerLastName varchar(30) not null,
		City varchar(30) not null,
		State char(2) not null,
		Zipcode char(10) not null,
		Email varchar(40) not null,
		HomePhone char(10), 
		CellPhone char(10) not null, 
		WorkPhone char(10), 
		SSN	char(9) not null,
		UserLoginID smallint, 
		Constraint FK2 foreign key(UserLoginID) references UserLogins(UserLoginID)
	);

--Table count 11


create table Account
	(
		AccountID int primary key not null,
		CurrentBalance int not null,
		AccountTypeID tinyint not null,
		AccountStatusTypeID tinyint not null,
		InterestSavingsRateID tinyint,
		Constraint FK4 foreign key(AccountTypeID) references AccountType(AccountTypeID),
		Constraint FK5 foreign key(AccountStatusTypeID) references AccountStatusType(AccountStatusTypeID),
		Constraint FK6 foreign key(InterestSavingsRateID) references SavingsInterestRates(SavingsInterestRateID)


	);

--ALTER TABLE Account ALTER COLUMN InterestSavingsRateID tinyint NULL;

--Table count 12

create table OverDraftLog
	(
		AccountID int primary key not null,
		OverDraftDate datetime not null,
		OverDraftAmount money not null,
		OverDraftTransactionXml xml not null,
		Constraint FK1 foreign key(AccountID) references Account(AccountID)
	);

--Table count 13

create table LoginAccount
	(
		UserLoginID smallint not null,
		AccountID int not null,
		Constraint FK11 foreign key(AccountID) references Account(AccountID)
	);

--Table count 14

create table UserSecurityAnswers
	(
		UserLoginID smallint primary key not null,
		UserSecurityAnswer1 varchar(25) not null,
		UserSecurityAnswer2 varchar(25) not null,
		UserSecurityAnswer3 varchar(25) not null,
		UserSecurityQuestionID tinyint not null,
		Constraint FK12 foreign key(UserLoginID) references UserLogins(UserLoginID),
		Constraint FK13 foreign key(UserSecurityQuestionID) references UserSecurityQuestions(UserSecurityQuestionID)
	);

--Table count 15

create table CustomerAccount
	(
		AccountID int not null,
		CustomerID int not null,
		Constraint FK14 foreign key(AccountID) references Account(AccountID),
		Constraint FK15 foreign key(CustomerID) references Customer(CustomerID)
	);

--Table count 16

create table TransactionLog
	(
		TransactionID int IDENTITY(56770001, 1) primary key not null,
		TransactionDate datetime not null,
		TransactionTypeID tinyint not null,
		TransactionAmount money not null,
		NewBalance money not null,
		AccountID int not null,
		CustomerID int not null,
		EmployeeID int not null,
		UserLoginID smallint not null,
		Constraint FK7 foreign key(TransactionTypeID) references TransactionType(TransactionTypeID),
		Constraint FK16 foreign key(AccountID) references Account(AccountID),
		Constraint FK3 foreign key(CustomerID) references Customer(CustomerID),
		Constraint FK17 foreign key(EmployeeID) references Employee(EmployeeID),
		Constraint FK18 foreign key(UserLoginID) references UserLogins(UserLoginID)
	);

--Table count 17


create table FailedTransactionLog
	(
		FailedTransactionID int primary key not null,
		FailedTransactionErrorTypeID tinyint not null,
		FailedTransactionErrorTime datetime not null,
		FailedTransactionXML xml not null,
		Constraint FK19 foreign key(FailedTransactionErrorTypeID) references FailedTransactionErrorType(FailedTransactionErrorTypeID)
	);


--Bulk date insertion 1

BULK INSERT UserLogins
	FROM 'C:\Users\ruzdomain\Desktop\SQL\PROJECT\UserLogins.csv'
	WITH (
		FORMAT = 'CSV',
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '\n'	
	)

select * from UserLogins;

--Bulk date insertion 2

BULK INSERT UserSecurityQuestions
	FROM 'C:\Users\ruzdomain\Desktop\SQL\PROJECT\UserSecurityQuestions.csv'
	WITH (
		FORMAT = 'CSV',
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '\n'	
	)

select * from UserSecurityQuestions;

--Bulk date insertion 3

BULK INSERT SavingsInterestRates
	FROM 'C:\Users\ruzdomain\Desktop\SQL\PROJECT\SavingsInterestRates.csv'
	WITH (
		FORMAT = 'CSV',
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '\n'	
	)

select * from SavingsInterestRates;

--Bulk date insertion 4

BULK INSERT TransactionType
	FROM 'C:\Users\ruzdomain\Desktop\SQL\PROJECT\TransactionType.csv'
	WITH (
		FORMAT = 'CSV',
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '\n'	
	)

select * from TransactionType;

--Bulk date insertion 5

BULK INSERT AccountType
	FROM 'C:\Users\ruzdomain\Desktop\SQL\PROJECT\AccountType.csv'
	WITH (
		FORMAT = 'CSV',
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '\n'	
	)
	
select * from AccountType;

--Bulk date insertion 6

BULK INSERT AccountStatusType
	FROM 'C:\Users\ruzdomain\Desktop\SQL\PROJECT\AccountStatusType.csv'
	WITH (
		FORMAT = 'CSV',
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '\n'	
	)

select * from AccountStatusType;

--Bulk date insertion 7

BULK INSERT FailedTransactionErrorType
	FROM 'C:\Users\ruzdomain\Desktop\SQL\PROJECT\FailedTransactionErrorType.csv'
	WITH (
		FORMAT = 'CSV',
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '\n'	
	)


select * from FailedTransactionErrorType;

--Bulk date insertion 8

BULK INSERT Employee
	FROM 'C:\Users\ruzdomain\Desktop\SQL\PROJECT\Employee.csv'
	WITH (
		FORMAT = 'CSV',
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '\n'	
	)


select * from Employee;

--Bulk date insertion 9

BULK INSERT Customer
	FROM 'C:\Users\ruzdomain\Desktop\SQL\PROJECT\Customer.csv'
	WITH (
		FORMAT = 'CSV',
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '\n'	
	)

select * from Customer;


--Bulk date insertion 10



BULK INSERT Account
	FROM 'C:\Users\ruzdomain\Desktop\SQL\PROJECT\Account.csv'
	WITH (
		FORMAT = 'CSV',
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '\n'	
	)

select * from Account;


--Bulk date insertion 11

BULK INSERT LoginAccount
	FROM 'C:\Users\ruzdomain\Desktop\SQL\PROJECT\LoginAccount.csv'
	WITH (
		FORMAT = 'CSV',
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '\n'	
	)



select * from LoginAccount;

--Bulk date insertion 12

BULK INSERT UserSecurityAnswers
	FROM 'C:\Users\ruzdomain\Desktop\SQL\PROJECT\UserSecurityAnswers.csv'
	WITH (
		FORMAT = 'CSV',
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '\n'	
	)



select * from UserSecurityAnswers;

--Bulk date insertion 13

BULK INSERT CustomerAccount
	FROM 'C:\Users\ruzdomain\Desktop\SQL\PROJECT\CustomerAccount.csv'
	WITH (
		FORMAT = 'CSV',
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '\n'	
	)



select * from CustomerAccount;

--Bulk date insertion 14

BULK INSERT TransactionLog
	FROM 'C:\Users\ruzdomain\Desktop\SQL\PROJECT\TransactionLog.csv'
	WITH (
		FORMAT = 'CSV',
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '\n'	
	)


select * from TransactionLog;




Insert into LoginErrorLog Values 
							('68666001','2021-05-08 10:10:10','<?xml version="1.0" encoding="utf-8"?>
									<Error>
										<UserLoginID>711</UserLoginID>
										<Code>68666001</Code>
										<Description>Insufficient Funds </Description>
										<Message> You do not have sufficient funds in your account. </Message>
									</Error>'),
							('68666002','2021-05-11 11:10:10','<?xml version="1.0" encoding="utf-8"?>
									<Error>
										<UserLoginID>733</UserLoginID>
										<Code>68666002</Code>
										<Description>Account Frozen.</Description>
										<Message> Account Freezed Due to suspicious transaction. </Message>
									</Error>'),

							('68666003','2021-05-19 13:10:10','<?xml version="1.0" encoding="utf-8"?>
									<Error>
										<UserLoginID>719</UserLoginID>
										<Code>68666003</Code>
										<Description>Account Inactive.</Description>
										<Message>Account Inactive due to lack of any transaction for log time. </Message>
									</Error>'),
							('68666004','2021-06-03 14:10:10','<?xml version="1.0" encoding="utf-8"?>
									<Error>
										<UserLoginID>725</UserLoginID>
										<Code>68666004</Code>
										<Description>Account Reactivation In Progress.</Description>
										<Message>Transaction cannot be done unless the account is fully reactivated. </Message>
									</Error>'),
							('68666005','2021-06-04 15:10:10','<?xml version="1.0" encoding="utf-8"?>
									<Error>
										<UserLoginID>749</UserLoginID>
										<Code>68666005</Code>
										<Description>Account Temporary Halted.</Description>
										<Message>Account halted being instructed by the customer. </Message>
									</Error>');

select * from LoginErrorLog;




Insert into OverDraftLog Values 
							(110072,'2021-06-11 10:10:10', 300, '<?xml version="1.0" encoding="utf-8"?>
									<Overdraft>
										<CustomerID>2340047</CustomerID>
										<Amount>300</Amount>
										<Description>Overdraft Took Place</Description>
										<Message> Overdraft has a fee associated with it. Please be notified. </Message>
									</Overdraft>'),
							(110073,'2021-06-11 11:10:10',200,'<?xml version="1.0" encoding="utf-8"?>
									<Overdraft>
										<CustomerID>2340048</CustomerID>
										<Amount>200</Amount>
										<Description>Overdraft Took Place</Description>
										<Message> Overdraft has a fee associated with it. Please be notified. </Message>
									</Overdraft>'),

							(110074,'2021-06-11 13:10:10',700,'<?xml version="1.0" encoding="utf-8"?>
									<Overdraft>
										<CustomerID>2340049</CustomerID>
										<Amount>700</Amount>
										<Description>Overdraft Took Place</Description>
										<Message>Overdraft has a fee associated with it. Please be notified. </Message>
									</Overdraft>'),
							(110075,'2021-06-11 14:10:10',1500,'<?xml version="1.0" encoding="utf-8"?>
									<Overdraft>
										<CustomerID>2340050</CustomerID>
										<Amount>1500</Amount>
										<Description>Overdraft Took Place</Description>
										<Message>Overdraft has a fee associated with it. Please be notified. </Message>
									</Overdraft>');

select * from OverDraftLog;




Insert into FailedTransactionLog Values 
							(57770076,101, '2021-06-03 10:10:10', '<?xml version="1.0" encoding="utf-8"?>
									<FailedTransaction>
										<CustomerID>2340011</CustomerID>
										<Description>Insufficient Balance</Description>
										<Message>Insufficient Balance Causes the transaction to fail.</Message>
									</FailedTransaction>'),
							(57770077,102,'2021-06-07 11:10:10','<?xml version="1.0" encoding="utf-8"?>
									<FailedTransaction>
										<CustomerID>2340017</CustomerID>
										<Description>Limit Exceeded</Description>
										<Message>Transaction fails as the amount exceeds the limit set by customer instruction.</Message>
									</FailedTransaction>'),

							(57770078,102,'2021-06-09 13:10:10','<?xml version="1.0" encoding="utf-8"?>
									<FailedTransaction>
										<CustomerID>2340029</CustomerID>
										<Description>Limit Exceeded</Description>
										<Message>Transaction fails as the amount exceeds the limit set by customer instruction.</Message>
									</FailedTransaction>'),
							(57770079,101, '2021-06-13 14:10:10','<?xml version="1.0" encoding="utf-8"?>
									<FailedTransaction>
										<CustomerID>2340039</CustomerID>
										<Description>Insufficient Balance</Description>
										<Message>Insufficient Balance Causes the transaction to fail.</Message>
									</FailedTransaction>');
