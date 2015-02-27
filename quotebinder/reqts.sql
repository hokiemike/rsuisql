select * from EMPLOYEE where emp_last_name like '%cook%'


update employee set emp_department_number = 200 where emp_record_number = 5300
update employee set emp_department_number = 300 where emp_record_number = 5300
update employee set emp_department_number = 1900 where emp_record_number = 5300
update employee set emp_department_number = 1900 where emp_record_number = 5467 --mary


select * from SecUser where EmpRecordNumber = 5467
select * from SecUser where EmpRecordNumber = 5300

select * from SecGroupUser where SecUserID = 677
select * from SecGroup where SecGroupID IN (7,13,17)
select * from SecRoleUser where SecUserID = 677

select * from SecGroupUser where SecUserID = 502
select * from SecGroup where SecGroupID IN (7,13,17)
select * from SecRoleUser where SecUserID = 502

select sr.*
from SecRoleUser sru 
join SecRole sr on sru.SecRoleID = sr.SecRoleID
and sru.SecUserID = 502

select distinct sgu.SecGroupID, sr.*
from SecGroupRole sgu 
join SecRole sr on sgu.SecRoleID = sr.SecRoleID
and sgu.SecGroupID IN (7,13,17)


GO


select sub_policy_number
from Submission
where business_type = 170
 and CreateDate > '3/1/2006'
 and isNull(qb_sequence_no,0) != 0


select qb.qb_gross_premium, qb.QB_MINIMUM_PREMIUM, qb.QB_FLAT_CHARGE
from QUOTE_BINDER qb
join Submission s on s.SUB_RECORD_NUMBER = qb.SUB_RECORD_NUMBER and s.QB_SEQUENCE_NO = qb.QB_SEQUENCE_NO
where s.DEPARTMENT_NUMBER = 300
and s.CreateDate > '1/1/2005'
and charindex('.',cast(qb.qb_gross_premium as varchar)) != 0

select cast(qb.qb_gross_premium as varchar),qb.qb_gross_premium, qb.QB_MINIMUM_PREMIUM, qb.QB_FLAT_CHARGE, qb.QB_CREATION_DATE
from QUOTE_BINDER qb
join Submission s on s.SUB_RECORD_NUMBER = qb.SUB_RECORD_NUMBER and s.QB_SEQUENCE_NO = qb.QB_SEQUENCE_NO
where 1=1
--and s.DEPARTMENT_NUMBER = 300
and s.CreateDate > '1/1/2003'
and charindex('.00',cast(qb.qb_flat_charge as varchar)) = 0


select s.DEPARTMENT_NUMBER, s.SUB_POLICY_NUMBER, s.SUB_RECORD_NUMBER, qb.QB_TYPE
 from QUOTE_BINDER qb
join SUBMISSION s on s.SUB_RECORD_NUMBER = qb.SUB_RECORD_NUMBER
where QB_TYPE is not null
and s.DEPARTMENT_NUMBER = 1900
and s.CreateDate > '02/01/2007'


select s.DEPARTMENT_NUMBER, s.SUB_POLICY_NUMBER, s.SUB_RECORD_NUMBER, qb.QB_TYPE
 from QUOTE_BINDER qb
join SUBMISSION s on s.SUB_RECORD_NUMBER = qb.SUB_RECORD_NUMBER
where QB_TYPE is not null
and s.DEPARTMENT_NUMBER = 1900
and s.CreateDate > '02/01/2007'


select distinct qb.QB_TYPE, qbpl.EXCESS_BUSINESS_TYPE, rt.DESCRIPTION
 from QUOTE_BINDER qb
join SUBMISSION s on s.SUB_RECORD_NUMBER = qb.SUB_RECORD_NUMBER
left outer join REFERENCE_TYPE rt on rt.TYPE_SKEY = qbpl.EXCESS_BUSINESS_TYPE
where QB_TYPE is not null
and s.DEPARTMENT_NUMBER = 300
--and qb.QB_TYPE = 'Excess'

select distinct qb.QB_TYPE, qbpl.EXCESS_BUSINESS_TYPE, rt.DESCRIPTION
 from QUOTE_BINDER qb
join QUOTE_BINDER_PROF_LIAB qbpl on qbpl.SUB_RECORD_NUMBER = qb.SUB_RECORD_NUMBER and qbpl.QB_SEQUENCE_NO = qb.QB_SEQUENCE_NO
join SUBMISSION s on s.SUB_RECORD_NUMBER = qb.SUB_RECORD_NUMBER
left outer join REFERENCE_TYPE rt on rt.TYPE_SKEY = qbpl.EXCESS_BUSINESS_TYPE
where QB_TYPE is not null
and s.DEPARTMENT_NUMBER = 1900
--and qb.QB_TYPE = 'Excess'

