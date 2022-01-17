use Retail_Data
go

select * from Customer
select * from Transactions
select * from prod_cat_info
/* DATA PREPARATION AND UNDERSTANDING */

--1. What is the total number of rows in each of the 3 tables in the database.

select COUNT(*) as 'Total Numner of Rows' from Customer
union all
select COUNT(*) from Transactions
union all
select COUNT(*) from prod_cat_info


--2. What is the total number of Transaction that have a return

select count(*) 'Returned Transactions' from Transactions
where total_amt < 0


--3. As you would noticed, the dates provided across the datasets are not in correct format. As first steps,
--		Please convert the date variable into valid date formats before proceeding ahead.

alter table Customer
	alter column DOB date

alter table Transactions
	alter column Tran_date date


--4. What is the time range of the transaction data available for analysis? Show the output in number of days
--		months, and years simultaneously in different columns.

select 

DATEDIFF(DAY,MIN(tran_date), MAX(tran_date)) 'No. of Days', 
DATEDIFF(MONTH,MIN(tran_date), MAX(tran_date)) 'No. of Months', 
DATEDIFF(YEAR,MIN(tran_date), MAX(tran_date)) 'No. of Years' 
from Transactions


--5. Which product category does the sub-category "DIY" belong to?

select prod_cat, prod_subcat from prod_cat_info
where prod_subcat = 'DIY'


/* DATA ANALYSIS */


--1. Which channel is most frequently used for Transactions?

select top 1 store_type, COUNT(Store_type) [Top Channel] from Transactions
group by Store_type
order by [Top Channel] desc


--2. What is the count of Male and Female customers in the Database?

select Gender, COUNT(gender) [Count_Of_Gender] from Customer
group by Gender
having Gender != ''


--3. From which city do we have maximum number of customers and how many?

select top 1 city_code, COUNT(city_code) [Maximum_No_Customers] from Customer
group by city_code
order by Maximum_No_Customers desc


--4. How many sub-categories are there under the books category?

select prod_cat, COUNT(prod_subcat) [Count_Of_Sub-Category] from prod_cat_info
where prod_cat = 'Books'
group by prod_cat

--5. What is the maximum quantity of products ever ordered?

select top 1 prod_cat_code, max(Qty) [Max_Quantity] from Transactions
group by prod_cat_code



--6. What is the net total revenue generated in Categories Electronics and books?


select p1.prod_cat, SUM(total_amt) [Total_Net_Revenue] 
		from Transactions t1 
	left join 
		prod_cat_info p1 on t1.prod_cat_code = p1.prod_cat_code and t1.prod_subcat_code = p1.prod_sub_cat_code

where p1.prod_cat = 'Electronics' or p1.prod_cat = 'Books'
group by p1.prod_cat 


--7. How many customers have >10 transactions with us, excluding returns?

SELECT COUNT(*) [Count_of_Customers]
FROM
(
    SELECT cust_id 
    FROM Transactions
	where total_amt > 0
    group by cust_id
    having count (total_amt) > 10
) AS T


--8. What is the combined revenue earned from the "Electronics" & "Clothing" categories,from "FlagShip Store"?


select t1.Store_type, SUM(t1.total_amt) [Total_Revenue]
		from Transactions t1 
	left join 
		prod_cat_info p1 on t1.prod_cat_code = p1.prod_cat_code and t1.prod_subcat_code = p1.prod_sub_cat_code

where t1.Store_type = 'Flagship store' and p1.prod_cat in ('Electronics', 'Clothing')
group by t1.Store_type


--9. What is the total revenue generated from "Male" customers in "Electronics" Category? Output should display total revenue by prod_sub_cat


select p1.prod_subcat,SUM(total_amt) [Total_Revenue] from Customer c1
		inner join

		Transactions t1 on c1.customer_Id = t1.cust_id
		inner join

		prod_cat_info p1 on t1.prod_cat_code = p1.prod_cat_code and t1.prod_subcat_code = p1.prod_sub_cat_code

where c1.Gender = 'M' and p1.prod_cat = 'Electronics'
	group by p1.prod_subcat


--10. What is percentage of sales and returns by product sub category; display only top 5 sub categories in terms of sales?

