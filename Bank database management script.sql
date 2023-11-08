Use bank_dbms;

#1. query to display account number, customer’s number, customer’s firstname,lastname,account opening date.
#Display the records sorted in ascending order based on account number.

SELECT account_number,am.customer_number,firstname,lastname,account_opening_date
FROM customer_master cm JOIN account_master am
ON cm.customer_number=am.customer_number
ORDER BY account_number;

#2.Write a query to display the number of customer’s from Delhi. Give the count an alias name of Cust_Count. 

SELECT count(customer_number) Cust_Count
FROM customer_master
WHERE customer_city= "Delhi";

#3. Display the records sorted in ascending order based on customer number and then by account number.

SELECT am.customer_number, firstname, account_number
FROM customer_master cm JOIN account_master am
ON cm.customer_number=am.customer_number
WHERE day(account_opening_date)>15;


#4. Write a query to display customer number, customers first name, account number where the account status is terminated. Display the records sorted in ascending order based on customer number and then by account number.
SELECT am.customer_number,firstname, account_number
FROM customer_master cm JOIN account_master am
ON cm.customer_number=am.customer_number
WHERE account_status= "Terminated"
ORDER BY am.customer_number, account_number;

#5. Write a query to display the total number of withdrawals and total number of deposits being done by customer whose customer number ends with 001. The query should display transaction type and the number of transactions. Give an alias name as Trans_Count for number of transactions.Display the records sorted in ascending order based on transaction type.

SELECT transaction_type,count(transaction_number) Trans_Count
FROM account_master am JOIN transaction_details td
ON am.account_number=td.account_number
WHERE customer_number like '%001'
GROUP BY transaction_type
ORDER BY transaction_type;


#6.Write a query to display the number of customers who have registration but no account in the bank. Give the alias name as Count_Customer for number of customers.
SELECT count(customer_number) Count_Customer
FROM customer_master
WHERE customer_number NOT IN (SELECT customer_number FROM account_master)

#7.Write a query to display account number and total amount deposited by each account holder (Including the opening balance ). Give the total amount deposited an alias name of Deposit_Amount.Display the records in sorted order based on account number.

SELECT td.account_number, opening_balance + sum(transaction_amount) Deposit_Amount
FROM account_master am INNER JOIN transaction_details td
ON am.account_number=td.account_number
WHERE transaction_type="desposit"
GROUP BY account_number
ORDER BY account_number;

#8.Write a query to display the number of accounts opened in each city .The Query should display Branch City and number of accounts as No_of_Accounts.For the branch city where we don’t have anyaccounts opened display 0. Display the records in sorted order based on branch city. select branch_master.branch_city, count(account_master.account_number) as No_of_Accounts from branch_master left join account_master on account_master.branch_id=branch_master.branch_id group by branch_master.branch_city order by branch_city;

select branch_master.branch_city, count(account_master.account_number) as No_of_Accounts from
branch_master left join account_master on account_master.branch_id=branch_master.branch_id
group by branch_master.branch_city order by branch_city;

#9. Write a query to display the firstname of the customers who have more than 1 account. Display the records in sorted order based on firstname.

select firstname
FROM customer_master cm INNER JOIN account_master am
ON cm.customer_number=am.customer_number
group by firstname
having count(account_number)>1
order by firstname;

#10. Write a query to display the customer number, customer firstname, customer lastname who has taken loan from more than 1 branch. Display the records sorted in order based on customer number.

SELECT ld.customer_number, firstname, lastname
FROM customer_master cm INNER JOIN loan_details ld
ON cm.customer_number=ld.customer_number
GROUP BY customer_number
HAVING count(branch_id)>1
ORDER BY customer_number;

#11.Write a query to display the customer’s number, customer’s firstname, customer’s city and branch city where the city of the customer and city of the branch is different.Display the records sorted in ascending order based on customer number.
select customer_master.customer_number, firstname, customer_city, branch_city
from account_master inner join customer_master on account_master.customer_number =
customer_master.customer_number
inner join branch_master on account_master.branch_id = branch_master.branch_id
where customer_city != branch_city order by customer_master.customer_number;

#12. Write a query to display the number of clients who have asked for loans but they don’t have any account in the bank though they are registered customers. Give the count an alias name of Count.

SELECT count(ld.customer_number) Count
FROM customer_master cm INNER JOIN loan_details ld
ON cm.customer_number=ld.customer_number
WHERE cm.customer_number NOT IN ( SELECT customer_number FROM account_master)

#13. Write a query to display the account number who has done the highest transaction. For example the account A00023 has done 5 transactions i.e. suppose 3 withdrawal and 2 deposits.
Whereas the account A00024 has done 3 transactions i.e. suppose 2 withdrawals and 1 deposit. So
account number of A00023 should be displayed.
In case of multiple records, display the records sorted in ascending order based on account number.

SELECT td.account_number
FROM account_master am INNER JOIN transaction_details td
ON am.account_number=td.account_number
group by td.account_number
having count(td.transaction_number)>=ALL
(SELECT count(td.transaction_number)
FROM account_master am INNER JOIN transaction_details td
ON am.account_number=td.account_number
group by td.account_number) order by am.account_number;


14. Write a query to show the branch name,branch city where we have the maximum customers.
For example the branch B00019 has 3 customers, B00020 has 7 and B00021 has 10. So branch id
B00021 is having maximum customers. If B00021 is Koramangla branch Bangalore, Koramangla branch
should be displayed along with city name Bangalore.
In case of multiple records, display the records sorted in ascending order based on branch name.

select branch_name,branch_city
FROM branch_master INNER JOIN account_master
ON branch_master.branch_id=account_master.branch_id
group by branch_name
having count(customer_number)>=ALL
(select count(customer_number)
FROM branch_master INNER JOIN account_master
ON branch_master.branch_id=account_master.branch_id
group by branch_name) order by branch_name;

#15. Write a query to display all those account number, deposit, withdrawal where withdrawal is more
than deposit amount. Hint: Deposit should include opening balance as well.
For example A00011 account opened with Opening Balance 1000 and A00011 deposited 2000 rupees
on 2012-12-01 and 3000 rupees on 2012-12-02. The same account i.e A00011 withdrawn 3000 rupees
on 2013-01-01 and 7000 rupees on 2013-01-03. So the total deposited amount is 6000 and total
withdrawal amount is 10000. So withdrawal amount is more than deposited amount for account
number A00011. Display the records sorted in ascending order based on account number.

select am.account_number,opening_balance+sum(case when transaction_type="deposit" then
transaction_amount end) as Deposit,sum(case when transaction_type="withdrawl" then
transaction_amount end) as Withdrawal from account_master am join transaction_details td
on am.account_number=td.account_number group by am.account_number having
Withdrawal>Deposit;