select qb.SUB_RECORD_NUMBER, qb.QB_SEQUENCE_NO, s.SUB_POLICY_NUMBER, qb.QB_TYPE, qbpl.EXCESS_BUSINESS_TYPE, rt.DESCRIPTION
 from QUOTE_BINDER qb
join QUOTE_BINDER_PROF_LIAB qbpl on qbpl.SUB_RECORD_NUMBER = qb.SUB_RECORD_NUMBER and qbpl.QB_SEQUENCE_NO = qb.QB_SEQUENCE_NO
join SUBMISSION s on s.SUB_RECORD_NUMBER = qb.SUB_RECORD_NUMBER
left outer join REFERENCE_TYPE rt on rt.TYPE_SKEY = qbpl.EXCESS_BUSINESS_TYPE
where QB_TYPE is not null
and s.DEPARTMENT_NUMBER = 1900
and qb.QB_TYPE = 'Excess'
and qbpl.EXCESS_BUSINESS_TYPE is null



SELECT  rt.DESCRIPTION, pc.*, RT2.DESCRIPTION FROM [dbo].[POLICY_COVERAGE] pc
join reference_type rt on rt.TYPE_SKEY = pc.BUSINESS_TYPE
join reference_type rt2 on rt2.TYPE_SKEY = pc.COVERAGE_SKEY
where DEPARTMENT_NUMBER = 1900
GO


SELECT * 
FROM QB_POLICY_LIMITS qbpl

select s.STATUS_CODE, s.PRIOR_STATUS_CODE
from Submission s
where s.STATUS_CODE = 'Q'
and s.PRIOR_STATUS_CODE = 'O'

select * from Submission where SUB_RECORD_NUMBER = 0

select * from STATUS

select uw.FromStatusCode, s.STATUS_DESCRIPTION, uw.ToStatusCode, 
       s2.STATUS_DESCRIPTION, uw.Type
from UnderwritingWorkflow uw
 left outer join STATUS s on s.STATUS_CODE = uw.FromStatusCode
 left outer join STATUS s2 on s2.STATUS_CODE = uw.ToStatusCode
 where Department_Number = 300
order by FromStatusCode

select count(*)
 from QUOTE_BINDER qb
join SUBMISSION s on s.SUB_RECORD_NUMBER = qb.SUB_RECORD_NUMBER
where DEPARTMENT_NUMBER = 1800
 and RSUI_FORM_NAME is not null

select * 
from DocumentFormField
where FieldScript like '%collection%'

select * from Submission where SUB_POLICY_NUMBER = 103629
select * from Endorsement where SUB_RECORD_NUMBER = 860816

select s.*
 from QUOTE_BINDER qb
join SUBMISSION s on s.SUB_RECORD_NUMBER = qb.SUB_RECORD_NUMBER and s.QB_SEQUENCE_NO = qb.QB_SEQUENCE_NO
and s.DEPARTMENT_NUMBER = 300
and s.CreateDate > '02/01/2007'
order by s.CreateDate


select qbd.*
from RuleBasedDoc rbd
join QB_DOCUMENTS qbd on rbd.DocId = qbd.DocId
join RuleBasedDocStateApproval rbdsa on rbdsa.DocId = rbd.DocId
where 1=1
and qbd.SUB_RECORD_NUMBER = xxx
and qbd.QB_SEQUENCE_NO = 

-- inner
select rbd.DocId
from RuleBasedDoc rbd
join QB_DOCUMENTS qbd on rbd.DocId = qbd.DocId
where 1=1
and qbd.SUB_RECORD_NUMBER = xxx
and qbd.QB_SEQUENCE_NO = yyy
and rbd.DocTypeId = 26

-- outer
select rbd.*
from RuleBasedDoc rbd
join QB_DOCUMENTS qbd on rbd.DocId = qbd.DocId
left join RuleBasedDocStateApproval rbdsa on rbd.DocId = rbdsa.DocId AND rbdsa.STATE_ABBREVIATION = polinsuredstate
where 1=1
 and qbd.SUB_RECORD_NUMBER = xxx
 and qbd.QB_SEQUENCE_NO = yyy
 and isnull(rbdsa.EffectiveDate,'2199-01-01') >  poleffdate
 and isnull(rbdsa.ExpirationDate,'1900-01-01') < poleffdate
 and rbd.DocTypeId = 26