select top 5 
			p1.prod_subcat [Subcategory], 
			SUM((case when t1.Qty > 0 then t1.total_amt else 0 end)) [Sales],

			SUM((case when t1.Qty < 0 then t1.total_amt else 0 end)) [Returns],

			SUM((case when t1.Qty > 0 then t1.Qty else 0 end)) - 
				SUM((case when t1.Qty < 0 then t1.Qty else 0 end)) [Total_Qty],

			SUM((case when t1.Qty < 0 then t1.total_amt else 0 end)) /
				(SUM((case when t1.Qty > 0 then t1.total_amt else 0 end)) - 
				SUM((case when t1.Qty < 0 then t1.total_amt else 0 end)))*100 [%_Returns],

			SUM((case when t1.Qty > 0 then t1.total_amt else 0 end)) /
				(SUM((case when t1.Qty > 0 then t1.total_amt else 0 end)) - 
				SUM((case when t1.Qty < 0 then t1.total_amt else 0 end)))*100 [%_Sales]

		from Transactions t1 
		
	inner join prod_cat_info p1 on t1.prod_subcat_code = p1.prod_sub_cat_code

group by p1.prod_subcat
order by [%_Sales] desc

--11.For all Customers aged between 25 to 35 years find what is the net total revenue generated by these consumers in th last 30 days
--		of transactions from max transaction date available in the data?


select c1.customer_Id,DATEDIFF(YEAR, c1.DOB,CURRENT_TIMESTAMP) [Age], SUM(t1.total_amt) [Net_Revenue] 
	from Transactions t1 inner join Customer c1 on t1.cust_id = c1.customer_Id

where DATEDIFF(YEAR, c1.DOB,CURRENT_TIMESTAMP) between 25 and 35
group by c1.customer_Id,c1.DOB, t1.tran_date
having t1.tran_date >= DATEADD(DAY,-30,MAX(t1.tran_date))


--12. Which product category has seen the max value of returns in the last 3 months of transactions?

select top 1 p1.prod_cat, SUM((case when t1.total_amt < 0 then t1.total_amt else 0 end)) [Total_Returns]
		
		from Transactions t1 
	inner join 
		prod_cat_info p1 on t1.prod_cat_code = p1.prod_cat_code 
					and t1.prod_subcat_code = p1.prod_sub_cat_code
where total_amt < 0 
group by p1.prod_cat, t1.tran_date
having t1.tran_date >= DATEADD(day,-90,max(t1.tran_date))

--13. Which store-type sells the maximum products; by value of sales amount and by quantity sold?

select top 1 t1.Store_type, SUM(t1.Qty) [Total_Quantity], SUM(t1.total_amt) [Total_Sales] from 
			Transactions t1 
	inner join 
			prod_cat_info p1 on t1.prod_cat_code = p1.prod_cat_code 
		and 
			t1.prod_subcat_code = p1.prod_sub_cat_code
	group by t1.Store_type
	order by Total_Quantity desc, Total_Sales desc

--14. What are the categories for which average revenue is above the overall average

select p1.prod_cat, AVG(t1.total_amt) 'Average' from
			Transactions t1 
	inner join 
			prod_cat_info p1 on t1.prod_cat_code = p1.prod_cat_code 
		and 
			t1.prod_subcat_code = p1.prod_sub_cat_code
	group by p1.prod_cat
	having AVG(t1.total_amt) > (select AVG(total_amt) from Transactions)

--15. Find the average and total revenue by each subcategory for the categories which are 
--		among top 5 categories in terms of quantity sold.

 select 
	p1.prod_cat, p1.prod_subcat, AVG(cast(total_amt as float)) as Average_Revenue, SUM(cast(total_amt as float)) as Total_Revenue
 from 
	Transactions as T1
 INNER JOIN 
	prod_Cat_info as P1
		ON T1.prod_cat_code = P1.prod_cat_code 
	AND 
		T1.prod_subcat_code = P1.prod_sub_cat_code
 
	WHERE P1.prod_cat_code IN (select top 5 P1.prod_cat_code 
									from 
										prod_cat_info as P1 inner join Transactions as T1
										ON P1.prod_cat_code = T1.prod_cat_code 
									AND 
										P1.prod_sub_cat_code = T1.prod_subcat_code
									group by P1.prod_cat_code
								)
	group by P1.prod_cat, P1.prod_subcat