USE [Data Analyst]
GO
/* Tim hieu ve tung table trong dataset */
--- Lead Basic
SELECT *
FROM leads_basic_details

--- SM Assign leads
SELECT *
FROM sales_managers_assigned_leads_d

--- Leads Interaction
SELECT *
FROM leads_interaction_details

--- Leads Demo
SELECT *
FROM leads_demo_watched_details

--- Leads Reason for no interest
SELECT *
FROM leads_reasons_for_no_interest

/* Tim hieu ve Lead Basic */
SELECT *
FROM leads_basic_details

--- Hien tai co bao nhieu Lead ?
SELECT count(distinct lead_id) as lead_assign
FROM leads_basic_details

--- Do tuoi khach hang cua Lead ?
--- Sau khi tim hieu, co 2 do tuoi max la 211 va 116, sau khi loai bo ra thi do tuoi toi da la 25
SELECT max(age)
FROM leads_basic_details
WHERE age < 116

SELECT min(age) as min_age, round(avg(age),0) as avg_age , max(age) as max_age
FROM leads_basic_details
WHERE age < 116

--- Luong Lead phan bo theo do tuoi la ?
SELECT age, count(lead_id) as lead_per_age
FROM leads_basic_details
WHERE age < 116
GROUP BY age

--- Co bao nhieu lead Male and Female ?
SELECT gender, count(lead_id) as number_of_leads
FROM leads_basic_details
GROUP BY gender

--- Luong Lead Phan Bo Theo Gender va Do Tuoi 
SELECT gender, age, count(lead_id) as lead_per_each
FROM leads_basic_details
WHERE age < 116
GROUP BY gender, age
ORDER BY gender

--- Leads bao gom bao nhieu thanh pho va gom cac thanh pho nao ?
SELECT count(distinct current_city) as city
FROM leads_basic_details

SELECT distinct current_city, count(lead_id) as leads_per_city
FROM leads_basic_details
GROUP BY current_city

--- Luong Lead Phan Bo Theo City, Gender, Age
SELECT current_city, gender, age, count(lead_id) as lead_per_each
FROM leads_basic_details
WHERE age < 116
GROUP BY current_city, gender, age

--- Current Education phan loai, co bao nhieu loai ? 
SELECT distinct current_education
FROM leads_basic_details

--- Leads per Current Education
SELECT current_education, count(lead_id) as lead_per_education
FROM leads_basic_details
GROUP BY current_education
ORDER BY lead_per_education desc

--- Leads phan bo theo current_education, City, Gender, Age
SELECT current_education, current_city, gender, age, count(lead_id) as lead_per_each
FROM leads_basic_details
GROUP BY current_education, current_city, gender, age

--- Parent_Occupation phan loai, co bao nhieu loai ?
SELECT distinct parent_occupation
FROM leads_basic_details

--- Leads per Parent_Occupation
SELECT parent_occupation, count(lead_id) as lead_per_parent_occ
FROM leads_basic_details
GROUP BY parent_occupation
ORDER BY lead_per_parent_occ desc

--- Leads phan bo theo parent_occupation, current_education, City, Gender, Age
SELECT parent_occupation, current_education, current_city, gender, age, count(lead_id) as lead_per_each
FROM leads_basic_details
GROUP BY parent_occupation, current_education, current_city, gender, age

--- Lead_gen_source phan loai, co bao nhieu loai ? 
SELECT distinct lead_gen_source
FROM leads_basic_details

--- Leads phan bo theo lead_gen_source
SELECT lead_gen_source, count(lead_id) as lead_per_lead_gen
FROM leads_basic_details
GROUP BY lead_gen_source
ORDER BY lead_per_lead_gen desc

--- Lead Phan bo theo lead_gen_source,  parent_occupation, current_education, City, Gender, Age
SELECT lead_gen_source, parent_occupation, current_education, current_city, gender, age, count(lead_id) as lead_per_each
FROM leads_basic_details
GROUP BY lead_gen_source, parent_occupation, current_education, current_city, gender, age;

/* Tim hieu Sales_Manager_Assign: Trong table co luu y ve ids nhu:
- snr_sm_id: Senior Sales Manager ID
- jnr_sm_id: Junior Sales Manager ID */
SELECT snr_sm_id, jnr_sm_id, count(lead_id)
FROM sales_managers_assigned_leads_d
GROUP BY snr_sm_id, jnr_sm_id

SELECT *
FROM sales_managers_assigned_leads_d

--- Tim hieu ve Senior Manager ID: 4 Senior
SELECT distinct snr_sm_id
FROM sales_managers_assigned_leads_d

--- Tim hieu ve Junior Manager ID: 16 Junior
SELECT distinct jnr_sm_id
FROM sales_managers_assigned_leads_d