--and rbdsa.STATE_ABBREVIATION != polinsuredstate 


select s.PRIOR_SUB_RECORD_NUMBER, priors.QB_SEQUENCE_NO, s.SUB_CURRENT_EFFECTIVE_DATE, s.INSURED_STATE, s.*
 from QUOTE_BINDER qb
join SUBMISSION s on s.SUB_RECORD_NUMBER = qb.SUB_RECORD_NUMBER 
join SUBMISSION priors on priors.SUB_RECORD_NUMBER = s.PRIOR_SUB_RECORD_NUMBER
  and s.QB_SEQUENCE_NO = qb.QB_SEQUENCE_NO
where 1=1
and s.DEPARTMENT_NUMBER = 300
and s.PRIOR_SUB_RECORD_NUMBER is not null
and s.CreateDate > '03/01/2007'


select * from UnderwritingWorkflow  where Department_Number = 300 and Type = 'select'

select rbd.*
from RuleBasedDoc rbd
join QB_DOCUMENTS qbd on rbd.DocId = qbd.DocId
left join RuleBasedDocStateApproval rbdsa on rbd.DocId = rbdsa.DocId AND rbdsa.STATE_ABBREVIATION = 'TX'
where 1=1
 and qbd.SUB_RECORD_NUMBER = 960710
 and qbd.QB_SEQUENCE_NO = 1
 and ( ( isnull(rbdsa.DocId,0) = 0 ) OR 
     ( EffectiveDate >  '6/1/2007' or isnull(rbdsa.ExpirationDate,'2199-01-01') < '6/1/2007' ) )
 --and rbdsa.Admitted = 1
 and rbd.DocTypeId = 26
order by rbd.DocId

select * from RuleBasedDocStateApproval
where DocId = 8180

update RuleBasedDocStateApproval set ExpirationDate = '5/4/2007' 
where StateApprovalId = 32678 
and STATE_ABBREVIATION = 'TX' 
and ExpirationDate is null


update RuleBasedDocStateApproval set ExpirationDate = null 
where StateApprovalId = 32678 
and STATE_ABBREVIATION = 'TX' 




select qbd.*
 from QUOTE_BINDER qb
join SUBMISSION s on s.SUB_RECORD_NUMBER = qb.SUB_RECORD_NUMBER and s.QB_SEQUENCE_NO = qb.QB_SEQUENCE_NO
join QB_DOCUMENTS qbd on qbd.SUB_RECORD_NUMBER = qb.SUB_RECORD_NUMBER AND qbd.QB_SEQUENCE_NO = qb.QB_SEQUENCE_NO
and s.DEPARTMENT_NUMBER = 300
and s.CreateDate > '02/01/2007'
and s.STATUS_CODE = 'I'
order by s.CreateDate


select * from QUOTE_BINDER_D_O where SUB_RECORD_NUMBER = 1057276

select * from QB_DOCUMENTS where SUB_RECORD_NUMBER = 1065892


select * from Program

select * from RuleBasedDocType where DocTypeId = 163

select * from RuleBasedDoc where DocTypeId = 163

--
-- PL
--

update employee set emp_department_number = 1900 where emp_record_number = 5300

select count(*)
from QUOTE_BINDER qb
join SUBMISSION s on s.SUB_RECORD_NUMBER = qb.SUB_RECORD_NUMBER
join QUOTE_BINDER_PROF_LIAB qbpl on 
      qbpl.SUB_RECORD_NUMBER = qb.SUB_RECORD_NUMBER and qbpl.QB_SEQUENCE_NO = qb.QB_SEQUENCE_NO
where 1=1
and s.DEPARTMENT_NUMBER = 1900
and qb.QB_MINIMUM_EARNED_PREMIUM != qbpl.MINIMUM_EARNED_PREMIUM


select s.SUB_POLICY_NUMBER, s.BUSINESS_TYPE, qbpl.EXCESS_BUSINESS_TYPE
from QUOTE_BINDER qb
join SUBMISSION s on s.SUB_RECORD_NUMBER = qb.SUB_RECORD_NUMBER
join QUOTE_BINDER_PROF_LIAB qbpl on 
      qbpl.SUB_RECORD_NUMBER = qb.SUB_RECORD_NUMBER and qbpl.QB_SEQUENCE_NO = qb.QB_SEQUENCE_NO
