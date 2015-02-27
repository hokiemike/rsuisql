select s.sub_policy_number, count(e.endorsement_skey)
from endorsement e
join submission s on s.sub_record_number = e.sub_record_number
where 1=1
 and s.DEPARTMENT_NUMBER = 1800
 and s.CreateDate > '01/01/2005'
  and ENDTYPE_RECORD_NUMBER != 10
group by s.sub_policy_number
having count(e.endorsement_skey) > 1

--select * from endorsement_type

--select * from departments


select * from ri_header_level
where (isnull(SUB_RECORD_NUMBER,0) = 0 and isnull(QB_SEQUENCE_NO,0) = 0)
and isnull(ENDORSEMENT_SKEY,0) != 0


select ps.POLICY_CODE,SUB_POLICY_NUMBER,SUB_POLICY_SUFFIX   
from submission s
 join Policy_Symbol ps on s.SUB_POLICY_SYMBOL = ps.SYMBOL_SKEY
where CreateDate > '08/04/2005'
and sub_policy_symbol is not null

select * from Employee order by emp_last_name

select * from Departments

select distinct sub_policy_type from submission

select * from reference_category

select * from Policy_type

select * from Policy_type_codes

select * from ApprovedCOmpany where department_number = 100006

select top 100 * from Quote_Binder where qb_minimum_earned_premium_pct > 0

select distinct status_code from submission



select * from status



select distinct(qb_status) from quote_binder

select * from quote_binder where sub_record_number = 825787

select * from reference_type

select * from qualifiedattribute

select * from location where location_skey = 227


select * from reference_category