--- Luong lead Senior assign cho Junior la:
SELECT snr_sm_id, count(jnr_sm_id) as lead_assign_jnr_sm
FROM sales_managers_assigned_leads_d
GROUP BY snr_sm_id

--- Luong Lead tung Junior SM nhan la: 
SELECT jnr_sm_id, count(lead_id) as lead_assign
FROM sales_managers_assigned_leads_d
GROUP BY jnr_sm_id

--- Tim hieu ve assign date: ( 1-1 -> 19-2)
SELECT min(assigned_date) min_assign_date, max(assigned_date) max_assign_date
FROM sales_managers_assigned_leads_d

--- Tim hieu ve Cycle
SELECT min(cycle) min_cycle, ROUND(avg(cycle),1) avg_cycle, max(cycle) max_cycle
FROM sales_managers_assigned_leads_d

--- So luong Leads theo Cycle la:
SELECT cycle, count(lead_id) as lead_per_cycle
FROM sales_managers_assigned_leads_d
GROUP BY cycle

--- So luong Lead theo Cycle va duoc Assign boi cac SM la:
SELECT snr_sm_id, jnr_sm_id, cycle, count(lead_id) as lead_assign
FROM sales_managers_assigned_leads_d
GROUP BY snr_sm_id, jnr_sm_id, cycle

/* Tim hieu ve interaction details */

SELECT *
FROM leads_interaction_details

--- Lead Stage va lead_id dc phan bo
SELECT lead_stage, count(lead_id) as lead_id_count
FROM leads_interaction_details
GROUP BY lead_stage;

--- Ty le trang thai Lead Stage
With Total as (
SELECT lead_stage, cast(count(lead_id) as float) as lead_id_count
FROM leads_interaction_details
GROUP BY lead_stage ),

Summ as (
SELECT sum(lead_id_count) as Total_Sum
FROM Total )

SELECT lead_stage, ROUND(100* lead_id_count/ (SELECT * FROM Summ), 2) as Percentage
FROM Total
GROUP BY Total.lead_stage, Total.lead_id_count;

--- Call Status
SELECT call_status, count(lead_id) as num_of_lead
FROM leads_interaction_details
GROUP BY call_status;

--- Call Status vao moi giai doan, successfull and unsuccessful
--- Successful
With total as (
SELECT lead_stage, call_status, count(lead_id) as lead_count
FROM leads_interaction_details
WHERE call_status = 'successful'
GROUP BY lead_stage, call_status ),

Summ as (
SELECT count(lead_id) as total_sum
FROM leads_interaction_details )

SELECT lead_stage, call_status, lead_count, 100* lead_count / (SELECT * FROM Summ) as Percentage
FROM total
GROUP BY lead_stage, call_status, lead_count
ORDER BY CASE WHEN lead_stage = 'lead' THEN 1
						WHEN lead_stage = 'awareness' THEN 2
						WHEN lead_stage = 'consideration' THEN 3
						WHEN lead_stage = 'conversion' THEN 4 END ;


--- Unsuccessfull
With total as (
SELECT lead_stage, call_status, count(lead_id) as lead_count
FROM leads_interaction_details
WHERE call_status = 'unsuccessful'
GROUP BY lead_stage, call_status ),

Summ as (
SELECT count(lead_id) as total_sum
FROM leads_interaction_details )

SELECT lead_stage, call_status, lead_count, 100* lead_count / (SELECT * FROM Summ) as Percentage
FROM total
GROUP BY lead_stage, call_status, lead_count
ORDER BY CASE WHEN lead_stage = 'lead' THEN 1
						WHEN lead_stage = 'awareness' THEN 2
						WHEN lead_stage = 'consideration' THEN 3
						WHEN lead_stage = 'conversion' THEN 4 END ;

---- Call Reason
--- Call reason and lead stage
SELECT distinct lead_stage, call_reason
FROM leads_interaction_details
ORDER BY lead_stage

--- Call Reason Process
SELECT lead_stage ,call_reason, call_status , count(lead_id) as lead_count
FROM leads_interaction_details
GROUP BY lead_stage, call_reason,call_status
ORDER BY lead_stage

/* Merge Sales Manager and Leads Interaction */
--- Tinh thoi gian assign date and call done date
SELECT *
FROM sales_managers_assigned_leads_d as sm
JOIN leads_interaction_details as inter
ON sm.lead_id = inter.lead_id and sm.jnr_sm_id = inter.jnr_sm_id

--- Insert Day Call Done Column
SELECT *,DATEDIFF(day, assigned_date, call_done_date) as Day_call_done
FROM sales_managers_assigned_leads_d as sm
JOIN leads_interaction_details as inter
ON sm.lead_id = inter.lead_id and sm.jnr_sm_id = inter.jnr_sm_id;

