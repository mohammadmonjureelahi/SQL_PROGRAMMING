use dbprojectbank;
GO
-- Q1: Create a view to get all customers with checking account from ON province. [Moderate] 

IF EXISTS (SELECT * FROM sys.all_views WHERE NAME='VW_ON_ChekingAccount')
DROP VIEW VW_ON_ChekingAccount;
GO
create view VW_ON_ChekingAccount
	as
	select C.CustomerID,C.CustomerFirstName+' '+C.CustomerLastName [Customer Name],C.State, AT.AccountTypeDescription
	from Customer C 
	  join CustomerAccount CA 
	   on C.CustomerID=CA.CustomerID
	   join Account A
	   on CA.AccountID=A.AccountID
	   join AccountType AT
	   on A.AccountTypeID=AT.AccountTypeID
	where AT.AccountTypeDescription='Checking Account' and C.State='ON';
GO

select * from VW_ON_ChekingAccount;

GO
--Q2: Create a view to get all customers with total account balance (including interest rate) greater than 5000. [Advanced]
--Here we just focus on the Savings account Balance.
GO

IF EXISTS (SELECT * FROM sys.all_views WHERE NAME='VW_Customer_Balance_TTLQ')
DROP VIEW VW_Customer_Balance_TTLQ;
GO
CREATE VIEW VW_Customer_Balance_TTLQ AS

SELECT C.CustomerFirstName+' '+C.CustomerLastName AS [Customer Name], A.AccountID, A.CurrentBalance AS Account_Balance, 
	   S.SavingsInterestRateValue,
	   cast((A.CurrentBalance + A.CurrentBalance*(S.SavingsInterestRateValue/12)*Datediff(MM,TL.TransactionDate, GETDATE())) as decimal(10,2)) 
			AS Total_Account_Balance

	FROM
      SavingsInterestRates S
	  join Account A
	  on A.InterestSavingsRateID = S.SavingsInterestRateID
	  join TransactionLog TL
	  on TL.AccountID = A.AccountID
	  join Customer C
	  on C.CustomerID = TL.CustomerID
	  where (A.CurrentBalance + A.CurrentBalance*(S.SavingsInterestRateValue/12)*Datediff(MM,TL.TransactionDate, GETDATE())) > 5000
;
GO

select  * from VW_Customer_Balance_TTLQ;
GO


--Q3: Create a view to get counts of checking and savings accounts by customer. [Moderate]

IF EXISTS (SELECT * FROM sys.all_views WHERE NAME='VW_Counts_Account')
DROP VIEW VW_Counts_Account;
GO

create view VW_Counts_Account
	as
	select C.CustomerFirstName+' '+C.CustomerLastName [Customer Name], AT.AccountTypeDescription, count(*) [Number of Account]
	from Customer C 
	  join CustomerAccount CA 
	   on C.CustomerID=CA.CustomerID
	   join Account A
	   on CA.AccountID=A.AccountID
	   join AccountType AT
	   on A.AccountTypeID=AT.AccountTypeID
	group by C.CustomerFirstName+' '+C.CustomerLastName, AT.AccountTypeDescription;

GO
select * from VW_Counts_Account
		order by [Customer Name];

GO


--Q4: Create a view to get any particular user’s login and password using AccountId. [Moderate]

IF EXISTS (SELECT * FROM sys.all_views WHERE NAME='VW_Users_Login_password')
DROP VIEW VW_Users_Login_password;
GO
create view VW_Users_Login_password
	as
	select C.CustomerFirstName+' '+C.CustomerLastName [Customer Name], UL.UserName UserLoginName, UL.UserPassword UserLoginPassword
	from Customer C 
	  join CustomerAccount CA 
	   on C.CustomerID=CA.CustomerID
	   join LoginAccount LA
	   on CA.AccountID=LA.AccountID
	   join UserLogins UL
	   on LA.UserLoginID=UL.UserLoginID
	where CA.AccountID = 100025;

GO
select * from VW_Users_Login_password;
		
GO


--Q5: Create a view to get all customers’ overdraft amount. [Moderate]

IF EXISTS (SELECT * FROM sys.all_views WHERE NAME='VW_All_Customers_Overdraft_Amount')
DROP VIEW VW_All_Customers_Overdraft_Amount;
GO
create view VW_All_Customers_Overdraft_Amount
	as
	select C.CustomerFirstName+' '+C.CustomerLastName [Customer Name], ODL.OverDraftAmount, ODL.OverDraftDate, 
		   ODL.OverDraftTransactionXml
	from Customer C 
	  join CustomerAccount CA 
	   on C.CustomerID=CA.CustomerID
	   join OverDraftLog ODL
	   on CA.AccountID=ODL.AccountID;
	   

GO
select * from VW_All_Customers_Overdraft_Amount;

GO

--Q6: Create a stored procedure to add “User_” as a prefix to everyone’s login (username). [Moderate]
--Before the Store Procedure is created the table

select * from UserLogins;