where 1=1
and s.DEPARTMENT_NUMBER = 1900
and s.SUB_EFFECTIVE_DATE > '1/1/2005'
and s.STATUS_CODE = 'I'
and s.BUSINESS_TYPE = 171
and qbpl.EXCESS_BUSINESS_TYPE = 166

select distinct qbpl.EXCESS_BUSINESS_TYPE
from QUOTE_BINDER qb
join SUBMISSION s on s.SUB_RECORD_NUMBER = qb.SUB_RECORD_NUMBER
join QUOTE_BINDER_PROF_LIAB qbpl on 
      qbpl.SUB_RECORD_NUMBER = qb.SUB_RECORD_NUMBER and qbpl.QB_SEQUENCE_NO = qb.QB_SEQUENCE_NO
where 1=1
and s.DEPARTMENT_NUMBER = 1900
and s.SUB_EFFECTIVE_DATE > '1/1/2005'
and s.STATUS_CODE = 'I'
and s.BUSINESS_TYPE = 171
and qbpl.EXCESS_BUSINESS_TYPE = 166

select top 300 * from QUOTE_BINDER_PRIMARY_CARRIERS


select * 
from DOCUMENTS
where DEPARTMENT_NUMBER = 1900
and DOCUMENT_TYPE = 179

select * 
from RuleBasedDoc
where DocTypeId = 163
and 


select *
from QB_DOCUMENTS
where SUB_RECORD_NUMBER = 1085998
order by DocId


select DOCUMENT_NUMBER, DOCUMENT_NAME
from DOCUMENTS
where 1=1
and ORG_NUMBER = 2
and INACTIVE_DATE is null
and DOCUMENT_TYPE = 26
and DEPARTMENT_NUMBER = 1900




select *
from QUOTE_BINDER where RejectTRIA = 'N'
and QB_TERRORISM_PREMIUM = 0

select *
from QUOTE_BINDER where RejectTRIA = 'Y'
and QB_TERRORISM_PREMIUM > 0



select s.SUB_RECORD_NUMBER, s.SUB_SUBMISSION_NUMBER, qb.*
from QUOTE_BINDER qb
join SUBMISSION s on s.SUB_RECORD_NUMBER = qb.SUB_RECORD_NUMBER
join QUOTE_BINDER_PROF_LIAB qbpl on 
      qbpl.SUB_RECORD_NUMBER = qb.SUB_RECORD_NUMBER and qbpl.QB_SEQUENCE_NO = qb.QB_SEQUENCE_NO
where 1=1
and s.DEPARTMENT_NUMBER = 1900
and qbpl.OCCUR_OR_CLMSMADE = 'C'
and s.SUB_EFFECTIVE_DATE > '5/1/2007'
and s.STATUS_CODE = 'Q'
--d qbpl.BusinessTypeKey = 166


select s.SUB_RECORD_NUMBER, s.SUB_SUBMISSION_NUMBER, qbpl.BusinessTypeKey, qb.*
from QUOTE_BINDER qb
join SUBMISSION s on s.SUB_RECORD_NUMBER = qb.SUB_RECORD_NUMBER
join QUOTE_BINDER_PROF_LIAB qbpl on 
      qbpl.SUB_RECORD_NUMBER = qb.SUB_RECORD_NUMBER and qbpl.QB_SEQUENCE_NO = qb.QB_SEQUENCE_NO
where 1=1
and s.DEPARTMENT_NUMBER = 1900
--and qb.QB_TERRORISM_PREMIUM > 0
-- qb.isExcess = 1
and s.SUB_EFFECTIVE_DATE > '05/01/2007'
and qbpl.BusinessTypeKey = 169

select distinct qbpl.BusinessTypeKey
from QUOTE_BINDER qb
join SUBMISSION s on s.SUB_RECORD_NUMBER = qb.SUB_RECORD_NUMBER
join QUOTE_BINDER_PROF_LIAB qbpl on 
      qbpl.SUB_RECORD_NUMBER = qb.SUB_RECORD_NUMBER and qbpl.QB_SEQUENCE_NO = qb.QB_SEQUENCE_NO
where 1=1
and s.DEPARTMENT_NUMBER = 1900
--and qb.QB_TERRORISM_PREMIUM > 0
--and qb.isExcess = 1
and qbpl.BusinessTypeKey = 169



select * from ProfLiabBusinessType
--and s.STATUS_CODE = 'Q'
--and qbpl.OCCUR_OR_CLMSMADE = 'O'