--- Thoi gian lead duoc tiep xuc, min, avg, max 
With DayDone as (
SELECT DATEDIFF(day, assigned_date, call_done_date) as Day_call_done
FROM sales_managers_assigned_leads_d as sm
JOIN leads_interaction_details as inter
ON sm.lead_id = inter.lead_id and sm.jnr_sm_id = inter.jnr_sm_id )

SELECT Min(Day_call_done) as min_day, avg(Day_call_done) as avg_day, max(Day_call_done) as max_day
FROM DayDone

--- Lead assign > 10 ngay va Cycle = 1
SELECT *,DATEDIFF(day, assigned_date, call_done_date) as Day_call_done
FROM sales_managers_assigned_leads_d as sm
JOIN leads_interaction_details as inter
ON sm.lead_id = inter.lead_id and sm.jnr_sm_id = inter.jnr_sm_id
WHERE DATEDIFF(day, assigned_date, call_done_date) > 10 and DATEDIFF(day, assigned_date, call_done_date) < 14 AND sm.cycle = 1

--- Lead assign > 10 ngay, co luong cycle tu 2 - 3 lan. 
SELECT *,DATEDIFF(day, assigned_date, call_done_date) as Day_call_done
FROM sales_managers_assigned_leads_d as sm
JOIN leads_interaction_details as inter
ON sm.lead_id = inter.lead_id and sm.jnr_sm_id = inter.jnr_sm_id
WHERE DATEDIFF(day, assigned_date, call_done_date) > 10

--- Tim Jnr, Snr SM co luong lead hoan thanh tot ?
--- Lead tot la ty le % Succesfull cao va co luong ngay Day_call_done <= avg
--- Tim SNR, JNR SM co ty le Successfull lead cao, va o tung stage

--- Successfull Call Status Percentage
SELECT *
FROM sales_managers_assigned_leads_d as sm
JOIN leads_interaction_details as inter
ON sm.lead_id = inter.lead_id and sm.jnr_sm_id = inter.jnr_sm_id

--- Input vao Power BI de tinh chi tiet % cua snr, jnr
SELECT sm.snr_sm_id, sm.jnr_sm_id,lead_stage, call_status, call_reason ,count(call_status) as status_count,DATEDIFF(day, assigned_date, call_done_date) as Day_call_done
FROM leads_interaction_details as inter
JOIN sales_managers_assigned_leads_d as sm
ON inter.lead_id = sm.lead_id AND inter.jnr_sm_id = sm.jnr_sm_id
GROUP BY inter.lead_stage, inter.call_status, sm.snr_sm_id, sm.jnr_sm_id, call_reason ,call_status , DATEDIFF(day, assigned_date, call_done_date)

/* Leads demo watch */
SELECT *
FROM leads_demo_watched_details

--- Languages 
SELECT language, count(lead_id) as lead_count
FROM leads_demo_watched_details
GROUP BY language

--- Watch Percentage
SELECT min(watched_percentage) as min_watch_pct, ROUND(avg(watched_percentage), 2) as avg_watch_pct, max(watched_percentage) as max_watch_pct
FROM leads_demo_watched_details
WHERE watched_percentage < 101

--- TOP high watch_percentage language
SELECT *
FROM leads_demo_watched_details
WHERE watched_percentage < 101
ORDER BY watched_percentage DESC

--- TOP low watch_percentage language
SELECT *
FROM leads_demo_watched_details
WHERE watched_percentage < 101
ORDER BY watched_percentage

--- Which language has total watch_percentage highest ?
SELECT language, SUM(watched_percentage) as total_percentage
FROM leads_demo_watched_details
GROUP BY language

--- Which ID has 100% watch_percentage ? 
SELECT *
FROM leads_demo_watched_details
WHERE watched_percentage = 100

--- How many lead_id has watched_percentage over avg ?
SELECT language, count(lead_id) as leads_count
FROM leads_demo_watched_details
WHERE watched_percentage > (SELECT AVG(watched_percentage) FROM leads_demo_watched_details)
GROUP BY language

/* JOIN Sales Manager Assign, leads_interaction and Leads Demo Watch */

SELECT *
FROM leads_demo_watched_details as dm
JOIN leads_interaction_details as inter
ON dm.lead_id = inter.lead_id
JOIN sales_managers_assigned_leads_d as sm
ON sm.lead_id = dm.lead_id

--- How many days since call done time success to demo watch date ? 
SELECT DATEDIFF(DAY, call_done_date, demo_watched_date) as days_count
FROM leads_demo_watched_details as dm
JOIN leads_interaction_details as inter
ON dm.lead_id = inter.lead_id
JOIN sales_managers_assigned_leads_d as sm
ON sm.lead_id = dm.lead_id