--Now let us create the Store Procedure
GO
IF EXISTS (SELECT * FROM sys.procedures WHERE NAME='SP_ModifyUserLogin')
DROP PROC SP_ModifyUserLogin
GO
CREATE PROCEDURE SP_ModifyUserLogin
AS
UPDATE UserLogins
SET UserName = Concat('User_', UserName);

GO

EXEC SP_ModifyUserLogin;
GO

--After the Store Procedure is created the table

select * from UserLogins;

GO






--Q7: Create a stored procedure that accepts AccountId as a parameter and returns customer’s full  name. [Advanced]

GO
IF EXISTS (SELECT * FROM sys.procedures WHERE NAME='SP_FullNameFromAccountId')
DROP PROC SP_FullNameFromAccountId
GO
create proc SP_FullNameFromAccountId       
            @AccountID int,			                   
			@Fullname nvarchar(100) output 
as
begin
  if (@AccountID in (select AccountID from CustomerAccount))
    begin
	  			Select @FullName= C.CustomerFirstName+' '+C.CustomerMiddleInitial+' '+C.CustomerLastName
				from Customer C
				join CustomerAccount CA
				on CA.CustomerID=C.CustomerID
				where CA.AccountID=@AccountID;
               set @Fullname=replace (@FullName,'  ',' ')
   end
  else
   begin
    print 'There is no Customer with  Account Id= '+CONVERT(varchar(12), @AccountID )
   end
end
GO





--Executing for invalid account id
Declare @FullName nvarchar(100)
exec SP_FullNameFromAccountId 100029, @FullName out
Print ' Full name is '+@FullName


GO

--Q8: Create a stored procedure that returns error logs inserted in the last 24 hours. [Advanced]

IF EXISTS (SELECT * FROM sys.procedures WHERE NAME='SP_ERRORS_24H')
DROP PROCEDURE SP_ERRORS_24H;
GO

CREATE PROCEDURE SP_ERRORS_24H
AS
SELECT * FROM LoginErrorLog
WHERE  ErrorTime BETWEEN DATEADD(hh, -24, GETDATE()) AND GETDATE();
GO

EXEC SP_ERRORS_24H;
GO

--Let us create another Store Procedure so that we can capture our data which are 4 months old

IF EXISTS (SELECT * FROM sys.procedures WHERE NAME='SP_ERRORS_4M')
DROP PROCEDURE SP_ERRORS_4M;
GO

CREATE PROCEDURE SP_ERRORS_4M
AS
SELECT * FROM LoginErrorLog
WHERE  ErrorTime BETWEEN DATEADD(mm, -4, GETDATE()) AND GETDATE();
GO

EXEC SP_ERRORS_4M;
GO


--Q9: Create a stored procedure that takes a deposit as a parameter and updates CurrentBalance value for that particular account. [Advanced]
--Just let us have alook at the Current balance before the Store Procedure
GO
select * from Account
	where AccountID = 100023;
GO
--Now, let us create the Store Procedure and check the change
IF EXISTS (SELECT * FROM sys.procedures WHERE NAME='SP_Update_cBalance_After_Deposit')
DROP PROCEDURE SP_Update_cBalance_After_Deposit;
GO
CREATE PROCEDURE SP_Update_cBalance_After_Deposit @AccountID INT, @Deposit INT
AS
begin
	if (@AccountID in (select AccountID from Account))
	begin
	  	UPDATE Account
		SET CurrentBalance = CurrentBalance + @Deposit
		where AccountID = @AccountID;
	end
	else
	begin
	print 'There is no Customer with  Account Id= '+CONVERT(varchar(12), @AccountID )
	end
end
GO
EXEC SP_Update_cBalance_After_Deposit 100023, 3000;
GO
select * from Account
	where AccountID = 100023;
GO


--Q10: Create a stored procedure that takes a withdrawal amount as a parameter and updates 

--Just let us have alook at the Current balance before the Store Procedure

GO
select * from Account
	where AccountID = 100015;
GO

--Now let us create the store procedure

IF EXISTS (SELECT * FROM sys.procedures WHERE NAME='SP_Update_cBalance_After_Withdrawal')
DROP PROCEDURE SP_Update_cBalance_After_Withdrawal;
GO

CREATE PROCEDURE SP_Update_cBalance_After_withdrawal @AccountID INT, @Withdraw INT
AS
begin
	if (@AccountID in (select AccountID from Account))
	begin
      if (@Withdraw <= (select CurrentBalance from Account where AccountID =@AccountID ))
		  begin
	  		  UPDATE Account
			  SET CurrentBalance = CurrentBalance - @Withdraw
	 		  where AccountID = @AccountID;
		  end
	  else
		  begin
		      print 'Current Balance is less than the withdrawal amount '+CONVERT(varchar(12),@Withdraw )
		  end
	end
	else
	begin
	  print 'There is no Customer with  Account Id= '+CONVERT(varchar(12), @AccountID )
	end
end
GO

EXEC SP_Update_cBalance_After_Withdrawal 100015, 300;
GO

--Just let us have alook at the Current balance after the Store Procedure execution

GO
select * from Account
	where AccountID = 100015;
GO

