select t1.term, t1.Loan_nature, (t1.Count/t2.Total)*100  from (select sum(Count) Count, term, Loan_nature from (SELECT count(*) Count, term,
CASE WHEN loan_status in ('Current','Issued', 'Fully Paid') THEN "Good Loan"
ELSE "Bad Loan"
END AS Loan_nature
FROM loan where term is not null group by term, loan_status) group by term, Loan_nature) t1 LEFT OUTER JOIN (select sum(Count) Total, term from (select sum(Count) Count, term, Loan_nature from (SELECT count(*) Count, term,
CASE WHEN loan_status in ('Current','Issued', 'Fully Paid') THEN "Good Loan"
ELSE "Bad Loan"
END AS Loan_nature
FROM loan where term is not null group by term, loan_status) group by term, Loan_nature) group by term) t2 ON t1.term=t2.term



select * from (select count(id) Count, emp_title from loan group by emp_title order by Count DESC) where ROWNUM <=1

select * from (select count(id) Count, emp_title from loan group by emp_title order by Count) where ROWNUM <=1






select Count, purpose from (SELECT count(*) Count, purpose,
CASE WHEN loan_status in ('Current','Issued', 'Fully Paid') THEN "Good Loan"
ELSE "Bad Loan"
END AS Loan_nature
FROM loan where term is not null group by purpose, loan_status) where Loan_nature = "Bad Loan" group by purpose, Loan_nature order by Count DESC
