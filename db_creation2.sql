
CREATE TABLE borrower_master AS
  SELECT member_id  , emp_title , emp_length , home_ownership , annual_inc , verification_status , issue_d , loan_status , pymnt_plan , url , "desc" , purpose , title , zip_code , addr_state , dti , delinq_2yrs , earliest_cr_line , inq_last_6mths , mths_since_last_delinq , mths_since_last_record , open_acc , pub_rec , total_acc , mths_since_last_major_derog , policy_code , annual_inc_jo , dti_jo , verification_status_jo , acc_now_delinq , tot_coll_amt , tot_cur_bal , open_acc_6m , open_il_6m , open_il_12m , open_il_24m , mths_since_rcnt_il , total_bal_il , il_util , open_rv_12m , open_rv_24m , max_bal_bc , all_util , total_rev_hi_lim , inq_fi , total_cu_tl , inq_last_12m 
  FROM loan_dump;


  CREATE TABLE loan_master AS
  SELECT id  , member_id , loan_amnt , funded_amnt , funded_amnt_inv , term , _rate , installment , grade , sub_grade , issue_d , loan_status , pymnt_plan , url , purpose , revol_bal , revol_util , total_acc , initial_list_status , out_prncp , out_prncp_inv , total_pymnt , total_pymnt_inv , total_rec_prncp , total_rec_ , total_rec_late_fee , recoveries , collection_recovery_fee , last_pymnt_d , last_pymnt_amnt , next_pymnt_d , last_credit_pull_d , collections_12_mths_ex_med , policy_code
   FROM loan_dump;


CREATE TABLE transaction_master (
    tran_id  ,
    id , tran_amnt , tran_date datetime,
    CONSTRAINT PK_tran PRIMARY KEY (tran_id)
)


CREATE TABLE inv_master (member_inv_id  ,
CONSTRAINT PK_inv PRIMARY KEY (member_inv_id))

CREATE TABLE borrower_master AS
  SELECT member_id  , emp_title , emp_length , home_ownership , annual_inc , verification_status , issue_d , loan_status , pymnt_plan , url , "desc" , purpose , title , zip_code , addr_state , dti , delinq_2yrs , earliest_cr_line , inq_last_6mths , mths_since_last_delinq , mths_since_last_record , open_acc , pub_rec , total_acc , mths_since_last_major_derog , policy_code , annual_inc_jo , dti_jo , verification_status_jo , acc_now_delinq , tot_coll_amt , tot_cur_bal , open_acc_6m , open_il_6m , open_il_12m , open_il_24m , mths_since_rcnt_il , total_bal_il , il_util , open_rv_12m , open_rv_24m , max_bal_bc , all_util , total_rev_hi_lim , inq_fi , total_cu_tl , inq_last_12m 
  FROM loan_dump;


  CREATE TABLE loan_master AS
  SELECT id  , member_id , loan_amnt , funded_amnt , funded_amnt_inv , term , _rate , installment , grade , sub_grade , issue_d , loan_status , pymnt_plan , url , purpose , revol_bal , revol_util , total_acc , initial_list_status , out_prncp , out_prncp_inv , total_pymnt , total_pymnt_inv , total_rec_prncp , total_rec_ , total_rec_late_fee , recoveries , collection_recovery_fee , last_pymnt_d , last_pymnt_amnt , next_pymnt_d , last_credit_pull_d , collections_12_mths_ex_med , policy_code
   FROM loan_dump;




ALTER TABLE loan_master ADD CONSTRAINT FK_memid FOREIGN KEY (member_id) REFERENCES borrower_master(member_id)

ALTER TABLE loan_master ADD CONSTRAINT FK_meminvid FOREIGN KEY (member_inv_id) REFERENCES inv_master(member_inv_id)

ALTER TABLE transaction_master ADD CONSTRAINT FK_id FOREIGN KEY (id) REFERENCES loan_master(id)





