select *
from underwritingserviceslog
where policynumber = 1673

select * from endorsement where endorsement_skey =   198278

select * from Submission where sub_policy_number = 1673
select * from Quote_Binder where sub_record_number = 1026733



select distinct PolicyNumber
from underwritingserviceslog a
where 1=1
 and a.MethodCalled = 'UPDATEPOLICY'
 and a.PolicyNumber in 
   (select b.policynumber from underwritingserviceslog b
     where a.ReceivedDate > b.ReceivedDate
      and a.POlicyNumber = b.PolicyNumber
      and b.MethodCalled = 'ISSUEPOLICY')


select *
from underwritingserviceslog
where policynumber = 1336


select *
from underwritingserviceslog a
where 1=1
 and a.MethodCalled = 'UNBINDPOLICY'
 and a.PolicyNumber in 
   (select b.policynumber from underwritingserviceslog b
     where a.ReceivedDate > b.ReceivedDate
      and a.POlicyNumber = b.PolicyNumber
      and b.MethodCalled = 'BINDPOLICY')
